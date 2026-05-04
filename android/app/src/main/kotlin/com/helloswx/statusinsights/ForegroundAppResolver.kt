package com.helloswx.statusinsights

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager

object ForegroundAppResolver {
    fun hasUsageStatsPermission(context: Context): Boolean {
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
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

    fun getForegroundWindowTitle(context: Context, fallbackTitle: String = ""): String {
        val packageName = getForegroundPackageName(context)
        val safeFallback = fallbackTitle.trim()

        if (packageName.isNullOrBlank()) {
            return safeFallback
        }

        return if (packageName == context.packageName) {
            if (safeFallback.isNotBlank()) safeFallback else resolveAppLabel(context, packageName)
        } else {
            resolveAppLabel(context, packageName)
        }
    }

    private fun getForegroundPackageName(context: Context): String? {
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
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

    private fun resolveAppLabel(context: Context, packageName: String): String {
        return try {
            val appInfo = context.packageManager.getApplicationInfo(packageName, 0)
            context.packageManager.getApplicationLabel(appInfo).toString().ifBlank { packageName }
        } catch (_: PackageManager.NameNotFoundException) {
            resolveLauncherLabel(context, packageName) ?: packageName
        } catch (_: Exception) {
            resolveLauncherLabel(context, packageName) ?: packageName
        }
    }

    private fun resolveLauncherLabel(context: Context, packageName: String): String? {
        return try {
            val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName) ?: return null
            val resolveInfo = context.packageManager.resolveActivity(launchIntent, 0) ?: return null
            resolveInfo.loadLabel(context.packageManager)?.toString()
        } catch (_: Exception) {
            null
        }
    }
}
