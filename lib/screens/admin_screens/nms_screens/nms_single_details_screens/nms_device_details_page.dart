import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_single_details_models/nms_device_details_model.dart';
import '../../../../utils/color_data.dart';
import '../../../../utils/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../../../utils/widget.dart';

class NMSDeviceDetails extends StatefulWidget {
  final String deviceId;

  const NMSDeviceDetails({Key? key, required this.deviceId}) : super(key: key);

  @override
  State<NMSDeviceDetails> createState() => _NMSDeviceDetailsState();
}

class _NMSDeviceDetailsState extends State<NMSDeviceDetails> {
  List<NMSDeviceDetailsListDataModel> deviceDetailList = [];
  bool showLoader = true;
  String deviceName = "";
  String ipAddress = "";
  String groupName = "";
  String type = "";
  String deviceStatus = "";
  String lastFailOn = "";
  String lastCriticalOn = "";
  String lastSuccessOn = "";
  String deviceImg = "";
  String successPercentage = "";
  String criticalPercentage = "";
  String failPercentage = "";

  List<NMSDeviceDetailsLogsDataModel> logsList = [];

  getDeviceDetails() {
    logsList = [];
    final apiController = ApiController();
    apiController.getNmsDeviceDetails(deviceId: widget.deviceId).then((value) {
      if (value != null) {
        List<NMSDeviceDetailsListDataModel> details = [];
        List<NMSDeviceDetailsLogsDataModel> logs = [];
        for (var data in value.data) {
          details = data.deviceDetails;
          logs = data.logsData;
        }
        if (details.isNotEmpty) {
          deviceDetailList = details;
          deviceName = details[0].deviceName;
          ipAddress = details[0].ipAddress;
          deviceImg = details[0].imageUrl;
          type = details[0].typeName;
          deviceStatus = details[0].status;
          groupName = details[0].locationName;
          lastFailOn = details[0].lastFailOn;
          lastCriticalOn = details[0].lastCriticalOn;
          lastSuccessOn = details[0].lastSuccessOn;
          successPercentage = details[0].successPer;
          criticalPercentage = details[0].criticalPer;
          failPercentage = details[0].failPer;
        }
        if (logs.isNotEmpty) {
          logsList = logs;
        }
      }
      showLoader = false;
      setState(() {});
    });
  }

  String baseUrl = "";

