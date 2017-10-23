CFLAGS := -Wall -g -MMD
LDFLAGS :=
LIBS :=
LOCAL_CFLAGS :=
EXTERNAL_CFLAGS :=

external_srcs :=

#CONFIG_DBUS:=1

PKG_CONFIG := pkg-config

EXTERNAL_SRC_DIR := external

progs := fstman

local_srcs := fst_mux_bonding.c \
	fst_manager.c \
	fst_tc.c

LOCAL_CFLAGS += -I$(EXTERNAL_SRC_DIR)/ -I$(EXTERNAL_SRC_DIR)/inih
EXTERNAL_CFLAGS += $(addprefix -I,$(sort $(dir $(wildcard $(EXTERNAL_SRC_DIR)/*/))))

LOCAL_CFLAGS += $(shell $(PKG_CONFIG) --cflags libnl-3.0)
LIBS += $(shell $(PKG_CONFIG) --libs libnl-3.0)

ifndef CONFIG_DBUS

external_srcs += \
	$(EXTERNAL_SRC_DIR)/wpa_ctrl.c \
	$(EXTERNAL_SRC_DIR)/eloop.c \
	$(EXTERNAL_SRC_DIR)/common.c \
	$(EXTERNAL_SRC_DIR)/os_unix.c \
	$(EXTERNAL_SRC_DIR)/wpa_debug.c \
	$(EXTERNAL_SRC_DIR)/fst_ctrl_aux.c \
	$(EXTERNAL_SRC_DIR)/inih/ini.c

EXTERNAL_CFLAGS += -DCONFIG_CTRL_IFACE -DCONFIG_CTRL_IFACE_UNIX -DCONFIG_FST
EXTERNAL_CFLAGS += -DCONFIG_DEBUG_FILE

local_srcs += fst_ctrl.c fst_cfgmgr.c fst_ini_conf.c main.c fst_rateupg.c

else

LOCAL_CFLAGS += \
	$(shell $(PKG_CONFIG) --cflags glib-2.0) \
	$(shell $(PKG_CONFIG) --cflags gio-2.0) \
	-DCONFIG_DBUS
LIBS += \
	$(shell $(PKG_CONFIG) --libs glib-2.0) \
	$(shell $(PKG_CONFIG) --libs gio-2.0)

local_srcs += fst_ctrl_dbus.c main_dbus.c

external_srcs += \
	$(EXTERNAL_SRC_DIR)/os_unix.c \
	$(EXTERNAL_SRC_DIR)/fst_ctrl_aux.c

endif

local_objs :=$(local_srcs:.c=.o)
external_objs := $(external_srcs:.c=.o)
all_objs :=$(local_objs) $(external_objs)

all prod prof: $(progs)

fstman: $(all_objs)

fstman: $(LIBS)

prod prof: CFLAGS += -O2
prof: CFLAGS += -pg

prod: strip

$(all_objs): %.o: %.c

$(local_objs):
	$(CC) $(CFLAGS) $(LOCAL_CFLAGS) -o $@ -c $<

$(external_objs):
	$(CC) $(CFLAGS) $(EXTERNAL_CFLAGS) -o $@ -c $<

$(progs): %:
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)

strip:
	strip $(progs)

clean:
	$(RM) $(all_objs) $(progs) $(all_objs:%.o=%.d)

echo:
	@echo $(progs) $(local_srcs) $(all_objs) $(all_objs:%.o=%.d)

-include $(all_objs:%.o=%.d)
