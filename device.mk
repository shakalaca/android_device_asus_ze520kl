#
# Copyright (C) 2016 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:system/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.manual_postprocessing.xml:system/etc/permissions/android.hardware.camera.manual_postprocessing.xml \
    frameworks/native/data/etc/android.hardware.camera.manual_sensor.xml:system/etc/permissions/android.hardware.camera.manual_sensor.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:system/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:system/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:system/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/asus.software.azs.xml:system/etc/permissions/asus.software.azs.xml \
    $(LOCAL_PATH)/configs/permissions/asus.software.zenui.xml:system/etc/permissions/asus.software.zenui.xml

# Screen density
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
PRODUCT_AAPT_CONFIG := normal

# Device was launched with M
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=23

# Boot animation
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH := 1080

$(call inherit-product, frameworks/native/build/phone-xxhdpi-3072-dalvik-heap.mk)
$(call inherit-product, frameworks/native/build/phone-xxhdpi-3072-hwui-memory.mk)

PRODUCT_PACKAGES += libGLES_android

# Audio
PRODUCT_PACKAGES += \
    audiod \
    audio.a2dp.default \
    audio.primary.msm8953 \
    audio.r_submix.default \
    audio.usb.default \
    libbthost_if \
    libaudio-resampler \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcompostprocbundle \
    libvolumelistener \
    tinymix

PRODUCT_COPY_FILES +=  \
    $(LOCAL_PATH)/configs/audio/aanc_tuning_mixer.txt:system/etc/aanc_tuning_mixer.txt \
    $(LOCAL_PATH)/configs/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/configs/audio/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    $(LOCAL_PATH)/configs/audio/audio_output_policy.conf:system/vendor/etc/audio_output_policy.conf \
    $(LOCAL_PATH)/configs/audio/audio_platform_info_extcodec.xml:system/etc/audio_platform_info_extcodec.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_mtp.xml:system/etc/mixer_paths_mtp.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:system/etc/mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_qrd_skuh.xml:system/etc/mixer_paths_qrd_skuh.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_qrd_skui.xml:system/etc/mixer_paths_qrd_skui.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_qrd_skuhf.xml:system/etc/mixer_paths_qrd_skuhf.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_qrd_skum.xml:system/etc/mixer_paths_qrd_skum.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_qrd_sku3.xml:system/etc/mixer_paths_qrd_sku3.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_wcd9330.xml:system/etc/mixer_paths_wcd9330.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_wcd9306.xml:system/etc/mixer_paths_wcd9306.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_wcd9335.xml:system/etc/mixer_paths_wcd9335.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_wcd9326.xml:system/etc/mixer_paths_wcd9326.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_qrd_skun.xml:system/etc/mixer_paths_qrd_skun.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_skuk.xml:system/etc/mixer_paths_skuk.xml

# Voice recognition
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths.xml:system/etc/sound_trigger_mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_platform_info.xml:system/etc/sound_trigger_platform_info.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths_wcd9306.xml:system/etc/sound_trigger_mixer_paths_wcd9306.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths_wcd9330.xml:system/etc/sound_trigger_mixer_paths_wcd9330.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths_wcd9335.xml:system/etc/sound_trigger_mixer_paths_wcd9335.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:/system/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:/system/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:/system/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:/system/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:/system/etc/usb_audio_policy_configuration.xml

# FM
PRODUCT_PACKAGES += \
    FM2 \
    libfmjni \
    libqcomfm_jni \
    libfm-hci \
    fm_helium \
    qcom.fmradio \
    fmhal_service

