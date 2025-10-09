import 'dart:developer';

import 'package:coolie_application/firebase_options.dart';
import 'package:coolie_application/repositories/authentication_repo.dart';
import 'package:coolie_application/routes/route_name.dart';
import 'package:coolie_application/routes/route_pages.dart';
import 'package:coolie_application/screens/coolie/home/home_controller.dart';
import 'package:coolie_application/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/app_toasting.dart';
import 'utils/app_config.dart';
import 'utils/theme_constants.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await loadRepositories();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    Firebase.app();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleNotificationClick(message);
  });
  terminatedNotification();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = (errorDetails) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
  runApp(const MyApp());
}

String? lastHandledMessageId;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.messageId != null && message.messageId != lastHandledMessageId) {
    lastHandledMessageId = message.messageId;
    await notificationService.init();
    notificationService.showRemoteNotificationAndroid(message);
    _handleNotificationClick(message);
  }
}

void terminatedNotification() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.messageId != lastHandledMessageId) {
    lastHandledMessageId = initialMessage.messageId;
    notificationService.showRemoteNotificationAndroid(initialMessage);
    _handleNotificationClick(initialMessage);
  }
}

void _handleNotificationClick(RemoteMessage message) async {
  log("Notification data: ${message.data["bookingId"]}");
  if (Get.isRegistered<HomeController>()) {
    final homeCtrl = Get.find<HomeController>();
    homeCtrl.bookingId.value = message.data["bookingId"];
    log("Updated bookingId in HomeController: ${homeCtrl.bookingId.value}");
  } else {
    log("HomeController not registered, navigating to Home with bookingId");
    Get.toNamed(RouteName.home, arguments: {"bookingId": message.data["bookingId"]});
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: GetMaterialApp(
        scaffoldMessengerKey: AppToasting.scaffoldMessengerKey,
        title: AppConfig.appName,
        initialRoute: RouteName.splash,
        getPages: RoutePages.pages,
        defaultTransition: Transition.rightToLeftWithFade,
        debugShowCheckedModeBanner: false,
        theme: defaultTheme,
      ),
    );
  }
}

Future<void> loadRepositories() async {
  await Get.putAsync(() => AuthenticationRepo().init());
}
