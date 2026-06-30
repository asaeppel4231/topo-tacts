#ifndef TIME_HELPER
#define TIME_HELPER

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/classes/node.hpp>

using namespace godot;

class SaveGameManager : public Node {
    GDCLASS(SaveGameManager, Node);
    
public:
    enum play_mode {
        MODE_SINGLEPLAYER = 0,
        MODE_MULTIPLAYER = 1
    };

private:
    String current_save_path;     // user://saves/save_X.tar
    String temp_dir;              // user://temp/abc123xyz/
    int current_slot = -1;
    enum play_mode current_mode = MODE_SINGLEPLAYER;
    // Hilfsfunktionen
    String generate_temp_dir();
    int get_last_slot();
    bool extract_tar_to_temp(const String &path);
    bool pack_temp_to_tar(const String &path);
    Vector<String> list_temp_files();
    Vector<uint8_t> read_file(const String &path);

protected:
    static void _bind_methods();

public:
    SaveGameManager();
    ~SaveGameManager();
    
    // Savegame-Operationen
    int create_save(int slot = -1);
    bool load_save(int slot);
    bool extend_to_multiplayer();
    void close_save();
    int get_current_slot();
    int get_current_mode();
    
    // JSON
    Dictionary read_metadata();
    bool write_metadata(const Dictionary &meta);

    void shutdown();
};

#endif
