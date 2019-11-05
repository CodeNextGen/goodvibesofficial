package live.exit.musicplayer

import android.app.*
import android.content.Intent
import android.os.IBinder
import android.content.Context
import android.app.PendingIntent
import android.app.NotificationManager
import android.graphics.Bitmap

import android.os.Binder
import android.os.Build
import android.support.v4.media.session.MediaSessionCompat
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.media.app.NotificationCompat as MediaNotificationCompat

class MusicPlayerService : Service() {
  var flutterActivity: Activity? = null
  private var notificationManager: NotificationManager? = null
  private var notificationData: NotificationData = NotificationData()
  private var session: MediaSessionCompat? = null

  private val play = Intent(NOTIFY_PLAY)
  private val pause = Intent(NOTIFY_PAUSE)
  private val previous = Intent(NOTIFY_PREVIOUS)
  private val next = Intent(NOTIFY_NEXT)

  private val notificationId = 85711
  private val channelId = "music_player_notifications"
  private val channelName = "Music Player Notification Channel"
  private val binder = LocalBinder()

  inner class LocalBinder : Binder() {
    val service: MusicPlayerService
      get() = this@MusicPlayerService
  }

  override fun onBind(intent: Intent?): IBinder? {
    Log.v("MusicPlayerService", "Bound!")
    return binder
  }

  override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
    Log.v("MusicPlayerService", "Starting...")
    val channel: NotificationChannel?
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      channel = NotificationChannel(
          channelId,
          channelName, NotificationManager.IMPORTANCE_LOW
      )
      channel.setSound(null, null)
      channel.enableLights(false)
      channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
      val service = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      service.createNotificationChannel(channel)
    }
    startForeground(notificationId, updateNotification(notificationData))
    notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    session = MediaSessionCompat(applicationContext, "MediaSession")
    return START_NOT_STICKY
  }

  fun updateNotification(notificationData: NotificationData): Notification {
    Log.v("MusicPlayerService", "Updating Notification...")
    this.notificationData = notificationData

    if (!notificationData.isPlaying) {
      if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
        stopForeground(STOP_FOREGROUND_DETACH);
      else
        stopForeground(false);
    }

    val builder = NotificationCompat.Builder(applicationContext, channelId)
        .setSmallIcon(R.drawable.notification_icon)
        .setContentTitle(notificationData.trackName)
        .setContentText("${notificationData.artistName} - ${notificationData.albumName}")
        .setLargeIcon(notificationData.coverImage)
        .setStyle(MediaNotificationCompat.MediaStyle()
                .setShowActionsInCompactView(0, 1, 2 /* prev, pause, next buttons */)
                .setMediaSession(session?.sessionToken))
        .setOngoing(notificationData.isPlaying)

    if (flutterActivity != null) {
      val notificationIntent = Intent(applicationContext, flutterActivity!!.javaClass)
      notificationIntent.flags = (Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
      builder.setContentIntent(PendingIntent.getActivity(applicationContext, 0,
          notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT))
    }

    builder.addAction(R.drawable.media_previous, "Previous", PendingIntent.getBroadcast(applicationContext, 1, previous, PendingIntent.FLAG_UPDATE_CURRENT))
    if (notificationData.isPlaying) {
      builder.addAction(R.drawable.media_pause, "Pause", PendingIntent.getBroadcast(applicationContext, 1, pause, PendingIntent.FLAG_UPDATE_CURRENT))
    } else {
      builder.addAction(R.drawable.media_play, "Play", PendingIntent.getBroadcast(applicationContext, 1, play, PendingIntent.FLAG_UPDATE_CURRENT))
    }
    builder.addAction(R.drawable.media_next, "Next", PendingIntent.getBroadcast(applicationContext, 1, next, PendingIntent.FLAG_UPDATE_CURRENT))


    val notification = builder.build()
    notificationManager?.notify(notificationId, notification)
    return notification
  }
}

class NotificationData {
  var isPlaying = true
  var trackName: String? = ""
  var albumName: String? = ""
  var artistName: String? = ""
  var coverImage: Bitmap? = null
}