package com.asus.flipcover2;

import android.os.Bundle;

interface IFlipCoverCallBack {
    void goToSleepAtTime(long t);
    void goToSleepAfterTimeStamp(long t);
    void wakeUp(long t);
    void userActivity(long j, boolean z);
    void powerOffDevice();
    void restartDevice();
    boolean disableNonSecureKeyguard();
    Bundle execCmd(int i, in Bundle b);
}
