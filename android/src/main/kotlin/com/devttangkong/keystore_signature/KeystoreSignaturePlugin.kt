package com.devttangkong.keystore_signature

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** KeystoreSignaturePlugin */
class KeystoreSignaturePlugin : FlutterPlugin, MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android.
    private lateinit var channel: MethodChannel

    // Context of the Android application, used to access system services and package information.
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "keystore_signature")
        channel.setMethodCallHandler(this)
    }

    // Handles method calls from Flutter and delegates "getHashKey" requests.
    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getSignatures" -> getSignatures(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    @SuppressLint("InlinedApi")
    @Suppress("DEPRECATION")
    fun getSignatures(result: Result) {
        val isAfterApi28 = Build.VERSION.SDK_INT >= Build.VERSION_CODES.P

        try {
            val packageInfo = context.packageManager.getPackageInfo(
                context.packageName,
                when (isAfterApi28) {
                    true -> PackageManager.GET_SIGNING_CERTIFICATES
                    false -> PackageManager.GET_SIGNATURES
                }
            )

            // Sends an error to Flutter if the application PackageInfo is unavailable.
            if (packageInfo == null) {
                result.error("PackageInfo is null", "Failed to retrieve package information", null)
                return
            }

            val signatures = when (isAfterApi28) {
                true -> packageInfo.signingInfo?.apkContentsSigners
                false -> packageInfo.signatures
            }

            // Sends an error to Flutter if the application has no valid signatures.
            if (signatures.isNullOrEmpty()) {
                result.error("Signature is invalid", "No valid app signature found", null)
                return
            }

            val byteList = signatures.map { it.toByteArray() }
            result.success(byteList)
        } catch (error: PackageManager.NameNotFoundException) {
            result.error("PackageInfo not found", error.message, null)
        }
    }
}
