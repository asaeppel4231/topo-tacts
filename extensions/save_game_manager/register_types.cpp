#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/class_db.hpp>
#include "save_game_manager.hpp"

using namespace godot;

void initialize_save_game_manager(ModuleInitializationLevel level) {
    if (level == MODULE_INITIALIZATION_LEVEL_SCENE) {
        ClassDB::register_class<SaveGameManager>();
    }
}

void uninitialize_save_game_manager(ModuleInitializationLevel level) {
    return; /* nothing to do */
}

extern "C" {

GDExtensionBool GDE_EXPORT save_game_manager_init(
    GDExtensionInterfaceGetProcAddress get_proc_address,
    GDExtensionClassLibraryPtr library,
    GDExtensionInitialization *init) {

    GDExtensionBinding::InitObject binding(get_proc_address, library, init);

    binding.register_initializer(initialize_save_game_manager);
    binding.register_terminator(uninitialize_save_game_manager);
   binding.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return binding.init();
}

}

