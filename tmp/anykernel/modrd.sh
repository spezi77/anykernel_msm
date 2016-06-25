#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Revival use by spezi77
#

# Config for picking the default hotplug (0..off / 1..on)
# Warning: Only enable one hotplug driver at a time!
autosmp_hotplug=0
dyn_hotplug=1
auto_hotplug=0

# Check to see if the ramdisk has already been patched
hstweaks=`grep -c "# <-- Revival Tweaks" init.mako.rc`
if [ $hstweaks -eq 0 ] ; then
    hstweaks=`grep -c "# CPU HOTPLUG tweaks" init.mako.rc`
else
    sed -e '/# <-- Revival Tweaks END -->/ { N; d; }' -i init.mako.rc
fi

if [ $hstweaks -gt 0 ] ; then
    # Substitute tweaks header (if applicable)
    sed 's/CPU HOTPLUG tweaks/<-- Revival Tweaks BEGIN -->/' -i init.mako.rc
fi

# Apply patch only if necessary
if [ $hstweaks -eq 0 ] ; then
    # Check to see if there's any occurence of stop mpdecision in the ramdisk
    stopmpd=`grep -c "stop mpdecision" init.mako.rc`
    # Check to see if there's any occurence of stop thermald in the ramdisk
    stopthe=`grep -c "stop thermald" init.mako.rc`
    # Check to see if there's any occurence of ondemand in the ramdisk
    hellsac=`grep -c "ondemand" init.mako.rc`

hellsac=0

    # Remove end marker (if applicable)
    sed -e '/# <-- Revival Tweaks END -->/ { N; d; }' -i init.mako.rc
    if [ `grep -c "# <-- Revival Tweaks BEGIN" init.mako.rc` -eq 0 ] ; then
        sed '/# disable diag port/ {
            i\    # <-- Revival Tweaks BEGIN -->
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

    # Set CPU governor to ondemand if not set in the ramdisk
    if [ $hellsac -eq 0 ] ; then
        # Remove current cpu and gpu settings if present
        sed '/sys\/devices\/system\/cpu/ d' -i init.mako.rc
        # Prevent duplicates
        sed -e '/# Set GPU governor to interactive/ { N; d; }' -i init.mako.rc
        sed '/kgsl/ d' -i init.mako.rc

        # Add Revival Tweaks
        sed '/# disable diag port/ {
            i\    # Revival Tweaks
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "ondemand"
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor "ondemand"
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "ondemand"
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor "ondemand"
    restorecon_recursive /sys/devices/system/cpu/cpufreq/ondemand
            i\    write /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu1/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu2/cpufreq/screen_off_max_freq 1026000
            i\    write /sys/devices/system/cpu/cpu3/cpufreq/screen_off_max_freq 1026000
            i\\
            i\    # Set GPU governor to interactive
            i\    write /sys/class/kgsl/kgsl-3d0/pwrscale/trustzone/governor interactive
            i\\
        }' -i init.mako.rc
    fi
fi


# CPU Hotplugs section
    # Prevent duplicates
    sed -e '/# <-- Revival Tweaks END -->/ { N; d; }' -i init.mako.rc
    sed -e '/autosmp-hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/dyn_hotplug/ { N; d; }' -i init.mako.rc
    sed -e '/auto-hotplug/ { N; d; }' -i init.mako.rc

if [ $autosmp_hotplug -eq 1 ] ; then
    # Set autosmp_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Enable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled Y
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Disable auto-hotplug
        i\    write /sys/module/auto_hotplug/parameters/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $dyn_hotplug -eq 1 ] ; then
    # Set dyn_hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\\   # Enable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 1
        i\\
        i\    # Disable auto-hotplug
        i\    write /sys/module/auto_hotplug/parameters/enabled 0
        i\\
        }'  -i init.mako.rc
fi

if [ $auto_hotplug -eq 1 ] ; then
    # Set mako-hotplug as default while other hotplugs are set to disabled
    sed '/# disable diag port/ {
        i\    # Disable autosmp-hotplug
        i\    write /sys/module/autosmp/parameters/enabled N
        i\\
        i\\   # Disable dyn_hotplug
        i\    write /sys/module/dyn_hotplug/parameters/enabled 0
        i\\
        i\    # Enable auto-hotplug
        i\    write /sys/module/auto_hotplug/parameters/enabled 1
        i\\
        }'  -i init.mako.rc
fi

# Add marker to indicate where HS tweaks have an end
sed '/# disable diag port/ {
        i\    # <-- Revival Tweaks END -->
        i\\
        }' -i init.mako.rc

