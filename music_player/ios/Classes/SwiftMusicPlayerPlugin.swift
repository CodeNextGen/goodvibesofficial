import Flutter
import UIKit
import AVKit
import AVFoundation

import MediaPlayer


enum MusicPlayerError: Error {
  case unknownMethod
  case invalidUrl
}

@available(iOS 10.0, *)
public class SwiftMusicPlayerPlugin: NSObject, FlutterPlugin {
  /// How often the position of the player should be updated.
  let positionUpdateInterval = TimeInterval(0.5)
  
  
  var playPauseTarget: Any?
  var nextTrackTarget: Any?
  var previousTrackTarget: Any?
  var changePlaybackPositionTarget: Any?
  
  var player: AVPlayer?
  let channel: FlutterMethodChannel
  
  let audioSession: AVAudioSession
  
  var positionTimer: Timer?
  // In ms
  var duration: Double?
  var position = 0.0
  
  var trackName = ""
  var albumName = ""
  var artistName = ""
  var image: UIImage?
  
  
  var itemStatusObserver: NSKeyValueObservation?
  var timeControlStatusObserver: NSKeyValueObservation?
  var durationObserver: NSKeyValueObservation?
  
  
  init(_ channel: FlutterMethodChannel) {
    self.channel = channel
    self.audioSession = AVAudioSession.sharedInstance()
    
    super.init()
  }
  
