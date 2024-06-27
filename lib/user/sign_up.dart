import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import '../main.dart';
import '../utils/color_data.dart';
import '../utils/constant.dart';
import '../utils/widget.dart';
import 'otp_verify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showLoader = false;

  // login formKey
  final _formKey = GlobalKey<FormState>();

  bool showPassword = true;
  bool validate = false;
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _mobileNoFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _firstName = "";
  String _lastName = "";
  String _mobileNo = "";
  String _password = "";

  Future<String> checkUserInLocalDB(mobileNo) async {
    String returnMsg = "";
    LocalDB _localDB = LocalDB();
    await _localDB.getDB();
    var v = await _localDB.getDataTable(
        queryForDB:
            "select * from employee_details where mobile_no='$mobileNo'");
    if (v.isEmpty) {
      returnMsg = "User doesn't exist";
    } else if (v.isNotEmpty) {
      returnMsg = "User Already Registered";
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
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  getVerticalSpace(110.h),
                  getAssetImage("OM_logo.png", 96.h, 211.h),
                  getVerticalSpace(50.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: getCustomFont(
                        "Create Account", 24.sp, Color(0xFF222222), 1,
                        fontWeight: FontWeight.w600),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: getCustomFont(
                        "Sign up to get started", 14.sp, Color(0xFF555555), 1,
                        fontWeight: FontWeight.w400),
                  ),
                  getVerticalSpace(25.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: getCustomFont(
                        "First Name", 12.sp, Color(0xFF868686), 1,
                        fontWeight: FontWeight.w400),
                  ),
                  getVerticalSpace(2.h),
                  TextFormField(
                    showCursor: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constant.fontFamily,
                        fontSize: 14.sp),
                    validator: (mobileNo) {
                      if (mobileNo!.isEmpty) {
                        return 'Please enter First Name';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    ],
                    cursorColor: Colors.blue,
                    focusNode: _firstNameFocus,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: 20.h, top: 12.h, bottom: 12.h, right: 11.h),
                          child: getAssetImage("grey_user.png", 15.h, 11.h)),
                      prefixIconConstraints: BoxConstraints(
                        maxHeight: 40.h,
                        minHeight: 40.h,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      hintText: 'Enter First Name',
                      hintStyle: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: Constant.fontFamily,
                          fontSize: 14.sp),
                    ),
                    onSaved: (firstName) => _firstName = firstName!.trim(),
                    onFieldSubmitted: (_) {
                      _fieldFocusChange(
                          context, _firstNameFocus, _lastNameFocus);
                    },
                  ),
                  getVerticalSpace(16.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: getCustomFont(
                        "Last Name", 12.sp, Color(0xFF868686), 1,
                        fontWeight: FontWeight.w400),
                  ),
                  getVerticalSpace(2.h),
                  TextFormField(
                    showCursor: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (mobileNo) {
                      if (mobileNo!.isEmpty) {
                        return 'Please enter Last Name';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    ],
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constant.fontFamily,
                        fontSize: 14.sp),
                    cursorColor: Colors.blue,
                    focusNode: _lastNameFocus,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: 20.h, top: 12.h, bottom: 12.h, right: 11.h),
                          child: getAssetImage("grey_user.png", 15.h, 11.h)),
                      prefixIconConstraints: BoxConstraints(
                        maxHeight: 40.h,
                        minHeight: 40.h,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      hintText: 'Enter Last Name',
                      hintStyle: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: Constant.fontFamily,
                          fontSize: 14.sp),
                    ),
                    onSaved: (lastName) => _lastName = lastName!.trim(),
                    onFieldSubmitted: (_) {
                      _fieldFocusChange(
                          context, _lastNameFocus, _mobileNoFocus);
                    },
                  ),
                  getVerticalSpace(16.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: getCustomFont("Phone", 12.sp, Color(0xFF868686), 1,
                        fontWeight: FontWeight.w400),
                  ),
                  getVerticalSpace(2.h),
                  TextFormField(
                    showCursor: true,
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constant.fontFamily,
                        fontSize: 14.sp),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    validator: (mobileNo) {
                      if (mobileNo!.isEmpty) {
                        return 'Please enter Mobile No';
                      } else if (mobileNo.length < 10) {
                        return 'Please enter valid Mobile No';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    cursorColor: Colors.blue,
                    focusNode: _mobileNoFocus,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(12.h),
                          child: Icon(Icons.phone_android,
                              color: Color(0xFF868686))),
                      prefixIconConstraints: BoxConstraints(
                        maxHeight: 40.h,
                        minHeight: 40.h,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      hintText: 'Enter Mobile No',
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
                    showCursor: true,
                    focusNode: _passwordFocus,
                    obscureText: showPassword,
                    textInputAction: TextInputAction.done,
                    cursorColor: Colors.blue,
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constant.fontFamily,
                        fontSize: 14.sp),
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Invalid password';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    onSaved: (password) => _password = password!.trim(),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(12.h),
                          child: getAssetImage("lock.png", 15.h, 21.h)),
                      prefixIconConstraints: BoxConstraints(
                        maxHeight: 40.h,
                        minHeight: 40.h,
                      ),
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
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.h)),
                          borderSide:
                              BorderSide(color: Color(0xFFEDEDED), width: 1.h)),
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: Constant.fontFamily,
                          fontSize: 14.sp),
                    ),
                  ),
                  getVerticalSpace(40.h),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          showLoader = true;
                        });
                        checkUserInLocalDB(_mobileNo).then((value) {
                          if (value != "User Already Registered") {
                            final apiController = ApiController();
                            apiController
                                .sendOtp(mobileNo: _mobileNo)
                                .then((value) {
                              String status = value.split("|||||")[0];
                              if (status == "Success") {
                                String userId = value.split("|||||")[1];
                                String fcmTopic = _mobileNo;
                                setState(() {
                                  showLoader = false;
                                });
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => OTPVerify(
                                      mobileNo: _mobileNo,
                                      otpType: "signUp",
                                      id: userId,
                                      userInfo: {
                                        "firstName": _firstName,
                                        "lastName": _lastName,
                                        "password": _password,
                                      },
                                      fcmTopic: fcmTopic,
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  showLoader = false;
                                });
                                CommonFunctions().toastMessage(status);
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
                          "Create Account", 16.sp, Colors.white, 1,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  getVerticalSpace(20.h),
                  RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily),
                          children: [
                        TextSpan(
                            text: "Login",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: Constant.fontFamily),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                Navigator.pop(context);
                              })
                      ])),
                ],
              ),
            ),
          ),
          Visibility(
              visible: showLoader,
              child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.white70,
                  child:
                      const SpinKitFadingCircle(color: Colors.cyan, size: 70))),
        ],
      ),
    );
  }

  // field focus change function
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