# Camera
PRODUCT_PACKAGES += \
    camera.msm8953 \
    bspcapability \
    Snap \
    libbson \
    libshim_camera

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/camera/msm8996_camera.xml:system/etc/camera/msm8996_camera.xml \
    $(LOCAL_PATH)/configs/camera/msm8937_camera.xml:system/etc/camera/msm8937_camera.xml \
    $(LOCAL_PATH)/configs/camera/msm8952_camera.xml:system/etc/camera/msm8952_camera.xml \
    $(LOCAL_PATH)/configs/camera/msm8953_camera.xml:system/etc/camera/msm8953_camera.xml \
    $(LOCAL_PATH)/configs/camera/csidtg_camera.xml:system/etc/camera/csidtg_camera.xml \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_352x288_30_1.conf:system/etc/camera/Invensense/VStab_352x288_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_640x480_30_0.conf:system/etc/camera/Invensense/VStab_640x480_30_0.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_720x480_30_1.conf:system/etc/camera/Invensense/VStab_720x480_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_1920x1080_30_0.conf:system/etc/camera/Invensense/VStab_1920x1080_30_0.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_1280x720_30_0.conf:system/etc/camera/Invensense/VStab_1280x720_30_0.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_176x144_30_1.conf:system/etc/camera/Invensense/VStab_176x144_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_352x288_30_0.conf:system/etc/camera/Invensense/VStab_352x288_30_0.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_640x480_30_1.conf:system/etc/camera/Invensense/VStab_640x480_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_1920x1080_30_1.conf:system/etc/camera/Invensense/VStab_1920x1080_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_1280x720_30_1.conf:system/etc/camera/Invensense/VStab_1280x720_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_320x240_30_1.conf:system/etc/camera/Invensense/VStab_320x240_30_1.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_320x240_30_0.conf:system/etc/camera/Invensense/VStab_320x240_30_0.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_176x144_30_0.conf:system/etc/camera/Invensense/VStab_176x144_30_0.conf \
    $(LOCAL_PATH)/configs/camera/Invensense/VStab_720x480_30_0.conf:system/etc/camera/Invensense/VStab_720x480_30_0.conf \
    $(LOCAL_PATH)/configs/camera/imx214_chromatix.xml:system/etc/camera/imx214_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/imx230_qc2002_chromatix.xml:system/etc/camera/imx230_qc2002_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/imx230_qc2002_with_gyro_chromatix.xml:system/etc/camera/imx230_qc2002_with_gyro_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/imx230_chromatix.xml:system/etc/camera/imx230_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/imx258_chromatix.xml:system/etc/camera/imx258_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/imx258_mono_chromatix.xml:system/etc/camera/imx258_mono_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/imx298_chromatix.xml:system/etc/camera/imx298_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/s5k3m2xm_chromatix_bear.xml:system/etc/camera/s5k3m2xm_chromatix_bear.xml \
    $(LOCAL_PATH)/configs/camera/s5k3m2xm_chromatix.xml:system/etc/camera/s5k3m2xm_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/s5k3m2xx_chromatix.xml:system/etc/camera/s5k3m2xx_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/s5k3l8_mono_chromatix.xml:system/etc/camera/s5k3l8_mono_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/s5k3l8_f3l8yam_chromatix.xml:system/etc/camera/s5k3l8_f3l8yam_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/s5k3l8_chromatix.xml:system/etc/camera/s5k3l8_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/csidtg_chromatix.xml:system/etc/camera/csidtg_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov13850_chromatix.xml:system/etc/camera/ov13850_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov13850_q13v06k_chromatix.xml:system/etc/camera/ov13850_q13v06k_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov8858_chromatix.xml:system/etc/camera/ov8858_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov8856_chromatix.xml:system/etc/camera/ov8856_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov8865_chromatix.xml:system/etc/camera/ov8865_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov5670_f5670bq_chromatix.xml:system/etc/camera/ov5670_f5670bq_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov5670_chromatix.xml:system/etc/camera/ov5670_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov5695_chromatix.xml:system/etc/camera/ov5695_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov4688_chromatix.xml:system/etc/camera/ov4688_chromatix.xml \
    $(LOCAL_PATH)/configs/camera/ov2680_chromatix.xml:system/etc/camera/ov2680_chromatix.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/bspcapability.xml:system/etc/bspcapability.xml \