  private func getPlayer() -> AVPlayer {
    if self.player != nil { return player!; }
    // The player is not setup, so set it up now:
    let player = AVPlayer()
    player.automaticallyWaitsToMinimizeStalling = false
    self.player = player
    
    timeControlStatusObserver = player.observe(\AVPlayer.timeControlStatus) { [unowned self] player, _ in
      self.timeControlStatusChanged(player.timeControlStatus)
    }
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.togglePlayPauseCommand.isEnabled = true
    playPauseTarget = commandCenter.togglePlayPauseCommand.addTarget(handler: {
      (event) in
      if player.timeControlStatus == AVPlayer.TimeControlStatus.paused {
        self.resume()
      } else {
        self.pause()
      }
      return .success
    })

    commandCenter.nextTrackCommand.isEnabled = true
    nextTrackTarget = commandCenter.nextTrackCommand.addTarget(handler: {
      (event) in
      self.channel.invokeMethod("onPlayNext", arguments: nil)
      return .success
    })

    commandCenter.previousTrackCommand.isEnabled = true
    previousTrackTarget = commandCenter.previousTrackCommand.addTarget(handler: {
      (event) in
      self.channel.invokeMethod("onPlayPrevious", arguments: nil)
      return .success
    })
    
    commandCenter.changePlaybackPositionCommand.isEnabled = true
    changePlaybackPositionTarget = commandCenter.changePlaybackPositionCommand.addTarget(handler: {
      (remoteEvent) in
      if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
        player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)))
        return .success
      }
      return .commandFailed
    })
    
    return player
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "exit.live/music_player", binaryMessenger: registrar.messenger())
    let instance = SwiftMusicPlayerPlugin(channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("\(call.method)")
    do {
      switch call.method {
      case "play":
        try play(call.arguments as! NSDictionary)
      case "pause":
        pause()
      case "stop":
        stop()
      case "resume":
        resume()
      case "seek":
        seek(call.arguments as! Double)
      default:
        throw MusicPlayerError.unknownMethod
      }
      result("iOS " + UIDevice.current.systemVersion)
    } catch {
      print("MusicPlayer flutter bridge error: \(error)")
      result(0)
    }
  }
  
  
  func play(_ properties: NSDictionary) throws {
    let player = getPlayer()
    
    // try audioSession.setCategory(.playback, mode: .default, options: [])
    try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [])

    try audioSession.setActive(true)
    
    // Resetting values.
    self.duration = nil
    position = 0.0
    // Since the positionTimer is only set when `readyToPlay` we reset it
    // immediately here.
    positionTimer?.invalidate()
    positionTimer = nil
    
    let urlString = properties["url"] as! String
    let url = URL.init(string: urlString)
    if url == nil {
      throw MusicPlayerError.invalidUrl
    }
    
    trackName = properties["trackName"] as! String
    albumName = properties["albumName"] as! String
    artistName = properties["artistName"] as! String
    
    
    let coverFilename = properties["coverFilename"]
    if coverFilename != nil && coverFilename is String {
      try setCover(coverFilename as! String)
    }
    
    updateInfoCenter()
    
    let playerItem = AVPlayerItem.init(url: url!)
    
    
    itemStatusObserver = playerItem.observe(\AVPlayerItem.status) { [unowned self] playerItem, _ in
      self.itemStatusChanged(playerItem.status)
    }
    
    durationObserver = playerItem.observe(\AVPlayerItem.duration) { [unowned self] playerItem, _ in
      self.durationChanged()
    }
    
    player.replaceCurrentItem(with: playerItem)
    player.playImmediately(atRate: 1.0)
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(audioDidPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
  }
  
  func setCover(_ fileName: String) throws {
    let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    let imageUrl = documentsUrl.appendingPathComponent(fileName)
    let imageData = try Data.init(contentsOf: imageUrl)
    image = UIImage.init(data: imageData)
  }
  
  func updateInfoCenter() {
    if (self.player == nil) { return; }
    
    let player = self.player!
    var songInfo = [String : Any]()
    songInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.timeControlStatus == AVPlayer.TimeControlStatus.playing ? 1.0 : 0.0
    songInfo[MPMediaItemPropertyTitle] = trackName
    songInfo[MPMediaItemPropertyAlbumTitle] = albumName
    songInfo[MPMediaItemPropertyArtist] = artistName
    
    if duration != nil {
      songInfo[MPMediaItemPropertyPlaybackDuration] =  duration! / 1000
      songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] =  (position * duration!) / 1000
    }
    if (image != nil) {
      songInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(image: image!)
    }
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
    // MPNowPlayingInfoCenter.default().playbackState = player.rate == 0.0 ? .paused : .playing
      if #available(iOS 13, macOS 10.12.2, *) {
      MPNowPlayingInfoCenter.default().playbackState = player.rate == 0.0 ? .paused : .playing
    }

  }
  
  func pause() {
    player?.pause()
  }
  
  func stop() {
    if self.player == nil { return }
    
    let player = self.player!

    self.player = nil
    
    itemStatusObserver?.invalidate()
    durationObserver?.invalidate()
    positionTimer?.invalidate()
    
    player.pause()
    player.replaceCurrentItem(with: nil)
    

    // This hides the command center again
    let commandCenter = MPRemoteCommandCenter.shared();
    commandCenter.togglePlayPauseCommand.removeTarget(playPauseTarget)
    commandCenter.nextTrackCommand.removeTarget(nextTrackTarget)
    commandCenter.previousTrackCommand.removeTarget(previousTrackTarget)
    commandCenter.changePlaybackPositionCommand.removeTarget(changePlaybackPositionTarget)

    MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
  }
  
  func resume() {
    player?.play()
  }
  
  func seek(_ positionPercent: Double) {
    if self.player == nil { return }
    
    let player = self.player!
    if (duration == nil || player.currentItem == nil) { return; }
    let to = CMTime.init(seconds: (duration! * positionPercent) / 1000, preferredTimescale: 1)
    let tolerance = CMTime.init(seconds: 0.1, preferredTimescale: 1)
    player.currentItem!.seek(to: to, toleranceBefore: tolerance, toleranceAfter: tolerance)
  }
  
  @objc func audioDidPlayToEnd() {
    channel.invokeMethod("onCompleted", arguments: nil)
  }
  
  func timeControlStatusChanged(_ status: AVPlayer.TimeControlStatus) {
    switch (status) {
    case AVPlayer.TimeControlStatus.playing:
      print("Playing.")
      channel.invokeMethod("onIsPlaying", arguments: nil)
      
    case AVPlayer.TimeControlStatus.paused:
      print("Paused.")
      channel.invokeMethod("onIsPaused", arguments: nil)
      
    case AVPlayer.TimeControlStatus.waitingToPlayAtSpecifiedRate:
      print("Waiting to play at specified rate.")
      channel.invokeMethod("onIsLoading", arguments: nil)
    }
    updateInfoCenter()
  }
  
  
  func durationChanged() {
    if self.player == nil { return }
    let player = self.player!
    
    var newDuration: Double?
    
    if player.currentItem != nil && !CMTIME_IS_INDEFINITE(player.currentItem!.duration) {
      newDuration = player.currentItem!.duration.seconds * 1000
    }
    
    if newDuration != duration {
      duration = newDuration
      channel.invokeMethod("onDuration", arguments: duration == nil ? nil : lround(duration!))
    }
    updateInfoCenter()
  }
  
  func positionChanged(timer: Timer) {
    if self.player == nil { return }
    let player = self.player!
    
    if duration == nil || player.currentItem == nil || CMTIME_IS_INDEFINITE(player.currentItem!.currentTime()) {
      // We don't want to do anything if we don't have a duration, currentItem or currentTime.
      return
    }
    
    let positionInMs = player.currentItem!.currentTime().seconds * 1000
    let positionPercent = positionInMs / duration!
    
    if positionPercent != position {
      position = positionPercent
      channel.invokeMethod("onPosition", arguments: position)
    }
  }
  
  func itemStatusChanged(_ status: AVPlayerItem.Status) {
    // Switch over status value
    switch status {
    case .readyToPlay:
      positionTimer = Timer.scheduledTimer(withTimeInterval: positionUpdateInterval, repeats: true, block:  self.positionChanged)
    case .failed:
      channel.invokeMethod("onError", arguments: ["code": 0, "message": "Playback failed"])
    case .unknown:
      channel.invokeMethod("onError", arguments: ["code": 0, "message": "Unknown error"])
    }
  }
}
