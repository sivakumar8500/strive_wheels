package com.example.wheels_rider

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.strivewheels/journey_notification"
    private val NOTIFICATION_ID = 4032
    private val CHANNEL_ID = "live_journey_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showJourneyNotification" -> {
                    val title = call.argument<String>("title") ?: "Ride in Progress"
                    val body = call.argument<String>("body") ?: ""
                    val subText = call.argument<String>("subText") ?: "Strive Rider"
                    val progress = call.argument<Int>("progress") ?: 0
                    val maxProgress = call.argument<Int>("maxProgress") ?: 100
                    showNotification(title, body, subText, progress, maxProgress)
                    result.success(true)
                }
                "dismissJourneyNotification" -> {
                    dismissNotification()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun showNotification(title: String, body: String, subText: String, progress: Int, maxProgress: Int) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Live Journey Tracking",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows live ongoing ride and navigation status"
                lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
                setShowBadge(true)
            }
            notificationManager.createNotificationChannel(channel)
        }

        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        )

        val smallIconRes = try {
            val id = resources.getIdentifier("ic_notification", "drawable", packageName)
            if (id != 0) id else android.R.drawable.ic_menu_directions
        } catch (_: Exception) {
            android.R.drawable.ic_menu_directions
        }

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(smallIconRes)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setSubText(subText)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_NAVIGATION)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setProgress(maxProgress, progress, false)
            .setContentIntent(pendingIntent)

        try {
            notificationManager.notify(NOTIFICATION_ID, builder.build())
        } catch (e: Exception) {
            android.util.Log.e("LiveJourneyNotification", "Failed to show notification: ${e.message}", e)
        }
    }

    private fun dismissNotification() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(NOTIFICATION_ID)
    }
}
