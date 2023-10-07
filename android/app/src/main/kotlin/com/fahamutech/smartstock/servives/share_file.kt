package com.fahamutech.smartstock.servives

import android.content.ClipData
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.PackageManager.ResolveInfoFlags
import android.content.pm.ResolveInfo
import android.os.Build
import androidx.core.app.ShareCompat
import androidx.core.content.FileProvider
import java.io.File


fun shareFileContent(
    context: Context,
    data: ByteArray,
    fileName: String,
    mime: String
) {
    saveAndShare(context, fileName, data, mime)
}

private fun saveAndShare(context: Context, fileName: String, data: ByteArray, mime: String) {
    val cacheDir = File(context.filesDir, "export_files")
    cacheDir.deleteRecursively()
    cacheDir.mkdir()
    val fileNameSanitised = fileName.replace(Regex("[^a-zA-Z0-9.]"), "")
//    Log.e("TAG++++++", fileNameSanitised)
//    val fileNameChunks = fileNameSanitised.split(".")
//    val name = if (fileNameChunks.isNotEmpty()) fileNameChunks[0] else ""
//    val extension = if (fileNameChunks.size > 1) fileNameChunks[1] else ".txt"
    val tempFile = File(cacheDir, fileNameSanitised)
    tempFile.writeBytes(data)
    val fileForRead = File(cacheDir, fileNameSanitised)
    val fileUri =
        FileProvider.getUriForFile(
            context,
            "com.fahamutech.fileprovider",
            fileForRead,
            fileNameSanitised
        )
    val shareIntent = ShareCompat.IntentBuilder(context).setStream(fileUri).intent
    shareIntent.action = Intent.ACTION_SEND
    shareIntent.setDataAndType(fileUri, mime)
    shareIntent.putExtra(Intent.EXTRA_STREAM, fileUri)
    shareIntent.clipData = ClipData.newRawUri("", fileUri)
    val resInfoList: List<ResolveInfo> =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.queryIntentActivities(
                shareIntent,
                ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY.toLong())
            )
        } else {
            context.packageManager.queryIntentActivities(
                shareIntent,
                PackageManager.MATCH_DEFAULT_ONLY
            )
        }
//    Log.e("TO:::GRANT::::SIZE--->", resInfoList.size.toString())
    for (resolveInfo in resInfoList) {
        val packageName = resolveInfo.activityInfo.packageName
//        Log.e("T:::GRANT::::", packageName)
        context.grantUriPermission(
            packageName,
            fileUri,
            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        )
    }

    context.startActivity(Intent.createChooser(shareIntent, fileNameSanitised))
}