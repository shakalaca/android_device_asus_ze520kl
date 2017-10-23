package com.asus.flipcover2;

import android.os.Bundle;
import com.asus.flipcover2.IFlipCoverCallBack;

interface IFlipCoverService {
    void onSystemReady(in Bundle b, IFlipCoverCallBack cb);
    void onBootCompleted(in Bundle b, IFlipCoverCallBack cb);
    void showFlipCover(in Bundle b);
    void hideFlipCover(in Bundle b);
    void onScreenTurnedOff(int t, in Bundle b);
    void onScreenTurnedOn(in Bundle b);
    boolean isFlipCoverShowing();
    boolean isFlashLightOn();
    boolean isFlashLightSelected();
    void turnOffFlashLight(in Bundle b);
    void showDeviceOptionView(in Bundle b);
    Bundle execCmd(int i, in Bundle b);
}
