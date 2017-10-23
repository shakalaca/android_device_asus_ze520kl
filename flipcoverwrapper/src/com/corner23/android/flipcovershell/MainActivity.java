package com.corner23.android.flipcovershell;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class MainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.empty);
		
		Intent i = new Intent();
		i.setClassName("com.asus.flipcover3", "com.asus.flipcover.view.settings.CoverSettingsActivity");
		this.startActivity(i);
		this.overridePendingTransition(0, 0);
		this.finish();
	}
}
