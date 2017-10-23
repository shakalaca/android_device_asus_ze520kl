LOCAL_PATH := $(call my-dir)
PKG_CONFIG ?= pkg-config

INCLUDES = $(LOCAL_PATH)
INCLUDES += $(LOCAL_PATH)/external
INCLUDES += $(LOCAL_PATH)/external/common
INCLUDES += $(LOCAL_PATH)/external/fst
INCLUDES += $(LOCAL_PATH)/external/utils
INCLUDES += $(LOCAL_PATH)/external/inih
# The iproute includes used for a correct linux/pkt_sched.h
INCLUDES += external/iproute2/include
INCLUDES += external/libnl/include

OBJS = fst_mux_bonding.c
OBJS += fst_manager.c
OBJS += fst_tc.c
OBJS += fst_ctrl.c
OBJS += main.c
OBJS += fst_cfgmgr.c
OBJS += fst_ini_conf.c
OBJS += fst_rateupg.c

OBJS += external/wpa_ctrl.c
OBJS += external/eloop.c
OBJS += external/common.c
OBJS += external/os_unix.c
OBJS += external/wpa_debug.c
OBJS += external/fst_ctrl_aux.c
OBJS += external/inih/ini.c

L_CFLAGS += -DCONFIG_CTRL_IFACE -DCONFIG_CTRL_IFACE_UNIX -DCONFIG_FST -DCONFIG_LIBNL20 -DANDROID
L_CFLAGS += -DCONFIG_CTRL_IFACE_CLIENT_DIR=\"/data/misc/wifi/sockets\"
L_CFLAGS += -DDEFAULT_HAPD_CLI_DIR=\"/data/misc/wifi/hostapd\"
L_CFLAGS += -DDEFAULT_WPAS_CLI_DIR=\"\"
L_CFLAGS += -DCONFIG_ANDROID_LOG
L_CFLAGS += -DANDROID_LOG_NAME=\"fstman\"
# Disable unused parameter warnings
L_CFLAGS += -Wno-unused-parameter

include $(CLEAR_VARS)
LOCAL_MODULE       := fstman.ini
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/wifi
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := fstman
LOCAL_SHARED_LIBRARIES += libnl
LOCAL_SHARED_LIBRARIES += libcutils
LOCAL_CFLAGS := $(L_CFLAGS)
LOCAL_SRC_FILES := $(OBJS)
LOCAL_C_INCLUDES := $(INCLUDES)
include $(BUILD_EXECUTABLE)
