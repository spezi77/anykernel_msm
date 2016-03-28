#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Marshmallow use by Zaclimon
#


# Check to see if there's any occurence of franco's tweaks in the ramdisk
francotweaks=`grep -c "import init.performance_profiles.rc" init.mako.rc`

# Apply performance profiles stuff
if [ $francotweaks -eq 0 ] ; then
sed '/import init.mako.tiny.rc/ a\import init.performance_profiles.rc' -i init.mako.rc
cp ../init.performance_profiles.rc ./
chmod 0755 init.performance_profiles.rc
fi

# Modifications to init.mako.rc
if [ $francotweaks -eq 0 ] ; then
sed '/scaling_governor/ s/ondemand/hellsactive/g' -i init.mako.rc
sed '/scaling_governor/ s/interactive/hellsactive/g' -i init.mako.rc
sed '/scaling_governor/ s/intelliactive/hellsactive/g' -i init.mako.rc
sed '/scaling_governor/ s/conservative/hellsactive/g' -i init.mako.rc

sed '/cpu3\/cpufreq\/scaling_min_freq 81000/ a\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu3\/cpufreq\/scaling_min_freq 94000/ a\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu3\/cpufreq\/scaling_min_freq 384000/ a\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu0\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu1\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu2\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/# disable diag port/ i\    write /sys/devices/system/cpu/cpu1/online 1' -i init.mako.rc
sed '/# disable diag port/ i\    write /sys/devices/system/cpu/cpu2/online 0' -i init.mako.rc
sed '/# disable diag port/ i\    write /sys/devices/system/cpu/cpu3/online 0' -i init.mako.rc
sed '/# disable diag port/ i\\' -i init.mako.rc
sed '/# disable diag port/ i\    # hellsactive' -i init.mako.rc
sed '/# disable diag port/ i\\' -i init.mako.rc

sed '/# hellsactive/ a\    restorecon_recursive /sys/devices/system/cpu/cpufreq/hellsactive' -i init.mako.rc
sed '/restorecon_recursive \/sys\/devices\/system\/cpu\/cpufreq\/hellsactive/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/above_hispeed_delay "20000 1026000:60000 1242000:150000"' -i init.mako.rc
sed '/hellsactive\/above_hispeed_delay "20000 1026000:60000 1242000:150000"/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/align_windows 1' -i init.mako.rc
sed '/hellsactive\/align_windows 1/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/boostpulse_duration 1000000' -i init.mako.rc
sed '/hellsactive\/boostpulse_duration 1000000/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/go_hispeed_load 99' -i init.mako.rc
sed '/hellsactive\/go_hispeed_load 99/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/hispeed_freq 1134000' -i init.mako.rc
sed '/hellsactive\/hispeed_freq 1134000/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/io_is_busy 1' -i init.mako.rc
sed '/hellsactive\/io_is_busy 1/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/target_loads "90 384000:40 1026000:80 1242000:95"' -i init.mako.rc
sed '/hellsactive\/target_loads "90 384000:40 1026000:80 1242000:95"/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/min_sample_time 80000' -i init.mako.rc
sed '/hellsactive\/min_sample_time 80000/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/timer_rate 20000' -i init.mako.rc
sed '/hellsactive\/timer_rate 20000/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/max_freq_hysteresis 0' -i init.mako.rc
sed '/hellsactive\/max_freq_hysteresis 0/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/timer_slack 80000' -i init.mako.rc
sed '/hellsactive\/timer_slack 80000/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/two_phase_freq "1350000,1350000,1350000,1350000"' -i init.mako.rc
sed '/hellsactive\/two_phase_freq "1350000,1350000,1350000,1350000"/ a\    write /sys/devices/system/cpu/cpufreq/hellsactive/input_boost_freq 1026000' -i init.mako.rc
sed '/hellsactive\/input_boost_freq 1026000/ a\    # GPU' -i init.mako.rc
sed '/hellsactive\/input_boost_freq 1026000/ a\\' -i init.mako.rc
fi

# Modifications to init.rc
if [ $francotweaks -eq 0 ] ; then
sed '/sys\/devices\/system\/cpu\/cpufreq\/hellsactive/ s/0660/0664/g' -i init.rc
fi
