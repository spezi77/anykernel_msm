#!/sbin/sh

mount -o rw /system;

# thermald.conf
chown root.system system/etc/thermald.conf
chmod 644 system/etc/thermald.conf

# mpdfake
chown root.system system/bin/mpdfake
chmod 755 system/bin/mpdfake

umount /system;

return $?
