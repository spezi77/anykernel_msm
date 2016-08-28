#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Revival use by spezi77
#

# Config for picking the default hotplug (0..off / 1..on)
# Warning: Only enable one hotplug driver at a time!
autosmp_hotplug=0
dyn_hotplug=1
mako_hotplug=0

    # Substitute tweaks header (if applicable)
    sed 's/<-- HellSpawn Tweaks BEGIN -->/<-- Revival Tweaks BEGIN -->/' -i init.mako.rc
    # Remove old/duplicate settings (if applicable)
    sed -e '/alucard-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/zendecision/ { N; d; }' -i init.mako.rc
    sed -e '/intelliplug/ d' -i init.mako.rc
    sed -e '/hellsactive/ d' -i init.mako.rc
    sed -e '/scaling_min_freq/ d' -i init.mako.rc
    sed -e '/screen_off_max_freq/ d' -i init.mako.rc
    sed -e '/Set GPU governor/ { N; d; }' -i init.mako.rc
    sed -e '/communicate with mpdecision and thermald/ d' -i init.mako.rc
    sed -e '/mpdecision 2770 root system/ { N; d; }' -i init.mako.rc
    sed -e '/Disable mpdecision/ { N; d; }' -i init.mako.rc
    sed -e '/Run mpdfake service to absorb logcat spam/ { N; d; }' -i init.mako.rc
    sed -e '/start mpdfake/ d' -i init.mako.rc
    sed -e '/Disable thermald/ { N; d; }' -i init.mako.rc
    sed -e '/CPU governor/ d' -i init.mako.rc
    sed -e '/sys\/devices\/system\/cpu/ d' -i init.mako.rc
    sed -e '/Slightly lower voltage/ { N; d; }' -i init.mako.rc
    sed -e '/Speed up io/ { N; d; }' -i init.mako.rc
    sed -e '/scheduler/ d' -i init.mako.rc
    sed -e '/fsync/ d' -i init.mako.rc
    sed -e '/kgsl/ d' -i init.mako.rc
    sed -e '/ksm/ d' -i init.mako.rc
    sed -e '/KSM/ d' -i init.mako.rc
    sed -e '/intelli_plug/ d' -i init.mako.rc
    sed -e '/max_gpuclk/ d' -i init.mako.rc

    # Remove end marker (if applicable)
    sed -e '/# <-- Revival Tweaks END -->/ { N; d; }' -i init.mako.rc
    sed -e '/# <-- HellSpawn Tweaks END -->/ { N; d; }' -i init.mako.rc

    if [ `grep -c "# <-- Revival Tweaks BEGIN" init.mako.rc` -eq 0 ] ; then
        sed '/# disable diag port/ {
            i\    # <-- Revival Tweaks BEGIN -->
            i\\
            }' -i init.mako.rc
    fi

    # Stop mpdecision
        sed '/# disable diag port/ {
            i\    # Disable mpdecision service to prevent conflicts with other hotplug drivers
            i\    stop mpdecision
            i\\
            }'  -i init.mako.rc
    if [ `grep -c "# Use mpdfake service to absorb logcat spam" init.mako.rc` -eq 0 ] ; then
    # Use mpdfake service to absorb logcat spam
        sed '/service thermald/ {
            i\# Use mpdfake service to absorb logcat spam
            i\service mpdfake /system/bin/mpdfake
            i\    class core
            i\    user root
            i\    group system
            i\    socket pb stream 660 root system
            i\    seclabel u:r:init:s0
            i\\
            }'  -i init.mako.rc
    fi
    # Start mpdfake
        sed '/# disable diag port/ {
            i\    # Run mpdfake service to absorb logcat spam
            i\    mkdir /dev/socket/mpdfake 2770 root system
            i\    start mpdfake
            i\\
            }'  -i init.mako.rc
    # Stop thermald 
        sed '/# disable diag port/ {
            i\    # Disable thermald service
            i\    stop thermald
            i\\
            }'  -i init.mako.rc

    # Set CPU governor to ondemand 

        # Add Revival Tweaks
        sed '/# disable diag port/ {
            i\    # CPU governor
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "ondemand"
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor "ondemand"
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "ondemand"
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor "ondemand"
            i\    restorecon_recursive /sys/devices/system/cpu/cpufreq/ondemand
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpufreq/ondemand/up_threshold 95
            i\    write /sys/devices/system/cpu/cpufreq/ondemand/down_threshold 8
            i\    write /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor 4
            i\    write /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy 1
            i\    write /sys/devices/system/cpu/cpufreq/ondemand/touch_load 55
            i\    write /sys/devices/system/cpu/cpufreq/ondemand/touch_load_duration 900
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/util_threshold 25
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/util_threshold 30
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/util_threshold 35
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/util_threshold 40
            i\    write /sys/devices/system/cpu/cpu1/online 1
            i\    write /sys/devices/system/cpu/cpu2/online 0
            i\    write /sys/devices/system/cpu/cpu3/online 0
            i\\
            i\    # Set GPU governor to interactive
            i\    write /sys/class/kgsl/kgsl-3d0/pwrscale/trustzone/governor interactive
            i\    write /sys/class/kgsl/kgsl-3d0/max_gpuclk 200000000
            i\\
            i\    # Speed up io
            i\    write /sys/block/mmcblk0/queue/nr_requests 256
            i\    write /sys/block/mmcblk0/queue/scheduler tripndroid
            i\\
            i\    # enable KSM
            i\    write /sys/kernel/mm/ksm/run 1
            i\    write /sys/kernel/mm/ksm/deferred_timer 1
            i\\
        }' -i init.mako.rc

# CPU Hotplugs section
    # Prevent duplicates
    sed -e '/# <-- Revival Tweaks END -->/ { N; d; }' -i init.mako.rc
    sed -e '/autosmp-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/dyn_hotplug/ d' -i init.mako.rc
    sed -e '/mako-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/auto-hotplug/ { N; d; }' -i init.mako.rc

if [ $autosmp_hotplug -eq 1 ] ; then
    # Set autosmp_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Enable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled Y
        i\\
        i\    # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $dyn_hotplug -eq 1 ] ; then
    # Set dyn_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Enable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 1
        i\    write /sys/module/dyn_hotplug/parameters/down_timer_cnt 6
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $mako_hotplug -eq 1 ] ; then
    # Set mako-hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Enable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 1
        i\\
        }'  -i init.mako.rc
fi

# Add marker to indicate where HS tweaks have an end
sed '/# disable diag port/ {
        i\    # <-- Revival Tweaks END -->
        i\\
        }' -i init.mako.rc

# Finally, remove double empty lines
sed '/^$/N;/^\n$/D' -i init.mako.rc

