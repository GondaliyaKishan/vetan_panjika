import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/user/reset_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import '../utils/constant.dart';
import '../utils/widget.dart';

// ignore: must_be_immutable
class OTPVerify extends StatefulWidget {
  final String mobileNo;
  final String otpType;
  String id;
  final Map<String, String> userInfo;
  String fcmTopic;

  OTPVerify(
      {Key? key,
      required this.mobileNo,
      required this.otpType,
      required this.id,
      required this.userInfo,
      required this.fcmTopic})
      : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify>
    with SingleTickerProviderStateMixin {
  late List<TextEditingController?> controls;
  bool clearText = false;

  final int time = 180;
  late AnimationController _controller;
  late final AnimationController controller;
  late Timer timer;
  late int totalTimeInSeconds;
  late bool _hideResendButton;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration!;
    return duration;
  }

  Future<void> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final LocalDB _localDB = LocalDB();

  // insert employee details to localDB
  Future<String> insertToLocalDB(
      mobileNo, firstName, lastName, password) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var userType = shared.getString("userType") ?? "";
    var companyId = shared.getString("CompanyID") ?? "";
    var baseUrl = shared.getString("baseURL") ?? "";
    String returnString = "";
    await _localDB.getDB();
    var v = await _localDB.getDataTable(
        queryForDB:
            "select * from employee_details where mobile_no='$mobileNo'");
    if (v.isEmpty) {
      var h =
          await _localDB.emptyTable(queryForDB: "delete from employee_details");
      debugPrint(h);
      var v =
          await _localDB.insertToDB(queryForDB: """insert into employee_details
      (mobile_no, first_name, last_name, password)
      values ('$mobileNo', '$firstName', '$lastName', '$password')""");
      returnString = "SignUP Successful";
      debugPrint(v.toString());
      await _localDB.getDB();
      var t =
          await _localDB.emptyTable(queryForDB: "delete from background_data");
      debugPrint(t);
      var k = await _localDB.insertToDB(queryForDB: """
      insert into background_data
      (userType, companyId, baseUrl, userMobile)
      values ('$userType', '$companyId', '$baseUrl', '${widget.mobileNo}')
      """);
      debugPrint(k);
    } else if (v.isNotEmpty) {
      returnString = "User Already Registered";
    }
    return returnString;
  }

  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness:
          Brightness.dark, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [
            getVerticalSpace(110.h),
            getAssetImage("OM_logo.png", 96.h, 211.h),
            getVerticalSpace(50.h),
            Align(
              alignment: Alignment.topLeft,
              child: getCustomFont(
                  "Verification Code", 24.sp, Color(0xFF222222), 1,
                  fontWeight: FontWeight.w600),
            ),
            getVerticalSpace(5.h),
            Align(
              alignment: Alignment.topLeft,
              child: getMultiLineFont(
                  "We texted you a code Please enter it below",
                  14.sp,
                  Color(0xFF555555),
                  fontWeight: FontWeight.w400),
            ),
            getVerticalSpace(25.h),

            // SizedBox(
            //   height: 32,
            //   child: Offstage(
            //     offstage: !_hideResendButton,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         const Icon(Icons.access_time),
            //         const SizedBox(width: 5.0),
            //         OtpTimer(_controller, 15.0)
            //       ],
            //     ),
            //   ),
            // ),
            // const Spacer(flex: 1),
            OtpTextField(
              numberOfFields: 5,
              fieldHeight: 57.h,
              fieldWidth: 57.h,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              showCursor: true,
              borderRadius: BorderRadius.circular(12.h),
              autoFocus: true,
              cursorColor: AppColors.primaryColor,
              borderColor: AppColors.primaryColor,
              disabledBorderColor: Color(0xFFEDEDED),
              enabledBorderColor: AppColors.primaryColor,
              focusedBorderColor: AppColors.primaryColor,
              clearText: clearText,
              showFieldAsBox: true,
              textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF545454),
                  fontSize: 18.sp,
                  fontFamily: Constant.fontFamily),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onCodeChanged: (String value) {
                debugPrint(value);
              },
              handleControllers: (controllers) {
                //get all textFields controller, if needed
                controls = controllers;
              },
              onSubmit: (String otpValue) {}, // end onSubmit
            ),
            getVerticalSpace(25.h),

            RichText(
                text: TextSpan(
                    text: "If you didn’t receive a code,",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w500,
                        fontFamily: Constant.fontFamily),
                    children: [
                  TextSpan(
                      text: " Resend",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: Constant.fontFamily),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final apiController = ApiController();
                          apiController
                              .sendOtp(mobileNo: widget.mobileNo)
                              .then((value) {
                            String status = value.split("|||||")[0];
                            if (status == "Success") {
                              String id = value.split("|||||")[1];
                              setState(() {
                                widget.id = id;
                              });
                            }
                          });
                        })
                ])),
            getVerticalSpace(102.h),
            GestureDetector(
              onTap: () {

                List<String> list = [];
                controls.forEach(
                  (element) {
                    list.add(element!.text);
                  },
                );
                String otpString = list.join();

                //set clear text to clear text from all fields
                setState(() {
                  clearText = true;
                });
                // navigate to different screen code goes here
                final apiController = ApiController();
                apiController
                    .verifyOtp(otpValue: otpString, id: widget.id)
                    .then((value) {
                  if (value == "OTP Verified") {
                    if (widget.otpType == "signUp") {
                      String firstName =
                          widget.userInfo["firstName"].toString();
                      String lastName = widget.userInfo["lastName"].toString();
                      String password = widget.userInfo["password"].toString();
                      insertToLocalDB(
                              widget.mobileNo, firstName, lastName, password)
                          .then((value) {
                        if (value == "SignUP Successful") {
                          _firebaseMessaging
                              .subscribeToTopic(widget.fcmTopic)
                              .whenComplete(() {
                            debugPrint("Subscribed to Topic");
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      });
                    } else {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ResetPassword(
                            mobileNo: widget.mobileNo,
                          ),
                        ),
                      );
                    }
                  } else {
                    CommonFunctions().toastMessage(value);
                  }
                });
              },
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5.h),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFF3197FF).withOpacity(0.5),
                          offset: Offset(0, 0),
                          blurRadius: 10)
                    ]),
                child: getCustomFont("Send", 16.sp, Colors.white, 1,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.height = 60,
    this.elevation = 1,
    this.color = Colors.cyan,
    this.textStyle,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final double height;
  final double elevation;
  final String title;
  final Color color;

  // final BorderSide borderSide;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: MaterialButton(
        onPressed: onPressed,
        elevation: elevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        height: height,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  final double fontSize;
  final Color timeColor = Colors.black;

  const OtpTimer(this.controller, this.fontSize, {Key? key}) : super(key: key);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration!;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Text(
          timerString,
          style: TextStyle(
              fontSize: fontSize,
              color: timeColor,
              fontWeight: FontWeight.w600),
        );
      },
    );
  }
}