  getImgBaseUrl() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    baseUrl = shared.getString("baseURL") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getImgBaseUrl();
    getDeviceDetails();
  }

  @override
  Widget build(BuildContext context) {
    List title = [
      'IP Address',
      'Location',
      'Type',
      'Last Offline On',
      'Last High Latency On',
      'Last Online On'
    ];

    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness:
          Brightness.light, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Device Details", style: theme.text20),
      //   backgroundColor: Colors.white,
      // ),
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
                      getCustomFont("Device Details", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.black,
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 700));
                setState(() {
                  showLoader = true;
                });
                getDeviceDetails();
              },
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      getVerticalSpace(20.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.h),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 12,
                                  offset: Offset(0, 0))
                            ]),
                        padding: EdgeInsets.all(15.h),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                deviceImg.isEmpty
                                    ? Container()
                                    : FadeInImage.assetNetwork(
                                        image:
                                            '$baseUrl/assets/images/Devices/$deviceImg',
                                        placeholder: 'assets/SplashPlace.JPG',
                                        fit: BoxFit.fill,
                                        height: 30.h,
                                      ),
                                getHorizontalSpace(5.h),
                                getCustomFont(
                                    deviceName == "" ? '' : deviceName,
                                    16.sp,
                                    AppColors.blackColor,
                                    1,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                            getVerticalSpace(15.h),
                            Row(
                              children: [
                                PieChart(
                                  dataMap: {
                                    'Online:  ${(successPercentage == "" ? '' : successPercentage)}':
                                        double.parse(successPercentage == ""
                                            ? '0.00'
                                            : successPercentage),
                                    'Critical:  ${(criticalPercentage == "" ? '' : criticalPercentage)}':
                                        double.parse(criticalPercentage == ""
                                            ? '0.00'
                                            : criticalPercentage),
                                    'Offline:  ${(failPercentage == "" ? '' : failPercentage)}':
                                        double.parse(failPercentage == ""
                                            ? '0.00'
                                            : failPercentage),
                                  },
                                  animationDuration:
                                      const Duration(milliseconds: 1000),
                                  // chartLegendSpacing: 16.0,
                                  chartRadius: 63.h,
                                  colorList: const [
                                    Color(0xFF009847),
                                    Color(0xFFFFBC00),
                                    Color(0xFFE10000),
                                  ],
                                  initialAngleInDegree: 270.0,
                                  chartType: ChartType.disc,
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: false,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: false,
                                    chartValueStyle: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    showChartValues: false,
                                    showChartValuesInPercentage: true,
                                    showChartValuesOutside: false,
                                  ),
                                ),
                                getHorizontalSpace(31.h),
                                Expanded(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            getMultiLineFont(
                                                "${double.parse(successPercentage == "" ? '0.00' : successPercentage)}%",
                                                14.sp,
                                                Color(0xFF009847),
                                                fontWeight: FontWeight.w600),
                                            getVerticalSpace(2.h),
                                            getMultiLineFont("Online", 11.sp,
                                                AppColors.textBlackColor,
                                                fontWeight: FontWeight.w500,
                                                textAlign: TextAlign.center)
                                          ],
                                        ),
                                        getHorizontalSpace(12.h),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            getMultiLineFont(
                                                "${double.parse(criticalPercentage == "" ? '0.00' : criticalPercentage)}%",
                                                14.sp,
                                                Color(0xFFFFBC00),
                                                fontWeight: FontWeight.w600),
                                            getVerticalSpace(2.h),
                                            getMultiLineFont("High Latency",
                                                11.sp, AppColors.textBlackColor,
                                                fontWeight: FontWeight.w500,
                                                textAlign: TextAlign.center)
                                          ],
                                        ),
                                        getHorizontalSpace(12.h),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            getMultiLineFont(
                                                "${double.parse(failPercentage == "" ? '0.00' : failPercentage)}%",
                                                14.sp,
                                                Color(0xFFE10000),
                                                fontWeight: FontWeight.w600),
                                            getVerticalSpace(2.h),
                                            getMultiLineFont("Offline", 11.sp,
                                                AppColors.textBlackColor,
                                                fontWeight: FontWeight.w500,
                                                textAlign: TextAlign.center)
                                          ],
                                        ),
                                        getHorizontalSpace(22.h),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      getVerticalSpace(20.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.h),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 12,
                                  offset: Offset(0, 0))
                            ]),
                        padding: EdgeInsets.all(15.h),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            getCustomFont("Device Details", 16.sp,
                                AppColors.blackColor, 1,
                                fontWeight: FontWeight.w600),
                            getVerticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomFont(
                                      "Ip Address", 14.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w500),
                                  getCustomFont(
                                      (ipAddress == "" ? '' : ipAddress),
                                      14.sp,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                            getVerticalSpace(12.h),
                            Divider(
                              height: 0,
                              color: AppColors.dividerColor,
                              thickness: 1.h,
                            ),
                            getVerticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomFont(
                                      "Location", 14.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w500),
                                  getHorizontalSpace(20.h),
                                  Expanded(
                                    child: getMultiLineFont(
                                        (groupName == "" ? '' : groupName),
                                        14.sp,
                                        Colors.black,
                                        textAlign: TextAlign.right,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            getVerticalSpace(12.h),
                            Divider(
                              height: 0,
                              color: AppColors.dividerColor,
                              thickness: 1.h,
                            ),
                            getVerticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomFont("Type", 14.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w500),
                                  getCustomFont((type == "" ? '' : type), 14.sp,
                                      Colors.black, 1,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                            getVerticalSpace(12.h),
                            Divider(
                              height: 0,
                              color: AppColors.dividerColor,
                              thickness: 1.h,
                            ),
                            getVerticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomFont(
                                      "Last Offline On", 14.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w500),
                                  getCustomFont(
                                      (lastFailOn == "" ? '0' : lastFailOn),
                                      14.sp,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                            getVerticalSpace(12.h),
                            Divider(
                              height: 0,
                              color: AppColors.dividerColor,
                              thickness: 1.h,
                            ),
                            getVerticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomFont("Last High Latency On", 14.sp,
                                      Colors.black, 1,
                                      fontWeight: FontWeight.w500),
                                  getCustomFont(
                                      (lastCriticalOn == ""
                                          ? '0'
                                          : lastCriticalOn),
                                      14.sp,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                            getVerticalSpace(12.h),
                            Divider(
                              height: 0,
                              color: AppColors.dividerColor,
                              thickness: 1.h,
                            ),
                            getVerticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomFont(
                                      "Last Online On", 14.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w500),
                                  getCustomFont(
                                      (lastSuccessOn == ""
                                          ? '0'
                                          : lastSuccessOn),
                                      14.sp,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      getVerticalSpace(20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Event Summary", 16.sp, AppColors.blackColor, 1,
                            fontWeight: FontWeight.w600),
                      ),
                      getVerticalSpace(10.h),
                      if (logsList.isEmpty && showLoader == false)
                        emptyDataWidget()
                      else
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return getVerticalSpace(15.h);
                          },
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logsList.length,
                          itemBuilder: (context, eventIndex) {

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.12),
                                        blurRadius: 12,
                                        offset: Offset(0, 0))
                                  ]),
                              padding: EdgeInsets.all(15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  logsList[eventIndex].status == "UpTime"
                                      ? getAssetImage(
                                          "up_green.png", 20.h, 20.h)
                                      : logsList[eventIndex].status ==
                                              "DownTime"
                                          ? getAssetImage(
                                              "down_red.png", 20.h, 20.h)
                                          : getAssetImage(
                                              "uptime_yellow.png", 20.h, 20.h),
                                  getHorizontalSpace(10.h),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getMultiLineFont(
                                                  "Start Time",
                                                  12.sp,
                                                  AppColors.greyTextColor,
                                                  fontWeight:
                                                      FontWeight.w400),
                                              getVerticalSpace(3.h),
                                              getMultiLineFont(
                                                  "${((logsList[eventIndex].startTime == "" ? '' : logsList[eventIndex].startTime).toString())}",
                                                  14.sp,
                                                  AppColors.blackColor,
                                                  fontWeight:
                                                      FontWeight.w500)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  getHorizontalSpace(5.h),
                                  Flexible(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        getAssetImage("circle.png", 17.h, 17.h),
                                        getHorizontalSpace(5.h),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              getCustomFont("Duration", 11.sp,
                                                  AppColors.greyTextColor, 1,
                                                  fontWeight: FontWeight.w400,
                                                  textOverflow:
                                                      TextOverflow.ellipsis),
                                              getVerticalSpace(5.h),
                                              DottedLine(
                                                direction: Axis.horizontal,
                                                lineThickness: 1.h,
                                                dashLength: 5.h,
                                                dashColor: Color(0xFFD0D0D0),
                                                dashGapLength: 3.h,
                                                dashGapColor:
                                                    Colors.transparent,
                                              ),
                                              getVerticalSpace(5.h),
                                              Flexible(
                                                child: getMultiLineFont(
                                                    ((logsList[eventIndex]
                                                                    .duration ==
                                                                ""
                                                            ? ''
                                                            : logsList[
                                                                    eventIndex]
                                                                .duration)
                                                        .toString()),
                                                    11.sp,
                                                    AppColors.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                        ),
                                        getHorizontalSpace(5.h),
                                        getAssetImage("circle.png", 17.h, 17.h),
                                      ],
                                    ),
                                  ),
                                  getHorizontalSpace(5.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        getMultiLineFont("End Time", 12.sp,
                                            AppColors.greyTextColor,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.end),
                                        getVerticalSpace(3.h),
                                        getMultiLineFont(
                                            "${((logsList[eventIndex].endTime == "" ? '' : logsList[eventIndex].endTime).toString())}",
                                            14.sp,
                                            AppColors.blackColor,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.end)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
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
          ),
        ],
      ),
    );
  }
}
