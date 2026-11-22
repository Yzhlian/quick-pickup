package com.quickpickup.launcher;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

public final class PickupActivity extends Activity {
    private static final String PINDUODUO_PACKAGE = "com.xunmeng.pinduoduo";
    private static final Uri IDENTITY_PAGE = Uri.parse(
            "pinduoduo://com.xunmeng.pinduoduo/mdkd/package?tab=ID_CODE&entry_source=11");
    private static final String STATION_ENTRY =
            "https://mdkd.pinduoduo.com/weixin/package?tab=ID_CODE";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // On configuration changes, restore the fallback instead of dispatching twice.
        if (savedInstanceState != null) {
            showFallback();
            return;
        }

        Intent openIdentity = new Intent(Intent.ACTION_VIEW, IDENTITY_PAGE)
                .setPackage(PINDUODUO_PACKAGE)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            startActivity(openIdentity);
            finish();
        } catch (ActivityNotFoundException | SecurityException ignored) {
            showFallback();
        }
    }

    private void showFallback() {
        new AlertDialog.Builder(this)
                .setTitle(R.string.open_failed)
                .setMessage(R.string.fallback_help)
                .setPositiveButton(R.string.copy_station_link, (dialog, button) -> {
                    ClipboardManager clipboard = getSystemService(ClipboardManager.class);
                    clipboard.setPrimaryClip(
                            ClipData.newPlainText(getString(R.string.station_link), STATION_ENTRY));
                    if (Build.VERSION.SDK_INT < 33) {
                        Toast.makeText(this, R.string.link_copied, Toast.LENGTH_SHORT).show();
                    }
                    finish();
                })
                .setNegativeButton(android.R.string.cancel, (dialog, button) -> finish())
                .setOnCancelListener(dialog -> finish())
                .show();
    }
}
