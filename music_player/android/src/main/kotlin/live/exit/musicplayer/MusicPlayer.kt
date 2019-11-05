package live.exit.musicplayer

import android.media.MediaPlayer

import android.support.v4.media.session.MediaControllerCompat
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import io.flutter.plugin.common.MethodChannel
import java.util.Timer
import java.util.TimerTask
import kotlin.math.roundToInt
import android.app.Activity

class MusicPlayer(private val channel: MethodChannel, private val session: MediaSessionCompat, private val activity: Activity) : MediaControllerCompat.Callback(), MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener {

  private val player = MediaPlayer()
  private var timer = Timer()
  private var task: TimerTask? = null

  init {
    player.reset()
    player.setOnPreparedListener(this)
    player.setOnCompletionListener(this)
    session.controller.registerCallback(this)
  }

  override fun onPrepared(p0: MediaPlayer?) {
    player.start()
    channel.invokeMethod("onDuration", player.duration)
    channel.invokeMethod("onIsPlaying", null)
  }

  override fun onCompletion(p0: MediaPlayer?) {
    channel.invokeMethod("onCompleted", null)
  }

  fun play(url: String) {
    player.reset()
    channel.invokeMethod("onPosition", 0.0)
    player.setDataSource(url)
    player.prepareAsync()
    channel.invokeMethod("onIsLoading", null)
    task?.cancel()
    task = object : TimerTask() {
      override fun run() {
        if (player.isPlaying) {
          session.setPlaybackState(PlaybackStateCompat.Builder()
              .setState(PlaybackStateCompat.STATE_PLAYING, player.currentPosition.toLong(), 1f)
              .build())
          activity.runOnUiThread(java.lang.Runnable {
            channel.invokeMethod("onPosition", player.currentPosition.toDouble() / player.duration.toDouble())
          })
        }
      }
    }
    timer.schedule(task, 0, 100)
  }

  fun pause() {
    if (player.isPlaying) {
      player.pause()
    }
    channel.invokeMethod("onIsPaused", null)
  }

  fun stop() {
    player.stop()
    channel.invokeMethod("onIsStopped", null)
  }

  fun resume() {
    player.start()
    channel.invokeMethod("onIsPlaying", null)
  }

  fun previous() {
    channel.invokeMethod("onPlayPrevious", null)
  }

  fun next() {
    channel.invokeMethod("onPlayNext", null)
  }

  fun seek(position: Double) {
    val ms = (player.duration * position).roundToInt()
    player.seekTo(ms)
  }
}