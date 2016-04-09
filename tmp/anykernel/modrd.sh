#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for HellSpawn use by spezi77
#

# Config for msm_mpdecision based kernel
msm_mpdecision=0

# Check to see if the ramdisk has already been patched
bstweaks=`grep -c "# CPU HOTPLUG tweaks" init.mako.rc`
if [ $bstweaks -eq 0 ] ; then
    bstweaks=`grep -c "# <-- HellSpawn Tweaks" init.mako.rc`
fi

# Apply patch only if necessary
if [ $bstweaks -eq 0 ] ; then
    # Check to see if there's any occurence of stop mpdecision in the ramdisk
    stopmpd=`grep -c "stop mpdecision" init.mako.rc`
    # Check to see if there's any occurence of stop thermald in the ramdisk
    stopthe=`grep -c "stop thermald" init.mako.rc`
    # Check to see if there's any occurence of hellsactive in the ramdisk
    hellsac=`grep -c "hellsactive" init.mako.rc`

if [ $msm_mpdecision -eq 1 ] ; then
    stopmpd=1
    stopthe=1
fi

    sed '/# disable diag port/ {
            i\    # <-- HellSpawn Tweaks BEGIN -->
            i\\
            }' -i init.mako.rc

    # Stop mpdecision if not set in the ramdisk
    if [ $stopmpd -eq 0 ] ; then
        sed '/# communicate with mpdecision and thermald/ d' -i init.mako.rc
        sed -e '/mpdecision 2770 root system/ { N; d; }' -i init.mako.rc
        sed '/# disable diag port/ {
            i\    # Disable mpdecision service to prevent conflicts with mako-hotplug
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
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 94000
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 94000
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 94000
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 94000
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
    sed '/# disable diag port/ {
            i\    # <-- HellSpawn Tweaks END -->
            i\\
            }' -i init.mako.rc
fi
