package com.corner23.android.flipcovershell;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class LidStateReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		if (intent != null && "cyanogenmod.intent.action.LID_STATE_CHANGED".equals(intent.getAction())) {
			intent.setClass(context, FlipCoverService.class);
			context.startService(intent);
		}
	}
}
