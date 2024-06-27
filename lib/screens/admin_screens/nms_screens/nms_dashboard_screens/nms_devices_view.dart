import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_device_view_model.dart';
import '../../../../utils/color_data.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/widget.dart';
import '../nms_type_wise_list/nms_device_type_wise_devices.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NMSDeviceView extends StatefulWidget {
  const NMSDeviceView({Key? key}) : super(key: key);

  @override
  State<NMSDeviceView> createState() => _NMSDeviceViewState();
}

class _NMSDeviceViewState extends State<NMSDeviceView> {
  List hostsStatus = [];
  String upPercentage = "";
  String offlinePercentage = "";
  String criticalPercentage = "";
  String notManagedPercentage = "";
  List<NMSDeviceViewDeviceDataModel> hostList = [];
  String hostDefault = "";
  bool showLoader = true;
  String noDataMessage = '';
  String agentImg = "";

  getDevicesList() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    apiController.getNmsDeviceViewData().then((value) {
      if (value != null) {
        List<NMSDeviceViewDataPercentageModel> percentageData = [];
        List<NMSDeviceViewDeviceDataModel> deviceListData = [];
        for (var data in value.data) {
          percentageData = data.percentage;
          deviceListData = data.deviceData;
        }
        if (deviceListData.isNotEmpty) {
          hostList = deviceListData;
          agentImg = hostList[0].imageUrl;
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
    getDevicesList();
  }

  @override
  Widget build(BuildContext context) {
    List<NMSDeviceViewDeviceDataModel> sHostList = hostList;
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
                      getCustomFont("Devices", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
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
                  getDevicesList();
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
                            Row(
                              children: [
                                agentImg.isEmpty
                                    ? Container()
                                    : FadeInImage.assetNetwork(
                                        image:
                                            '$baseUrl/assets/images/Devices/$agentImg',
                                        placeholder: 'assets/SplashPlace.JPG',
                                        fit: BoxFit.fill,
                                        height: 30.h,
                                      ),
                                getHorizontalSpace(5.h),
                                getCustomFont("Devices Status", 16.sp,
                                    AppColors.blackColor, 1,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                            getVerticalSpace(10.h),
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
                          "Devices", 16.sp, AppColors.blackColor, 1,
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
                    if (sHostList.isEmpty && showLoader == false)
                      emptyDataWidget()
                    else
                      GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 124.h,
                            crossAxisSpacing: 16.h,
                            mainAxisSpacing: 16.h),
                        itemCount: sHostList.length,
                        itemBuilder: (context, hostIndex) {
                          return AnimationConfiguration.staggeredList(
                            position: hostIndex,
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
                                                    NMSDeviceTypeWiseDevices(
                                                      deviceTypeId:
                                                          sHostList[hostIndex]
                                                              .typeId,
                                                    )))
                                        .then((value) => setState(() {
                                              getDevicesList();
                                            }));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 15.h,
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
                                        FadeInImage.assetNetwork(
                                          image:
                                              '$baseUrl/assets/images/Devices/${sHostList[hostIndex].imageUrl}',
                                          placeholder: 'assets/SplashPlace.JPG',
                                          fit: BoxFit.fill,
                                          height: 40.h,
                                          width: 40.h,
                                        ),
                                        getVerticalSpace(10.h),
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
                                                    (sHostList[hostIndex]
                                                                .online ==
                                                            ""
                                                        ? ''
                                                        : sHostList[hostIndex]
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
                                                    (sHostList[hostIndex]
                                                                .highLatency ==
                                                            ""
                                                        ? ''
                                                        : sHostList[hostIndex]
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
                                                    (sHostList[hostIndex]
                                                                .offline ==
                                                            ""
                                                        ? ''
                                                        : sHostList[hostIndex]
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
                                                    (sHostList[hostIndex]
                                                                .notMonitored ==
                                                            ""
                                                        ? ''
                                                        : sHostList[hostIndex]
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
                                            sHostList[hostIndex].typeName,
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
