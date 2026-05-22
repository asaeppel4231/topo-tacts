#include "time_helper.hpp"

#include <chrono>

using namespace std::chrono;
using namespace std::chrono_literals;

// Workaround for missing make_time() in GCC
template <class Duration>
constexpr hh_mm_ss<Duration> make_time(Duration d) {
    return hh_mm_ss<Duration>(d);
}

void TimeHelper::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_local_datetime_from_unix", "ts"), \
    &TimeHelper::get_local_datetime_from_unix);
}

Dictionary TimeHelper::get_local_datetime_from_unix(int64_t ts) {
    sys_seconds timestamp { seconds{ts} };

    const auto* tz = current_zone();

    zoned_time zt{tz, timestamp};
    auto local = zt.get_local_time();
    auto dp = floor<days>(local);
    year_month_day yemd{dp};

    auto time = make_time(local - dp);

    Dictionary d;
    d["year"]    = int(yemd.year());
    d["month"]   = unsigned(yemd.month());
    d["day"]     = unsigned(yemd.day());
    d["hour"]    = time.hours().count();
    d["minute"]  = time.minutes().count();
    d["second"]  = time.seconds().count();
    return d;
}
