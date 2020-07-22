package com.fahamutech.smartstock.pos

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.concurrent.schedule
import kotlin.concurrent.scheduleAtFixedRate


class SalesSyncService(val cacheController: CacheController) : Service(){
    companion object var started = false

    override fun onBind(intent: Intent?): IBinder? {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!started) {
            Log.i("SalesSyncService", "Sales synchronization started")
            GlobalScope.launch {
                Timer("SettingUp", true).scheduleAtFixedRate(0, 2000) {
                    Log.i("Timer", "Timer ticking ..... ")
                }
            }
            started = true
        }
        return START_STICKY
    }


}