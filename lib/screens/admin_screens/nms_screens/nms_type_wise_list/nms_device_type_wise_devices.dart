import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_filter_models/nms_agent_filter_model.dart';
import '../../../../model/nms_models/nms_filter_models/nms_location_filter_model.dart';
import '../../../../model/nms_models/nms_type_wise_list_models/nms_device_type_wise_devices_model.dart';
import '../nms_single_details_screens/nms_device_details_page.dart';

class NMSDeviceTypeWiseDevices extends StatefulWidget {
  final String deviceTypeId;
  const NMSDeviceTypeWiseDevices({Key? key, required this.deviceTypeId}) : super(key: key);

  @override
  State<NMSDeviceTypeWiseDevices> createState() => _NMSDeviceTypeWiseDevicesState();
}

class _NMSDeviceTypeWiseDevicesState extends State<NMSDeviceTypeWiseDevices> {

  String? filterDefault;
  String token = "";
  List<NMSLocationFilterDataModel> locationFilters = [];
  List<NMSDeviceTypeDevicesDataModel> deviceData = [];
  bool showLoader = true;
  String noDataMessage = '';
  List<NMSAgentFilterDataModel> agentFilters = [];
  String? agentDefault;
  String agentId = "0";

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

  getLocationFilter() {
    var apiController = ApiController();
    apiController.getNmsLocationFilter(agentId).then((value) {
      if (value != null) {
        List<NMSLocationFilterDataModel> locationFilterData = [];
        for (var data in value.data) {
          locationFilterData.add(data);
        }
        locationFilters = locationFilterData;
      }
      setState(() {});
    });
  }

  String locationId = "0";
  getDeviceTypeWiseDevices() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    deviceData = [];
    apiController.getNmsDeviceTypeWiseDevicesData(agentId: agentId, locationId: locationId, deviceTypeId: widget.deviceTypeId).then((value) {
      if (value != null) {
        for (var data in value.data) {
          deviceData.add(data);
        }
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    getAgentFilter();
    getLocationFilter();
    getDeviceTypeWiseDevices();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("DeviceType Wise Devices", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.black,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 700));
            getAgentFilter();
            getLocationFilter();
            getDeviceTypeWiseDevices();
          },
          child: ListView(children: [
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 7, left: 7, right: 7),
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
                    hint: const Text('Filter by Agent'),
                    onChanged: (String? value) {
                      setState(() {
                        agentDefault = value!;
                        agentId = value;
                        showLoader = true;
                      });
                      getDeviceTypeWiseDevices();
                    },
                    items: agentFilters.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.agentName),
                        value: item.transNo.toString(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 7, left: 7, right: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: filterDefault,
                    isExpanded: true,
                    elevation: 2,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    iconSize: 25,
                    hint: const Text('Filter by Location'),
                    onChanged: (String? value) {
                      setState(() {
                        filterDefault = value!;
                        locationId = value;
                        showLoader = true;
                      });
                      getDeviceTypeWiseDevices();
                    },
                    items: locationFilters.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.locationName),
                        value: item.transNo.toString(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: (deviceData.isEmpty
                  ? Center(
                child: SizedBox(
                    height: size.height / 1.4,
                    child: Center(
                      child: Text(
                        noDataMessage,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: deviceData.length,
                itemBuilder: (context, deviceIndex) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NMSDeviceDetails(
                              deviceId: deviceData[deviceIndex].deviceId
                                  .toString(),
                            ),
                          )).then((value) => setState(() {
                            getDeviceTypeWiseDevices();
                      }));
                    },
                    child: ListTile(
                      leading: Text(
                        '${deviceIndex + 1}.',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      title: Text(
                        deviceData[deviceIndex].deviceName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                          'Location: ${deviceData[deviceIndex].locationName}' '\nIP: ${deviceData[deviceIndex].ipAddress}'),
                      trailing: Text(
                        deviceData[deviceIndex].status == "Critical"
                            ? "High Latency"
                            : deviceData[deviceIndex].status == "NotMonitored"
                            ? "Not Monitored"
                            : deviceData[deviceIndex].status,
                        style: TextStyle(
                          fontSize: 16,
                          color: (deviceData[deviceIndex].status == 'Online')
                              ? Colors.green
                              : deviceData[deviceIndex].status == 'Offline'
                              ? Colors.red
                              : deviceData[deviceIndex].status == 'Not Monitored'
                              ? Colors.grey
                              : Colors.orange,
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
          ]),
        ),
        Visibility(
            visible: showLoader,
            child: Container(
                width: size.width,
                height: size.height,
                color: Colors.white70,
                child: const SpinKitFadingCircle(color: Colors.cyan, size: 70))),
      ]),
    );
  }
}
