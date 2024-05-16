import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:securities_app/application.dart';
import 'package:securities_app/config/app_config.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//
//   await Firebase.initializeApp();
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
// }

Future<void> main() async {
  sl.registerSingleton<AppConfig>(
    AppConfig()..setProd(),
  );
  // setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
  };

  runZonedGuarded(() {
    runApp(
      const Application(),
    );
  }, (error, stackTrace) {
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
