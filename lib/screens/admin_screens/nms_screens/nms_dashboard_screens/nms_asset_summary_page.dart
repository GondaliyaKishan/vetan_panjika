import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:pie_chart/pie_chart.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_filter_models/nms_agent_filter_model.dart';
import '../../../../model/nms_models/nms_filter_models/nms_device_type_filter_model.dart';
import '../../../../model/nms_models/nms_filter_models/nms_location_filter_model.dart';
import '../../../../utils/color_data.dart';
import '../../../../utils/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../utils/widget.dart';

class ChartData {
  final String x;
  final double y;
  final String color;

  ChartData(this.x, this.y, this.color);
}

class NMSAssetSummary extends StatefulWidget {
  const NMSAssetSummary({Key? key}) : super(key: key);

  @override
  State<NMSAssetSummary> createState() => _NMSAssetSummaryState();
}

class _NMSAssetSummaryState extends State<NMSAssetSummary> {
  String? locationDefault;
  String? deviceTypeDefault;
  String? agentDefault;
  List inventoryList = [];
  List<String> inventoryColorList = [];
  List inventoryCountList = [];
  List<NMSAgentFilterDataModel> agentList = [];
  List<NMSDeviceTypeFilterDataModel> deviceTypeList = [];
  List<NMSLocationFilterDataModel> locationList = [];
  String total = '';
  bool showLoader = true;
  String noDataMessage = '';
  int touchedIndex = 0;

  getAgentFilter() {
    var apiController = ApiController();
    apiController.getNmsAgentFilter().then((value) {
      if (value != null) {
        List<NMSAgentFilterDataModel> agentFilterData = [];
        for (var data in value.data) {
          agentFilterData.add(data);
        }
        agentList = agentFilterData;
      }
      setState(() {});
    });
  }

  getDeviceTypeFilter() {
    var apiController = ApiController();
    apiController.getNmsDeviceTypeFilter().then((value) {
      if (value != null) {
        List<NMSDeviceTypeFilterDataModel> deviceTypeFilterData = [];
        for (var data in value.data) {
          deviceTypeFilterData.add(data);
        }
        deviceTypeList = deviceTypeFilterData;
      }
      setState(() {});
    });
  }

  getLocationFilter() {
    var apiController = ApiController();
    apiController.getNmsLocationFilter(agent).then((value) {
      if (value != null) {
        List<NMSLocationFilterDataModel> locationFilterData = [];
        for (var data in value.data) {
          locationFilterData.add(data);
        }
        locationList = locationFilterData;
      }
      setState(() {});
    });
  }

  String location = '0';
  String deviceType = '0';
  String agent = '0';

