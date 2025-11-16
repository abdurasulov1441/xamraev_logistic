import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:xamraev_logistic/app/app.dart';
import 'package:xamraev_logistic/services/db/cache.dart';
import 'firebase_options.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {
    print("Firebase init error: $e");
  }

  try {
    await cache.init();
  } catch (_) {}

  if (Platform.isAndroid) {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (_) {}
  }

  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (_) {}

  try {
    EasyLocalization.logger.enableBuildModes = [];
    await EasyLocalization.ensureInitialized();
  } catch (_) {}

  try {
    runApp(
      ProviderScope(
        child: EasyLocalization(
          path: 'assets/translations',
          supportedLocales: const [Locale('uz'), Locale('ru'), Locale('uk')],
          startLocale: const Locale('uz'),
          saveLocale: true,
          child: const App(),
        ),
      ),
    );
  } catch (e, s) {
    FirebaseCrashlytics.instance.recordError(e, s, fatal: true);
  }
}
