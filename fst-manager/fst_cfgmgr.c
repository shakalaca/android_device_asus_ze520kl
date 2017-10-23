/*
 * FST Manager: FST Configuration Manager
 *
 * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <linux/sockios.h>
#include "fst_cfgmgr.h"
#include "fst_rateupg.h"
#include "fst_ini_conf.h"

#define FST_MGR_COMPONENT "CFGMGR"
#include "fst_manager.h"

static struct fst_config_ctx
{
	enum fst_config_method method;
	struct fst_ini_config *handle;
} fstcfg = {FST_CONFIG_CLI, NULL};

static int get_iface_flags(int sock, const char *ifname, short int *flags)
{
	struct ifreq ifr;

	os_memset(&ifr, 0, sizeof(ifr));
	os_strlcpy(ifr.ifr_name, ifname, IFNAMSIZ);

	if (ioctl(sock, SIOCGIFFLAGS, &ifr) != 0) {
		fst_mgr_printf(MSG_ERROR, "Error getting interface %s flags", ifname);
		return -2;
	}
	*flags = ifr.ifr_flags;
	return 0;
}

static int set_iface_flags(int sock, const char *ifname, short int flags)
{
	struct ifreq ifr;

	os_memset(&ifr, 0, sizeof(ifr));
	os_strlcpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_flags = flags;

	if (ioctl(sock, SIOCSIFFLAGS, &ifr) != 0) {
		fst_mgr_printf(MSG_ERROR, "Error setting interface %s flags", ifname);
		return -2;
	}
	return 0;
}

static int set_iface_txqueuelen(int sock, const char *ifname, int txqueuelen)
{
	struct ifreq ifr;

	os_memset(&ifr, 0, sizeof(ifr));
	os_strlcpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_qlen = txqueuelen;

	fst_mgr_printf(MSG_INFO, "Setting %s txqueuelen %d", ifname, txqueuelen);

	if (ioctl(sock, SIOCSIFTXQLEN, &ifr) != 0) {
		fst_mgr_printf(MSG_ERROR, "Error setting interface %s txqueuelen", ifname);
		return -1;
	}

	return 0;
}

static int set_iface_up(int sock, const char *ifname, Boolean up)
{
	short int flags;
	int ret;

	if (sock < 0)
		return -1;

	ret = get_iface_flags(sock, ifname, &flags);
	if (ret < 0)
		return ret;

	if (up) {
		if (flags & IFF_UP)
			return 0;
		flags |= IFF_UP;
	} else {
		if (!(flags & IFF_UP))
			return 0;
		flags &= ~IFF_UP;
	}

	return set_iface_flags(sock, ifname, flags);
}


static int enslave_device(int sock, const char *bond, const char *ifname)
{
	struct ifreq  if_enslave;
	short int iface_flags;

	if (sock < 0)
		return -1;

	if (get_iface_flags(sock, ifname, &iface_flags) < 0)
		return -1;

	if (iface_flags & IFF_SLAVE) {
		fst_mgr_printf(MSG_INFO, "Interface %s already enslaved", ifname);
		return 0;
	}

	/* Device should be down before bonding in new kernels */
	iface_flags &= ~IFF_UP;
	if (set_iface_flags(sock, ifname, iface_flags) < 0) {
		fst_mgr_printf(MSG_ERROR, "Cannot down slave %s", ifname);
		return -2;
	}

	/* Enslave the device */
	os_strlcpy(if_enslave.ifr_name, bond, IFNAMSIZ);
	os_strlcpy(if_enslave.ifr_slave, ifname, IFNAMSIZ);
	if ((ioctl(sock, SIOCBONDENSLAVE, &if_enslave) < 0)) {
			fst_mgr_printf(MSG_ERROR, "Error enslaving %s to %s: %s",
				ifname, bond, strerror(errno));
			return -2;
	}

	return 0;
}

