import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class BackgroundController {
  final LocalDB _localDB = LocalDB();
  static final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<String> sendAttendanceToServer() async {
    String returnString = "";
    await _localDB.getDB();
    List data = [];
    data = await _localDB.getDataTable(queryForDB: "select * from background_data");
    if (data.isNotEmpty) {
      String userType = data[0]["userType"];
      String companyId = data[0]["companyId"];
      String baseURL = data[0]["baseUrl"];
      String userMobile = data[0]["userMobile"];
      if (userType != "Admin") {
        bool connectivity = false;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            connectivity = true;
          }
        } on SocketException catch (_) {
          connectivity = false;
        }
        if (connectivity) {
          try {
            await _localDB.getDB();
            List offlineData = [];
            offlineData = await _localDB.getDataTable(
                queryForDB: "select * FROM attendance_logs");
            if (offlineData.isNotEmpty) {
              for (int i = 0; i < offlineData.length; i++) {
                var loginUrl = baseURL + urlController.syncAttendanceUrl;
                const headers = {'Content-Type': 'application/json'};
                var loginResponse = await http
                    .post(
                  Uri.parse(loginUrl),
                  headers: headers,
                  body: json.encode({
                    "AppCode": urlController.appCode,
                    "CompanyCode": companyId,
                    "MobileNo": userMobile,
                    "Log_picture": offlineData[i]["img_string"],
                    "Longitude": offlineData[i]["longitude"],
                    "Latitude": offlineData[i]["latitude"],
                    "GLocation": "",
                    "LogDateTime": offlineData[i]["date_time"]
                  }),
                )
                    .timeout(const Duration(seconds: 15));

                var responseJson = json.decode(loginResponse.body);
                if (responseJson["Status"] == "Success" ||
                    responseJson["Status"] == "Log Already Exists") {
                  await _localDB.getDB();
                  var value = await _localDB.emptyTable(
                      queryForDB:
                      "delete FROM attendance_logs where id=${offlineData[i]["id"]}");
                  returnString = "Success";
                } else {
                  returnString = responseJson["Status"].toString();
                }
              }
              return returnString;
            } else {
              returnString = "No Data";
              return returnString;
            }
          } catch (e) {
            returnString = "Server Unreachable";
            debugPrint(e.toString());
            return returnString;
          }
        } else {
          returnString = "No Connection";
          return returnString;
        }
      } else {
        return returnString;
      }
    } else {
      return returnString;
    }
  }

  Future<void> initializeService() async {
    // Background Notification Channel
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(
        const AndroidNotificationChannel(
        "background_service", "BackgroundService",
        importance: Importance.low,
        playSound: false,
        enableVibration: false
    ));

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: "background_service", // this must match with notification channel you created above.
        initialNotificationTitle: 'Background Service',
        initialNotificationContent: 'Background Service Running...',
        foregroundServiceNotificationId: 889,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();

    return true;
  }
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      }, onError: (e, s) {
        debugPrint(e.toString()+s.toString());
      }, onDone: () => debugPrint("foreground listen closed"));
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      }, onError: (e, s) {
        debugPrint(e.toString()+s.toString());
      }, onDone: () => debugPrint("background listen closed"));
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          BackgroundController().sendAttendanceToServer();
          service.invoke("update");
        }
      }
    });
  }
}
