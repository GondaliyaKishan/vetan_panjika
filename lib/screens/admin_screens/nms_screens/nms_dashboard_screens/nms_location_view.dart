import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_filter_models/nms_agent_filter_model.dart';
import '../../../../model/nms_models/nms_location_view_model.dart';
import '../../../../utils/color_data.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/widget.dart';
import '../nms_type_wise_list/nms_location_wise_devices.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NMSLocationView extends StatefulWidget {
  const NMSLocationView({Key? key}) : super(key: key);

  @override
  State<NMSLocationView> createState() => _NMSLocationViewState();
}

class _NMSLocationViewState extends State<NMSLocationView> {
  List locationStatus = [];
  String upPercentage = "";
  String offlinePercentage = "";
  String criticalPercentage = "";
  String notManagedPercentage = "";
  List<NMSLocationViewLocationDataModel> locationList = [];
  List hostList = [];
  List<NMSAgentFilterDataModel> agentFilters = [];
  String? filterDefault;
  bool showLoader = true;
  String noDataMessage = '';

  getLocations() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    apiController.getNmsLocationViewData(agent).then((value) {
      if (value != null) {
        List<NMSLocationViewDataPercentageModel> percentageData = [];
        List<NMSLocationViewLocationDataModel> ipsListData = [];
        for (var data in value.data) {
          percentageData = data.percentage;
          ipsListData = data.locationData;
        }
        if (ipsListData.isNotEmpty) {
          locationList = ipsListData;
        }
        if (percentageData.isNotEmpty) {
          upPercentage = percentageData[0].upPercentage;
          offlinePercentage = percentageData[0].offlinePercentage;
          criticalPercentage = percentageData[0].criticalPercentage;
          notManagedPercentage = percentageData[0].notManagedPercentage;
        }
      }
      showLoader = false;
      setState(() {});
    });
  }

  String agent = "0";

  getAgentFilter() {
    var apiController = ApiController();
    apiController.getNmsAgentFilter().then((value) {
      if (value != null) {
        List<NMSAgentFilterDataModel> agentFilterData = [];
        for (var data in value.data) {
          agentFilterData.add(data);
        }
        agentFilters = agentFilterData;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getAgentFilter();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness:
          Brightness.light, // For iOS (dark icons) // status bar color
    ));
    double screenWidth = double.infinity;

    double padding = 20.h;
    double spacing = 16.h;

    int numberOfColumns = 2;

    double itemWidth =
        (screenWidth - (padding * 2) - (spacing * (numberOfColumns - 1))) /
            numberOfColumns;
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
                      getCustomFont("Location", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                Container(
                  width: 200.h,
                  height: 36.h,
                  // margin: const EdgeInsets.only(
                  //     top: 15, bottom: 7, left: 7, right: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.h),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: filterDefault,
                        isExpanded: true,
                        elevation: 0,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.fontFamily),
                        iconSize: 25,
                        hint: Text(
                          'Filter by Agent',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily),
                        ),
                        // padding: EdgeInsets.symmetric(horizontal: 10.h),
                        icon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            child:
                                getAssetImage("filter_blue.png", 15.h, 21.h)),
                        onChanged: (String? value) {
                          setState(() {
                            filterDefault = value!;
                            agent = value;
                            showLoader = true;
                          });
                          getLocations();
                        },
                        items: agentFilters.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item.agentName,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.fontFamily),
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: item.transNo.toString(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(children: [
              RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 700));
                  getAgentFilter();
                  getLocations();
                },
                child: ListView(
                  shrinkWrap: true,
                  children: [
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
                            getCustomFont("Location Status", 16.sp,
                                AppColors.blackColor, 1,
                                fontWeight: FontWeight.w600),
                            getVerticalSpace(20.h),
                            Row(
                              children: [
                                PieChart(
                                  dataMap: {
                                    'Online:  ${(upPercentage == "" ? '' : upPercentage)}':
                                        double.parse(upPercentage == ""
                                            ? '0.00'
                                            : upPercentage),
                                    'Critical:  ${(criticalPercentage == "" ? '' : criticalPercentage)}':
                                        double.parse(criticalPercentage == ""
                                            ? '0.00'
                                            : criticalPercentage),
                                    'Online:  ${(offlinePercentage == "" ? '' : offlinePercentage)}':
                                        double.parse(offlinePercentage == ""
                                            ? '0.00'
                                            : offlinePercentage),
                                    'Online:  ${(notManagedPercentage == "" ? '' : notManagedPercentage)}':
                                        double.parse(notManagedPercentage == ""
                                            ? '0.00'
                                            : notManagedPercentage),
                                  },
                                  animationDuration:
                                      const Duration(milliseconds: 1000),
                                  chartLegendSpacing: 16.0,
                                  chartRadius: 63.h,
                                  colorList: const [
                                    Color(0xFF009847),
                                    Color(0xFFFFBC00),
                                    Color(0xFFE10000),
                                    Color(0xFF000000),
                                  ],
                                  initialAngleInDegree: 270.0,
                                  chartType: ChartType.disc,
                                  // centerText:
                                  //     '${(upPercentage == "" ? '' : upPercentage)}%',
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
                                getHorizontalSpace(13.h),
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
                                                "${double.parse(upPercentage == "" ? '0.00' : upPercentage)}%",
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
                                                "${double.parse(offlinePercentage == "" ? '0.00' : offlinePercentage)}%",
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
                                        getHorizontalSpace(12.h),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              getMultiLineFont(
                                                  "${double.parse(notManagedPercentage == "" ? '0.00' : notManagedPercentage)}%",
                                                  14.sp,
                                                  Color(0xFF000000),
                                                  fontWeight: FontWeight.w600),
                                              getVerticalSpace(2.h),
                                              getMultiLineFont(
                                                  "Not Monitored",
                                                  11.sp,
                                                  AppColors.textBlackColor,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]),
                    ),
                    getVerticalSpace(20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: getCustomFont(
                          "Locations", 16.sp, AppColors.blackColor, 1,
                          fontWeight: FontWeight.w600),
                    ),
                    getVerticalSpace(10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                    color: Color(0xFF009847),
                                    border: Border.all(
                                        color: Colors.white, width: 1.h),
                                    borderRadius: BorderRadius.circular(3.h)),
                              ),
                              getHorizontalSpace(5.h),
                              getCustomFont("Locations", 11.sp,
                                  AppColors.textBlackColor, 1,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                          getHorizontalSpace(10.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFBC00),
                                    border: Border.all(
                                        color: Colors.white, width: 1.h),
                                    borderRadius: BorderRadius.circular(3.h)),
                              ),
                              getHorizontalSpace(5.h),
                              getCustomFont("High Latency", 11.sp,
                                  AppColors.textBlackColor, 1,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                          getHorizontalSpace(10.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE10000),
                                    border: Border.all(
                                        color: Colors.white, width: 1.h),
                                    borderRadius: BorderRadius.circular(3.h)),
                              ),
                              getHorizontalSpace(5.h),
                              getCustomFont(
                                  "Offline", 11.sp, AppColors.textBlackColor, 1,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                          getHorizontalSpace(10.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                    color: Color(0xFF000000),
                                    border: Border.all(
                                        color: Colors.white, width: 1.h),
                                    borderRadius: BorderRadius.circular(3.h)),
                              ),
                              getHorizontalSpace(5.h),
                              getCustomFont("Not Monitored", 11.sp,
                                  AppColors.textBlackColor, 1,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                        ],
                      ),
                    ),
                    getVerticalSpace(10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Divider(
                        height: 0,
                        color: Colors.black.withOpacity(0.20),
                        thickness: 1.h,
                      ),
                    ),
                    getVerticalSpace(15.h),
                    if (locationList.isEmpty && showLoader == false)
                      emptyDataWidget()
                    else
                      GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 150.h,
                            crossAxisSpacing: 16.h,
                            mainAxisSpacing: 16.h),
                        itemCount: locationList.length,
                        itemBuilder: (context, locationIndex) {
                          return AnimationConfiguration.staggeredList(
                            position: locationIndex,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NMSLocationWiseDevices(
                                          locationId:
                                              locationList[locationIndex]
                                                  .locationId,
                                        ),
                                      ),
                                    ).then((value) => setState(() {}));
                                  },
                                  child: Container(
                                    width: itemWidth,
                                    padding: EdgeInsets.only(
                                        top: 10.h,
                                        left: 20.h,
                                        right: 20.h,
                                        bottom: 15.h),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15.h),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.10),
                                              blurRadius: 15,
                                              offset: Offset(0, 0))
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PieChart(
                                          dataMap: {
                                            (locationList[locationIndex]
                                                        .online ==
                                                    ""
                                                ? ''
                                                : locationList[locationIndex]
                                                    .online): double.parse(
                                                locationList[locationIndex]
                                                            .online ==
                                                        ""
                                                    ? '0.00'
                                                    : locationList[
                                                            locationIndex]
                                                        .online),
                                            (locationList[locationIndex]
                                                        .highLatency ==
                                                    ""
                                                ? ''
                                                : locationList[locationIndex]
                                                    .highLatency): double.parse(
                                                locationList[locationIndex]
                                                            .highLatency ==
                                                        ""
                                                    ? '0.00'
                                                    : locationList[
                                                            locationIndex]
                                                        .highLatency),
                                            (locationList[locationIndex]
                                                        .offline ==
                                                    ""
                                                ? ''
                                                : locationList[locationIndex]
                                                    .offline): double.parse(
                                                locationList[locationIndex]
                                                            .offline ==
                                                        ""
                                                    ? '0.00'
                                                    : locationList[
                                                            locationIndex]
                                                        .offline),
                                          },
                                          animationDuration: const Duration(
                                              milliseconds: 1000),
                                          chartLegendSpacing: 0,
                                          chartRadius: 55.h,
                                          colorList: [
                                            (locationList[locationIndex]
                                                        .online ==
                                                    '0'
                                                ? Colors.orange
                                                : Colors.green),
                                            (locationList[locationIndex]
                                                        .highLatency ==
                                                    '0'
                                                ? Colors.red
                                                : Colors.orange),
                                            (locationList[locationIndex]
                                                        .offline ==
                                                    '0'
                                                ? Colors.green
                                                : Colors.red),
                                          ],
                                          initialAngleInDegree: 270,
                                          chartType: ChartType.disc,
                                          ringStrokeWidth: 12,
                                          legendOptions: const LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: false,
                                            legendShape: BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          chartValuesOptions:
                                              const ChartValuesOptions(
                                            showChartValueBackground: false,
                                            chartValueStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            showChartValues: false,
                                            showChartValuesInPercentage: true,
                                            showChartValuesOutside: false,
                                          ),
                                        ),
                                        getVerticalSpace(5.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 12.h,
                                                  height: 12.h,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF009847),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.h),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.h)),
                                                ),
                                                getHorizontalSpace(5.h),
                                                getCustomFont(
                                                    (locationList[locationIndex]
                                                                .online ==
                                                            ""
                                                        ? ''
                                                        : locationList[
                                                                locationIndex]
                                                            .online),
                                                    11.sp,
                                                    AppColors.textBlackColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                            getHorizontalSpace(10.h),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 12.h,
                                                  height: 12.h,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFFBC00),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.h),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.h)),
                                                ),
                                                getHorizontalSpace(5.h),
                                                getCustomFont(
                                                    (locationList[locationIndex]
                                                                .highLatency ==
                                                            ""
                                                        ? ''
                                                        : locationList[
                                                                locationIndex]
                                                            .highLatency),
                                                    11.sp,
                                                    AppColors.textBlackColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                            getHorizontalSpace(10.h),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 12.h,
                                                  height: 12.h,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFE10000),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.h),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.h)),
                                                ),
                                                getHorizontalSpace(5.h),
                                                getCustomFont(
                                                    (locationList[locationIndex]
                                                                .offline ==
                                                            ""
                                                        ? ''
                                                        : locationList[
                                                                locationIndex]
                                                            .offline),
                                                    11.sp,
                                                    AppColors.textBlackColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                            getHorizontalSpace(10.h),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 12.h,
                                                  height: 12.h,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF000000),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.h),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.h)),
                                                ),
                                                getHorizontalSpace(5.h),
                                                getCustomFont(
                                                    (locationList[locationIndex]
                                                                .notMonitored ==
                                                            ""
                                                        ? ''
                                                        : locationList[
                                                                locationIndex]
                                                            .notMonitored),
                                                    11.sp,
                                                    AppColors.textBlackColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                          ],
                                        ),
                                        getVerticalSpace(10.h),
                                        getCustomFont(
                                            locationList[locationIndex]
                                                .locationName,
                                            11.sp,
                                            AppColors.textBlackColor,
                                            1,
                                            fontWeight: FontWeight.w500,
                                            textOverflow:
                                                TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
            ]),
          ),
        ],
      ),
    );
  }
}
