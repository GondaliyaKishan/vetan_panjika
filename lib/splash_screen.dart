import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import 'package:vetan_panjika/utils/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetan_panjika/utils/widget.dart';
import 'controllers/api_controller.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // subscribe to promotional notifications function
  void subscribeToPromotions() {
    _firebaseMessaging
        .subscribeToTopic("promotions")
        .whenComplete(() => debugPrint("Subscribed to Promotions"));
  }

  // final _geofenceService = GeofenceService.instance.setup(
  //     interval: 5000,
  //     accuracy: 100,
  //     loiteringDelayMs: 60000,
  //     statusChangeDelayMs: 10000,
  //     useActivityRecognition: true,
  //     allowMockLocations: false,
  //     printDevLog: false,
  //     geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  // void startGeofenceService() {
  //   List<Geofence> geofenceList = [
  //     Geofence(
  //       id: 'place_1',
  //       latitude: 21.234454109175804,
  //       longitude: 72.9062554312807,
  //       radius: [
  //         GeofenceRadius(id: 'radius_100m', length: 100),
  //       ],
  //     ),
  //   ];
  //
  //   _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
  //   _geofenceService.addLocationChangeListener(_onLocationChanged);
  //   _geofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
  //   _geofenceService.addActivityChangeListener(_onActivityChanged);
  //   _geofenceService.addStreamErrorListener(_onError);
  //
  //   _geofenceService.start(geofenceList).catchError(_onError);
  // }

//   Future<void> _onGeofenceStatusChanged(
//       Geofence geofence,
//       GeofenceRadius geofenceRadius,
//       GeofenceStatus geofenceStatus,
//       Location location) async {
//     print('geofence: ${geofence.toJson()}');
//     print('geofenceRadius: ${geofenceRadius.toJson()}');
//     print('geofenceStatus: ${geofenceStatus.toString()}');
//     Fluttertoast.showToast(
//         msg: geofenceStatus.toString(), toastLength: Toast.LENGTH_LONG);
//     // _geofenceStreamController.sink.add(geofence);
//   }
//
// // This function is to be called when the activity has changed.
//   void _onActivityChanged(Activity prevActivity, Activity currActivity) {
//     print('prevActivity: ${prevActivity.toJson()}');
//     print('currActivity: ${currActivity.toJson()}');
//     // Fluttertoast.showToast(
//     //     msg: currActivity.toJson().toString(), toastLength: Toast.LENGTH_LONG);
//     // _activityStreamController.sink.add(currActivity);
//   }
//
// // This function is to be called when the location has changed.
//   void _onLocationChanged(Location location) {
//     // print('location: ${location.toJson()}');
//     // Fluttertoast.showToast(
//     //     msg: location.toJson().toString(), toastLength: Toast.LENGTH_LONG);
//   }
//
// // This function is to be called when a location services status change occurs
// // since the service was started.
//   void _onLocationServicesStatusChanged(bool status) {
//     print('isLocationServicesEnabled: $status');
//   }
//
// // This function is used to handle errors that occur in the service.
//   void _onError(error) {
//     final errorCode = getErrorCodesFromError(error);
//     if (errorCode == null) {
//       print('Undefined error: $error');
//       return;
//     }
//
//     print('ErrorCode: $errorCode');
//   }

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // startGeofenceService();
    subscribeToPromotions();
    Future.delayed(
      Duration(seconds: 3),
      () {
        nextScreen();
      },
    );
  }

  nextScreen() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var apiController = ApiController();

    accessToken == ""
        ? apiController.autoLogin().then((value) => Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => value),
            ))
        : apiController.adminAutoLogin().then((value) => Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => value),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness:
          Brightness.dark, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    // return AnimatedSplashScreen.withScreenFunction(
    //   splash: 'assets/OM_logo.png',
    //   curve: Curves.easeIn,
    //   centered: true,
    //   splashIconSize: size.width * 0.25,
    //   duration: 3000,
    //   screenFunction: () async {
    //
    //     SharedPreferences shared = await SharedPreferences.getInstance();
    //     String accessToken = shared.getString("access_token") ?? "";
    //     var apiController = ApiController();
    //
    //     return accessToken == ""
    //         ? apiController.autoLogin().then((value) => value)
    //         : apiController.adminAutoLogin().then((value) => value);
    //   },
    //   backgroundColor: Colors.white,
    //   splashTransition: SplashTransition.fadeTransition,
    //   pageTransitionType: PageTransitionType.fade,
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.fill)),
        child: getAssetImage("OM_logo.png", 96.h, 211.h),
      ),
    );
  }
}