# Display
PRODUCT_PACKAGES += \
    gralloc.msm8953 \
    copybit.msm8953 \
    hwcomposer.msm8953 \
    memtrack.msm8953 \
    liboverlay \
    libtinyxml

# Connectivity Engine support
PRODUCT_PACKAGES += \
    libcnefeatureconfig

# Display Calibration
PRODUCT_PACKAGES += \
    libjni_livedisplay

# Fingerprint
PRODUCT_PACKAGES += \
    fingerprintd

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fpservice.sh:system/etc/fpservice.sh

# For android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Browser
PRODUCT_PACKAGES += \
    Gello

# GPS
PRODUCT_PACKAGES += \
    gps.msm8953 \
    libgnsspps

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/etc/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/gps/etc/flp.conf:system/etc/flp.conf \
    $(LOCAL_PATH)/gps/etc/izat.conf:system/etc/izat.conf \
    $(LOCAL_PATH)/gps/etc/lowi.conf:system/etc/lowi.conf \
    $(LOCAL_PATH)/gps/etc/sap.conf:system/etc/sap.conf \
    $(LOCAL_PATH)/gps/etc/xtwifi.conf:system/etc/xtwifi.conf

# Ebtables
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes

# IRQ
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

# IRSC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:system/etc/sec_config

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/ASUS_TransKeyboard.kl:system/usr/keylayout/ASUS_TransKeyboard.kl \
    $(LOCAL_PATH)/configs/keylayout/focal-touchscreen.kl:system/usr/keylayout/focal-touchscreen.kl \
    $(LOCAL_PATH)/configs/keylayout/ft5x06_ts.kl:system/usr/keylayout/ft5x06_ts.kl \
    $(LOCAL_PATH)/configs/keylayout/goodixfp.kl:system/usr/keylayout/goodixfp.kl \
    $(LOCAL_PATH)/configs/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/configs/keylayout/synaptics_dsx.kl:system/usr/keylayout/synaptics_dsx.kl \
    $(LOCAL_PATH)/configs/keylayout/synaptics_dsxv26.kl:system/usr/keylayout/synaptics_dsxv26.kl \
    $(LOCAL_PATH)/configs/keylayout/synaptics_rmi4_i2c.kl:system/usr/keylayout/synaptics_rmi4_i2c.kl

# Lights
PRODUCT_PACKAGES += \
    lights.msm8953

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media/media_profiles.xml:system/etc/media_profiles.xml

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/capability.xml:system/etc/capability.xml \

# OMX
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libextmedia_jni \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVenc \
    libOmxVidcCommon \
    libstagefrighthw \
    libmm-omxcore

# Power
PRODUCT_PACKAGES += \
    power.msm8953

# QMI
PRODUCT_PACKAGES += \
    libjson

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.class_core.sh \
    init.qcom.early_boot.sh \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.qcom.usb.sh \
    init.qcom.sensors.sh \
    init.qcom.sh \
    init.class_main.sh \
    ueventd.qcom.rc

PRODUCT_PACKAGES += \
    init.asus.rc \
    init.asus.usb.sh \
    init.asus.usb.rc \
    init.asus.thermald.rc \
    init.asus.debugtool.rc \
    init.target.rc \
    sp

# RIL
PRODUCT_PACKAGES += \
    librmnetctl \
    libxml2 \
    libtar \
    libprotobuf-cpp-lite

# Sensors
PRODUCT_PACKAGES += \
    sensors.msm8953

# Wifi
PRODUCT_PACKAGES += \
    ipacm \
    ipacm-diag \
    IPACM_cfg.xml \
    libqsap_sdk \
    libQWiFiSoftApCfg \
    libwcnss_qmi \
    libwpa_client \
    libwifi-hal-qcom \
    hostapd \
    dhcpcd.conf \
    wpa_supplicant \
    wpa_supplicant.conf \
    hs20-osu-client

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat \
    $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_cfg.ini:system/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_wlan_nv.bin:system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin \
    $(LOCAL_PATH)/configs/wifi/WCNSS_wlan_dictionary.dat:system/etc/firmware/wlan/prima/WCNSS_wlan_dictionary.dat