static int release_device(int sock, const char *bond, const char *ifname)
{
	struct ifreq  if_enslave;
	short int iface_flags;

	if (sock < 0)
		return -1;

	if (get_iface_flags(sock, ifname, &iface_flags) < 0)
		return -1;

	if (!(iface_flags & IFF_SLAVE)) {
		fst_mgr_printf(MSG_INFO, "Interface %s not enslaved", ifname);
		return 0;
	}

	/* Release the device */
	os_strlcpy(if_enslave.ifr_name, bond, IFNAMSIZ);
	os_strlcpy(if_enslave.ifr_slave, ifname, IFNAMSIZ);
	if ((ioctl(sock, SIOCBONDRELEASE, &if_enslave) < 0)) {
			fst_mgr_printf(MSG_ERROR, "Error releasing %s from %s: %s",
				ifname, bond, strerror(errno));
			return -2;
	}
	return 0;
}

static int fst_cfgmgr_get_txqueuelen(const char *gname)
{
	int res = -1;

	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_txqueuelen(fstcfg.handle, gname);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		break;
	}

	return res;
}

static int do_bonding_operations(Boolean enslave)
{
	struct fst_group_info *groups;
	struct fst_iface_info *ifaces;
	int gcnt, icnt, muxtype, sock, i, j, txqueuelen, res;
	char buf[80];

	if (fstcfg.handle == NULL) {
		fst_mgr_printf(MSG_ERROR, "Interfaces configuration not found");
		goto error_handle;
	}

	gcnt = fst_ini_config_get_groups(fstcfg.handle, &groups);
	if (gcnt < 0) {
		fst_mgr_printf(MSG_ERROR, "Cannot read groups");
		goto error_groups;
	}

	if ((sock = socket(AF_INET, SOCK_DGRAM,0)) < 0) {
		fst_mgr_printf(MSG_ERROR, "Cannot open socket");
		goto error_socket;
	}

	for (i = 0; i < gcnt; i++) {
		muxtype = fst_cfgmgr_get_mux_type(groups[i].id,
			buf, sizeof(buf)-1);
		if (muxtype && os_strncmp(buf, "bonding", sizeof(buf)-1) &&
				os_strncmp(buf, "bonding_l2da", sizeof(buf)-1)) {
			fst_mgr_printf(MSG_DEBUG,
				"Group %s mux type %s not supported, skipping",
				groups[i].id, buf);
			continue;
		}
		if (!fst_cfgmgr_is_mux_managed(groups[i].id)) {
			fst_mgr_printf(MSG_DEBUG,
				"Group %s mux is unmanaged, skipping",
				groups[i].id);
			continue;
		}
		if (fst_cfgmgr_get_mux_ifname(groups[i].id, buf, sizeof(buf)-1) <= 0) {
			fst_mgr_printf(MSG_ERROR, "Cannot get mux name for %s",
				groups[i].id);
			goto error_muxname;
		}
		icnt = fst_ini_config_get_group_ifaces(fstcfg.handle,
			&groups[i], &ifaces);
		if (icnt < 0) {
			fst_mgr_printf(MSG_ERROR, "Cannot read interfaces for %s",
				groups[i].id);
			goto error_ifaces;
		}
		for (j = 0; j < icnt; j++) {
			fst_mgr_printf(MSG_DEBUG,
				"%s interface %s to mux %s (group %s)",
				enslave ? "Enslaving":"Releasing", ifaces[j].name,
				buf, groups[i].id);
			if (enslave)
				res = enslave_device(sock, buf, ifaces[j].name);
			else
				res = release_device(sock, buf, ifaces[i].name);
			if (res < 0) {
				fst_mgr_printf(MSG_ERROR, "Cannot process %s",
					ifaces[j].name);
				goto error_enslave;
			}
		}

		txqueuelen = fst_cfgmgr_get_txqueuelen(groups[i].id);
		if (txqueuelen >= 0) {
			res = set_iface_txqueuelen(sock, buf, txqueuelen);
			if (res != 0)
				goto error_set_iface;
		}

		fst_mgr_printf(MSG_DEBUG, "Setting bonding iface %s %s",
			buf, enslave ? "up":"down");
		if (set_iface_up(sock, buf, enslave) < 0) {
			fst_mgr_printf(MSG_ERROR, "Cannot set iface %s", buf);
			goto error_set_iface;
		}
		free(ifaces);
	}
	close(sock);
	free(groups);
	return 0;
error_set_iface:
error_enslave:
	free(ifaces);
error_ifaces:
error_muxname:
	close(sock);
error_socket:
	free(groups);
error_groups:
error_handle:
	return -1;
}

