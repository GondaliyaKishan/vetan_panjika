import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/employee_models/employee_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetan_panjika/screens/employee_screens/address_screen.dart';
import 'package:vetan_panjika/screens/employee_screens/bank_detail_screen.dart';
import 'package:vetan_panjika/screens/employee_screens/my_profile_screen.dart';
import '../../common/common_func.dart';
import '../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'employee_dashboard.dart';

class EmpPersonalInfo extends StatefulWidget {
  const EmpPersonalInfo({Key? key}) : super(key: key);

  @override
  _EmpPersonalInfoState createState() => _EmpPersonalInfoState();
}

class _EmpPersonalInfoState extends State<EmpPersonalInfo> {
  bool showLoader = true;
  String noDataMsg = "";

  List<EmployeeDetailsModel> employeeData = [];

  getEmpInfo() {
    var apiController = ApiController();
    apiController.getEmployeeInfo().then((value) {
      if (value != null) {
        employeeData = [];
        for (var info in value.data) {
          employeeData.add(info);
        }
      }
      if (employeeData.isEmpty) {
        noDataMsg = "No Branches to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getEmpInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness:
          Brightness.light, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 74.h, bottom: 28.h, left: 20.h, right: 20.h),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32.h))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      getAssetImage("back.png", 14.h, 10.h),
                      getHorizontalSpace(9.h),
                      getCustomFont("Back", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                getAssetImage("white_edit.png", 20.h, 20.h)
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.cyan,
                  onRefresh: () async {
                    setState(() {
                      showLoader = true;
                    });
                    Future.delayed(const Duration(seconds: 3));
                    getEmpInfo();
                  },
                  child: employeeData.isEmpty ? Container() : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      getVerticalSpace(39.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.h),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 1.h),
                                  borderRadius: BorderRadius.circular(110 / 2)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(110 / 2),
                                child: employeeData.isNotEmpty
                                    ? (employeeData[0].profileImg == ""
                                        ? Image.asset(
                                            "assets/CS_userimg.png",
                                            fit: BoxFit.cover,
                                          )
                                        : employeeData[0]
                                                .profileImg
                                                .contains(".")
                                            ? FadeInImage.assetNetwork(
                                                image:
                                                    employeeData[0].profileImg,
                                                placeholder:
                                                    "assets/CS_userimg.png",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.memory(
                                                base64Decode(
                                                    employeeData[0].profileImg),
                                                fit: BoxFit.cover,
                                              ))
                                    : Image.asset(
                                        "assets/CS_userimg.png",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              height: 110.h,
                              width: 110.h,
                            ),
                            getHorizontalSpace(23.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getCustomFont(employeeData[0].name, 24.sp,
                                    AppColors.blackColor, 1,
                                    fontWeight: FontWeight.w600),
                                getVerticalSpace(1.h),
                                getCustomFont(employeeData[0].designation,
                                    14.sp, Color(0xFF868686), 1,
                                    fontWeight: FontWeight.w500)
                              ],
                            )
                          ],
                        ),
                      ),
                      getVerticalSpace(24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.h),
                        child: Row(
                          children: [
                            getAssetImage("phone.png", 20.h, 20.h),
                            getHorizontalSpace(8.h),
                            getCustomFont(employeeData[0].mobileNo, 14.sp,
                                Color(0xFF868686), 1,
                                fontWeight: FontWeight.w500)
                          ],
                        ),
                      ),
                      getVerticalSpace(12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.h),
                        child: Row(
                          children: [
                            getAssetImage("mail.png", 14.h, 20.h),
                            getHorizontalSpace(8.h),
                            getCustomFont(employeeData[0].email, 14.sp,
                                Color(0xFF868686), 1,
                                fontWeight: FontWeight.w500)
                          ],
                        ),
                      ),
                      getVerticalSpace(30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              height: 0,
                              color: Color(0xFFE3E3E3),
                              thickness: 1,
                            ),
                            getVerticalSpace(32.h),
                            InkWell(
                              onTap: () {
                                // Navigator.push(context, route)
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MyProfileScreen(
                                            data: employeeData[0],
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFF8FF),
                                        borderRadius:
                                            BorderRadius.circular(5.h)),
                                    alignment: Alignment.center,
                                    child: getAssetImage(
                                        "profile.png", 28.h, 22.h),
                                  ),
                                  getHorizontalSpace(12.h),
                                  getCustomFont("My Profile", 16.sp,
                                      AppColors.blackColor, 1,
                                      fontWeight: FontWeight.w500),
                                  Spacer(),
                                  getAssetImage("right_arrow.png", 14.h, 10.h),
                                ],
                              ),
                            ),
                            getVerticalSpace(20.h),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => BankDetailScreen(
                                            data: employeeData[0],
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFEE3CF),
                                        borderRadius:
                                            BorderRadius.circular(5.h)),
                                    alignment: Alignment.center,
                                    child:
                                        getAssetImage("home.png", 28.h, 28.h),
                                  ),
                                  getHorizontalSpace(12.h),
                                  getCustomFont("Bank Details ", 16.sp,
                                      AppColors.blackColor, 1,
                                      fontWeight: FontWeight.w500),
                                  Spacer(),
                                  getAssetImage("right_arrow.png", 14.h, 10.h),
                                ],
                              ),
                            ),
                            getVerticalSpace(20.h),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => AddressScreen(
                                            data: employeeData[0],
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE3FFF0),
                                        borderRadius:
                                            BorderRadius.circular(5.h)),
                                    alignment: Alignment.center,
                                    child: getAssetImage(
                                        "address.png", 25.h, 32.h),
                                  ),
                                  getHorizontalSpace(12.h),
                                  getCustomFont("Address ", 16.sp,
                                      AppColors.blackColor, 1,
                                      fontWeight: FontWeight.w500),
                                  Spacer(),
                                  getAssetImage("right_arrow.png", 14.h, 10.h),
                                ],
                              ),
                            ),
                          ],
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
                            color: Colors.cyan, size: 70))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
