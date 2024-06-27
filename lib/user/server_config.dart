import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import 'package:vetan_panjika/utils/widget.dart';
import '../common/common_func.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../common/database_helper.dart';
import '../controllers/api_controller.dart';
import '../main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constant.dart';

class ServerConfig extends StatefulWidget {
  const ServerConfig({Key? key}) : super(key: key);

  @override
  State<ServerConfig> createState() => _ServerConfigState();
}

class _ServerConfigState extends State<ServerConfig> {
  bool showLoader = false;

  // local settings formKey
  final _serverSetFormKey = GlobalKey<FormState>();

  // server configuration //
  final _companyIdController = TextEditingController();
  final _softwareUrlController = TextEditingController();

  String? _companyID;
  String? _softwareUrl;

  String _verticalGroupValue = "Employee";
  List<String> options = ["Admin", "Employee"];

  // -- //

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  // to get server settings
  getSettings() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String url = shared.getString("baseURL") ?? "";
    _verticalGroupValue = shared.getString("userType") ?? "Admin";
    String _companyIDStored = shared.getString("CompanyID") ?? "";
    if (url.isNotEmpty) {
      _softwareUrl = url;
      _softwareUrlController.text = _softwareUrl ?? "";
    }
    if (_companyIDStored.isNotEmpty) {
      _companyID = _companyIDStored;
      _companyIdController.text = _companyIDStored;
    }
    setState(() {});
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
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              children: [
                getVerticalSpace(110.h),
                getAssetImage("OM_logo.png", 96.h, 211.h),
                getVerticalSpace(50.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: getCustomFont(
                      "Server Settings", 24.sp, Color(0xFF222222), 1,
                      fontWeight: FontWeight.w600),
                ),
                getVerticalSpace(9.h),
                Form(
                  key: _serverSetFormKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(5.h)),
                        padding: EdgeInsets.all(6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _verticalGroupValue = "Admin";
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10.h, bottom: 10.h, left: 31.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.01),
                                      border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 1.h),
                                      borderRadius: BorderRadius.circular(5.h),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.05),
                                            offset: Offset(0, 0),
                                            blurRadius: 10.h)
                                      ]),
                                  child: Row(
                                    children: [
                                      getAssetImage(
                                          _verticalGroupValue == "Admin"
                                              ? "check_radio.png"
                                              : "uncheck.png",
                                          25.h,
                                          25.h),
                                      getHorizontalSpace(10.h),
                                      getCustomFont(
                                          "Admin", 16.sp, Colors.black, 1,
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            getHorizontalSpace(14.h),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _verticalGroupValue = "Employee";
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10.h, bottom: 10.h, left: 31.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.01),
                                      border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 1.h),
                                      borderRadius: BorderRadius.circular(5.h),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.05),
                                            offset: Offset(0, 0),
                                            blurRadius: 10.h)
                                      ]),
                                  child: Row(
                                    children: [
                                      getAssetImage(
                                          _verticalGroupValue == "Employee"
                                              ? "check_radio.png"
                                              : "uncheck.png",
                                          25.h,
                                          25.h),
                                      getHorizontalSpace(10.h),
                                      getCustomFont(
                                          "Employee", 16.sp, Colors.black, 1,
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       height: 60,
                      //       width: size.width - 95,
                      //       child: RadioGroup<String>.builder(
                      //         direction: Axis.horizontal,
                      //         groupValue: _verticalGroupValue,
                      //         activeColor: Colors.blueAccent,
                      //         horizontalAlignment:
                      //             MainAxisAlignment.spaceAround,
                      //         onChanged: (value) => setState(() {
                      //           _verticalGroupValue = value!;
                      //         }),
                      //         items: options,
                      //         textStyle: const TextStyle(
                      //             fontSize: 15, color: Colors.black),
                      //         itemBuilder: (item) => RadioButtonBuilder(
                      //           item,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // companyID
                      getVerticalSpace(19.h),
                      Align(
                        alignment: Alignment.topLeft,
                        child: getCustomFont(
                            "Name", 12.sp, Color(0xFF868686), 1,
                            fontWeight: FontWeight.w400),
                      ),
                      getVerticalSpace(2.h),
                      TextFormField(
                        controller: _companyIdController,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.blue,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'Please Enter Company ID';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.fontFamily,
                            fontSize: 14.sp),
                        onSaved: (companyID) => _companyID = companyID!.trim(),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  left: 20.h,
                                  top: 12.h,
                                  bottom: 12.h,
                                  right: 11.h),
                              child:
                                  getAssetImage("grey_user.png", 15.h, 11.h)),
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
                          hintText: 'Enter Company Id',
                          hintStyle: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily,
                              fontSize: 14.sp),
                        ),
                      ),
                      getVerticalSpace(16.h),
                      TextFormField(
                        controller: _softwareUrlController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        cursorColor: Colors.blue,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Software Url can't be empty";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.fontFamily,
                            fontSize: 14.sp),
                        onSaved: (ipAddress) =>
                            _softwareUrl = ipAddress!.trim(),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  left: 17.h,
                                  top: 12.h,
                                  bottom: 12.h,
                                  right: 11.h),
                              child: getAssetImage("url.png", 15.h, 15.h)),
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
                          hintText: 'Enter Software Url',
                          hintStyle: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily,
                              fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                getVerticalSpace(40.h),
                GestureDetector(
                  onTap: () async {
                    if (_verticalGroupValue == "Admin") {
                      SharedPreferences shared =
                          await SharedPreferences.getInstance();
                      if (_serverSetFormKey.currentState!.validate()) {
                        _serverSetFormKey.currentState!.save();
                        setState(() {
                          showLoader = true;
                        });
                        String baseURL = _softwareUrl!;
                        final apiController = ApiController();
                        apiController
                            .checkServerConfig(
                                baseUrl: baseURL, companyId: _companyID!)
                            .then((value) {
                          if (value == "Success") {
                            shared.setString("CompanyID", _companyID!);
                            shared.setString("userType", _verticalGroupValue);
                            shared.setString("baseURL", baseURL);
                            setState(() {
                              showLoader = false;
                            });
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              showLoader = false;
                            });
                            CommonFunctions().toastMessage(value);
                          }
                        });
                      }
                    }
                    if (_verticalGroupValue != "Admin") {
                      SharedPreferences shared =
                          await SharedPreferences.getInstance();
                      if (_serverSetFormKey.currentState!.validate()) {
                        _serverSetFormKey.currentState!.save();
                        setState(() {
                          showLoader = true;
                        });
                        String baseURL = _softwareUrl!;
                        final apiController = ApiController();
                        apiController
                            .checkServerConfig(
                                baseUrl: baseURL, companyId: _companyID!)
                            .then((value) async {
                          if (value == "Success") {
                            LocalDB localDB = LocalDB();
                            await localDB.getDB();
                            await localDB.updateTable(
                                queryForDB:
                                    "update background_data set companyId='$_companyID', baseUrl='$baseURL', userType='$_verticalGroupValue'");
                            shared.setString("CompanyID", _companyID!);
                            shared.setString("userType", _verticalGroupValue);
                            shared.setString("baseURL", baseURL);
                            setState(() {
                              showLoader = false;
                            });
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              showLoader = false;
                            });
                            CommonFunctions().toastMessage(value);
                          }
                        });
                      }
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
                    child: getCustomFont("Submit", 16.sp, Colors.white, 1,
                        fontWeight: FontWeight.w500),
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
    );
  }

  // ip address validation
  String? validateIpAddress(String? value) {
    String pattern = r'\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "IP Address is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid IP Address";
    } else {
      return null;
    }
  }

  // port validation
  String? validatePort(String? value) {
    String pattern =
        r'^((6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9]{2})|(6[0-4][0-9]{3})|([1-5][0-9]{4})|([0-5]{0,5})|([0-9]{1,4}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Port is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Port";
    } else {
      return null;
    }
  }
}
