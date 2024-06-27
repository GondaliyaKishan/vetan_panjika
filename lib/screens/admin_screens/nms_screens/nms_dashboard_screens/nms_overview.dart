import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetan_panjika/model/nms_models/nms_filter_models/nms_agent_filter_model.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_filter_models/nms_device_type_filter_model.dart';
import '../../../../model/nms_models/nms_filter_models/nms_location_filter_model.dart';
import '../../../../model/nms_models/nms_overview_model.dart';
import '../nms_single_details_screens/nms_device_details_page.dart';

class NMSOverview extends StatefulWidget {
  const NMSOverview({Key? key}) : super(key: key);

  @override
  State<NMSOverview> createState() => _NMSOverviewState();
}

class _NMSOverviewState extends State<NMSOverview> {
  bool showLoader = true;
  List<NMSOverviewDataIpsDataModel> ipsData = [];
  List inventoryData = [];
  List networkLocations = [];
  var upPercentage = "";
  var criticalPercentage = "";
  var offlinePercentage = "";
  var notManagedPercentage = "";
  String? locationDefault;
  String? hostDefault;
  String? agentDefault;
  List<NMSAgentFilterDataModel> agentList = [];
  List<NMSLocationFilterDataModel> locationList = [];
  List<NMSDeviceTypeFilterDataModel> deviceTypeList = [];
  bool showFilters = false;
  String noDataMessage = '';

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

  String location = "0";
  String deviceType = "0";
  String agent = "0";

