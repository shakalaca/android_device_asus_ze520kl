/*
   Copyright (c) 2014, The Linux Foundation. All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void vendor_load_properties()
{
    std::string project = property_get("ro.boot.id.prj");
    property_set("ro.product.name", "WW_Phone");
    if (project == "6") {
        property_override("ro.build.product", "ZE520KL");
        property_override("ro.build.description", "WW_Phone-user 7.0 NRD90M 14.2020.1703.28-20170410 release-keys");
        property_override("ro.build.fingerprint", "asus/WW_Phone/ASUS_Z017D_1:7.0/NRD90M/14.2020.1703.28-20170410:user/release-keys");
        property_override("ro.product.device", "ASUS_Z017D_1");
        property_override("ro.product.model", "ASUS_Z017D");
        property_set("ro.product.carrier", "US-ASUS_Z017D-WW_Phone");
        property_set("ro.hardware.id", "ZE520KL_MP");
        property_set("ro.build.csc.version", "WW_ZE520KL-14.2020.1703.28-20170410");
    } else if (project == "7") {
        property_override("ro.build.product", "ZE552KL");
        property_override("ro.build.description", "WW_Phone-user 7.0 NRD90M 14.2020.1703.28-20170410 release-keys");
        property_override("ro.build.fingerprint", "asus/WW_Phone/ASUS_Z012D:7.0/NRD90M/14.2020.1703.28-20170410:user/release-keys");
        property_override("ro.product.device", "ASUS_Z012D");
        property_override("ro.product.model", "ASUS_Z012D");
        property_set("ro.product.carrier", "US-ASUS_Z012D-WW_Phone");
        property_set("ro.hardware.id", "ZE552KL_MP");
        property_set("ro.build.csc.version", "WW_ZE552KL-14.2020.1703.28-20170410");
    }
}
