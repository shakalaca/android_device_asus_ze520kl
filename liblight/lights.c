/*
 * Copyright (C) 2014 The CyanogenMod Project
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

#include <cutils/log.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <hardware/lights.h>

/******************************************************************************/

#define MAX_PATH_SIZE 80

#define LED_LIGHT_OFF 0
#define LED_LIGHT_ON 255

enum {
    ATTENTION = 0,
    NOTIFICATION,
    BATTERY,
    LIGHT_MAX,
};

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static struct light_state_t g_lights[LIGHT_MAX];

#define LCD_BRIGHTNESS_FILE "/sys/class/leds/lcd-backlight/brightness"

#define GREEN_LED_BRIGHTNESS_FILE "/sys/class/leds/green/brightness"
#define RED_LED_BRIGHTNESS_FILE "/sys/class/leds/red/brightness"

#define GREEN_LED_PWM_FILE "/sys/class/leds/green/pwm_us"
#define RED_LED_PWM_FILE "/sys/class/leds/red/pwm_us"
/**
 * device methods
 */

void init_globals(void)
{
    // init the mutex
    pthread_mutex_init(&g_lock, NULL);
}

static int write_int(char const* path, int value)
{
    int fd;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
        char buffer[20];
        int bytes = sprintf(buffer, "%d\n", value);
        int amt = write(fd, buffer, bytes);
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            ALOGE("%s: failed to open %s\n", __func__, path);
            already_warned = 1;
        }
        return -errno;
    }
}

static int write_str(char const* path, char *value)
{
    int fd;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
        char buffer[PAGE_SIZE];
        int bytes = sprintf(buffer, "%s\n", value);
        int amt = write(fd, buffer, bytes);
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            ALOGE("%s: failed to open %s\n", __func__, path);
            already_warned = 1;
        }
        return -errno;
    }
}

static int is_lit(struct light_state_t const* state)
{
    return state->color & 0x00ffffff;
}

static int rgb_to_brightness(struct light_state_t const* state)
{
    int color = state->color & 0x00ffffff;
    return ((77 * ((color >> 16) & 0x00ff))
            + (150 * ((color >> 8) & 0x00ff)) + (29 * (color & 0x00ff))) >> 8;
}

static int set_light_backlight(__attribute__((unused)) struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);
    pthread_mutex_lock(&g_lock);
    err = write_int(LCD_BRIGHTNESS_FILE, brightness);
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int set_light_locked(struct light_state_t const* state)
{
    int onMS, offMS;
    int blink, fake_pwm, pwm;
    int brightness_level;

    switch (state->flashMode) {
    case LIGHT_FLASH_TIMED:
    case LIGHT_FLASH_HARDWARE:
        onMS = state->flashOnMS;
        offMS = state->flashOffMS;
        break;
    case LIGHT_FLASH_NONE:
    default:
        onMS = 0;
        offMS = 0;
        break;
    }

    if (onMS > 0 && offMS > 0) {
        int totalMS = onMS + offMS;

        // pwm specifies the ratio of ON versus OFF
        // pwm = 0 -> always off
        // pwm = 255 -> always on
        fake_pwm = (onMS * 255) / totalMS;

        // the low 4 bits are ignored, so round up if necessary
        if (fake_pwm > 0 && fake_pwm < 16)
            fake_pwm = 16;

        blink = 1;
        pwm = offMS * 1000;
    } else {
        blink = 0;
        pwm = 0;
    }

    if (is_lit(state))
        brightness_level = (state->color & 0xff000000) ?
                (state->color & 0xff000000) >> 24 : LED_LIGHT_ON;
    else
        brightness_level = LED_LIGHT_OFF;

    // turn led off
    write_int(GREEN_LED_BRIGHTNESS_FILE, LED_LIGHT_OFF);
    write_int(RED_LED_BRIGHTNESS_FILE, LED_LIGHT_OFF);

    if (blink) {
        // brightness equals to led on in ms
        write_int(GREEN_LED_BRIGHTNESS_FILE, fake_pwm);
        // pwn uquals to led off in us
        write_int(GREEN_LED_PWM_FILE, pwm);
    } else {
        write_int(GREEN_LED_BRIGHTNESS_FILE, brightness_level);
        write_int(GREEN_LED_PWM_FILE, 100);
    }

    return 0;
}

static int handle_led_prioritized_locked(struct light_state_t const* state)
{
    if (is_lit(&g_lights[ATTENTION]))
        return set_light_locked(&g_lights[ATTENTION]);
    else if (is_lit(&g_lights[NOTIFICATION]))
        return set_light_locked(&g_lights[NOTIFICATION]);
    else
        return set_light_locked(state);
}

static int set_light_notifications(__attribute__((unused)) struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    pthread_mutex_lock(&g_lock);
    g_lights[NOTIFICATION] = *state;
    err = handle_led_prioritized_locked(state);
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int set_light_attention(__attribute__((unused)) struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    pthread_mutex_lock(&g_lock);
    g_lights[ATTENTION] = *state;
    err = handle_led_prioritized_locked(state);
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int set_light_battery(__attribute__((unused)) struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;

    if (!dev)
        return -1;

    pthread_mutex_lock(&g_lock);

    int level = (state->color & 0xFF000000) >> 24;
    ALOGV("%s: color=%x level=%d", __func__, state->color, level);

    // sanity check
    if (level < 0)
        level = 0;
    else if (level > 100)
        level = 100;

    // turn led off
    write_int(GREEN_LED_BRIGHTNESS_FILE, LED_LIGHT_OFF);
    write_int(RED_LED_BRIGHTNESS_FILE, LED_LIGHT_OFF);

    if (is_lit(state)) {
        if (level <= 15) {
            write_int(RED_LED_BRIGHTNESS_FILE, 255);
            write_int(RED_LED_PWM_FILE, 100);
        } else if (level <= 99) {
            write_int(GREEN_LED_BRIGHTNESS_FILE, 255);
            write_int(GREEN_LED_PWM_FILE, 100);
            write_int(RED_LED_BRIGHTNESS_FILE, 255);
            write_int(RED_LED_PWM_FILE, 100);
        } else {
            write_int(GREEN_LED_BRIGHTNESS_FILE, 255);
            write_int(GREEN_LED_PWM_FILE, 100);
        }
    }

    pthread_mutex_unlock(&g_lock);
    return err;
}


/** Close the lights device */
static int close_lights(struct light_device_t *dev)
{
    if (dev)
        free(dev);

    return 0;
}


/******************************************************************************/

/**
 * module methods
 */

/** Open a new instance of a lights device using name */
static int open_lights(const struct hw_module_t* module, char const* name,
        struct hw_device_t** device)
{
    int (*set_light)(struct light_device_t* dev,
            struct light_state_t const* state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name))
        set_light = set_light_backlight;
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name))
        set_light = set_light_notifications;
    else if (0 == strcmp(LIGHT_ID_ATTENTION, name))
        set_light = set_light_attention;
    else if (0 == strcmp(LIGHT_ID_BATTERY, name))
        set_light = set_light_battery;
    else
        return -EINVAL;

    pthread_once(&g_init, init_globals);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t*)module;
    dev->common.close = (int (*)(struct hw_device_t*))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t*)dev;
    return 0;
}

static struct hw_module_methods_t lights_module_methods = {
    .open =  open_lights,
};

/*
 * The lights Module
 */
struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "MSM8953 lights Module",
    .author = "Google, Inc.",
    .methods = &lights_module_methods,
};
