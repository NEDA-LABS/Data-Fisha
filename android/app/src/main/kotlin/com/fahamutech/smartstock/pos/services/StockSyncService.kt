package com.fahamutech.smartstock.pos.services

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

class StockSyncService : Service(){
    companion object var started = false
    override fun onBind(intent: Intent?): IBinder? {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i("StockSyncService", "Stock synchronization started")
        return START_STICKY
    }
}