static int bonding_ifaces_prepare()
{
	return do_bonding_operations(TRUE);
}

static int bonding_ifaces_cleanup()
{
	return do_bonding_operations(FALSE);
}

static int group_sessions_cleanup(const struct fst_group_info *gi)
{
	uint32_t *sids = NULL;
	int n, i, res = 0;

	n = fst_get_sessions(gi, &sids);
	if (n < 0) {
		fst_mgr_printf(MSG_WARNING, "cannot get sessions for group %s",
				gi->id);
		return 0;
	}

	for (i = 0; i < n; i++) {
		if (fst_session_remove(sids[i])) {
			fst_mgr_printf(MSG_ERROR, "cannot remove session %u",
					sids[i]);
			res = -1;
		}
	}
	fst_free(sids);

	return res;
}

static int group_detach_all(const struct fst_group_info *group)
{
	struct fst_iface_info *ifaces;
	int i, res;

	res = fst_get_group_ifaces(group, &ifaces);
	if (res < 0) {
		fst_mgr_printf(MSG_ERROR,
			"Cannot get ifaces for group %s", group->id);
		return -1;
	}
	for (i = 0; i < res; i++) {
		if (fst_detach_iface(&ifaces[i]))
			fst_mgr_printf(MSG_WARNING,
			"Error detaching interface %s", ifaces[i].name);
	}
	fst_free(ifaces);
	return 0;
}

int  fst_cfgmgr_init(enum fst_config_method m, void *ctx)
{
	fstcfg.method = m;
	switch (m) {
	case FST_CONFIG_CLI:
		fstcfg.handle = NULL;
		break;
	case FST_CONFIG_INI:
		fstcfg.handle = fst_ini_config_init((const char*)ctx);
		if (fstcfg.handle == NULL) {
			fst_mgr_printf(MSG_ERROR, "Cannot initialize config");
			return -1;
		}
		if(bonding_ifaces_prepare()) {
			fst_mgr_printf(MSG_ERROR, "Cannot prepare bonding ifaces");
			return -1;
		}
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Invalid config method %d", m);
		return -1;
	}
	return 0;
}

void fst_cfgmgr_deinit()
{
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		bonding_ifaces_cleanup();
		fst_ini_config_deinit(fstcfg.handle);
		fstcfg.handle = NULL;
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		break;
	}
}


int fst_cfgmgr_get_groups(struct fst_group_info **groups)
{
	int res;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = fst_get_groups(groups);
		if (res < 0)
			fst_mgr_printf(MSG_ERROR, "Cannot get groups");
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_groups(fstcfg.handle, groups);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Cannot get groups in current config");
		res = -1;
	}
	return res;
}

int fst_cfgmgr_get_ctrl_iface(char *buf, int size)
{
	int res = -1;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_ctrl_iface(fstcfg.handle, buf, size);
		break;
	default:
		fst_mgr_printf(MSG_ERROR,
			"Cannot get ctrl_path in current config");
	}
	return res;
}

int fst_cfgmgr_get_group_ifaces(const struct fst_group_info *group,
	struct fst_iface_info **ifaces)
{
	int res;

	fst_mgr_printf(MSG_INFO, "group: %s", group->id);

	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = fst_get_group_ifaces(group, ifaces);
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_group_ifaces(fstcfg.handle,
			group, ifaces);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Cannot get ifaces in current config");
		res = -1;
	}
	return res;
}

