#!/system/bin/sh
#
# This script acts as a enabler/disabler for USB-OTG hack for the Nexus 4 (Mako)
# Thanks to ziddey and faux123 @ XDA for this implementation.
#
# Replace the number between the quotes to set the USB-OTG hack.
# 0 to disable, 1 to enable. By default, the hack is disabled
#

echo "0" > sys/module/msm_otg/parameters/otg_hack_enable