PRODUCT_PACKAGES += \
    libcurl \
    tcpdump \
    wcnss_service

PRODUCT_PACKAGES += \
    fstman \
    fstman.ini

# IMS
PRODUCT_PACKAGES += \
    libshim_ims

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal/thermal-engine.conf:system/etc/thermal-engine.conf

# e2fsck
PRODUCT_PACKAGES += \
    e2fsck \
    resize2fs \
    tune2fs \
    blkid \
    mke2fs

# ANT+
PRODUCT_PACKAGES += \
    antradio_app \
    AntHalService \
    com.dsi.ant.antradio_library \
    libantradio

PRODUCT_COPY_FILES += \
    external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:system/etc/permissions/com.dsi.ant.antradio_library.xml

# ASUS Splendid
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W07.txt:/system/etc/firmware/phone_ct/BOE/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C01.txt:/system/etc/firmware/phone_ct/BOE/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C03.txt:/system/etc/firmware/phone_ct/BOE/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W02.txt:/system/etc/firmware/phone_ct/BOE/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W10.txt:/system/etc/firmware/phone_ct/BOE/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C05.txt:/system/etc/firmware/phone_ct/BOE/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C04.txt:/system/etc/firmware/phone_ct/BOE/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W06.txt:/system/etc/firmware/phone_ct/BOE/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_RdWeak.txt:/system/etc/firmware/phone_ct/BOE/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_Rd02.txt:/system/etc/firmware/phone_ct/BOE/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W09.txt:/system/etc/firmware/phone_ct/BOE/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_DEF.txt:/system/etc/firmware/phone_ct/BOE/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C02.txt:/system/etc/firmware/phone_ct/BOE/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W04.txt:/system/etc/firmware/phone_ct/BOE/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_Rd03.txt:/system/etc/firmware/phone_ct/BOE/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C07.txt:/system/etc/firmware/phone_ct/BOE/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C06.txt:/system/etc/firmware/phone_ct/BOE/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_Rd01.txt:/system/etc/firmware/phone_ct/BOE/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W01.txt:/system/etc/firmware/phone_ct/BOE/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W05.txt:/system/etc/firmware/phone_ct/BOE/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C08.txt:/system/etc/firmware/phone_ct/BOE/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W08.txt:/system/etc/firmware/phone_ct/BOE/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_W03.txt:/system/etc/firmware/phone_ct/BOE/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_RdStrong.txt:/system/etc/firmware/phone_ct/BOE/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C09.txt:/system/etc/firmware/phone_ct/BOE/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/BOE/LUT_C10.txt:/system/etc/firmware/phone_ct/BOE/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W07.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C01.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C03.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W02.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W10.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C05.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C04.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W06.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_RdWeak.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_Rd02.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W09.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_DEF.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C02.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W04.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_Rd03.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C07.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C06.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_Rd01.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W01.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W05.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C08.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W08.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_W03.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_RdStrong.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C09.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P5/LUT_C10.txt:/system/etc/firmware/phone_ct/TM5P5/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W07.txt:/system/etc/firmware/phone_ct/TXD/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C01.txt:/system/etc/firmware/phone_ct/TXD/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C03.txt:/system/etc/firmware/phone_ct/TXD/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W02.txt:/system/etc/firmware/phone_ct/TXD/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W10.txt:/system/etc/firmware/phone_ct/TXD/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C05.txt:/system/etc/firmware/phone_ct/TXD/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C04.txt:/system/etc/firmware/phone_ct/TXD/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W06.txt:/system/etc/firmware/phone_ct/TXD/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_RdWeak.txt:/system/etc/firmware/phone_ct/TXD/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_Rd02.txt:/system/etc/firmware/phone_ct/TXD/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W09.txt:/system/etc/firmware/phone_ct/TXD/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_DEF.txt:/system/etc/firmware/phone_ct/TXD/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C02.txt:/system/etc/firmware/phone_ct/TXD/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W04.txt:/system/etc/firmware/phone_ct/TXD/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_Rd03.txt:/system/etc/firmware/phone_ct/TXD/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C07.txt:/system/etc/firmware/phone_ct/TXD/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C06.txt:/system/etc/firmware/phone_ct/TXD/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_Rd01.txt:/system/etc/firmware/phone_ct/TXD/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W01.txt:/system/etc/firmware/phone_ct/TXD/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W05.txt:/system/etc/firmware/phone_ct/TXD/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C08.txt:/system/etc/firmware/phone_ct/TXD/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W08.txt:/system/etc/firmware/phone_ct/TXD/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_W03.txt:/system/etc/firmware/phone_ct/TXD/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_RdStrong.txt:/system/etc/firmware/phone_ct/TXD/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C09.txt:/system/etc/firmware/phone_ct/TXD/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TXD/LUT_C10.txt:/system/etc/firmware/phone_ct/TXD/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W07.txt:/system/etc/firmware/phone_ct/CTC/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C01.txt:/system/etc/firmware/phone_ct/CTC/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C03.txt:/system/etc/firmware/phone_ct/CTC/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W02.txt:/system/etc/firmware/phone_ct/CTC/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W10.txt:/system/etc/firmware/phone_ct/CTC/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C05.txt:/system/etc/firmware/phone_ct/CTC/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C04.txt:/system/etc/firmware/phone_ct/CTC/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W06.txt:/system/etc/firmware/phone_ct/CTC/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_RdWeak.txt:/system/etc/firmware/phone_ct/CTC/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_Rd02.txt:/system/etc/firmware/phone_ct/CTC/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W09.txt:/system/etc/firmware/phone_ct/CTC/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_DEF.txt:/system/etc/firmware/phone_ct/CTC/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C02.txt:/system/etc/firmware/phone_ct/CTC/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W04.txt:/system/etc/firmware/phone_ct/CTC/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_Rd03.txt:/system/etc/firmware/phone_ct/CTC/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C07.txt:/system/etc/firmware/phone_ct/CTC/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C06.txt:/system/etc/firmware/phone_ct/CTC/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_Rd01.txt:/system/etc/firmware/phone_ct/CTC/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W01.txt:/system/etc/firmware/phone_ct/CTC/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W05.txt:/system/etc/firmware/phone_ct/CTC/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C08.txt:/system/etc/firmware/phone_ct/CTC/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W08.txt:/system/etc/firmware/phone_ct/CTC/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_W03.txt:/system/etc/firmware/phone_ct/CTC/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_RdStrong.txt:/system/etc/firmware/phone_ct/CTC/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C09.txt:/system/etc/firmware/phone_ct/CTC/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/CTC/LUT_C10.txt:/system/etc/firmware/phone_ct/CTC/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W07.txt:/system/etc/firmware/phone_ct/LCE/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C01.txt:/system/etc/firmware/phone_ct/LCE/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C03.txt:/system/etc/firmware/phone_ct/LCE/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W02.txt:/system/etc/firmware/phone_ct/LCE/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W10.txt:/system/etc/firmware/phone_ct/LCE/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C05.txt:/system/etc/firmware/phone_ct/LCE/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C04.txt:/system/etc/firmware/phone_ct/LCE/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W06.txt:/system/etc/firmware/phone_ct/LCE/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_RdWeak.txt:/system/etc/firmware/phone_ct/LCE/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_Rd02.txt:/system/etc/firmware/phone_ct/LCE/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W09.txt:/system/etc/firmware/phone_ct/LCE/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_DEF.txt:/system/etc/firmware/phone_ct/LCE/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C02.txt:/system/etc/firmware/phone_ct/LCE/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W04.txt:/system/etc/firmware/phone_ct/LCE/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_Rd03.txt:/system/etc/firmware/phone_ct/LCE/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C07.txt:/system/etc/firmware/phone_ct/LCE/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C06.txt:/system/etc/firmware/phone_ct/LCE/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_Rd01.txt:/system/etc/firmware/phone_ct/LCE/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W01.txt:/system/etc/firmware/phone_ct/LCE/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W05.txt:/system/etc/firmware/phone_ct/LCE/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C08.txt:/system/etc/firmware/phone_ct/LCE/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W08.txt:/system/etc/firmware/phone_ct/LCE/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_W03.txt:/system/etc/firmware/phone_ct/LCE/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_RdStrong.txt:/system/etc/firmware/phone_ct/LCE/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C09.txt:/system/etc/firmware/phone_ct/LCE/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/LCE/LUT_C10.txt:/system/etc/firmware/phone_ct/LCE/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W07.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C01.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C03.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W02.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W10.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C05.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C04.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W06.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_RdWeak.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_Rd02.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W09.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_DEF.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C02.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W04.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_Rd03.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C07.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C06.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_Rd01.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W01.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W05.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C08.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W08.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_W03.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_RdStrong.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C09.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/phone_ct/TM5P2/LUT_C10.txt:/system/etc/firmware/phone_ct/TM5P2/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/asussplendid_config.xml:/system/etc/firmware/Splendid/asussplendid_config.xml \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/LUT_Rd03.txt:/system/etc/firmware/Splendid/LUT/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W07.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C01.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C03.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W02.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W10.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C05.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C04.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W06.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_RdWeak.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_Rd02.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W09.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_DEF.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C02.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W04.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_Rd03.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C07.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C06.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_Rd01.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W01.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W05.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C08.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W08.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_W03.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_RdStrong.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C09.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/BOE/LUT_C10.txt:/system/etc/firmware/Splendid/LUT/BOE/LUT_C10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W07.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C01.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C03.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W02.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W10.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W10.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C05.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C04.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W06.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_RdWeak.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_RdWeak.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_Rd02.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_Rd02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W09.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_DEF.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_DEF.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C02.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C02.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W04.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W04.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_Rd03.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_Rd03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C07.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C07.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C06.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C06.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_Rd01.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_Rd01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W01.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W01.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W05.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W05.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C08.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W08.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W08.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_W03.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_W03.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_RdStrong.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_RdStrong.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C09.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C09.txt \
    $(LOCAL_PATH)/configs/splendid/firmware/Splendid/LUT/TM/LUT_C10.txt:/system/etc/firmware/Splendid/LUT/TM/LUT_C10.txt

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/asus.hardware.display.splendid.reading_mode.xml:system/etc/permissions/asus.hardware.display.splendid.reading_mode.xml \
    $(LOCAL_PATH)/configs/permissions/asus.hardware.display.splendid.xml:system/etc/permissions/asus.hardware.display.splendid.xml

PRODUCT_PACKAGES += \
    AsusSplendidCommandAgent

# FlipCover
PRODUCT_PACKAGES += \
    FlipCoverWrapper

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/asus.software.cover3_feature_1.xml:/system/etc/permissions/asus.software.cover3_feature_1.xml \
    $(LOCAL_PATH)/configs/permissions/asus.hardware.transcover_version3.xml:/system/etc/permissions/asus.hardware.transcover_version3.xml \
    $(LOCAL_PATH)/configs/permissions/asus.hardware.transcover.xml:/system/etc/permissions/asus.hardware.transcover.xml \
    $(LOCAL_PATH)/configs/permissions/asus.hardware.transcover_info.xml:/system/etc/permissions/asus.hardware.transcover_info.xml

# dataservice
PRODUCT_PACKAGES += \
    rmnetcli

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

$(call inherit-product, vendor/cm/config/common_full_phone.mk)
