#include "save_game_manager.hpp"

#include <archive.h>
#include <archive_entry.h>

#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/classes/project_settings.hpp>

void SaveGameManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create_save", "slot"), &SaveGameManager::create_save, DEFVAL(-1));
    ClassDB::bind_method(D_METHOD("load_save", "slot"), &SaveGameManager::load_save);
    ClassDB::bind_method(D_METHOD("extend_to_multiplayer"), &SaveGameManager::extend_to_multiplayer);
    ClassDB::bind_method(D_METHOD("close_save"), &SaveGameManager::close_save);

    ClassDB::bind_method(D_METHOD("read_metadata"), &SaveGameManager::read_metadata);
    ClassDB::bind_method(D_METHOD("write_metadata", "meta"), &SaveGameManager::write_metadata);

    ClassDB::bind_method(D_METHOD("get_current_slot"), &SaveGameManager::get_current_slot);
    ClassDB::bind_method(D_METHOD("get_current_mode"), &SaveGameManager::get_current_mode);

    ClassDB::bind_method(D_METHOD("shutdown"), &SaveGameManager::shutdown);
}


String SaveGameManager::generate_temp_dir() {
    uint64_t r = Time::get_singleton()->get_ticks_usec();
    String name = String("user://temp/") + String::num_uint64(r);

    Ref<DirAccess> d = DirAccess::open("user://");
    if (d.is_valid()) {
        d->make_dir_recursive("temp/" + String::num_uint64(r));
    }

    return name;
}

int SaveGameManager::get_last_slot() {
    Ref<DirAccess> d = DirAccess::open("user://saves/");
    if (d.is_null()) return -1;
    int max_slot = -1;

    d->list_dir_begin();
    String file = d->get_next();

    while (!file.is_empty()) {
        if (file.begins_with("savegame_") && file.ends_with(".tar.gz")) {
            int slot = file.substr(5, file.length() - 9).to_int();
            if (slot > max_slot) max_slot = slot;
        }
        file = d->get_next();
    }
    d->list_dir_end();
    return max_slot;
}

Dictionary SaveGameManager::read_metadata() {
    String path = temp_dir.path_join("savegame.json");
    Ref<FileAccess> f = FileAccess::open(path, FileAccess::READ);

    if (f.is_null()) {
        return Dictionary();
    }

    String text = f->get_as_text();
    f->close();
    
    Variant parsed = JSON::parse_string(text);

    if (parsed.get_type() != Variant::DICTIONARY) {
        return Dictionary();
    }

    return parsed;
}

bool SaveGameManager::write_metadata(const Dictionary &meta) {
    ERR_FAIL_COND_V_MSG(temp_dir.is_empty(), false, "write_metadata: temp_dir is empty");

    String path = temp_dir.path_join("savegame.json");
    Ref<FileAccess> f = FileAccess::open(path, FileAccess::WRITE);

    if (f.is_null()) {
        return false;
    }

    String text = JSON::stringify(meta, "\t");
    f->store_string(text);
    f->close();

    return true;
}

bool SaveGameManager::extract_tar_to_temp(const String &path) {
    struct archive *a = archive_read_new();
    archive_read_support_filter_all(a);
    archive_read_support_format_all(a);

    if (archive_read_open_filename(a, path.utf8().get_data(), 10240) != ARCHIVE_OK) {
        archive_read_free(a);
        return false;
    }

    struct archive *ext = archive_write_disk_new();
    archive_write_disk_set_options(ext,
        ARCHIVE_EXTRACT_TIME |
        ARCHIVE_EXTRACT_PERM |
        ARCHIVE_EXTRACT_ACL |
        ARCHIVE_EXTRACT_FFLAGS);

    struct archive_entry *entry;

    while (archive_read_next_header(a, &entry) == ARCHIVE_OK) {
        String out_path = temp_dir.path_join(archive_entry_pathname(entry));
        archive_entry_set_pathname(entry, out_path.utf8().get_data());

        archive_write_header(ext, entry);

        const void *buff;
        size_t size;
        la_int64_t offset;

        while (archive_read_data_block(a, &buff, &size, &offset) == ARCHIVE_OK) {
            archive_write_data_block(ext, buff, size, offset);
        }
    }

    archive_write_close(ext);
    archive_write_free(ext);

    archive_read_close(a);
    archive_read_free(a);

    return true;
}

