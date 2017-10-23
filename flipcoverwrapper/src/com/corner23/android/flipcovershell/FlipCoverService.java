package com.corner23.android.flipcovershell;

import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.support.annotation.Nullable;
import android.os.PowerManager;
import android.os.SystemClock;

import com.asus.flipcover2.IFlipCoverService;

public class FlipCoverService extends Service {

	private static final String TAG = FlipCoverService.class.getSimpleName();

	IFlipCoverService mService;
	FlipCoverServiceConnection mFlipCoverServiceConnection = new FlipCoverServiceConnection();
	PowerManager mPowerManager;

	class FlipCoverServiceConnection implements ServiceConnection {
		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			mService = IFlipCoverService.Stub.asInterface(service);
		}

		@Override
		public void onServiceDisconnected(ComponentName name) {
			mService = null;
		}
	}

	@Nullable
	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	@Override
	public void onCreate() {
		super.onCreate();

		Intent is = new Intent();
		is.setClassName("com.asus.flipcover3", "com.asus.flipcover3.CoverService");
		bindService(is, mFlipCoverServiceConnection, Context.BIND_AUTO_CREATE);
		
		mPowerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
	}

	@Override
	public void onDestroy() {
		super.onDestroy();

		unbindService(mFlipCoverServiceConnection);
	}

	private void showFlipCover() {
		try {
			if (mService != null) {
				mService.showFlipCover(new Bundle());
			} else {
				mPowerManager.goToSleep(SystemClock.uptimeMillis(),
					PowerManager.GO_TO_SLEEP_REASON_LID_SWITCH,
					PowerManager.GO_TO_SLEEP_FLAG_NO_DOZE);
			}
		} catch (RemoteException e) {
			e.printStackTrace();
		}
	}

	private void hideFlipCover() {
		try {
			if (mService != null) {
				mService.hideFlipCover(new Bundle());
			}
		} catch (RemoteException e) {
			e.printStackTrace();
		}
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		int lidState = intent.getIntExtra("cyanogenmod.intent.extra.LID_STATE", 0);
		if (lidState == 0) {
			showFlipCover();
		} else {
			hideFlipCover();
		}

		return super.onStartCommand(intent, flags, startId);
	}
}
