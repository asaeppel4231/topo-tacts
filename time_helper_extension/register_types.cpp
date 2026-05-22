#include <godot_cpp/godot.hpp>
#include <godot_cpp/core/class_db.hpp>
#include "time_helper.hpp"

using namespace godot;

void initialize_time_helper(ModuleInitializationLevel level) {
    if (level == MODULE_INITIALIZATION_LEVEL_CORE) {
        ClassDB::register_class<TimeHelper>();
    }
}

void uninitialize_time_helper(ModuleInitializationLevel level) {
    // nichts zu tun
}

extern "C" {

GDExtensionBool GDE_EXPORT time_helper_init(
    GDExtensionInterfaceGetProcAddress get_proc_address,
    GDExtensionClassLibraryPtr library,
    GDExtensionInitialization *init) {

    GDExtensionBinding::InitObject binding(get_proc_address, library, init);

    binding.register_initializer(initialize_time_helper);
    binding.register_terminator(uninitialize_time_helper);
    binding.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_CORE);

    return binding.init();
}

}

