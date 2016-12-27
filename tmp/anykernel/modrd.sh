#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for HellSpawn use by spezi77
#

# Config for picking the default hotplug (0..off / 1..on)
# Warning: Only enable one hotplug driver at a time!
alucard_hotplug=0
autosmp_hotplug=1
dyn_hotplug=0
mako_hotplug=0
zendecision=0

    # Substitute tweaks header (if applicable)
    sed 's/<-- Revival Tweaks BEGIN -->/<-- HellSpawn Tweaks BEGIN -->/' -i init.mako.rc
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
    sed -e '/notify_on_migrate/ d' -i init.mako.rc
    sed -e '/Slightly lower voltage/ { N; d; }' -i init.mako.rc
    sed -e '/Speed up io/ { N; d; }' -i init.mako.rc
    sed -e '/scheduler/ d' -i init.mako.rc
    sed -e '/fsync/ d' -i init.mako.rc
    sed -e '/kgsl/ d' -i init.mako.rc
    sed -e '/ksm/ d' -i init.mako.rc
    sed -e '/KSM/ d' -i init.mako.rc
    sed -e '/intelli_plug/ d' -i init.mako.rc
    sed -e '/max_gpuclk/ d' -i init.mako.rc
    sed -e '/NeXus4ever Tweaks/ d' -i init.mako.rc

    # Remove end marker (if applicable)
    sed -e '/# <-- Revival Tweaks END -->/ { N; d; }' -i init.mako.rc
    sed -e '/# <-- HellSpawn Tweaks END -->/ { N; d; }' -i init.mako.rc

    if [ `grep -c "# <-- HellSpawn Tweaks BEGIN" init.mako.rc` -eq 0 ] ; then
        sed '/# disable diag port/ {
            i\    # <-- HellSpawn Tweaks BEGIN -->
            i\\
            }' -i init.mako.rc
    fi

    # Stop mpdecision
        sed '/# disable diag port/ {
            i\    # Disable mpdecision service to prevent conflicts with other hotplug drivers
            i\    stop mpdecision
            i\\
            }'  -i init.mako.rc
    # Stop thermald 
        sed '/# disable diag port/ {
            i\    # Disable thermald service
            i\    stop thermald
            i\\
            }'  -i init.mako.rc

    # Set CPU governor to hellsactive
        sed '/# disable diag port/ {
            i\    # CPU governor
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "hellsactive"
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor "hellsactive"
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "hellsactive"
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor "hellsactive"
    restorecon_recursive /sys/devices/system/cpu/cpufreq/hellsactive
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/above_hispeed_delay 20000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/align_windows 1
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/boostpulse_duration 1000000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/closest_freq_selection 0
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/freq_calc_thresh 94500
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/go_hispeed_load 99
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/hispeed_freq 1134000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/input_boost_freq 1026000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/io_is_busy 1
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/max_freq_hysteresis 0
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/min_sample_time 80000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/target_loads 90
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/timer_rate 20000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/timer_slack 80000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/two_phase_freq 1350000,1350000,1350000,1350000
            i\    write /sys/devices/system/cpu/cpufreq/hellsactive/use_freq_calc_thresh 1
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 384000
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 384000
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 384000
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 384000
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/screen_off_max_freq 1026000
            i\    write /dev/cpuctl/cpu.notify_on_migrate 1
            i\\
            i\    # Set GPU governor to simple
            i\    write /sys/class/kgsl/kgsl-3d0/pwrscale/trustzone/governor simple
            i\    write /sys/class/kgsl/kgsl-3d0/max_gpuclk 200000000
            i\\
            i\    # Speed up io
            i\    write /sys/block/mmcblk0/queue/nr_requests 256
            i\    write /sys/block/mmcblk0/queue/scheduler noop
            i\\
            i\    # enable KSM
            i\    write /sys/kernel/mm/ksm/run 1
            i\    write /sys/kernel/mm/ksm/deferred_timer 1
            i\\
        }' -i init.mako.rc

# CPU Hotplugs section
    # Prevent duplicates
    sed -e '/alucard-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/autosmp-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/intelliplug/ { N; d; }' -i init.mako.rc
    sed -e '/dyn_hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/mako-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/zendecision/ { N; d; }' -i init.mako.rc
    sed -e '/Set FSYNC to enabled/ { N; d; }' -i init.mako.rc
    sed -e '/Disable fsync/ { N; d; }' -i init.mako.rc

if [ $alucard_hotplug -eq 1 ] ; then
    # Set alucard_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Enable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 1
        i\\
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\    # Disable zendecision
        i\    write /sys/kernel/zen_decision/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $autosmp_hotplug -eq 1 ] ; then
    # Set autosmp_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 0
        i\\
        i\    # Enable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled Y
        i\\
        i\    # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\    # Disable zendecision
        i\    write /sys/kernel/zen_decision/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $dyn_hotplug -eq 1 ] ; then
    # Set dyn_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 0
        i\\
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
        i\    # Disable zendecision
        i\    write /sys/kernel/zen_decision/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $mako_hotplug -eq 1 ] ; then
    # Set mako-hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 0
        i\\
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Enable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 1
        i\\
        i\    # Disable zendecision
        i\    write /sys/kernel/zen_decision/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $zendecision -eq 1 ] ; then
    # Set zendecision as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 0
        i\\
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\    # Enable zendecision
        i\    write /sys/kernel/zen_decision/enabled 1
        i\\
        }'  -i init.mako.rc
fi

# Add marker to indicate where HS tweaks have an end
sed '/# disable diag port/ {
        i\    # Set FSYNC to enabled to prevent data loss
        i\    write /sys/module/sync/parameters/fsync_enabled Y
        i\\
        }' -i init.mako.rc

# Workaround to add back the "on charger" CPU Freq Sampling rates
sed -e '/power_collapse\/idle_enabled 1/ { N; d; }' -i init.mako.rc
sed '/service rmt_storage \/system\/bin\/rmt_storage/ {
        i\    write /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled 1
        i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "powersave"
        i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor "powersave"
        i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "powersave"
        i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor "powersave"
        i\    write /sys/devices/system/cpu/cpufreq/ondemand/up_threshold 90
        i\    write /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate 50000
        i\    write /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy 1
        i\    write /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor 4
        i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 384000
        i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 384000
        i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 384000
        i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 384000
        i\    write /sys/devices/system/cpu/cpu1/online 0
        i\    write /sys/devices/system/cpu/cpu2/online 0
        i\    write /sys/devices/system/cpu/cpu3/online 0
        i\\
        }' -i init.mako.rc

# Finally, remove double empty lines
sed '/^$/N;/^\n$/D' -i init.mako.rc

