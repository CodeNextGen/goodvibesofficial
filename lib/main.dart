import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/notification_page_provider.dart';
import 'package:goodvibes/providers.dart/notification_provider.dart';
import 'package:goodvibes/providers.dart/payment_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'locator.dart';
import 'pages/initial/splash.dart';
import 'providers.dart/app_init.dart';
import 'providers.dart/login_provider.dart';
import 'providers.dart/reminder_db_provider.dart';
import 'routes.dart';

void main() {
  // Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    setupLocator();
    AppInit().initDb();
    runApp(AppRoot());
  });
}

class AppRoot extends StatelessWidget with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.suspending) {
      if (Platform.isAndroid) {
        final _androidAppRetain = MethodChannel("android_app_retain");
        _androidAppRetain.invokeMethod("hide");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PaymentProvider>.value(
          value: PaymentProvider(),
        ),
        Provider<NotificationProvider>.value(value: NotificationProvider()),
        ChangeNotifierProvider<ReminderDbProvider>.value(
          value: ReminderDbProvider(),
        ),
        Provider<AdsProvider>.value(
          value: AdsProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>.value(
          value: LoginProvider(),
        ),
        ChangeNotifierProvider<MusicProvider>.value(
          value: MusicProvider(),
        ),
        ChangeNotifierProvider<StartupProvider>.value(
          value: StartupProvider(),
        ),
        ChangeNotifierProvider<NotificationPageProvider>.value(
          value: NotificationPageProvider(),
        ),
        // ChangeNotifierProvider<MusicPlayerProvider>.value(
        //   value: MusicPlayerProvider(),
        // ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('My app class');
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigationKey,
      routes: routes,
      debugShowCheckedModeBanner: false,
      title: 'Good Vibes',
      home: Splash(),
    );
  }
}
