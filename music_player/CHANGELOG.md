## 0.1.4

- Fix crash when starting playback on Android
- Improve speed when starting playback on iOS
- Show controls in compact view on Android
- Make the Android notification dismissible when paused

## 0.1.3

- Fix issue where MPRemoteCommandCenter controls didn't disappear when stopping
  audio on iOS
- Add next and previous button functionality for iOS control center
- Add support for the seek functionality in iOS control center

## 0.1.2

- Tapping the notification in Android brings the Flutter activity to the foreground

## 0.1.1

- Fix issue where some covers couldn't be displayed in iOS' command center (934942a)
- Fix issue where iOS player would crash if the cover couldn't be submitted
  (b992174)

## 0.1.0

- BREAKING: Use AndroidX to lower minSdkVersion 21
- Notification icon can no longer be provided via the Flutter app
- Add resources folder for all icons including the notification icon

## 0.0.8

- Fix displaying cover on iOS
- Implement `stop` functionality on iOS
- Fix a bug where playback would stop when the Flutter activity stops on Android

## 0.0.7

- Use a foreground service to ensure playback does not stop 
- Add possibility to use custom notification icon
- Removed support libary
- Increase minimum SDK version to Android 8.0 Oreo API 26 (should be decreased
  again using AndroidX)

## 0.0.6

- Remove Playlist functionality (should be properly reimplemented in the future)
- Fix example

## 0.0.5

- Update code for cache manager
- Start playback immediately on iOS

## 0.0.4

- Update dependencies

## 0.0.3

- Add possibility to seek on iOS.
- Properly send the `.onCompleted` event on iOS.
- Change name to Music Player.
- Add iOS Control Center and Android Notification player controls
- Add example
- Add gitlab CI for dartfmt and dartanalyzer
  
## 0.0.2

- Added more information to the project.

## 0.0.1

- The initial release with a working version of the iOS player.
