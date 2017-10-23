#!/system/bin/sh

# initial
/system/bin/fpseek

FP_module=`getprop ro.hardware.fingerprint`
HW_module=`getprop ro.config.versatility`

if [ "$FP_module" == 'gxfp3' ]; then
	/system/bin/gx_fpd_gxfp3
elif [ "$FP_module" == 'gxfp5' ]; then
	/system/bin/gx_fpd_gxfp3
elif [ "$FP_module" == 'gxfpa' ]; then
	/system/bin/gx_fpd
fi

if [ "$HW_module" == 'CN' ]; then
	/system/bin/TEEService
fi