  getOverviewData() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    ipsData = [];
    apiController
        .getNmsOverviewData(
            agentId: agent, deviceTypeId: deviceType, locationId: location)
        .then((value) {
      if (value != null) {
        List<NMSOverviewDataPercentageModel> percentageData = [];
        List<NMSOverviewDataIpsDataModel> ipsListData = [];
        for (var data in value.data) {
          percentageData = data.percentage;
          ipsListData = data.ipsData;
        }
        if (ipsListData.isNotEmpty) {
          ipsData = ipsListData;
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
    getAgentFilter();
    getDeviceTypeFilter();
    getLocationFilter();
    getOverviewData();
    getImgBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    List<String> alarms = [
      'Not Monitored',
      'Offline',
      'High Latency',
      'Online'
    ];
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Overview", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.cyan,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 700));
          getAgentFilter();
          getDeviceTypeFilter();
          getLocationFilter();
          getOverviewData();
        },
        child: Stack(
          children: [
            ListView(children: [
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (showFilters == true) {
                              showFilters = false;
                            } else {
                              showFilters = true;
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: 100,
                          margin: const EdgeInsets.only(top: 5, left: 7),
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Row(
                            children: const [
                              Text('Filters'),
                              Icon(Icons.filter_alt_outlined),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showFilters,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              // agent filter
                              Container(
                                width: size.width / 2.4,
                                height: 40,
                                margin: const EdgeInsets.only(
                                    top: 15, bottom: 8, left: 7, right: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      value: agentDefault,
                                      isExpanded: true,
                                      elevation: 2,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      iconSize: 25,
                                      hint: const Text('Agent'),
                                      onChanged: (String? value) {
                                        setState(() {
                                          agentDefault = value;
                                          agent = value!;
                                        });
                                        getLocationFilter();
                                        getOverviewData();
                                      },
                                      items: agentList.map((item) {
                                        return DropdownMenuItem(
                                          child:
                                              Text(item.agentName.toString()),
                                          value: item.transNo.toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              // location filter
                              Container(
                                alignment: Alignment.centerRight,
                                width: size.width / 2.2,
                                margin: const EdgeInsets.only(
                                    top: 15, bottom: 7, left: 7, right: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: locationDefault,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      iconSize: 25,
                                      hint: const Text('Location'),
                                      onChanged: (String? value) {
                                        setState(() {
                                          locationDefault = value;
                                          location = value!;
                                        });
                                        getOverviewData();
                                      },
                                      items: locationList.map((item) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              item.locationName.toString()),
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
                        Row(
                          children: [
                            // device type filter
                            Container(
                              width: size.width / 2.4,
                              height: 38,
                              margin: const EdgeInsets.only(
                                  top: 7, bottom: 8, left: 18, right: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    value: hostDefault,
                                    isExpanded: true,
                                    elevation: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    iconSize: 25,
                                    hint: const Text('Device'),
                                    onChanged: (String? value) {
                                      setState(() {
                                        hostDefault = value;
                                        deviceType = value!;
                                      });
                                      getOverviewData();
                                    },
                                    items: deviceTypeList.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(item.typeName.toString()),
                                        value: item.transNo.toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Row(children: const [
                      Text(
                        'Network  Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        PieChart(
                          dataMap: {
                            'Online:  ${(upPercentage == "" ? '' : upPercentage)}':
                                double.parse(
                                    upPercentage == "" ? '0.00' : upPercentage),
                            '': 100.00 -
                                double.parse(
                                    upPercentage == "" ? '0.00' : upPercentage)
                          },
                          animationDuration: const Duration(milliseconds: 1000),
                          chartLegendSpacing: 16,
                          chartRadius: size.width / 5,
                          colorList: const [Colors.green, Colors.black26],
                          initialAngleInDegree: 270,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 12,
                          centerText:
                              '${(upPercentage == "" ? '' : upPercentage)}%',
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
                            chartValueStyle:
                                TextStyle(fontSize: 16, color: Colors.black),
                            showChartValues: false,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(alarms[3])
                      ]),
                      Column(children: [
                        PieChart(
                          dataMap: {
                            'Critical:  ${(criticalPercentage == "" ? '' : criticalPercentage)}':
                                double.parse(criticalPercentage == ""
                                    ? '0.00'
                                    : criticalPercentage),
                            '': 100.00 -
                                double.parse(criticalPercentage == ""
                                    ? '0.00'
                                    : criticalPercentage)
                          },
                          animationDuration: const Duration(milliseconds: 1000),
                          chartLegendSpacing: 16,
                          chartRadius: size.width / 5,
                          colorList: const [Colors.orange, Colors.black26],
                          initialAngleInDegree: 270,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 12,
                          centerText:
                              '${(criticalPercentage == "" ? '' : criticalPercentage)}%',
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
                            chartValueStyle:
                                TextStyle(fontSize: 16, color: Colors.black),
                            showChartValues: false,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(alarms[2])
                      ]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        PieChart(
                          dataMap: {
                            'Online:  ${(offlinePercentage == "" ? '' : offlinePercentage)}':
                                double.parse(offlinePercentage == ""
                                    ? '0.00'
                                    : offlinePercentage),
                            '': 100.00 -
                                double.parse(offlinePercentage == ""
                                    ? '0.00'
                                    : offlinePercentage)
                          },
                          animationDuration: const Duration(milliseconds: 1000),
                          chartLegendSpacing: 16,
                          chartRadius: size.width / 5,
                          colorList: const [Colors.red, Colors.black26],
                          initialAngleInDegree: 270,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 12,
                          centerText:
                              '${(offlinePercentage == "" ? '' : offlinePercentage)}%',
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
                            chartValueStyle:
                                TextStyle(fontSize: 16, color: Colors.black),
                            showChartValues: false,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(alarms[1])
                      ]),
                      Column(children: [
                        PieChart(
                          dataMap: {
                            'Online:  ${(notManagedPercentage == "" ? '' : notManagedPercentage)}':
                                double.parse(notManagedPercentage == ""
                                    ? '0.00'
                                    : notManagedPercentage),
                            '': 100.00 -
                                double.parse(notManagedPercentage == ""
                                    ? '0.00'
                                    : notManagedPercentage)
                          },
                          animationDuration: const Duration(milliseconds: 1000),
                          chartLegendSpacing: 16.0,
                          chartRadius: size.width / 5,
                          colorList: const [Colors.black, Colors.black26],
                          initialAngleInDegree: 270.0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 12.0,
                          centerText:
                              '${(notManagedPercentage == "" ? '' : notManagedPercentage)}%',
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
                            chartValueStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            showChartValues: false,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(alarms[0]),
                      ]),
                    ],
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: (ipsData.isEmpty
                    ? Center(
                        child: SizedBox(
                          height: size.height / 3,
                          child: Center(
                            child: Text(
                              noDataMessage,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ipsData.length,
                        itemBuilder: (context, ipsIndex) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NMSDeviceDetails(
                                        deviceId: ipsData[ipsIndex].deviceId),
                                  )).then((value) => setState(() {
                                    getOverviewData();
                                  }));
                            },
                            child: ListTile(
                              leading: FadeInImage.assetNetwork(
                                image: '$baseUrl/assets/images/Devices/' +
                                    ipsData[ipsIndex].imageUrl,
                                placeholder: 'assets/SplashPlace.JPG',
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(ipsData[ipsIndex].deviceName),
                              subtitle: Text('${ipsData[ipsIndex].locationName}'
                                  '\n${ipsData[ipsIndex].ipAddress}'),
                              trailing: Text(
                                (ipsData[ipsIndex].status == "Critical"
                                    ? "High Latency"
                                    : ipsData[ipsIndex].status == "NotMonitored"
                                        ? "Not Monitored"
                                        : ipsData[ipsIndex].status),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: (ipsData[ipsIndex].status == 'Online')
                                      ? Colors.green
                                      : ipsData[ipsIndex].status == 'Offline'
                                          ? Colors.red
                                          : ipsData[ipsIndex].status ==
                                                  'HighLatency'
                                              ? Colors.orange
                                              : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      )),
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
    );
  }
}