int fst_cfgmgr_get_iface_group_cipher(const struct fst_iface_info *iface,
	char *buf, int len)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = 0;
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_iface_group_cipher(fstcfg.handle, iface,
			buf, len);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_get_iface_pairwise_cipher(const struct fst_iface_info *iface,
	char *buf, int len)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = 0;
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_iface_pairwise_cipher(fstcfg.handle, iface,
			buf, len);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_get_iface_hw_mode(const struct fst_iface_info *iface,
	char *buf, int len)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = 0;
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_iface_hw_mode(fstcfg.handle, iface,
			buf, len);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_get_iface_channel(const struct fst_iface_info *iface,
	char *buf, int len)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = 0;
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_iface_channel(fstcfg.handle, iface,
			buf, len);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}



int fst_cfgmgr_on_iface_init(const struct fst_group_info *group,
	struct fst_iface_info *iface)
{
	int res = 0;

	fst_mgr_printf(MSG_INFO, "group: %s", group->id);

	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		res = fst_attach_iface(group, iface);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_on_iface_deinit(struct fst_iface_info *iface)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		res = fst_detach_iface(iface);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_on_global_init(void)
{
	struct fst_group_info *groups;
	int i, res = 0;

	fst_mgr_printf(MSG_INFO, "enter");

	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		/* Remove existing configuration */
		res = fst_get_groups(&groups);
		if (res < 0) {
			fst_mgr_printf(MSG_ERROR, "Cannot get groups");
			return -1;
		}
		for (i=0; i < res; i++) {
			group_sessions_cleanup(&groups[i]);
			group_detach_all(&groups[i]);
		}
		if (res)
			fst_free(groups);
		res = fst_rate_upgrade_init(fstcfg.handle);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

void fst_cfgmgr_on_global_deinit(void)
{
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		fst_rate_upgrade_deinit();
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		break;
	}
}

int fst_cfgmgr_on_group_init(const struct fst_group_info *group)
{
	if (group_sessions_cleanup(group))
		return -1;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		if (fst_rate_upgrade_add_group(group))
			return -1;
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		break;
	}
	return 0;
}

int fst_cfgmgr_on_group_deinit(const struct fst_group_info *group)
{
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		if (fst_rate_upgrade_del_group(group))
			return -1;
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		return -1;
	}
	return 0;
}


int fst_cfgmgr_on_connect(struct fst_group_info *group, const char *iface,
	const u8* addr)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		res = fst_rate_upgrade_on_connect(group, iface, addr);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_on_disconnect(struct fst_group_info *group, const char *iface,
	const u8* addr)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		break;
	case FST_CONFIG_INI:
		res = fst_rate_upgrade_on_disconnect(group, iface, addr);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

void fst_cfgmgr_on_switch_completed(const struct fst_group_info *group,
	const char *old_iface, const char *new_iface, const u8* peer_addr)
{
	if (fstcfg.method != FST_CONFIG_INI)
		return;

	fst_rate_upgrade_on_switch_completed(group, old_iface,
		new_iface, peer_addr);
}

int fst_cfgmgr_get_mux_type(const char *gname, char *buf, int blen)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = 0;
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_mux_type(fstcfg.handle, gname, buf, blen);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

int fst_cfgmgr_get_mux_ifname(const char *gname, char *buf, int blen)
{
	int res = 0;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		os_strlcpy(buf, gname, blen);
		res = os_strlen(buf);
		break;
	case FST_CONFIG_INI:
		res = fst_ini_config_get_mux_ifname(fstcfg.handle, gname,
			buf, blen);
		if (res == 0) {
			/* Fallback to mux==group_name if no mux name key */
			os_strlcpy(buf, gname, blen);
			res = os_strlen(buf);
		}
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = -1;
		break;
	}
	return res;
}

Boolean fst_cfgmgr_is_mux_managed(const char *gname)
{
	Boolean res = FALSE;
	switch (fstcfg.method) {
	case FST_CONFIG_CLI:
		res = FALSE;
	case FST_CONFIG_INI:
		res = fst_ini_config_is_mux_managed(fstcfg.handle, gname);
		break;
	default:
		fst_mgr_printf(MSG_ERROR, "Wrong config method");
		res = FALSE;
		break;
	}
	return res;
}