bool SaveGameManager::pack_temp_to_tar(const String &path) {

    struct archive *a = archive_write_new();
    if (!a) {
        return false;
    }
    archive_write_set_format_pax_restricted(a);
    String abs_path = ProjectSettings::get_singleton()->globalize_path(path);

    CharString cs = abs_path.utf8();
    int open_res = archive_write_open_filename(a, cs.get_data());

    if (open_res != ARCHIVE_OK) {
        archive_write_free(a);
        return false;
    }

    Vector<String> files = list_temp_files();

    for (int i = 0; i < files.size(); i++) {
        String file = files[i];
        String full_path = temp_dir.path_join(file);

        Vector<uint8_t> data = read_file(full_path);


        struct archive_entry *entry = archive_entry_new();
        archive_entry_set_pathname(entry, file.utf8().get_data());
        archive_entry_set_size(entry, data.size());
        archive_entry_set_filetype(entry, AE_IFREG);
        archive_entry_set_perm(entry, 0644);

        archive_write_header(a, entry);
        archive_write_data(a, data.ptr(), data.size());
        archive_entry_free(entry);
    }

    archive_write_close(a);
    archive_write_free(a);

    return true;
}

int SaveGameManager::create_save(int slot) {

    if (slot < 0) {
        slot = get_last_slot() + 1;
    }

    current_slot = slot;
    current_save_path = "user://saves/savegame_" + itos(slot) + ".tar.gz";

    Dictionary meta;
    meta["last_saved"] = Time::get_singleton()->get_unix_time_from_system();
    meta["player"] = Dictionary();
    meta["blocks"] = Dictionary();
    meta["mode"] = "singleplayer";

    write_metadata(meta);
    String abs_save_dir = ProjectSettings::get_singleton()->globalize_path("user://saves");
    DirAccess::make_dir_recursive_absolute(abs_save_dir);

    pack_temp_to_tar(current_save_path);

    return slot;
}

bool SaveGameManager::load_save(int slot) {

    String tar_path = "user://saves/savegame_" + itos(slot) + ".tar.gz";

    if (!FileAccess::file_exists(tar_path)) {
        return false;
    }

    current_slot = slot;
    current_save_path = tar_path;

    return extract_tar_to_temp(tar_path);
}

bool SaveGameManager::extend_to_multiplayer() {

    Dictionary meta = read_metadata();
    meta["mode"] = "multiplayer";

    Dictionary blocks = meta["blocks"];
    int new_id = blocks.size();

    Dictionary b;
    b["timestamp"] = Time::get_singleton()->get_unix_time_from_system();
    blocks[String::num_int64(new_id)] = b;

    meta["blocks"] = blocks;

    return write_metadata(meta);
}

void SaveGameManager::close_save() {
    if (current_save_path == "" || current_slot == -1) {
        return;
    }

    Dictionary meta = read_metadata();
    meta["last_saved"] = Time::get_singleton()->get_unix_time_from_system();
    write_metadata(meta);

    pack_temp_to_tar(current_save_path);

    current_save_path = "";
    current_slot = -1;
}

int SaveGameManager::get_current_slot() {

    return current_slot;
}

int SaveGameManager::get_current_mode() {

    return current_mode;
}

Vector<String> SaveGameManager::list_temp_files() {

    Vector<String> out;
    Ref<DirAccess> d = DirAccess::open(temp_dir);
    if (d.is_null()) return out;

    d->list_dir_begin();
    String f = d->get_next();
    while (!f.is_empty()) {
        if (!d->current_is_dir()) {
            out.push_back(f);
        }
        f = d->get_next();
    }
    d->list_dir_end();
    return out;
}

Vector<uint8_t> SaveGameManager::read_file(const String &path) {
    Vector<uint8_t> data;
    Ref<FileAccess> f = FileAccess::open(path, FileAccess::READ);
    if (f.is_null()) return data;

    data.resize(f->get_length());
    f->get_buffer(data.ptrw(), data.size());
    f->close();
    return data;
}

void delete_dir_recursive(const String &path) {
    Ref<DirAccess> d = DirAccess::open(path);
    if (d.is_null()) {
        return;
    }

    d->list_dir_begin();
    String name = d->get_next();

    while (!name.is_empty()) {
        if (name == "." || name == "..") {
            name = d->get_next();
            continue;
        }

        String full = path.path_join(name);

        if (d->current_is_dir()) {
            delete_dir_recursive(full);
            DirAccess::remove_absolute(full);
        } else {
            DirAccess::remove_absolute(full);
        }

        name = d->get_next();
    }

    d->list_dir_end();

    DirAccess::remove_absolute(path);
}

void SaveGameManager::shutdown() {
    close_save();

    if (!temp_dir.is_empty()) {
        delete_dir_recursive(temp_dir);
    }
}

SaveGameManager::SaveGameManager() {
    temp_dir = generate_temp_dir();
}

SaveGameManager::~SaveGameManager() {
    shutdown();
}

