import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/screens/admin_screens/nms_screens/nms_single_details_screens/nms_agent_details_page.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_agent_list_model.dart';
import '../../../../utils/color_data.dart';
import '../../../../utils/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/widget.dart';

class NMSAgentPage extends StatefulWidget {
  const NMSAgentPage({Key? key}) : super(key: key);

  @override
  State<NMSAgentPage> createState() => _NMSAgentPageState();
}

class _NMSAgentPageState extends State<NMSAgentPage> {
  bool showLoader = true;

  List locationStatus = [];
  String upPercentage = "";
  String offlinePercentage = "";
  String criticalPercentage = "";
  String notManagedPercentage = "";
  List<NMSAgentListAgentDataModel> agentsData = [];
  String noDataMessage = '';

  getAgentsData() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    apiController.getNmsAgentsList().then((value) {
      if (value != null) {
        List<NMSAgentListDataPercentageModel> percentageData = [];
        List<NMSAgentListAgentDataModel> agentData = [];
        for (var data in value.data) {
          percentageData = data.percentage;
          agentData = data.agentData;
        }
        if (agentData.isNotEmpty) {
          agentsData = agentData;
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

  @override
  initState() {
    super.initState();
    getAgentsData();
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
                      getCustomFont("Agents", 20.sp, Colors.white, 1,
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
                  getAgentsData();
                },
                child: ListView(padding: EdgeInsets.zero, children: [
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
                    child: Column(children: [
                      Row(
                        children: [
                          getAssetImage("agent.png", 30.h, 30.h),
                          getHorizontalSpace(5.h),
                          getCustomFont(
                              "Agents Status", 16.sp, AppColors.blackColor, 1,
                              fontWeight: FontWeight.w600)
                        ],
                      ),
                      getVerticalSpace(12.h),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      getMultiLineFont(
                                          "${double.parse(criticalPercentage == "" ? '0.00' : criticalPercentage)}%",
                                          14.sp,
                                          Color(0xFFFFBC00),
                                          fontWeight: FontWeight.w600),
                                      getVerticalSpace(2.h),
                                      getMultiLineFont("High Latency", 11.sp,
                                          AppColors.textBlackColor,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.center)
                                    ],
                                  ),
                                  getHorizontalSpace(12.h),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        getMultiLineFont("Not Monitored", 11.sp,
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
                  (agentsData.isEmpty)
                      ? emptyDataWidget()
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return getVerticalSpace(15.h);
                          },
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: agentsData.length,
                          itemBuilder: (context, agentIndex) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NMSAgentDetails(
                                          agentId:
                                              agentsData[agentIndex].agentId),
                                    )).then((value) => setState(() {}));
                              },
                              child: Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getCustomFont(
                                            agentsData[agentIndex].agentName,
                                            14.sp,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w500),
                                        getVerticalSpace(3.h),
                                        Row(
                                          children: [
                                            Container(
                                              width: 32.h,
                                              height: 2.h,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.h)),
                                            ),
                                            getHorizontalSpace(4.h),
                                            Container(
                                              width: 8.h,
                                              height: 2.h,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.h)),
                                            )
                                          ],
                                        ),
                                        getVerticalSpace(8.h),
                                        getCustomFont(
                                            "Public IP: ${agentsData[agentIndex].publicIp}",
                                            12.sp,
                                            AppColors.greyTextColor,
                                            1,
                                            fontWeight: FontWeight.w400),
                                        getVerticalSpace(6.h),
                                        getCustomFont(
                                            "System IP: ${agentsData[agentIndex].systemIp}",
                                            12.sp,
                                            AppColors.greyTextColor,
                                            1,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    getCustomFont(
                                        "•  ${agentsData[agentIndex].status == "Critical" ? "High Latency" : agentsData[agentIndex].status == "NotMonitored" ? "Not Monitored" : agentsData[agentIndex].status}",
                                        14.sp,
                                        (agentsData[agentIndex].status ==
                                                'Online')
                                            ? Color(0xFF009847)
                                            : agentsData[agentIndex].status ==
                                                    'Offline'
                                                ? Color(0xFFE10000)
                                                : agentsData[agentIndex]
                                                            .status ==
                                                        'Critical'
                                                    ? Color(0xFFFFBC00)
                                                    : Colors.black,
                                        1,
                                        fontWeight: FontWeight.w600)
                                  ],
                                ),
                                // child: ListTile(
                                //   leading: Text(
                                //     '${agentIndex + 1}.',
                                //     style: const TextStyle(
                                //       fontSize: 18,
                                //     ),
                                //   ),
                                //   title: Text(agentsData[agentIndex].agentName,
                                //       style: const TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 16)),
                                //   subtitle: Text(
                                //       'Public IP:  ${agentsData[agentIndex].publicIp}'
                                //       '\n'
                                //       'System IP:  ${agentsData[agentIndex].systemIp}'),
                                //   trailing: Text(
                                //     agentsData[agentIndex].status == "Critical"
                                //         ? "High Latency"
                                //         : agentsData[agentIndex].status ==
                                //                 "NotMonitored"
                                //             ? "Not Monitored"
                                //             : agentsData[agentIndex].status,
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       color: (agentsData[agentIndex].status ==
                                //               'Online')
                                //           ? Colors.green
                                //           : agentsData[agentIndex].status ==
                                //                   'Offline'
                                //               ? Colors.red
                                //               : agentsData[agentIndex].status ==
                                //                       'Critical'
                                //                   ? Colors.orange
                                //                   : Colors.grey,
                                //     ),
                                //   ),
                                // ),
                              ),
                            );
                          },
                        ),
                ]),
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
