# Music Player
[![Gitlab Status](https://gitlab.com/exitlive/music-player/badges/master/build.svg)](https://gitlab.com/exitlive/music-player/pipelines)
[![Pub Status](https://img.shields.io/pub/v/music_player.svg)](https://pub.dartlang.org/packages/music_player)

A music player flutter plugin that uses the native api to
show the currently playing track with cover image and controls.

**This plugin is still in development.**

**Warning**: This plugin is written in Swift and Kotlin, so make
sure your project is setup to compile these languages.
 
The required iOS version for this plugin is `10.*` because some
features to control the audio playback have only been introduced
there. 
The required Android version is Android 5.0 Lollipop (API 21) or higher

## Usage

A simple [usage example](example/example.dart) 

For Android make sure to add `<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />` and
`<service android:enabled="true" android:name="live.exit.musicplayer.MusicPlayerService" />` to the
`AndroidManifest.xml` of your Flutter app.