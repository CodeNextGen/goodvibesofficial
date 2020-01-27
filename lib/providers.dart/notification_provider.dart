import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    // String timezone = DateTime.now().timeZoneName;
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    // _fcm.subscribeToTopic(timezone);
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

     getToken();
  }

  Future<Null> getToken() async {
    final String token = await _fcm.getToken();
    print('Token for the device is $token');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('notificatioToken', token);
    String uuid = _prefs.getString('uid');
    print("uuid $uuid");
//    if(uuid != null)
//    await Dio().post('$baseUrl/v1/users/device',
//        data: {"token": token, "Platform":isAndroid? "Android":"iOS"},
//        options: Options(
//          headers: {'uuid': uuid},
//        ));
  }

  void fcmConfig() {
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onlaunch: $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    });
  }

  Future showNotificationWithSound(int id, Time time, Day day) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '9840060186', 'Codeforcore', 'Moobile app for good vibes',
        sound: 'intro', importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(); //add sound : 'file name'
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        'Good Vibes Official',
        'Its time to listen goodvibes, relax and sleep healthy.',
        day,
        time,
        platformChannelSpecifics);
  }

  void cancelAllNotiFication() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void cancelAllNotiFicationById(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelMultipleNotifications(List<int> ids) {
    ids.forEach((int id) async {
      await flutterLocalNotificationsPlugin.cancel(id);
    });
  }
}
