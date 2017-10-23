/*
 * Copyright (C) 2016 The CyanogenMod Project
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

package org.cyanogenmod.hardware;

import org.cyanogenmod.internal.util.FileUtils;

import cyanogenmod.hardware.TouchscreenGesture;

/**
 * Touchscreen gestures API
 *
 * A device may implement several touchscreen gestures for use while
 * the display is turned off, such as drawing alphabets and shapes.
 * These gestures can be interpreted by userspace to activate certain
 * actions and launch certain apps, such as to skip music tracks,
 * to turn on the flashlight, or to launch the camera app.
 *
 * This *should always* be supported by the hardware directly.
 * A lot of recent touch controllers have a firmware option for this.
 *
 * This API provides support for enumerating the gestures
 * supported by the touchscreen.
 */
public class TouchscreenGestures {

    private static final String GESTURE_PATH =
            "/sys/devices/soc/78b7000.i2c/i2c-3/3-0038/gesture_mode";

    // Id, name, keycode
    private static final TouchscreenGesture[] TOUCHSCREEN_GESTURES = {
        new TouchscreenGesture(0, "Letter C", 265),
        new TouchscreenGesture(1, "Letter e", 266),
        new TouchscreenGesture(2, "Letter S", 267),
        new TouchscreenGesture(3, "Letter V", 263),
        new TouchscreenGesture(4, "Letter W", 268),
        new TouchscreenGesture(5, "Letter Z", 264),
    };

    private static final int KEY_MASK_GESTURE_CONTROL = 0x40;
    public static final int[] ALL_GESTURE_MASKS = {
        0x04, // c gesture mask
        0x08, // e gesture mask
        0x10, // s gesture mask
        0x01, // v gesture mask
        0x20, // w gesture mask
        0x02, // z gesture mask
    };

    /**
     * Whether device supports touchscreen gestures
     *
     * @return boolean Supported devices must return always true
     */
    public static boolean isSupported() {
        return FileUtils.isFileWritable(GESTURE_PATH) &&
                FileUtils.isFileReadable(GESTURE_PATH);
    }

    /*
     * Get the list of available gestures. A mode has an integer
     * identifier and a string name.
     *
     * It is the responsibility of the upper layers to
     * map the name to a human-readable format or perform translation.
     */
    public static TouchscreenGesture[] getAvailableGestures() {
        return TOUCHSCREEN_GESTURES;
    }

    /**
     * This method allows to set the activation status of a gesture
     *
     * @param gesture The gesture to be activated
     *        state   The new activation status of the gesture
     * @return boolean Must be false if gesture is not supported
     *         or the operation failed; true in any other case.
     */
    public static boolean setGestureEnabled(
            final TouchscreenGesture gesture, final boolean state) {
        int gestureMode = Integer.parseInt(FileUtils.readOneLine(GESTURE_PATH), 16) & ~KEY_MASK_GESTURE_CONTROL;
        int mask = ALL_GESTURE_MASKS[gesture.id];

        if (state)
            gestureMode |= mask;
        else
            gestureMode &= ~mask;

        if (gestureMode != 0)
            gestureMode |= KEY_MASK_GESTURE_CONTROL;

        return FileUtils.writeLine(GESTURE_PATH, String.format("%7s\n",
                Integer.toBinaryString(gestureMode)).replace(' ', '0'));
    }
}
