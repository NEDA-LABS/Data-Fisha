package com.fahamutech.smartstock.pos

import androidx.annotation.NonNull
import com.fahamutech.posprinter.JZV3Printer
import com.fahamutech.smartstock.pos.plugins.JZV3PrinterPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
//        JZV3Printer.getInstance().init(this)
        flutterEngine.plugins.add(JZV3PrinterPlugin())
    }
}