  getInventory() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    apiController
        .getNmsAssetSummaryData(
            agentId: agent, deviceTypeId: deviceType, locationId: location)
        .then((value) {
      if (value != null) {
        inventoryList = [];
        List<String>? colorList = [];
        inventoryCountList = [];
        for (var data in value.data) {
          inventoryList = data.typeNames;
          colorList = data.typeColors.cast<String>();
          inventoryCountList = data.countValues;
        }
        for (int i = 0; i < colorList!.length; i++) {
          inventoryColorList.add(colorList[i].toString());
        }
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getAgentFilter();
    getDeviceTypeFilter();
    getLocationFilter();
    getInventory();
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
    List<ChartData> chartData = [
      // ChartData("hello world", 10, "000000"),
      // ChartData("hello world", 14, "000000"),
      // ChartData("hello world", 15, "000000"),
      // ChartData("hello world", 2, "000000"),
      // ChartData("hello world", 20, "000000"),
      // ChartData("hello world", 5, "000000"),
      // ChartData("hello world", 15, "000000"),
      // ChartData("hello world", 25, "000000"),
      // ChartData("hello world", 9, "000000"),
      // ChartData("hello world", 18, "000000"),
    ];
    for (int i = 0; i < inventoryList.length; i++) {
      chartData.add(ChartData(
        '${inventoryList[i]}',
        double.parse(inventoryCountList[i]),
        inventoryColorList[i],
      ));
    }
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
                      getCustomFont("Asset Summary", 20.sp, Colors.white, 1,
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
                getAgentFilter();
                getDeviceTypeFilter();
                getInventory();
              },
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(
                                      "Agent", 12.sp, Color(0xFF868686), 1,
                                      fontWeight: FontWeight.w400),
                                  getVerticalSpace(2.h),
                                  Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.h),
                                        border: Border.all(
                                            color: Color(0xFFEDEDED),
                                            width: 1.h)),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: agentDefault,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 9.h),
                                          isExpanded: true,
                                          elevation: 2,
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14.sp,
                                              fontFamily: Constant.fontFamily,
                                              fontWeight: FontWeight.w500),
                                          icon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.h),
                                              child: getAssetImage(
                                                  "bottom.png", 10.h, 14.h)),
                                          hint: getCustomFont("All", 14.sp,
                                              AppColors.blackColor, 1,
                                              fontWeight: FontWeight.w500),
                                          onChanged: (String? value) {
                                            setState(() {
                                              agentDefault = value!;
                                              agent = value;
                                              showLoader = true;
                                            });
                                            getLocationFilter();
                                            getInventory();
                                          },
                                          items: agentList.map((item) {
                                            return DropdownMenuItem(
                                              child: Text(item.agentName,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 14.sp,
                                                      fontFamily:
                                                          Constant.fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500)),
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
                            getHorizontalSpace(15.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(
                                      "Location", 12.sp, Color(0xFF868686), 1,
                                      fontWeight: FontWeight.w400),
                                  getVerticalSpace(2.h),
                                  Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.h),
                                        border: Border.all(
                                            color: Color(0xFFEDEDED),
                                            width: 1.h)),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: locationDefault,
                                          isExpanded: true,
                                          elevation: 2,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 9.h),
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14.sp,
                                              fontFamily: Constant.fontFamily,
                                              fontWeight: FontWeight.w500),
                                          icon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.h),
                                              child: getAssetImage(
                                                  "bottom.png", 10.h, 14.h)),
                                          hint: getCustomFont("All", 14.sp,
                                              AppColors.blackColor, 1,
                                              fontWeight: FontWeight.w500),
                                          onChanged: (String? value1) {
                                            setState(() {
                                              locationDefault = value1!;
                                              location = value1;
                                              showLoader = true;
                                            });
                                            getInventory();
                                          },
                                          items: locationList.map((item) {
                                            return DropdownMenuItem(
                                              child: Text(item.locationName,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 14.sp,
                                                      fontFamily:
                                                          Constant.fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500)),
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
                            getHorizontalSpace(15.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(
                                      "Device", 12.sp, Color(0xFF868686), 1,
                                      fontWeight: FontWeight.w400),
                                  getVerticalSpace(2.h),
                                  Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.h),
                                        border: Border.all(
                                            color: Color(0xFFEDEDED),
                                            width: 1.h)),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: deviceTypeDefault,
                                          isExpanded: true,
                                          elevation: 2,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 9.h),
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14.sp,
                                              fontFamily: Constant.fontFamily,
                                              fontWeight: FontWeight.w500),
                                          icon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.h),
                                              child: getAssetImage(
                                                  "bottom.png", 10.h, 14.h)),
                                          hint: getCustomFont("All", 14.sp,
                                              AppColors.blackColor, 1,
                                              fontWeight: FontWeight.w500),
                                          onChanged: (String? value) {
                                            setState(() {
                                              deviceTypeDefault = value!;
                                              deviceType = value;
                                              showLoader = true;
                                            });
                                            getInventory();
                                          },
                                          items: deviceTypeList.map((item) {
                                            return DropdownMenuItem(
                                              child: Text(item.typeName,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 14.sp,
                                                      fontFamily:
                                                          Constant.fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              value: item.transNo.toString(),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
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
                        child: inventoryList.isEmpty
                            ? emptyDataWidget()
                            : Column(
                                children: [
                                  SfCircularChart(
                                      annotations: <CircularChartAnnotation>[
                                        CircularChartAnnotation(
                                          widget: Center(
                                            child: getCustomFont(
                                                "Total", 18.sp, Colors.black, 1,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                      series: <CircularSeries>[
                                        DoughnutSeries<ChartData, String>(
                                            dataSource: chartData,
                                            xValueMapper: (ChartData data, _) =>
                                                data.x,
                                            yValueMapper: (ChartData data, _) =>
                                                data.y,
                                            dataLabelMapper:
                                                (ChartData data, _) => data.x,
                                            radius: '50%',
                                            innerRadius: '70%',
                                            strokeColor: Colors.white,
                                            strokeWidth: 1.h,
                                            pointColorMapper:
                                                (ChartData data, _) =>
                                                    HexColor(data.color),
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    // builder: (data,
                                                    //     point,
                                                    //     series,
                                                    //     pointIndex,
                                                    //     seriesIndex) {
                                                    //   return Container(
                                                    //     padding: EdgeInsets
                                                    //         .symmetric(
                                                    //             vertical: 3.h,
                                                    //             horizontal:
                                                    //                 12.h),
                                                    //     decoration: BoxDecoration(
                                                    //         color: HexColor(
                                                    //                 data.color)
                                                    //             .withOpacity(
                                                    //                 0.05),
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     4.h),
                                                    //         border: Border.all(
                                                    //             color: HexColor(
                                                    //                 data.color),
                                                    //             width: 2.h)),
                                                    //     child: getCustomFont(
                                                    //         data.x,
                                                    //         10.h,
                                                    //         Colors.black,
                                                    //         1,
                                                    //         fontWeight:
                                                    //             FontWeight
                                                    //                 .w500),
                                                    //   );
                                                    // },
                                                    builder: (data,
                                                        point,
                                                        series,
                                                        pointIndex,
                                                        seriesIndex) {
                                                      return getCustomFont(
                                                          data.x,
                                                          10.h,
                                                          HexColor(data.color),
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis);
                                                    },
                                                    labelIntersectAction:
                                                        LabelIntersectAction
                                                            .none,
                                                    isVisible: true,
                                                    connectorLineSettings:
                                                        ConnectorLineSettings(
                                                      color: Colors.black,
                                                      type: ConnectorType.curve,
                                                      length: '40%',
                                                    ),
                                                    // Positioning the data label
                                                    labelPosition:
                                                        ChartDataLabelPosition
                                                            .outside))
                                      ]),
                                  // CustomPaint(
                                  //   size: Size(double.infinity, 350),
                                  //   painter: DoughnutChartPainter(
                                  //       chartData: chartData),
                                  // ),
                                  GridView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.h),
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: inventoryList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10.h,
                                            mainAxisExtent: 15.h),
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: HexColor(
                                                    inventoryColorList[index]),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.h),
                                                borderRadius:
                                                    BorderRadius.circular(3.h)),
                                            height: 12.h,
                                            width: 12.h,
                                          ),
                                          getHorizontalSpace(5.h),
                                          getCustomFont(
                                              "${inventoryList[index]}: ${inventoryCountList[index]}",
                                              10.sp,
                                              Colors.black.withOpacity(0.70),
                                              1,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      );
                                    },
                                  ),
                                  getVerticalSpace(20.h)
                                ],
                              ),
                      )
                    ],
                    primary: true,
                    shrinkWrap: false,
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

