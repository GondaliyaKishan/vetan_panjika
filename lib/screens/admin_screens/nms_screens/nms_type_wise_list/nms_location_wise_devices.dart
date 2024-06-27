import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/screens/admin_screens/nms_screens/nms_single_details_screens/nms_device_details_page.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/nms_models/nms_filter_models/nms_device_type_filter_model.dart';
import '../../../../model/nms_models/nms_type_wise_list_models/nms_location_wise_devices_model.dart';

class NMSLocationWiseDevices extends StatefulWidget {
  final String locationId;
  const NMSLocationWiseDevices({Key? key, required this.locationId}) : super(key: key);

  @override
  State<NMSLocationWiseDevices> createState() => _NMSLocationWiseDevicesState();
}

class _NMSLocationWiseDevicesState extends State<NMSLocationWiseDevices> {

  String? filterDefault;
  String token = "";
  List<NMSDeviceTypeFilterDataModel> hostFilters = [];
  List<NMSLocationWiseDevicesDataModel> deviceData = [];
  bool showLoader = true;
  String noDataMessage = '';

  getFilter() {
    var apiController = ApiController();
    apiController.getNmsDeviceTypeFilter().then((value) {
      if (value != null) {
        List<NMSDeviceTypeFilterDataModel> deviceTypeFilterData = [];
        for (var data in value.data) {
          deviceTypeFilterData.add(data);
        }
        hostFilters = deviceTypeFilterData;
      }
      setState(() {});
    });
  }

  String deviceTypeId = "0";
  getLocationWiseDevices() {
    Future.delayed(const Duration(seconds: 2));
    var apiController = ApiController();
    deviceData = [];
    apiController.getNmsLocationWiseDevicesData(locationId: widget.locationId, deviceTypeId: deviceTypeId).then((value) {
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
  void initState() {
    super.initState();
    getFilter();
    getLocationWiseDevices();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Location Wise Devices", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.black,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 700));
            getFilter();
            getLocationWiseDevices();
          },
          child: ListView(
            children: [
              Container(
                margin:
                const EdgeInsets.only(top: 15, bottom: 7, left: 7, right: 7),
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
                      hint: const Text('Filter by Device Type'),
                      onChanged: (String? value) {
                        setState(() {
                          filterDefault = value!;
                          deviceTypeId = value;
                          showLoader = true;
                        });
                        getLocationWiseDevices();
                      },
                      items: hostFilters.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.typeName),
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
                            )).then((value) => setState(() {}));
                      },
                      child: ListTile(
                        leading: Text(
                          '${(deviceIndex == 0 ? 0 : deviceIndex) + 1}.',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        title: Text(
                            (deviceData[deviceIndex].deviceName == "" ? '' : deviceData[deviceIndex].deviceName),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        subtitle: Text(
                            'Type: ${(deviceData[deviceIndex].typeName == "" ? '' : deviceData[deviceIndex].typeName)}' '\nIP: ${(deviceData[deviceIndex].ipAddress == "" ? '' : deviceData[deviceIndex].ipAddress).toString()}'),
                        trailing: Text(
                          (deviceData[deviceIndex].status == "" ? '' : deviceData[deviceIndex].status) == "Critical"
                              ? "High Latency"
                              : (deviceData[deviceIndex].status == "" ? '' : deviceData[deviceIndex].status) == "NotMonitored"
                              ? "Not Monitored"
                              : (deviceData[deviceIndex].status == "" ? '' : deviceData[deviceIndex].status),
                          style: TextStyle(
                            fontSize: 16,
                            color: (deviceData[deviceIndex].status == 'Online')
                                ? Colors.green
                                : deviceData[deviceIndex].status == 'Offline'
                                ? Colors.red
                                : deviceData[deviceIndex].status == 'NotMonitored'
                                ? Colors.grey
                                : Colors.orange,
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
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
