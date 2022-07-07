# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=REPLACE_KERNEL_STRING
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=mi8937
device.name2=land
device.name3=landtoni
device.name4=riva
device.name5=rolex
device.name6=rova
device.name7=santoni
device.name8=ugg
device.name9=ugglite
device.name10=ulysse
device.name11=prada
device.name12=tiare
supported.versions=REPLACE_ANDROID_VERSION
supported.patchlevels=
'; } # end properties

PARTITION=REPLACE_PARTITION

# shell variables
block=/dev/block/bootdevice/by-name/$PARTITION;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=0;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

# Backup the partition
if dd if=${block} of=/sdcard/previous-${PARTITION}.img; then
  ui_print ""
  ui_print "Your previous ${PARTITION} image has been saved to: /sdcard/previous-${PARTITION}.img"
  ui_print ""
fi

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

# If lk2nd is installed, Read boot from 1MB offset
if [ "$(dd if=${block} skip=64 bs=1 count=5 2>/dev/null)" == "lk2nd" ]; then
  ui_print "Detected lk2nd installation! Skipping the first 1MB."
  customdd="bs=1M skip=1"
  lk2nd=1
fi

## AnyKernel boot install
dump_boot;

# Enable USB ConfigFS
patch_cmdline androidboot.usbconfigfs androidboot.usbconfigfs=true

# Disable PRLMK kill_heaviest_gid on tiare
if ! [ -z "$(cat /proc/cmdline|grep S88508)" ]; then
	patch_cmdline prlmk.kill_heaviest_gid prlmk.kill_heaviest_gid=0
fi

# If lk2nd is installed, Write boot to 1MB offset
if [ "$lk2nd" == "1" ]; then
  customdd="bs=1M seek=1"
  toybox blkdiscard -o 1048576 $block
else
  toybox blkdiscard $block
fi

write_boot;
## end boot install
