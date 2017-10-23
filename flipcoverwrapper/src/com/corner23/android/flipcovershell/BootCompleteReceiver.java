package com.corner23.android.flipcovershell;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

public class BootCompleteReceiver extends BroadcastReceiver {
	@Override
	public void onReceive(Context context, Intent intent) {
		if (intent != null && Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
			PackageManager pm = context.getPackageManager();
			ComponentName mainActivity = new ComponentName(context, MainActivity.class);
			try {
				pm.getPackageInfo("com.asus.flipcover3", 0);
				pm.setComponentEnabledSetting(mainActivity,
						PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
						PackageManager.DONT_KILL_APP);
			} catch (PackageManager.NameNotFoundException e) { // not installed
				pm.setComponentEnabledSetting(mainActivity,
						PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
						PackageManager.DONT_KILL_APP);
			}
		}
	}
}
