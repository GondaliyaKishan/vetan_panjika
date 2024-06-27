import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_dashboard.dart';
import 'package:vetan_panjika/user/server_config.dart';
import 'package:vetan_panjika/user/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetan_panjika/utils/widget.dart';
import '../common/common_func.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../screens/admin_screens/admin_dashboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/color_data.dart';
import '../utils/constant.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool showLoader = false;

  // login formKey
  final _formKey = GlobalKey<FormState>();

  bool showPassword = true;
  bool validate = false;
  final FocusNode _mobileNoFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _mobileNo = "";
  String _password = "";
  String _verticalGroupValue = "Employee";

  // -- //

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  // to get user type
  getUserType() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    _verticalGroupValue = shared.getString("userType") ?? "Admin";
  }

  Future<String> _userLoginLocal(
      {required String mobileNo, required String password}) async {
    String returnMsg = "";
    LocalDB _localDB = LocalDB();
    await _localDB.getDB();

    var v = await _localDB.getDataTable(queryForDB: """select * FROM
    employee_details
    where mobile_no='$mobileNo' and password='$password'""");
    print("data============${mobileNo}");
    if (v != null) {
      if (v.isNotEmpty) {
        returnMsg = "Success";
      } else {
        returnMsg = "Invalid Credentials";
      }
    } else {
      returnMsg = "User doesn't exist";
    }
    return returnMsg;
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
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getVerticalSpace(110.h),
                        getAssetImage("OM_logo.png", 96.h, 211.h),
                        getVerticalSpace(50.h),
                        Align(
                          alignment: Alignment.topLeft,
                          child: getCustomFont(
                              "Login", 24.sp, Color(0xFF222222), 1,
                              fontWeight: FontWeight.w600),
                        ),
                        getVerticalSpace(5.h),
                        Align(
                          alignment: Alignment.topLeft,
                          child: getCustomFont("Login to get started", 14.sp,
                              Color(0xFF555555), 1,
                              fontWeight: FontWeight.w400),
                        ),
                        getVerticalSpace(25.h),
                        Align(
                          alignment: Alignment.topLeft,
                          child: getCustomFont("Email Or Phone Number", 12.sp,
                              Color(0xFF868686), 1,
                              fontWeight: FontWeight.w400),
                        ),
                        getVerticalSpace(2.h),
                        TextFormField(
                          showCursor: true,
                          textInputAction: TextInputAction.next,
                          validator: (mobileNo) {
                            if (mobileNo!.isEmpty) {
                              return 'Please enter email or phone number.';
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily,
                              fontSize: 14.sp),
                          cursorColor: Colors.blue,
                          focusNode: _mobileNoFocus,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: getAssetImage("email.png", 15.h, 21.h)),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 40.h,
                              minHeight: 40.h,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            hintText: 'Enter Email Or Phone Number',
                            hintStyle: TextStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: Constant.fontFamily,
                                fontSize: 14.sp),
                          ),
                          onSaved: (mobileNo) => _mobileNo = mobileNo!.trim(),
                          onFieldSubmitted: (_) {
                            _fieldFocusChange(
                                context, _mobileNoFocus, _passwordFocus);
                          },
                        ),
                        getVerticalSpace(16.h),
                        Align(
                          alignment: Alignment.topLeft,
                          child: getCustomFont(
                              "Password", 12.sp, Color(0xFF868686), 1,
                              fontWeight: FontWeight.w400),
                        ),
                        getVerticalSpace(2.h),
                        TextFormField(
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily,
                              fontSize: 14.sp),
                          showCursor: true,
                          focusNode: _passwordFocus,
                          obscureText: showPassword,
                          textInputAction: TextInputAction.done,
                          cursorColor: Colors.blue,
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'Invalid password';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (password) => _password = password!.trim(),
                          decoration: InputDecoration(
                            // prefixIcon: const Icon(Icons.vpn_key_outlined,
                            //     color: Colors.blueAccent),
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: getAssetImage("lock.png", 15.h, 21.h)),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 40.h,
                              minHeight: 40.h,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: showPassword
                                    ? const Icon(
                                        Icons.visibility,
                                        color: Color(0xFF868686),
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                        color: Color(0xFF868686),
                                      ),
                              ),
                            ),

                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 40.h,
                              minHeight: 40.h,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h)),
                                borderSide: BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.h)),
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: Constant.fontFamily,
                                fontSize: 14.sp),
                          ),
                        ),
                        // forgot password option

                        getVerticalSpace(16.h),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences shared =
                                  await SharedPreferences.getInstance();
                              var baseUrl = shared.getString("baseURL") ?? "";
                              if (baseUrl != "") {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword(),
                                  ),
                                );
                              } else {
                                CommonFunctions().toastMessage(
                                    "Add server configuration first");
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const ServerConfig(),
                                    )).then((value) => getUserType());
                              }
                            },
                            child: getCustomFont("Forgot Password?", 14.sp,
                                AppColors.primaryColor, 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        getVerticalSpace(33.h),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences shared =
                                await SharedPreferences.getInstance();
                            var baseUrl = shared.getString("baseURL") ?? "";
                            if (baseUrl != "") {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  showLoader = true;
                                });
                                bool _isAdmin = _verticalGroupValue == "Admin"
                                    ? true
                                    : false;
                                final apiController = ApiController();
                                if (_isAdmin) {
                                  apiController
                                      .userLogin(_mobileNo, _password)
                                      .then((value) {
                                    if (value == "Success") {
                                      setState(() {
                                        showLoader = false;
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const AdminDashboard(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        showLoader = false;
                                      });
                                      CommonFunctions().toastMessage(value);
                                    }
                                  });
                                } else {
                                  _userLoginLocal(
                                          mobileNo: _mobileNo,
                                          password: _password)
                                      .then((value) {
                                    print("loginData============${value}");
                                    if (value == "Success") {
                                      apiController
                                          .employeeLoginInfo(
                                              _mobileNo, _password)
                                          .then((value) async {
                                        if (value != "") {
                                          if (value == "Success") {
                                            shared.setString(
                                                "loginSuccess", "Success");

                                            _firebaseMessaging
                                                .subscribeToTopic(_mobileNo)
                                                .whenComplete(() => debugPrint(
                                                    "subscribed to topic"));
                                            setState(() {
                                              showLoader = false;
                                            });
                                            Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    const EmployeeDashboard(
                                                        bytes: null),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              showLoader = false;
                                            });
                                            CommonFunctions()
                                                .toastMessage(value);
                                          }
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        showLoader = false;
                                      });
                                      CommonFunctions().toastMessage(value);
                                    }
                                  });
                                }
                              }
                            } else {
                              setState(() {
                                showLoader = false;
                              });
                              CommonFunctions().toastMessage(
                                  "Add server configuration first");
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const ServerConfig(),
                                  )).then((value) => getUserType());
                            }
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
                            child: getCustomFont(
                                "Login", 16.sp, Colors.white, 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        getVerticalSpace(19.h),
                        RichText(
                            text: TextSpan(
                                text: "Don’t have an account?",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Constant.fontFamily),
                                children: [
                              TextSpan(
                                  text: " Sign UP",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Constant.fontFamily),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      SharedPreferences shared =
                                          await SharedPreferences.getInstance();
                                      var baseUrl =
                                          shared.getString("baseURL") ?? "";
                                      if (baseUrl != "") {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const SignUp(),
                                          ),
                                        );
                                      } else {
                                        CommonFunctions().toastMessage(
                                            "Add server configuration first");
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  const ServerConfig(),
                                            )).then((value) => getUserType());
                                      }
                                    })
                            ])),
                      ],
                    ),
                  ),
                  // server setting option
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ServerConfig(),
                            )).then((value) => getUserType());
                      },
                      child: SizedBox(
                        child: Image(
                            image: AssetImage("assets/settings.png"),
                            height: 30.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: showLoader,
                child: Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.white70,
                    child: const SpinKitFadingCircle(
                        color: Colors.blueAccent, size: 70))),
          ],
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
