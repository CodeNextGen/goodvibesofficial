package live.exit.musicplayer

import android.app.Activity
import android.app.Application
import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.File
import android.content.BroadcastReceiver
import android.content.Context.BIND_AUTO_CREATE
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import live.exit.musicplayer.MusicPlayerService.LocalBinder
import android.os.IBinder
import android.content.ComponentName
import android.content.ServiceConnection
import android.os.Bundle
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat

const val NOTIFY_PAUSE = "live.exit.musicplayer.pause"
const val NOTIFY_PREVIOUS = "live.exit.musicplayer.previous"
const val NOTIFY_NEXT = "live.exit.musicplayer.next"
const val NOTIFY_PLAY = "live.exit.musicplayer.play"

class MusicPlayerPlugin(private val player: MusicPlayer, registrar: Registrar, private val context: Context, private val activity: Activity, private val session: MediaSessionCompat) : BroadcastReceiver(), MethodCallHandler, Application.ActivityLifecycleCallbacks {

  private var service: MusicPlayerService? = null
  private var bound = false
  private val notificationData: NotificationData = NotificationData()

  init {
    val filter = IntentFilter()
    filter.addAction(NOTIFY_PAUSE)
    filter.addAction(NOTIFY_PLAY)
    filter.addAction(NOTIFY_PREVIOUS)
    filter.addAction(NOTIFY_NEXT)
    context.registerReceiver(this, filter)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val context = registrar.activeContext()
      val activity = registrar.activity()
      val channel = MethodChannel(registrar.messenger(), "exit.live/music_player")
      val session = MediaSessionCompat(context, "MediaSession")
      val player = MusicPlayer(channel, session, activity)
      val plugin = MusicPlayerPlugin(player, registrar, context, activity, session)
      activity.getApplication().registerActivityLifecycleCallbacks(plugin)
      channel.setMethodCallHandler(plugin)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "play" -> play(call.arguments as Map<String, String>)
      "pause" -> pause()
      "stop" -> stop()
      "resume" -> resume()
      "seek" -> player.seek(call.arguments as Double)
      else -> {
        result.notImplemented()
      }
    }
    result.success(0)
  }

  private var connection: ServiceConnection = object : ServiceConnection {
    override fun onServiceDisconnected(name: ComponentName) {
      bound = false
      service = null
    }

    override fun onServiceConnected(name: ComponentName, service: IBinder) {
      bound = true
      val binder = service as LocalBinder
      this@MusicPlayerPlugin.service = binder.service
      binder.service.flutterActivity = activity
      binder.service.updateNotification(notificationData)
    }
  }

  private fun play(arguments: Map<String, Any>) {
    session.isActive = true
    session.setPlaybackState(PlaybackStateCompat.Builder()
        .setState(PlaybackStateCompat.STATE_PLAYING, 0, 1f)
        .build())
    val serviceIntent = Intent(activity, MusicPlayerService::class.java)
    Log.v("MusicPlayerPlugin", "Check if bound: $bound")
    if (!bound) {
      Log.v("MusicPlayerPlugin", "Starting service")
      activity.startService(serviceIntent)
      Log.v("MusicPlayerPlugin", "Binding service")
      activity.bindService(serviceIntent, connection, BIND_AUTO_CREATE)
    }
    val coverFilename = arguments["coverFilename"] as String?
    if (coverFilename != null) {
      Log.v("MusicPlayerPlugin", "Got show cover with $coverFilename")
      val options = BitmapFactory.Options()
      options.inPreferredConfig = Bitmap.Config.ARGB_8888
      notificationData.coverImage = BitmapFactory.decodeFile(File(context.cacheDir, coverFilename).absolutePath, options)
    } else {
      notificationData.coverImage = null
    }
    notificationData.trackName = arguments["trackName"] as String
    notificationData.albumName = arguments["albumName"] as String
    notificationData.artistName = arguments["artistName"] as String
    notificationData.isPlaying = true
    service?.updateNotification(notificationData)
    player.play(arguments["url"] as String)
  }

  private fun pause() {
    Log.v("MusicPlayerPlugin", "Pausing Playback")
    notificationData.isPlaying = false
    service?.updateNotification(notificationData)
    player.pause()
  }

  private fun resume() {
    Log.v("MusicPlayerPlugin", "Resuming Playback")
    notificationData.isPlaying = true
    service?.updateNotification(notificationData)
    player.resume()
  }

  override fun onReceive(context: Context?, intent: Intent?) {
    when {
      intent?.action.equals(NOTIFY_PAUSE) -> {
        Log.v("MusicPlayerPlugin", "Received: notify pause")
        notificationData.isPlaying = false
        service?.updateNotification(notificationData)
        player.pause()
      }
      intent?.action.equals(NOTIFY_PLAY) -> {
        Log.v("MusicPlayerPlugin", "Received: notify play")
        notificationData.isPlaying = true
        service?.updateNotification(notificationData)
        player.resume()

      }
      intent?.action.equals(NOTIFY_PREVIOUS) -> {
        Log.v("MusicPlayerPlugin", "Received: notify previous")
        notificationData.isPlaying = true
        service?.updateNotification(notificationData)
        player.previous()
      }
      intent?.action.equals(NOTIFY_NEXT) -> {
        Log.v("MusicPlayerPlugin", "Received: notify next")
        notificationData.isPlaying = true
        service?.updateNotification(notificationData)
        player.next()
      }
    }
  }

  private fun stop() {
    val serviceIntent = Intent(activity, MusicPlayerService::class.java)
    activity.stopService(serviceIntent)
    bound = false
    player.stop()
  }

  override fun onActivityPaused(activity: Activity?) {
    Log.v("MusicPlayerPlugin", "Activity Paused")
  }

  override fun onActivityResumed(activity: Activity?) {
    Log.v("MusicPlayerPlugin", "Activity Resumed")
  }

  override fun onActivityStarted(activity: Activity?) {
    Log.v("MusicPlayerPlugin", "Activity Started")
  }

  override fun onActivityDestroyed(activity: Activity?) {
    Log.v("MusicPlayerPlugin", "Activity Destroyed")
    stop()
    session.controller.unregisterCallback(player)
  }

  override fun onActivitySaveInstanceState(activity: Activity?, outState: Bundle?) {
    Log.v("MusicPlayerPlugin", "Activity Save Instance State")
  }

  override fun onActivityStopped(activity: Activity?) {
    Log.v("MusicPlayerPlugin", "Activity Stopped")
  }

  override fun onActivityCreated(activity: Activity?, savedInstanceState: Bundle?) {
    Log.v("MusicPlayerPlugin", "Activity Created")
  }
}