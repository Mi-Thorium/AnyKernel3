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
device.name1=REPLACE_DEVICE_NAME
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


## AnyKernel boot install
dump_boot;

# Enable USB ConfigFS
patch_cmdline androidboot.usbconfigfs androidboot.usbconfigfs=true

write_boot;
## end boot install
