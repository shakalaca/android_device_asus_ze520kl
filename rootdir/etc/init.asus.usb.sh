#!/system/bin/sh
#[NOTE] 2016.11.24 This script should perform after data mount due to persist property write
cdromname="/system/etc/cdrom_install.iso"
per_sysusbconfig=`getprop persist.sys.usb.config`
if [ -f $cdromname ]; then
    setprop persist.service.cdrom.enable 1
    echo "mounting usbcdrom lun" > /dev/kmsg
    echo $cdromname > /sys/class/android_usb/android0/f_mass_storage/lun/file
    chmod 0444 /sys/class/android_usb/android0/f_mass_storage/lun/file
    echo 1 > /sys/class/android_usb/android0/pready
    echo 0 > /sys/class/android_usb/android0/boot_lock
    case "$per_sysusbconfig" in
	"mtp,mass_storage" | "mtp")
		setprop persist.sys.usb.config mtp,mass_storage
	;;
	*)
		setprop persist.sys.usb.config mtp,adb,mass_storage
	;;
    esac
else
    setprop persist.service.cdrom.enable 0
    echo "unmounting usbcdrom lun" > /dev/kmsg
    echo "" > /sys/class/android_usb/android0/f_mass_storage/lun/file
    echo 1 > /sys/class/android_usb/android0/pready
    echo 0 > /sys/class/android_usb/android0/boot_lock
    case "$per_sysusbconfig" in
	"mtp,mass_storage" | "mtp")
		setprop persist.sys.usb.config mtp
	;;
	*)
		setprop persist.sys.usb.config mtp,adb
	;;
    esac
fi
