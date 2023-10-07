package com.fahamutech.smartstock.plugins

import android.content.Context
import com.fahamutech.smartstock.servives.shareFileContent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

fun flutterCommunicationChannel(context: Context, flutterEngine: FlutterEngine) {
    MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "smartstock/channel"
    ).setMethodCallHandler { call, result ->
        try {
            if (call.method == "file_export") {
                val data = call.argument<ByteArray>("data") ?: ByteArray(0)
                val fileName = call.argument<String>("filename") ?: "name.txt"
                val mime = call.argument<String>("mime") ?: "text/plain"
                shareFileContent(
                    context = context,
                    data = data,
                    fileName = fileName,
                    mime = mime,
                )
                result.success(mutableListOf("Ok"))
            } else {
                result.notImplemented();
            }
        } catch (e: Exception) {
            e.printStackTrace()
            result.error(
                "CHANNEL_ERROR",
                e.localizedMessage,
                "Something happen in communication channel"
            )
        }
    }
}