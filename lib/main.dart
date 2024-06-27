import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:vetan_panjika/splash_screen.dart';
import 'package:vetan_panjika/theme.dart';
import 'NotificationSettings/firebase_notification_handler.dart';
import 'controllers/background_controller.dart';
import 'controllers/location_controller.dart';
import 'controllers/url_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

AppThemeData theme = AppThemeData();
LocationController locationController = LocationController();
UrlController urlController = UrlController();
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundController().initializeService();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  theme.init();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
      Permission.activityRecognition,
    ].request();

    if (statuses[Permission.location]!.isGranted &&
        statuses[Permission.locationAlways]!.isGranted &&
        statuses[Permission.activityRecognition]!.isGranted) {
      print('All necessary permissions granted');
    } else {
      if (statuses[Permission.location]?.isPermanentlyDenied ??
          false ||
              statuses[Permission.locationAlways]!.isPermanentlyDenied ||
              statuses[Permission.activityRecognition]!.isPermanentlyDenied) {
        print(
            'One or more permissions permanently denied. Opening app settings.');
        openAppSettings();
      } else {
        print(
            'One or more permissions denied. Please grant permissions to continue.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _portraitModeOnly();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
      // requestPermissions();
    });
  }

  // lock app orientation to portrait mode only
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var _theme = ThemeData(
      fontFamily: 'Poppins',
      primarySwatch: theme.primarySwatch,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue, // button text color
        ),
      ),
    );

    if (theme.darkMode) {
      _theme = ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        unselectedWidgetColor: Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Office Manager',
      theme: _theme,
      home: const SplashScreen(),
    );
  }
}

// firebase background handler function for notifications
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("handle background service $message");
  dynamic data = message.data;
  // add parameters to show large icon in notifications
  // data["large_icon"], data["device_name"],
  if (data["category"] == "emp_notify") {
    String payload = data["page_title"] + "||" + data["notify_type"];
    FirebaseNotifications().showNotification(
        data["title"], data["body"], data["category"], payload);
  } else if (data["category"] == "promotions") {
    FirebaseNotifications().showPromotions(data["title"], data["body"],
        data["category"], data["big_picture"], data["event_name"]);
  }
}
