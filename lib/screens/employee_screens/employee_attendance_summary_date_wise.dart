import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vetan_panjika/common/image_dialog_widget.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetan_panjika/model/employee_models/employee_dashboard_logs_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';

class AttendanceSummaryDateWisePage extends StatefulWidget {
  final bool isAdmin;
  final String employeeId;
  final String date;
  final String dateNew;
  final String day;

  const AttendanceSummaryDateWisePage(
      {Key? key,
      required this.isAdmin,
      required this.employeeId,
      required this.date,
      required this.dateNew,
      required this.day})
      : super(key: key);

  @override
  _AttendanceSummaryDateWisePageState createState() =>
      _AttendanceSummaryDateWisePageState();
}

class _AttendanceSummaryDateWisePageState
    extends State<AttendanceSummaryDateWisePage> {
  List<EmployeeDashboardLogsModel> attendanceSummary = [];
  String logImgBaseUrl = "";
  String noDataMsg = "";
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    getAttendanceData();
    getImgUrl();
  }

  getImgUrl() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String base = (shared.getString("baseURL") ?? "");
    logImgBaseUrl = base == "" ? "" : base + urlController.attendanceImgUrl;
  }

  getAttendanceData() {
    var apiController = ApiController();
    if (widget.isAdmin) {
      apiController
          .getAdminEmployeeAttendanceDateWise(
              employeeId: widget.employeeId, date: widget.date)
          .then((value) {
        if (value != null) {
          attendanceSummary = [];
          for (var data in value.data) {
            attendanceSummary.add(data);
          }
        }
        if (attendanceSummary.isEmpty) {
          noDataMsg = "No logs found";
        }
        showLoader = false;
        setState(() {});
      });
    } else {
      apiController
          .getEmployeeAttendanceDateWise(date: widget.date)
          .then((value) {
        if (value != null) {
          attendanceSummary = [];
          for (var data in value.data) {
            attendanceSummary.add(data);
          }
        }
        if (attendanceSummary.isEmpty) {
          noDataMsg = "No logs found";
        }
        showLoader = false;
        setState(() {});
      });
    }
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
                          "Attendance Date Wise", 20.sp, Colors.white, 1,
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
                Wrap(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.h, left: 20.h, right: 20.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.h),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                offset: Offset(0, 0),
                                blurRadius: 12)
                          ]),
                      padding: EdgeInsets.all(15.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getCustomFont(
                                  "Attendance Log", 14.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600),
                              Row(
                                children: [
                                  getCustomFont(convertDate(widget.dateNew),
                                      12.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w600),
                                  getHorizontalSpace(5.h),
                                  getCustomFont(widget.day, 12.sp,
                                      AppColors.greyTextColor, 1,
                                      fontWeight: FontWeight.w400),
                                ],
                              )
                            ],
                          ),
                          getVerticalSpace(10.h),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.h,
                            dashLength: 2.h,
                            dashColor: Colors.black.withOpacity(0.10),
                            dashGapLength: 2.h,
                            dashGapColor: Colors.transparent,
                          ),
                          getVerticalSpace(15.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.h),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1.h),
                                color:
                                    AppColors.primaryColor.withOpacity(0.05)),
                            child: attendanceSummary.isEmpty
                                ? emptyDataWidget()
                                : ListView.separated(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.h),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: attendanceSummary.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap:
                                                      attendanceSummary[index]
                                                                  .mode ==
                                                              "FingerPrint"
                                                          ? () {}
                                                          : attendanceSummary[
                                                                          index]
                                                                      .mode ==
                                                                  "Manual"
                                                              ? () {}
                                                              : () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return ImageDialog(
                                                                        imageUrl: attendanceSummary[index].logImg.contains(".")
                                                                            ? (logImgBaseUrl +
                                                                                attendanceSummary[index].logImg)
                                                                            : attendanceSummary[index].logImg,
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                  child: ClipOval(
                                                    child: Container(
                                                      height: 32.h,
                                                      width: 32.h,
                                                      child: attendanceSummary[
                                                                      index]
                                                                  .mode ==
                                                              "Manual"
                                                          ? Image.asset(
                                                              "assets/CS_userimg.png",
                                                              fit: BoxFit.fill,
                                                              height: 32.h,
                                                              width: 32.h,
                                                            )
                                                          : attendanceSummary[
                                                                          index]
                                                                      .mode ==
                                                                  "Face"
                                                              ? FadeInImage(
                                                                  image: NetworkImage(
                                                                      logImgBaseUrl +
                                                                          attendanceSummary[index]
                                                                              .logImg),
                                                                  placeholder:
                                                                      const AssetImage(
                                                                    "assets/CS_userimg.png",
                                                                  ),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  height: 32.h,
                                                                  width: 32.h,
                                                                )
                                                              : attendanceSummary[
                                                                              index]
                                                                          .mode ==
                                                                      "FingerPrint"
                                                                  ? FadeInImage(
                                                                      image: AssetImage(
                                                                          "assets/fingerprint.png"),
                                                                      placeholder:
                                                                          AssetImage(
                                                                              "assets/CS_userimg.png"),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height:
                                                                          32.h,
                                                                      width:
                                                                          32.h,
                                                                    )
                                                                  : Image
                                                                      .memory(
                                                                      base64.decode(
                                                                          attendanceSummary[index]
                                                                              .logImg),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height:
                                                                          32.h,
                                                                      width:
                                                                          32.h,
                                                                    ),
                                                    ),
                                                  ),
                                                ),
                                                getHorizontalSpace(10.h),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    getCustomFont(
                                                        attendanceSummary[index]
                                                            .time,
                                                        14.sp,
                                                        Colors.black,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    getCustomFont(
                                                        attendanceSummary[index]
                                                            .mode,
                                                        10.sp,
                                                        AppColors.greyTextColor,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            getCustomFont("-", 10.sp,
                                                AppColors.greyTextColor, 1,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            DottedLine(
                                      direction: Axis.horizontal,
                                      lineLength: double.infinity,
                                      lineThickness: 1.h,
                                      dashLength: 2.h,
                                      dashColor: Colors.black.withOpacity(0.10),
                                      dashGapLength: 2.h,
                                      dashGapColor: Colors.transparent,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  String convertDate(String inputDate) {
    // Define the input format
    DateFormat inputFormat = DateFormat('d MMM yyyy');

    // Parse the input date string to a DateTime object
    DateTime dateTime = inputFormat.parse(inputDate);

    // Define the output format
    DateFormat outputFormat = DateFormat('MMM d, yyyy');

    // Format the DateTime object to the desired output format
    String outputDate = outputFormat.format(dateTime);

    return outputDate;
  }
}
