import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_single_details_models/nms_agent_details_model.dart';
import '../../../../utils/color_data.dart';
import '../../../../utils/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/widget.dart';
import 'package:dotted_line/dotted_line.dart';

class NMSAgentDetails extends StatefulWidget {
  final String agentId;

  const NMSAgentDetails({Key? key, required this.agentId}) : super(key: key);

  @override
  State<NMSAgentDetails> createState() => _NMSAgentDetailsState();
}

class _NMSAgentDetailsState extends State<NMSAgentDetails> {
  bool showLoader = true;

  List agentDetailList = [];
  String agentName = "";
  String publicIP = "";
  String localIP = "";
  String totalDevices = "";
  String agentStatus = "";
  String lastFailOn = "";
  String lastCriticalOn = "";
  String lastSuccessOn = "";
  String agentImg = "";
  String successPercentage = "";
  String criticalPercentage = "";
  String failPercentage = "";

  List<NMSAgentDetailsLogsDataModel> logsList = [];

  getAgentDetails() {
    logsList = [];
    final apiController = ApiController();
    apiController.getNmsAgentDetails(agentId: widget.agentId).then((value) {
      if (value != null) {
        List<NMSAgentDetailsListDataModel> details = [];
        List<NMSAgentDetailsLogsDataModel> logs = [];
        for (var data in value.data) {
          details = data.agentDetails;
          logs = data.logsData;
        }
        if (details.isNotEmpty) {
          agentDetailList = details;
          agentName = details[0].agentName;
          publicIP = details[0].publicIp;
          localIP = details[0].localIp;
          totalDevices = details[0].nosHosts;
          agentStatus = details[0].status;
          lastFailOn = details[0].lastFailOn;
          lastCriticalOn = details[0].lastCriticalOn;
          lastSuccessOn = details[0].lastSuccessOn;
          agentImg = details[0].imageUrl;
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
    getAgentDetails();
  }

  @override
  Widget build(BuildContext context) {
    List title = [
      'Agent Status',
      'Public IP',
      'Local IP',
      'No of Devices',
      'Last Offline On',
      'Last High Latency On',
      'Last Online On'
    ];

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
                      getCustomFont("Agent Details", 20.sp, Colors.white, 1,
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
                getAgentDetails();
              },
              child: Stack(
                children: [
                  ListView(padding: EdgeInsets.zero, children: [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getCustomFont(agentName == "" ? '' : agentName, 16.sp,
                              AppColors.blackColor, 1,
                              fontWeight: FontWeight.w600),
                          getVerticalSpace(20.h),
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
                          getCustomFont(
                              "Agent Details", 16.sp, AppColors.blackColor, 1,
                              fontWeight: FontWeight.w600),
                          getVerticalSpace(12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont(
                                    "Agent Status", 14.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w500),
                                getCustomFont(
                                    (agentStatus == "" ? '' : agentStatus)
                                                .toString() ==
                                            "Critical"
                                        ? "High Latency"
                                        : (agentStatus == "" ? '' : agentStatus)
                                                    .toString() ==
                                                "NotMonitored"
                                            ? "Not Monitored"
                                            : (agentStatus == ""
                                                    ? ''
                                                    : agentStatus)
                                                .toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont(
                                    "Public IP", 14.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w500),
                                getCustomFont(
                                    (publicIP == "" ? '' : publicIP).toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont(
                                    "Local IP", 14.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w500),
                                getCustomFont(
                                    (localIP == "" ? '' : localIP).toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont(
                                    "No Of Devices", 14.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w500),
                                getCustomFont(
                                    (totalDevices == "" ? '' : totalDevices),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont("Last Hign Latency On", 14.sp,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont(
                                    "Last Online On", 14.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w500),
                                getCustomFont(
                                    (lastSuccessOn == "" ? '0' : lastSuccessOn),
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
                    else ListView.separated(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              logsList[eventIndex].status == "UpTime"
                                  ? getAssetImage("up_green.png", 20.h, 20.h)
                                  : logsList[eventIndex].status == "DownTime"
                                      ? getAssetImage(
                                          "down_red.png", 20.h, 20.h)
                                      : getAssetImage(
                                          "down_yello.png", 20.h, 20.h),
                              getHorizontalSpace(10.h),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getMultiLineFont("Start Time", 12.sp,
                                              AppColors.greyTextColor,
                                              fontWeight: FontWeight.w400),
                                          getVerticalSpace(3.h),
                                          getMultiLineFont(
                                              "${((logsList[eventIndex].startTime == "" ? '' : logsList[eventIndex].startTime).toString())}",
                                              14.sp,
                                              AppColors.blackColor,
                                              fontWeight: FontWeight.w500)
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
                                            dashGapColor: Colors.transparent,
                                          ),
                                          getVerticalSpace(5.h),
                                          Flexible(
                                            child: getCustomFont(
                                                ((logsList[eventIndex]
                                                                .duration ==
                                                            ""
                                                        ? ''
                                                        : logsList[eventIndex]
                                                            .duration)
                                                    .toString()),
                                                11.sp,
                                                AppColors.primaryColor,
                                                1,
                                                fontWeight: FontWeight.w500,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    getMultiLineFont("End Time", 12.sp,
                                        AppColors.greyTextColor,
                                        fontWeight: FontWeight.w400,textAlign: TextAlign.end),
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
                  ]),
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
