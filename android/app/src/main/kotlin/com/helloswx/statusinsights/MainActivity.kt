package com.helloswx.statusinsights

import android.content.Intent
import android.provider.Settings
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val WINDOW_CHANNEL = "statusinsights/window_title"
        private const val DEVICE_REPORT_SERVICE_CHANNEL = "statusinsights/device_report_service"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WINDOW_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getForegroundWindowTitle" -> {
                        result.success(getForegroundWindowTitle())
                    }
                    "hasUsageStatsPermission" -> {
                        result.success(hasUsageStatsPermission())
                    }
                    "openUsageAccessSettings" -> {
                        openUsageAccessSettings()
                        result.success(true)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_REPORT_SERVICE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startForegroundReporting" -> {
                        val serverAddress = call.argument<String>("serverAddress")?.trim().orEmpty()
                        val apiKey = call.argument<String>("apiKey")?.trim().orEmpty()
                        val deviceId = call.argument<String>("deviceId")?.trim().orEmpty()
                        val intervalSeconds = (call.argument<Int>("intervalSeconds") ?: 20).coerceAtLeast(1)

                        if (serverAddress.isBlank() || deviceId.isBlank()) {
                            result.error(
                                "invalid_args",
                                "serverAddress and deviceId are required",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        startForegroundReporting(
                            serverAddress = serverAddress,
                            apiKey = apiKey,
                            deviceId = deviceId,
                            intervalSeconds = intervalSeconds
                        )
                        result.success(true)
                    }

                    "stopForegroundReporting" -> {
                        stopForegroundReporting()
                        result.success(true)
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun hasUsageStatsPermission(): Boolean {
        return ForegroundAppResolver.hasUsageStatsPermission(this)
    }

    private fun openUsageAccessSettings() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }

    private fun getForegroundWindowTitle(): String {
        val fallbackTitle = title?.toString().orEmpty()
        return ForegroundAppResolver.getForegroundWindowTitle(this, fallbackTitle)
    }

    private fun startForegroundReporting(
        serverAddress: String,
        apiKey: String,
        deviceId: String,
        intervalSeconds: Int
    ) {
        val intent = Intent(this, DeviceReportForegroundService::class.java).apply {
            action = DeviceReportForegroundService.ACTION_START
            putExtra(DeviceReportForegroundService.EXTRA_SERVER_ADDRESS, serverAddress)
            putExtra(DeviceReportForegroundService.EXTRA_API_KEY, apiKey)
            putExtra(DeviceReportForegroundService.EXTRA_DEVICE_ID, deviceId)
            putExtra(DeviceReportForegroundService.EXTRA_INTERVAL_SECONDS, intervalSeconds)
        }
        ContextCompat.startForegroundService(this, intent)
    }

    private fun stopForegroundReporting() {
        val intent = Intent(this, DeviceReportForegroundService::class.java)
        stopService(intent)
    }
}
