import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/main.dart';
import 'package:intl/intl.dart';
import 'package:vetan_panjika/model/employee_models/employee_attendance_model.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_attendance_summary_date_wise.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/common_func.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'employee_dashboard.dart';

class AttendanceSummaryPage extends StatefulWidget {
  const AttendanceSummaryPage({Key? key}) : super(key: key);

  @override
  _AttendanceSummaryPageState createState() => _AttendanceSummaryPageState();
}

class _AttendanceSummaryPageState extends State<AttendanceSummaryPage> {
  // dropdown
  List monthList = [
    {"month": "January", "id": 1},
    {"month": "February", "id": 2},
    {"month": "March", "id": 3},
    {"month": "April", "id": 4},
    {"month": "May", "id": 5},
    {"month": "June", "id": 6},
    {"month": "July", "id": 7},
    {"month": "August", "id": 8},
    {"month": "September", "id": 9},
    {"month": "October", "id": 10},
    {"month": "November", "id": 11},
    {"month": "December", "id": 12},
  ];
  List yearList = [
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
    "2031",
    "2032",
    "2033",
    "2034",
    "2035",
    "2036",
    "2037",
    "2038",
    "2039",
    "2040"
  ];
  String? monthDropdown;
  String? yearDropdown;
  var monthYear = "";
  String selectedMonth = "";
  String selectedYear = "";
  List<EmployeeAttendanceLogModel> attendanceSummary = [];
  List<EmployeeAttendanceLogSummaryModel> attendanceLogSummary = [];
  List<EmployeeAttendanceLogDataModel> attendanceLogData = [];
  String noDataMsg = "";
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    getMonthYear();
    getAttendanceData();
  }

  getMonthYear() async {
    var dateTime = DateTime.now().toUtc();
    String formattedDate = DateFormat.yMMM().format(dateTime);
    monthYear = formattedDate.replaceAll(" ", ", ");
    selectedMonth = dateTime.month.toString();
    monthDropdown = selectedMonth;
    selectedYear = dateTime.year.toString();
    yearDropdown = selectedYear;
  }

  getAttendanceData() {
    var apiController = ApiController();
    apiController
        .getAttendanceData(month: selectedMonth, year: selectedYear)
        .then((value) {
      if (value != null) {
        attendanceSummary = [];
        for (var data in value.data) {
          attendanceSummary.add(data);
        }
      }
      if (attendanceSummary.isNotEmpty) {
        attendanceLogSummary = attendanceSummary[0].dashboard;
        attendanceLogData = attendanceSummary[0].logs;
      }
      if (attendanceSummary.isEmpty) {
        noDataMsg = "No Entry to show";
      }
      showLoader = false;
      setState(() {});
    });
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
                      getCustomFont(
                          "Attendance Summary", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
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
                    getAttendanceData();
                  },
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Search", 16.sp, AppColors.blackColor, 1,
                            fontWeight: FontWeight.w600),
                      ),
                      getVerticalSpace(10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: AppColors.fillColor,
                                    border: Border.all(
                                        color: AppColors.strokeColor),
                                    borderRadius: BorderRadius.circular(5.h)),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      value: monthDropdown,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20),
                                      isExpanded: true,
                                      elevation: 0,
                                      style: TextStyle(
                                          color: AppColors.textBlackColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: Constant.fontFamily),
                                      iconSize: 25,
                                      hint: const Text('Month'),
                                      onChanged: (String? value) {
                                        setState(() {
                                          monthDropdown = value;
                                          selectedMonth = value!;
                                        });
                                      },
                                      items: monthList.map((item) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            item["month"].toString(),
                                            style: TextStyle(
                                                color: AppColors.textBlackColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    Constant.fontFamily),
                                          ),
                                          value: item["id"].toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            getHorizontalSpace(16.h),
                            Expanded(
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: AppColors.fillColor,
                                  border:
                                      Border.all(color: AppColors.strokeColor),
                                  borderRadius: BorderRadius.circular(5.h),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String?>(
                                      value: yearDropdown,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20),
                                      isExpanded: true,
                                      elevation: 0,
                                      style: TextStyle(
                                          color: AppColors.textBlackColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: Constant.fontFamily),
                                      iconSize: 25,
                                      hint: const Text('Year'),
                                      onChanged: (String? value) {
                                        setState(() {
                                          yearDropdown = value;
                                          selectedYear = value!;
                                        });
                                      },
                                      items: yearList.map((item) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                                color: AppColors.textBlackColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    Constant.fontFamily),
                                          ),
                                          value: item.toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            getHorizontalSpace(16.h),
                            GestureDetector(
                              onTap: getAttendanceData,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 41.h),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5.h),
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFF3197FF)
                                              .withOpacity(0.5),
                                          offset: Offset(0, 0),
                                          blurRadius: 10)
                                    ]),
                                height: 40.h,
                                alignment: Alignment.center,
                                child: getCustomFont(
                                    "Search", 16.sp, AppColors.unselectColor, 1,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      getVerticalSpace(20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Summary", 16.sp, AppColors.blackColor, 1,
                            fontWeight: FontWeight.w600),
                      ),
                      getVerticalSpace(10.h),
                      if (attendanceLogSummary.isEmpty)
                        emptyDataWidget()
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    summaryWidget(
                                        attendanceLogSummary[0].presentTotal,
                                        "Present",
                                        Color(0xFF009847),
                                        Color(0xFFF2FAF6)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].onTimeTotal,
                                        "On Time",
                                        Color(0xFFFFBC00),
                                        Color(0xFFFFFCF2)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].absentTotal,
                                        "Absent",
                                        Color(0xFFEC5B4F),
                                        Color(0xFFFEF7F6)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].lessHrsTotal,
                                        "Less Hours",
                                        Color(0xFF3197FF),
                                        Color(0xFFF6F9FE))
                                  ],
                                ),
                              ),
                            ),
                            getVerticalSpace(15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    summaryWidget(
                                        attendanceLogSummary[0]
                                            .punchMissingTotal,
                                        "Punch Missing",
                                        Color(0xFF582D15),
                                        Color(0xFFF7F4F3)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].halfDayTotal,
                                        "Half Day",
                                        Color(0xFF004F98),
                                        Color(0xFFF2F6FA)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].lateTotal,
                                        "Late",
                                        Color(0xFF1510FF),
                                        Color(0xFFF3F3FF)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].holidayTotal,
                                        "Total Holiday",
                                        Colors.black,
                                        Color(0xFFF2F2F2))
                                  ],
                                ),
                              ),
                            ),
                            getVerticalSpace(15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    summaryWidget(
                                        attendanceLogSummary[0]
                                            .holidayWorkingTotal,
                                        "Holiday Work",
                                        Color(0xFFFF7A00),
                                        Color(0xFFFFF8F2)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0].weekOffTotal,
                                        "Week Off",
                                        Color(0xFF009847),
                                        Color(0xFFF2FAF6)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget(
                                        attendanceLogSummary[0]
                                            .weekOffWorkingTotal,
                                        "Week Off Working",
                                        Color(0xFFFFBC00),
                                        Color(0xFFFFFCF2)),
                                    getHorizontalSpace(15.h),
                                    summaryWidget("-", "Leaves",
                                        Color(0xFFE10000), Color(0xFFFEF2F2))
                                  ],
                                ),
                              ),
                            ),
                            getVerticalSpace(15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.h),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFF3197FF)
                                                      .withOpacity(0.14),
                                                  offset: Offset(0, 0),
                                                  blurRadius: 12)
                                            ],
                                            border: Border.all(
                                                color: AppColors.primaryColor,
                                                width: 1.h)),
                                        child: Container(
                                          margin: EdgeInsets.all(3.h),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.h),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFF3197FF)
                                                      .withOpacity(0.14),
                                                  offset: Offset(0, 0),
                                                  blurRadius: 12)
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              getCustomFont("Overtime", 14.sp,
                                                  Colors.black, 1,
                                                  fontWeight: FontWeight.w600),
                                              getVerticalSpace(3.h),
                                              getCustomFont(
                                                  attendanceLogSummary[0]
                                                          .overtimeTotal +
                                                      " Hrs",
                                                  14.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        )),
                                  ),
                                  getHorizontalSpace(16.h),
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.h),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFF3197FF)
                                                      .withOpacity(0.14),
                                                  offset: Offset(0, 0),
                                                  blurRadius: 12)
                                            ],
                                            border: Border.all(
                                                color: AppColors.primaryColor,
                                                width: 1.h)),
                                        child: Container(
                                          margin: EdgeInsets.all(3.h),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.h),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFF3197FF)
                                                      .withOpacity(0.14),
                                                  offset: Offset(0, 0),
                                                  blurRadius: 12)
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              getCustomFont("Working Hrs",
                                                  14.sp, Colors.black, 1,
                                                  fontWeight: FontWeight.w600),
                                              getVerticalSpace(3.h),
                                              getCustomFont(
                                                  attendanceLogSummary[0]
                                                          .workingHrsTotal +
                                                      " Hrs",
                                                  14.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            getVerticalSpace(20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: getCustomFont(
                                  "Attendance", 16.sp, AppColors.blackColor, 1,
                                  fontWeight: FontWeight.w600),
                            ),
                            getVerticalSpace(10.h),
                            attendanceLogData.isNotEmpty
                                ? ListView.separated(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.h),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: attendanceLogData.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  AttendanceSummaryDateWisePage(
                                                isAdmin: false,
                                                employeeId: "",
                                                date: attendanceLogData[i]
                                                    .dateOld,
                                                dateNew: attendanceLogData[i]
                                                    .dateNew,
                                                day: attendanceLogData[i].day,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15.h),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.h),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.12),
                                                    offset: Offset(0, 0),
                                                    blurRadius: 12)
                                              ]),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      getCustomFont(
                                                          attendanceLogData[i]
                                                              .dateNew,
                                                          14.sp,
                                                          Colors.black,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      getHorizontalSpace(5.h),
                                                      getCustomFont(
                                                          attendanceLogData[i]
                                                              .day,
                                                          12.sp,
                                                          AppColors
                                                              .greyTextColor,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ],
                                                  ),
                                                  getCustomFont(
                                                      attendanceLogData[i]
                                                          .status,
                                                      14.sp,
                                                      AppColors.greenColor,
                                                      1,
                                                      fontWeight:
                                                          FontWeight.w600)
                                                ],
                                              ),
                                              getVerticalSpace(10.h),
                                              Divider(
                                                  height: 0,
                                                  color: AppColors.dividerColor,
                                                  thickness: 1),
                                              getVerticalSpace(10.h),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      getCustomFont(
                                                          "Working Hrs",
                                                          10.sp,
                                                          AppColors
                                                              .greyTextColor,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      getVerticalSpace(2.h),
                                                      getCustomFont(
                                                          attendanceLogData[i]
                                                                  .duration
                                                                  .isEmpty
                                                              ? "-"
                                                              : "${attendanceLogData[i].duration} Hrs",
                                                          14.sp,
                                                          Colors.black,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ],
                                                  ),
                                                  getHorizontalSpace(30.h),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      getCustomFont(
                                                          "Overtime",
                                                          10.sp,
                                                          AppColors
                                                              .greyTextColor,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      getVerticalSpace(2.h),
                                                      getCustomFont(
                                                          attendanceLogData[i]
                                                                  .overtime
                                                                  .isEmpty
                                                              ? "-"
                                                              : "${attendanceLogData[i].overtime} Hrs",
                                                          14.sp,
                                                          Colors.black,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  getCustomFont(
                                                      attendanceLogData[i]
                                                                  .isWeekOff ==
                                                              0
                                                          ? ""
                                                          : "Week off",
                                                      14.sp,
                                                      Colors.black,
                                                      1,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            getVerticalSpace(15.h),
                                  )
                                : Container(),
                            getVerticalSpace(10.h),
                          ],
                        )
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

  Widget summaryWidget(
      String data, String text, Color darkColor, Color lightColor) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: darkColor, borderRadius: BorderRadius.circular(8.h)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          width: double.infinity,
          margin: EdgeInsets.only(top: 2.h),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              color: lightColor, borderRadius: BorderRadius.circular(8.h)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getCustomFont(data, 14.sp, darkColor, 1,
                  fontWeight: FontWeight.w600),
              getVerticalSpace(2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.h),
                child: getMultiLineFont(text, 11.sp, AppColors.textBlackColor,
                    fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
