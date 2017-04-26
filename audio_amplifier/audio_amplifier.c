/*
 * Copyright (C) 2013-2014, The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <time.h>
#include <system/audio.h>
#include <platform.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>
#include <dlfcn.h>
#include <sys/ioctl.h>

#define LOG_TAG "tfa98xx"
#include <log/log.h>

#include <hardware/audio_amplifier.h>
#include <tinyalsa/asoundlib.h>

typedef int (*exTfa98xx_calibration_t)();
typedef int (*exTfa98xx_speakeron_t)(int);
typedef int (*exTfa98xx_speakeroff_t)();

typedef enum {
    Audio_Mode_Music_Normal = 0,
    Audio_Mode_Voice,
    Audio_Mode_Ringtone
} exTfa98xx_Audio_Mode_t;

typedef struct tfa98xx_device {
    amplifier_device_t amp_dev;
    audio_mode_t mode;
    void *lib_ptr;
    exTfa98xx_calibration_t exTfa98xx_calibration;
    exTfa98xx_speakeron_t exTfa98xx_speakeron;
    exTfa98xx_speakeroff_t exTfa98xx_speakeroff;    
} tfa98xx_device_t;

static tfa98xx_device_t *tfa98xx_dev = NULL;
static int tfa98xx_calibration_status = 0;

static int do_tfa98xx_calibration(hw_device_t *device) {
    const char *mixer_ctl_name = "QUIN_MI2S_RX Audio Mixer MultiMedia1";
    struct mixer_ctl *ctl;
    struct mixer *mixer;
    int ret = 0;
    tfa98xx_device_t *tfa98xx = (tfa98xx_device_t*) device;
    
    if (!tfa98xx) { 
        return -1;
    }

    if (tfa98xx_calibration_status == 1) {
        return 0;
    }

    mixer = mixer_open(0);
    if (mixer == NULL) {
        ALOGE("Error opening mixer");
        return -1;
    }

    ctl = mixer_get_ctl_by_name(mixer, mixer_ctl_name);
    if (ctl == NULL) {
        mixer_close(mixer);
        ALOGE("%s: Could not find %s\n", __func__, mixer_ctl_name);
        return -ENODEV;
    }

    if (mixer_ctl_set_value(ctl, 0, 1) < 0) {
        mixer_close(mixer);
        ALOGE("%s: Could not set mixer mode ", __func__);
        return -ENODEV;
    }
    
    ret = tfa98xx->exTfa98xx_calibration();
    if (ret == 0) {
        tfa98xx_calibration_status = 1;
        ALOGD("%s: exTfa98xx_calibration success", __func__);
    } else {
        tfa98xx_calibration_status = 0;
        ALOGE("%s: exTfa98xx_calibration fail", __func__);
    }
    
    mixer_ctl_set_value(ctl, 0, 0);
    mixer_close(mixer);
    return ret;
}

static int amp_output_stream_start(hw_device_t *device,
            struct audio_stream_out *stream, bool offload) {
    int ret = 0;

    tfa98xx_device_t *tfa98xx = (tfa98xx_device_t*) device;
    if (tfa98xx) {
        do_tfa98xx_calibration(tfa98xx);
    }
        
    return ret;
}
            
#define DEVICES_MASK \
    (AUDIO_DEVICE_OUT_EARPIECE | AUDIO_DEVICE_OUT_SPEAKER | AUDIO_DEVICE_OUT_WIRED_HEADSET | \
     AUDIO_DEVICE_OUT_WIRED_HEADPHONE)

static int amp_enable_output_devices(hw_device_t *device, uint32_t devices, bool enable) {
    tfa98xx_device_t *tfa98xx = (tfa98xx_device_t*) device;
    int ret;

    if ((devices & DEVICES_MASK) != 0) {
        if (enable) {
            exTfa98xx_Audio_Mode_t mode;
            
            switch (tfa98xx->mode) {
            case AUDIO_MODE_IN_COMMUNICATION:
            case AUDIO_MODE_IN_CALL: mode = Audio_Mode_Voice; break;
            default: mode = Audio_Mode_Music_Normal;
            }

            do_tfa98xx_calibration(tfa98xx);
            if ((ret = tfa98xx->exTfa98xx_speakeron(mode)) != 0) {
                ALOGI("exTfa98xx_exTfa98xx_speakeron(%d) failed: %d\n", mode, ret);
            }
        } else {
           if ((ret = tfa98xx->exTfa98xx_speakeroff()) != 0) {
                ALOGI("exTfa98xx_exTfa98xx_speakeroff failed: %d\n", ret);
            }
            tfa98xx_calibration_status = 0;
        }
    }
    return 0;
}

static int amp_dev_close(hw_device_t *device) {
    tfa98xx_device_t *tfa98xx = (tfa98xx_device_t*) device;

    if (tfa98xx) {
        dlclose(tfa98xx->lib_ptr);
        free(tfa98xx);
        tfa98xx_calibration_status = 0;
    }

    return 0;
}

static int amp_set_mode(hw_device_t *device, audio_mode_t mode) {
    tfa98xx_device_t *tfa98xx = (tfa98xx_device_t*) device;

    if (tfa98xx) {    
        ALOGI("%s: Set mode: %d\n", __func__, mode);
        tfa98xx->mode = mode;
    }

    return 0;
}

static int amp_module_open(const hw_module_t *module,
        __attribute__((unused)) const char *name, hw_device_t **device)
{
    if (tfa98xx_dev) {
        ALOGE("%s:%d: Unable to open second instance of TFA9890 amplifier\n",
                __func__, __LINE__);
        return -EBUSY;
    }

    tfa98xx_dev = calloc(1, sizeof(tfa98xx_device_t));
    if (!tfa98xx_dev) {
        ALOGE("%s:%d: Unable to allocate memory for amplifier device\n",
                __func__, __LINE__);
        return -ENOMEM;
    }

    tfa98xx_dev->amp_dev.common.tag = HARDWARE_DEVICE_TAG;
    tfa98xx_dev->amp_dev.common.module = (hw_module_t *) module;
    tfa98xx_dev->amp_dev.common.version = HARDWARE_DEVICE_API_VERSION(1, 0);
    tfa98xx_dev->amp_dev.common.close = amp_dev_close;
    tfa98xx_dev->amp_dev.set_mode = amp_set_mode;
    tfa98xx_dev->amp_dev.enable_output_devices = amp_enable_output_devices;
    tfa98xx_dev->amp_dev.output_stream_start = amp_output_stream_start;

    tfa98xx_dev->lib_ptr = dlopen("libtfa98xx.so", RTLD_NOW);
    if (!tfa98xx_dev->lib_ptr) {
        ALOGE("%s:%d: Unable to open libtfa98xx: %s",
                __func__, __LINE__, dlerror());
        free(tfa98xx_dev);
        return -ENODEV;
    }

    tfa98xx_dev->exTfa98xx_calibration = (exTfa98xx_calibration_t)dlsym(tfa98xx_dev->lib_ptr, "Tfa98xx_calibration");
    if (!tfa98xx_dev->exTfa98xx_calibration) {
        ALOGE("%s:%d: Unable to find required symbols: exTfa98xx_calibration", __func__, __LINE__);
        dlclose(tfa98xx_dev->lib_ptr);
        free(tfa98xx_dev);
        return -ENODEV;
    }

    tfa98xx_dev->exTfa98xx_speakeron = (exTfa98xx_speakeron_t)dlsym(tfa98xx_dev->lib_ptr, "Tfa98xx_speakeron");
    if (!tfa98xx_dev->exTfa98xx_speakeron) {
        ALOGE("%s:%d: Unable to find required symbols: exTfa98xx_speakeron", __func__, __LINE__);
        dlclose(tfa98xx_dev->lib_ptr);
        free(tfa98xx_dev);
        return -ENODEV;
    }

    tfa98xx_dev->exTfa98xx_speakeroff = (exTfa98xx_speakeroff_t)dlsym(tfa98xx_dev->lib_ptr, "Tfa98xx_speakeroff");
    if (!tfa98xx_dev->exTfa98xx_speakeroff) {
        ALOGE("%s:%d: Unable to find required symbols: exTfa98xx_speakeroff", __func__, __LINE__);
        dlclose(tfa98xx_dev->lib_ptr);
        free(tfa98xx_dev);
        return -ENODEV;
    }

    do_tfa98xx_calibration(tfa98xx_dev);

    *device = (hw_device_t *) tfa98xx_dev;

    return 0;
}

static struct hw_module_methods_t hal_module_methods = {
    .open = amp_module_open,
};

amplifier_module_t HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = AMPLIFIER_MODULE_API_VERSION_0_1,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = AMPLIFIER_HARDWARE_MODULE_ID,
        .name = "ZenFone 3 amplifier HAL",
        .author = "The CyanogenMod Open Source Project",
        .methods = &hal_module_methods,
    },
};
