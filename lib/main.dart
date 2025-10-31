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

  await notificationService.init();
  await requestNotificationPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

  await terminatedNotification();
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
  await GetStorage.init();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  if (message.messageId != null && message.messageId != lastHandledMessageId) {
    lastHandledMessageId = message.messageId;
    await notificationService.init();
    notificationService.showRemoteNotificationAndroid(message);
    log("Background message received: ${message.data}");
    _onMessageOpenedApp(message);
  }
}

void _onForegroundMessage(RemoteMessage message) async {
  if (message.messageId != null && message.messageId != lastHandledMessageId) {
    lastHandledMessageId = message.messageId;
    notificationService.showRemoteNotificationAndroid(message);
    log("Foreground message received: ${message.data}");
    _onMessageOpenedApp(message);
  }
}

void _onMessageOpenedApp(RemoteMessage message) {
  _handleNotificationClick(message);
}

Future<void> terminatedNotification() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.messageId != lastHandledMessageId) {
    lastHandledMessageId = initialMessage.messageId;
    notificationService.showRemoteNotificationAndroid(initialMessage);
    _handleNotificationClick(initialMessage);
  }
}

void _handleNotificationClick(RemoteMessage message) async {
  log("Notification data: ${message.data}");
  String? bookingId = message.data["bookingId"];

  if (bookingId != null) {
    log("Handling notification with bookingId: $bookingId");

    // Wait a bit for the app to initialize
    await Future.delayed(const Duration(milliseconds: 500));

    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      homeCtrl.bookingId.value = bookingId;
      log("Updated bookingId in HomeController: ${homeCtrl.bookingId.value}");
      homeCtrl.onInit();
    } else {
      log("HomeController not registered, navigating to Home with bookingId");
      Get.toNamed(RouteName.home, arguments: {"bookingId": bookingId});
    }
  }
}

Future<void> requestNotificationPermission() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    announcement: false,
  );

  log('Notification permission status: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('Notification permission granted');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('Provisional notification permission granted');
  } else {
    log('Notification permission denied');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      initialRoute: RouteName.splash,
      getPages: RoutePages.pages,
      defaultTransition: Transition.rightToLeftWithFade,
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
      enableLog: true,
      logWriterCallback: (text, {bool isError = false}) {
        if (isError) {
          log("GetX Error: $text");
        } else {
          log("GetX Log: $text");
        }
      },
      builder: (context, child) {
        return SafeArea(top: false, bottom: true, child: child ?? const SizedBox.shrink());
      },
    );
  }
}

Future<void> loadRepositories() async {
  await Get.putAsync(() => AuthenticationRepo().init());
}
