#ifndef TIME_HELPER
#define TIME_HELPER

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

/* Workaround class. Used in the SettingsDialog.
 * My godot 4.7 Time.get_datetime_dict_from_unix_time returns
 * UTC time, but my time zone is actually UTC + 2 (Europe/Berlin).
 * I think this is a bug, because Time.get_datetime_dict_from_system() returns local time.
 * Solution?
 * Workaround class which uses std::chrono directly.
*/

class TimeHelper : public Object {
    GDCLASS(TimeHelper, Object);
protected:
    static void _bind_methods();

public:
    Dictionary get_local_datetime_from_unix(int64_t ts);
};

#endif
