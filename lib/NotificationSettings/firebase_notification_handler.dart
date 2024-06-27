import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'notificaiton_handler.dart';

class FirebaseNotifications {
  late FirebaseMessaging _messaging;
  late BuildContext myContext;

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessagingListener(context);
    _createNotificationChannelGroup();
    myContext = context;
  }

  void firebaseCloudMessagingListener(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint("Settings: ${settings.authorizationStatus}");

    // we will use token to receive notification
    _messaging.getToken().then((token) => debugPrint("MyToken: $token"));
    // Handle message
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      debugPrint("Receive $remoteMessage");
      if (remoteMessage.data["category"] == "emp_notify") {
        // String iconName = ((remoteMessage.data["device_name"]).toString());
        // String largeIconName = iconName.split(".")[0];
        String payload = (remoteMessage.data["page_title"] +
                "||" +
                remoteMessage.data["notify_type"])
            .toString();
        if (Platform.isAndroid) {
          showNotification(
              remoteMessage.data["title"],
              remoteMessage.data["body"],
              remoteMessage.data["category"],
              // (remoteMessage.data["large_icon"]).toString(),
              // largeIconName,
              payload);
        } else if (Platform.isIOS) {
          showNotification(
              remoteMessage.data["title"],
              remoteMessage.data["body"],
              remoteMessage.data["category"],
              // (remoteMessage.data["large_icon"]).toString(),
              // largeIconName,
              payload);
        }
      } else if (remoteMessage.data["category"] == "promotions") {
        String iconName = ((remoteMessage.data["event_name"]).toString());
        String bigPictureName = iconName.split(".")[0];
        if (Platform.isAndroid) {
          showPromotions(
              remoteMessage.data["title"],
              remoteMessage.data["body"],
              remoteMessage.data["category"],
              (remoteMessage.data["big_picture"]).toString(),
              bigPictureName);
        } else if (Platform.isIOS) {
          showPromotions(
              remoteMessage.data["title"],
              remoteMessage.data["body"],
              remoteMessage.data["category"],
              (remoteMessage.data["big_picture"]).toString(),
              bigPictureName);
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      debugPrint("Receive open app: $remoteMessage");
      if (Platform.isIOS) {
        showDialog(
          context: myContext,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              (remoteMessage.data["title"]).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text((remoteMessage.data["body"]).toString()),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("Ok"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              )
            ],
          ),
        );
      } else if (Platform.isAndroid) {
        String pageTitle = remoteMessage.data["page_title"];
        String notify = remoteMessage.data["notify_type"];
        debugPrint("title: $pageTitle, notifyType: $notify");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         NotificationPage(title: pageTitle, notifyType: notify),
        //   ),
        // );
      }
    });
  }

  // add parameters to show large icon in notification
  // largeIcon, largeIconName,
  void showNotification(
      title, body, category, payload) async {
    var bigText = const BigTextStyleInformation("",
        summaryText: '', htmlFormatBigText: true, htmlFormatSummaryText: true);

    // final String bigIcon = await _downloadAndSaveFile(largeIcon, largeIconName);

    final String channelId = (category == "emp_notify"
        ? "emp_notify"
        : category == "promotions"
            ? "promotions"
            : "subscription");
    final String channelName = (category == "emp_notify"
        ? "Device Status"
        : category == "promotions"
            ? "Promotions"
            : "Subscription Notifications");
    final String channelDescription = (category == "emp_notify"
        ? "Shows Notifications for Devices Status"
        : category == "promotions"
            ? "Promotional Notifications"
            : "Subscription Related Notifications");

    var androidChannel = AndroidNotificationDetails(
      channelId,
      channelName,
      // channelDescription,
      playSound: true,
      showWhen: true,
      importance: Importance.max,
      channelShowBadge: true,
      groupAlertBehavior: GroupAlertBehavior.all,
      setAsGroupSummary: false,
      color: Colors.blue,
      // largeIcon: FilePathAndroidBitmap(bigIcon),
      styleInformation: bigText,
      priority: Priority.high,
    );
    var ios = const DarwinNotificationDetails();

    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin
        .show(Random().nextInt(1000), title, body, platform, payload: payload);
  }

  void showPromotions(title, body, category, bigPicture, eventName) async {
    final String bigIcon = await _downloadAndSaveFile(bigPicture, eventName);

    var bigText = BigPictureStyleInformation(FilePathAndroidBitmap(bigIcon));

    final String channelId = (category == "emp_notify"
        ? "emp_notify"
        : category == "promotions"
            ? "promotions"
            : "subscription");
    final String channelName = (category == "emp_notify"
        ? "Device Status"
        : category == "promotions"
            ? "Promotions"
            : "Subscription Notifications");
    final String channelDescription = (category == "emp_notify"
        ? "Shows Notifications for Devices Status"
        : category == "promotions"
            ? "Promotional Notifications"
            : "Subscription Related Notifications");

    var androidChannel = AndroidNotificationDetails(
      channelId,
      channelName,
      // channelDescription,
      playSound: true,
      showWhen: true,
      importance: Importance.max,
      channelShowBadge: true,
      groupAlertBehavior: GroupAlertBehavior.all,
      setAsGroupSummary: false,
      color: Colors.blue,
      largeIcon: FilePathAndroidBitmap(bigIcon),
      styleInformation: bigText,
      priority: Priority.high,
    );
    var ios = const DarwinNotificationDetails();

    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin
        .show(Random().nextInt(1000), title, body, platform, payload: "||");
  }
}

void _createNotificationChannelGroup() async {
  const String channelGroupId = 'Group Notification';
  // create the group first
  const AndroidNotificationChannelGroup androidNotificationChannelGroup =
      AndroidNotificationChannelGroup(
          channelGroupId, 'Office Manager Group Notifications',
          description: 'Office Manager Group Description');
  await NotificationHandler.flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannelGroup(androidNotificationChannelGroup);

  // create channels associated with the group
  // Device Notification Channel
  await NotificationHandler.flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(const AndroidNotificationChannel(
          'emp_notify',
          'Employee Notification',
          // 'Shows Notifications for Employee Attendance',
          groupId: channelGroupId,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true));

  // Offer & Promotions Channel
  await NotificationHandler.flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(const AndroidNotificationChannel(
          'promotions', 'Promotions',
      // 'Promotional Notifications',
          groupId: channelGroupId,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true));
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory? directory = await getExternalStorageDirectory();
  final String filePath = '${directory?.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}
