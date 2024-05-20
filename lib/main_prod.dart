import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:securities_app/application.dart';
import 'package:securities_app/config/app_config.dart';
import 'package:securities_app/di/di.dart';
import 'package:securities_app/global/network/http_override/custom_http_override.dart';

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

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    sl.registerSingleton<AppConfig>(
      AppConfig()..setProd(),
    );
    await configureDependencies(environment: Environment.prod);
    await Future.delayed(
      const Duration(seconds: 1),
    );
    // disableErrorWidget();
    // override http protocol
    HttpOverrides.global = CustomHttpOverrides();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(
        const Application(),
      );
    });

    ///[console] flavor running hidden when release mode

  }, (error, stackTrace) {
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
