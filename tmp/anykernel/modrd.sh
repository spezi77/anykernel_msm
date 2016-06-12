#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for HellSpawn use by spezi77
#

# Config for picking the default hotplug (0..off / 1..on)
# Warning: Only enable one hotplug driver at a time!
alucard_hotplug=0
autosmp_hotplug=1
intelliplug=0
dyn_hotplug=0
mako_hotplug=0
zendecision=0
thunderplug=0

# Check to see if the ramdisk has already been patched
hstweaks=`grep -c "# <-- HellSpawn Tweaks" init.mako.rc`
if [ $hstweaks -eq 0 ] ; then
    hstweaks=`grep -c "# CPU HOTPLUG tweaks" init.mako.rc`
else
    sed -e '/# <-- HellSpawn Tweaks END -->/ { N; d; }' -i init.mako.rc
fi

if [ $hstweaks -gt 0 ] ; then
    # Substitute tweaks header (if applicable)
    sed 's/CPU HOTPLUG tweaks/<-- HellSpawn Tweaks BEGIN -->/' -i init.mako.rc
    forceupd=`grep -c "# Disable mako-hotplug" init.mako.rc`
    # Force update occurs when someone comes from HS with bricked_hotplug and is about to dirty flash HS with mako-hotplug
    if [ $forceupd -eq 1 ] ; then
        # Remove mpdecision settings
        sed -e '/# communicate with mpdecision and thermald/  { N; d; }' -i init.mako.rc
        sed -e '/alucard-hotplug/ { N; d; }' -i init.mako.rc
        sed -e '/autosmp-hotplug/ { N; d; }' -i init.mako.rc
        sed -e '/intelliplug/ { N; d; }' -i init.mako.rc
        sed -e '/dyn_hotplug/ { N; d; }' -i init.mako.rc
        sed -e '/mako-hotplug/ { N; d; }' -i init.mako.rc
        sed -e '/thunderplug/ { N; d; }' -i init.mako.rc
        sed -e '/zendecision/ { N; d; }' -i init.mako.rc
        # let's go through the patch routine
        hstweaks=0
    fi
fi

# Apply patch only if necessary
if [ $hstweaks -eq 0 ] ; then
    # Check to see if there's any occurence of stop mpdecision in the ramdisk
    stopmpd=`grep -c "stop mpdecision" init.mako.rc`
    # Check to see if there's any occurence of stop thermald in the ramdisk
    stopthe=`grep -c "stop thermald" init.mako.rc`
    # Check to see if there's any occurence of hellsactive in the ramdisk
    hellsac=`grep -c "hellsactive" init.mako.rc`

    # Remove end marker (if applicable)
    sed -e '/# <-- HellSpawn Tweaks END -->/ { N; d; }' -i init.mako.rc
    if [ `grep -c "# <-- HellSpawn Tweaks BEGIN" init.mako.rc` -eq 0 ] ; then
        sed '/# disable diag port/ {
            i\    # <-- HellSpawn Tweaks BEGIN -->
            i\\
            }' -i init.mako.rc
    fi

    # Stop mpdecision if not set in the ramdisk
    if [ $stopmpd -eq 0 ] ; then
        sed '/# communicate with mpdecision and thermald/ d' -i init.mako.rc
        sed -e '/mpdecision 2770 root system/ { N; d; }' -i init.mako.rc
        sed '/# disable diag port/ {
            i\    # Disable mpdecision service to prevent conflicts with other hotplug drivers
            i\    stop mpdecision
            i\\
            }'  -i init.mako.rc
    fi

    # Stop thermald if not set in the ramdisk
    if [ $stopthe -eq 0 ] ; then
        sed '/# communicate with mpdecision and thermald/ d' -i init.mako.rc
        sed -e '/mpdecision 2770 root system/ { N; d; }' -i init.mako.rc
        sed '/# disable diag port/ {
            i\    # Disable thermald service
            i\    stop thermald
            i\\
            }'  -i init.mako.rc
    fi

    # Set CPU governor to hellsactive if not set in the ramdisk
    if [ $hellsac -eq 0 ] ; then
        # Remove current cpu and gpu settings if present
        sed '/sys\/devices\/system\/cpu/ d' -i init.mako.rc
        # Prevent duplicates
        sed -e '/# Set GPU governor to simple/ { N; d; }' -i init.mako.rc
        sed '/kgsl/ d' -i init.mako.rc

        # Add HellSpawn Tweaks
        sed '/# disable diag port/ {
            i\    # HellsActive Tweaks
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
            i\\
            i\    # Set GPU governor to simple
            i\    write /sys/class/kgsl/kgsl-3d0/pwrscale/trustzone/governor simple
            i\\
        }' -i init.mako.rc
    fi
fi


# CPU Hotplugs section
    # Prevent duplicates
    sed -e '/# <-- HellSpawn Tweaks END -->/ { N; d; }' -i init.mako.rc
    sed -e '/alucard-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/autosmp-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/intelliplug/ { N; d; }' -i init.mako.rc
    sed -e '/dyn_hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/mako-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/thunderplug/ { N; d; }' -i init.mako.rc
    sed -e '/zendecision/ { N; d; }' -i init.mako.rc


if [ $alucard_hotplug -eq 1 ] ; then
    # Set alucard_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Enable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 1
        i\\
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Disable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 0
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\\   # Disable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 0
        i\\
        i\\   # Disable zendecision
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
        i\    # Disable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 0
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\\   # Disable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 0
        i\\
        i\\   # Disable zendecision
        i\    write /sys/kernel/zen_decision/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $intelliplug -eq 1 ] ; then
    # Set intelliplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 0
        i\\
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Enable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 1
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\\   # Disable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 0
        i\\
        i\\   # Disable zendecision
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
        i\    # Disable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 0
        i\\
        i\\   # Enable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 1
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\\   # Disable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 0
        i\\
        i\\   # Disable zendecision
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
        i\    # Disable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 0
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Enable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 1
        i\\
        i\\   # Disable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 0
        i\\
        i\\   # Disable zendecision
        i\    write /sys/kernel/zen_decision/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $thunderplug -eq 1 ] ; then
    # Set thunderplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable alucard-hotplug
        i\    write /sys/kernel/alucard_hotplug/hotplug_enable 0
        i\\
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\    # Disable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 0
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\\   # Enable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 1
        i\\
        i\\   # Disable zendecision
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
        i\    # Disable intelliplug
        i\    write /sys/module/intelli_plug/parameters/intelli_plug_active 0
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable mako-hotplug
        i\    write /sys/class/misc/mako_hotplug_control/enabled 0
        i\\
        i\\   # Disable thunderplug
        i\    write /sys/kernel/thunderplug/hotplug_enabled 0
        i\\
        i\\   # Enable zendecision
        i\    write /sys/kernel/zen_decision/enabled 1
        i\\
        }'  -i init.mako.rc
fi

# Add marker to indicate where HS tweaks have an end
sed '/# disable diag port/ {
        i\    # <-- HellSpawn Tweaks END -->
        i\\
        }' -i init.mako.rc

