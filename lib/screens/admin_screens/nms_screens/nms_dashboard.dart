import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:vetan_panjika/model/nms_models/nms_dashboard_model.dart';
import 'package:vetan_panjika/screens/admin_screens/nms_screens/nms_dashboard_screens/nms_asset_summary_page.dart';
import 'package:vetan_panjika/screens/admin_screens/nms_screens/nms_dashboard_screens/nms_devices_view.dart';
import 'package:vetan_panjika/screens/admin_screens/nms_screens/nms_dashboard_screens/nms_location_view.dart';
import '../../../controllers/api_controller.dart';
import '../../../main.dart';
import '../../../utils/color_data.dart';
import '../../../utils/constant.dart';
import '../../../utils/widget.dart';
import 'nms_dashboard_screens/nms_agent_page.dart';
import 'nms_dashboard_screens/nms_overview.dart';
import 'nms_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NMSDashboard extends StatefulWidget {
  const NMSDashboard({Key? key}) : super(key: key);

  @override
  State<NMSDashboard> createState() => _NMSDashboardState();
}

class _NMSDashboardState extends State<NMSDashboard> {
  bool showLoader = true;

  String upPercentage = "";
  String offlinePercentage = "";
  String criticalPercentage = "";
  String notManagedPercentage = "";

  getDashboardData() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    apiController.getNmsDashboardData().then((value) {
      if (value != null) {
        List<NMSDashboardDataModel> dashboardData = [];
        for (var data in value.data) {
          dashboardData.add(data);
        }
        if (dashboardData.isNotEmpty) {
          upPercentage = dashboardData[0].upPercentage;
          offlinePercentage = dashboardData[0].offlinePercentage;
          criticalPercentage = dashboardData[0].criticalPercentage;
          notManagedPercentage = dashboardData[0].notManagedPercentage;
        }
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    getDashboardData();
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
                      getCustomFont("NMS", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.cyan,
              onRefresh: () async {
                setState(() {
                  showLoader = true;
                });
                getDashboardData();
              },
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      getVerticalSpace(20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NMSSearch(),
                              )).then((value) => setState(() {
                                getDashboardData();
                              }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6A6A6A).withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: Offset(0, 0))
                              ]),
                          padding: EdgeInsets.symmetric(horizontal: 9.h),
                          child: Row(
                            children: [
                              getAssetImage("search.png", 17.h, 17.h),
                              getHorizontalSpace(13.h),
                              getCustomFont(
                                  "Search", 14.sp, AppColors.greyTextColor, 1,
                                  fontWeight: FontWeight.w400)
                            ],
                          ),
                        ),
                      ),
                      getVerticalSpace(15.h),
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
                              getCustomFont("Network Status", 16.sp,
                                  AppColors.blackColor, 1,
                                  fontWeight: FontWeight.w600),
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
                                          double.parse(
                                              notManagedPercentage == ""
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
                                    chartValuesOptions:
                                        const ChartValuesOptions(
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
                                              getMultiLineFont(
                                                  "High Latency",
                                                  11.sp,
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
                                                    fontWeight:
                                                        FontWeight.w600),
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
                      getVerticalSpace(18.h),
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
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NMSOverview(),
                                          )).then((value) => setState(() {
                                            getDashboardData();
                                          }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "square.png", 15.h, 15.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Overview", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NMSAgentPage(),
                                          )).then((value) => setState(() {
                                            getDashboardData();
                                          }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img1.png", 18.h, 13.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Agents", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NMSLocationView(),
                                          )).then((value) => setState(() {
                                            getDashboardData();
                                          }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF009847),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF009847)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img2.png", 15.h, 11.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Locations", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            getVerticalSpace(20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NMSDeviceView(),
                                          )).then((value) => setState(() {
                                            getDashboardData();
                                          }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF582D15),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF582D15)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img3.png", 15.h, 21.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Devices", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NMSAssetSummary(),
                                          )).then((value) => setState(() {
                                            getDashboardData();
                                          }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFFBC00),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFFFBC00)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img4.png", 15.h, 15.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Asset Summary", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => Reports(),
                                      //     )).then((value) => setState(() {
                                      //   homePageList();
                                      // }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF1510FF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF1510FF)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img4.png", 15.h, 15.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Reports", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            getVerticalSpace(20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => FAQ(),
                                      //     )).then((value) => setState(() {
                                      //   homePageList();
                                      // }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF7A00),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFFF7A00)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img3.png", 15.h, 21.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("FAQ", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => AboutUs(),
                                      //     )).then((value) => setState(() {
                                      //   homePageList();
                                      // }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF004F98),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF004F98)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img4.png", 15.h, 15.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("About Us", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // _firebaseMessaging
                                      //     .unsubscribeFromTopic(fcmTopic)
                                      //     .whenComplete(
                                      //         () => print("Unsubscribed to Topic"));
                                      //
                                      // MySharedPreferences.instance
                                      //     .removeValue("email");
                                      // MySharedPreferences.instance
                                      //     .removeValue("TokenNo");
                                      // MySharedPreferences.instance
                                      //     .removeValue("UserName");
                                      // MySharedPreferences.instance
                                      //     .removeValue("FcmTopic");
                                      // MySharedPreferences.instance
                                      //     .removeValue("passLocked");
                                      //
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => Login(),
                                      //     ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.14)),
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                      padding: EdgeInsets.only(
                                          top: 12.h, bottom: 17.h),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 30.h,
                                              width: 30.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFE10000),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFE10000)
                                                          .withOpacity(0.37),
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              alignment: Alignment.center,
                                              child: getAssetImage(
                                                  "img4.png", 15.h, 15.h)),
                                          getVerticalSpace(5.h),
                                          getCustomFont("Logout", 11.sp,
                                              AppColors.textBlackColor, 1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
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
                              color: Colors.cyan, size: 70.0))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