class DoughnutChartPainter extends CustomPainter {
  final List<ChartData> chartData;
  final double innerRadius;
  final double outerRadius;

  DoughnutChartPainter(
      {required this.chartData, this.innerRadius = 90, this.outerRadius = 110});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRadius - innerRadius;

    double total = chartData.fold(0, (sum, data) => sum + data.y);
    double startAngle = -90.0;

    for (var data in chartData) {
      final sweepAngle = (data.y / total) * 360;
      paint.color = HexColor(data.color).withOpacity(1.0);

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: outerRadius / 2),
        startAngle * 3.14 / 180,
        sweepAngle * 3.14 / 180,
        false,
        paint,
      );

      final labelAngle = (startAngle + sweepAngle / 2) * 3.14 / 200;
      final labelX =
          (size.width / 2) + (outerRadius + 150) / 2 * cos(labelAngle);
      final labelY =
          (size.height / 2) + (outerRadius + 150) / 2 * sin(labelAngle);

      _drawLabel(canvas, data.x, Offset(labelX, labelY), data.color);

      startAngle += sweepAngle;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset position, String color) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    final textOffset = Offset(
      position.dx - textPainter.width / 2,
      position.dy - textPainter.height / 2,
    );

    final paint = Paint()
      // ..color = Color(int.parse(color, radix: 16)).withOpacity(0.05)
      ..color = HexColor(color).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: position,
            width: textPainter.width + 10,
            height: textPainter.height + 5),
        Radius.circular(4),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: position,
            width: textPainter.width + 10,
            height: textPainter.height + 5),
        Radius.circular(4),
      ),
      Paint()
        // ..color = Color(int.parse(color, radix: 16))
        ..color = HexColor(color)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
