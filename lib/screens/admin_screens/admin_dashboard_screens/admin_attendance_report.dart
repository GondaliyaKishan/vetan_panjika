import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/devices.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/reports/admin_day_wise_attendance_report.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/reports/admin_employee_wise_attendance_report.dart';
import '../../../main.dart';
import '../../../utils/color_data.dart';
import '../../../utils/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/widget.dart';
import '../../employee_screens/employee_leave_screens/employee_leave_add_edit.dart';

class AttendanceReports extends StatefulWidget {
  const AttendanceReports({Key? key}) : super(key: key);

  @override
  _AttendanceReportsState createState() => _AttendanceReportsState();
}

class _AttendanceReportsState extends State<AttendanceReports> {
  List<AttendanceMenu> menu = [
    AttendanceMenu(
        title: "Day Wise",
        imgPath: "image1.png",
        route: const AdminDayWiseAttendance()),
    AttendanceMenu(
        title: "Employee Wise",
        imgPath: "image2.png",
        route: const AdminEmployeeWiseAttendance()),
    AttendanceMenu(title: "Devices", imgPath: "image3.png", route: Devices()),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF6FBFF),
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness:
          Brightness.dark, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3197FF).withOpacity(0.50),
                    Color(0xFF3197FF).withOpacity(0.11)
                  ],
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32.h))),
            padding: EdgeInsets.only(bottom: 3.h),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF6FBFF),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(32.h))),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 68.h, bottom: 27.h, left: 20.h, right: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          getAssetImage("back_black.png", 22.h, 22.h),
                          getHorizontalSpace(9.h),
                          getCustomFont(
                              "attendance Reports", 18.sp, Colors.black, 1,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          getVerticalSpace(20.h),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              itemCount: menu.length,
              separatorBuilder: (BuildContext context, int i) =>
                  getVerticalSpace(15.h),
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: () {
                    // todo redirect to selected type
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => menu[i].route,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.h),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              offset: Offset(0, 0),
                              blurRadius: 9.h)
                        ]),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              height: 35.h,
                              width: 35.h,
                              alignment: Alignment.center,
                              child: getAssetImage(menu[i].imgPath, 15.h, 15.h),
                            ),
                            // Image.asset(
                            //   menu[i].imgPath,
                            //   height: 35,
                            // ),
                            // const SizedBox(width: 15),
                            getHorizontalSpace(8.h),
                            getCustomFont(menu[i].title, 14.sp,
                                AppColors.textBlackColor, 1,
                                fontWeight: FontWeight.w500)
                          ],
                        ),
                        getAssetImage("right.png", 18.h, 18.h)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceMenu {
  final String title;
  final String imgPath;
  final Widget route;

  AttendanceMenu(
      {required this.title, required this.imgPath, required this.route});
}
