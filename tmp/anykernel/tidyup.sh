#!/sbin/sh


mount -o rw /system;


# disable the PowerHAL since there is a kernel-side touch boost implemented
 [ -e /system/lib/hw/power.msm8960.so ] && mv /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so.bak;

# disable mpdecision

 [ -e /system/bin/mpdecision ] && mv /system/bin/mpdecision /system/bin/mpdecision.bak;

umount /system;

