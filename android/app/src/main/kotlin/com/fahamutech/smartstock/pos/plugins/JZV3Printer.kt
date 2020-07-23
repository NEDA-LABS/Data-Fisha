package com.fahamutech.smartstock.pos.plugins

import android.content.Context
import com.fahamutech.posprinter.JZV3Printer

class JZV3PrinterPlugin {
    fun start(context: Context){
        JZV3Printer.getInstance().init(context)
    }
}