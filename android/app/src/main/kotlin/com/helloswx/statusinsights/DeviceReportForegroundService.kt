package com.helloswx.statusinsights

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import org.json.JSONObject
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URI
import java.net.URL
import java.nio.charset.StandardCharsets
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit

class DeviceReportForegroundService : Service() {
    companion object {
        const val ACTION_START = "com.helloswx.statusinsights.action.START_REPORTING"
        const val ACTION_STOP = "com.helloswx.statusinsights.action.STOP_REPORTING"

        const val EXTRA_SERVER_ADDRESS = "serverAddress"
        const val EXTRA_API_KEY = "apiKey"
        const val EXTRA_DEVICE_ID = "deviceId"
        const val EXTRA_INTERVAL_SECONDS = "intervalSeconds"

        private const val CHANNEL_ID = "device_report_foreground_channel"
        private const val CHANNEL_NAME = "Device Status Reporting"
        private const val NOTIFICATION_ID = 1001
    }

    private var scheduler: ScheduledExecutorService? = null
    private var lastTaskRunning = false

    @Volatile
    private var serverAddress: String = ""

    @Volatile
    private var apiKey: String = ""

    @Volatile
    private var deviceId: String = ""

    @Volatile
    private var intervalSeconds: Int = 20

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                stopReporting()
                stopSelf()
                return START_NOT_STICKY
            }

            ACTION_START -> {
                updateConfig(intent)
                ensureForeground()
                restartReporting()
                return START_STICKY
            }

            else -> {
                if (intent != null) {
                    updateConfig(intent)
                    ensureForeground()
                    restartReporting()
                    return START_STICKY
                }
                return START_NOT_STICKY
            }
        }
    }

    override fun onDestroy() {
        stopReporting()
        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }

    private fun updateConfig(intent: Intent) {
        serverAddress = intent.getStringExtra(EXTRA_SERVER_ADDRESS)?.trim().orEmpty()
        apiKey = intent.getStringExtra(EXTRA_API_KEY)?.trim().orEmpty()
        deviceId = intent.getStringExtra(EXTRA_DEVICE_ID)?.trim().orEmpty()
        intervalSeconds = intent.getIntExtra(EXTRA_INTERVAL_SECONDS, 20).coerceAtLeast(1)
    }

    private fun ensureForeground() {
        createNotificationChannelIfNeeded()
        startForeground(NOTIFICATION_ID, buildNotification())
    }

    private fun restartReporting() {
        stopReporting()
        if (serverAddress.isBlank() || deviceId.isBlank()) {
            return
        }
        val executor = Executors.newSingleThreadScheduledExecutor()
        scheduler = executor
        lastTaskRunning = false
        executor.scheduleAtFixedRate(
            {
                if (lastTaskRunning) {
                    return@scheduleAtFixedRate
                }
                lastTaskRunning = true
                try {
                    reportDeviceStatus()
                } catch (_: Exception) {
                } finally {
                    lastTaskRunning = false
                }
            },
            0L,
            intervalSeconds.toLong(),
            TimeUnit.SECONDS
        )
    }

    private fun stopReporting() {
        scheduler?.shutdownNow()
        scheduler = null
        lastTaskRunning = false
    }

    private fun reportDeviceStatus() {
        val title = ForegroundAppResolver.getForegroundWindowTitle(this, "")
            .trim()
            .ifEmpty { "Unknown" }
        val body = JSONObject().apply {
            put("device_id", deviceId)
            put("status", title)
        }.toString()
        postJson(buildEndpointUrl("/status/device/set"), body)
    }

    private fun buildEndpointUrl(path: String): URL {
        val base = if (serverAddress.endsWith("/")) serverAddress else "$serverAddress/"
        val normalizedPath = if (path.startsWith("/")) path.substring(1) else path
        val resolved = URI(base).resolve(normalizedPath).toString()
        return URL(resolved)
    }

    private fun postJson(url: URL, body: String) {
        val connection = (url.openConnection() as HttpURLConnection).apply {
            requestMethod = "POST"
            connectTimeout = 10_000
            readTimeout = 10_000
            doOutput = true
            setRequestProperty("Content-Type", "application/json")
            setRequestProperty("X-API-Key", apiKey)
        }
        try {
            OutputStreamWriter(connection.outputStream, StandardCharsets.UTF_8).use { writer ->
                writer.write(body)
                writer.flush()
            }
            connection.inputStream.use {
                while (it.read() != -1) {
                }
            }
        } catch (_: Exception) {
            try {
                connection.errorStream?.use { stream ->
                    while (stream.read() != -1) {
                    }
                }
            } catch (_: Exception) {
            }
        } finally {
            connection.disconnect()
        }
    }

    private fun createNotificationChannelIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }
        val manager = getSystemService(NotificationManager::class.java) ?: return
        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_LOW
        )
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("StatusInsights")
            .setContentText("设备状态自动上报运行中")
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .build()
    }
}
