package com.helloswx.statusinsights

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val WINDOW_CHANNEL = "statusinsights/window_title"
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
    }

    private fun hasUsageStatsPermission(): Boolean {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return false
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 60 * 1000
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )
        return stats != null && stats.isNotEmpty()
    }

    private fun openUsageAccessSettings() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }

    private fun getForegroundWindowTitle(): String {
        val packageName = getForegroundPackageName()
        val fallbackTitle = title?.toString()?.trim().orEmpty()

        if (packageName.isNullOrBlank()) {
            return fallbackTitle
        }

        return if (packageName == this.packageName) {
            if (fallbackTitle.isNotBlank()) fallbackTitle else resolveAppLabel(packageName)
        } else {
            resolveAppLabel(packageName)
        }
    }

    private fun getForegroundPackageName(): String? {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return null
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 10 * 60 * 1000
        val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
        val event = UsageEvents.Event()
        var packageName: String? = null

        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND ||
                event.eventType == UsageEvents.Event.ACTIVITY_RESUMED
            ) {
                packageName = event.packageName
            }
        }
        return packageName
    }

    private fun resolveAppLabel(packageName: String): String {
        return try {
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(appInfo).toString().ifBlank { packageName }
        } catch (_: PackageManager.NameNotFoundException) {
            packageName
        } catch (_: Exception) {
            packageName
        }
    }
}
