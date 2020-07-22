package com.fahamutech.smartstock.pos

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log


class AutoStartBroadcaster: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val salesIntent = Intent(context, SalesSyncService::class.java)
        val stockIntent = Intent(context, StockSyncService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
            context?.startForegroundService(salesIntent)
            context?.startForegroundService(stockIntent)
        } else {
            context?.startService(salesIntent)
            context?.startService(stockIntent)
        }

        Log.i("AutostartBroadcaster", "Started the sync services")
    }
}