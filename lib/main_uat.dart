import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:securities_app/application.dart';
import 'package:securities_app/config/app_config.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");

// await Firebase.initializeApp();

///IOS Foreground Notification
// await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//   alert: true,
//   badge: true,
//   sound: true,
// );
// }

Future<void> main() async {
  GetIt.I.registerSingleton<AppConfig>(
    AppConfig()..setUat(),
  );

  // setupLocator();

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
