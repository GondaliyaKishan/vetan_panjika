import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static BuildContext? myContext;

  static void initNotification(BuildContext context) async {
    myContext = context;
    var initAndroid =
        const AndroidInitializationSettings("@drawable/app_icon2");
    var initIOS = const DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);
    flutterLocalNotificationPlugin.initialize(
      initSetting,
      // onSelectNotification: (payload) async {
      //   onNotifications.add(payload);
      // },
      // onDidReceiveNotificationResponse: (payload) async {
      //   onNotifications.add(payload.payload);
      // },
      // onDidReceiveBackgroundNotificationResponse: (payload) async {
      //   onNotifications.add(payload.payload);
      // }
    );
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: myContext!,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          )
        ],
      ),
    );
  }
}
