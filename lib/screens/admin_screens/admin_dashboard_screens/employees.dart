import 'package:flutter/material.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/admin_models/employees_model.dart';
import 'package:vetan_panjika/model/filters/branch_filter.dart';
import 'package:vetan_panjika/model/filters/device_filter.dart';
import '../../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  bool showFilters = false;
  String? branchDefault;
  String? deviceDefault;
  String? empType;
  String? empStatus;

  String noDataMsg = "";
  bool showLoader = true;

  List<AdminEmployeesModel> employeesList = [];

  List<BranchFilterModel> branchList = [];

  List<DeviceFilterModel> deviceList = [];

  List empTypeList = [
    {"name": "All", "value": 0},
    {"name": "Contract", "value": 1},
    {"name": "Permanent", "value": 2}
  ];

  List empStatusList = [
    {"name": "All", "value": 2},
    {"name": "Active", "value": 1},
    {"name": "Inactive", "value": 0}
  ];

  @override
  initState() {
    super.initState();
    getBranchFilter();
    getDeviceFilter();
    getEmployees();
  }

  getBranchFilter() {
    var apiController = ApiController();
    apiController.getBranchFilter().then((value) {
      if (value!.data.isNotEmpty) {
        setState(() {
          branchList = value.data;
        });
      }
    });
  }

  getDeviceFilter() {
    var apiController = ApiController();
    apiController.getDeviceFilter().then((value) {
      if (value!.data.isNotEmpty) {
        setState(() {
          deviceList = value.data;
        });
      }
    });
  }

  getEmployees() {
    var apiController = ApiController();
    var branchID = branchDefault == null
        ? ""
        : branchDefault == "0"
            ? ""
            : branchDefault;
    var deviceID = deviceDefault == null
        ? ""
        : deviceDefault == "0"
            ? ""
            : deviceDefault;
    var typeID = empType == null
        ? ""
        : empType == "0"
            ? ""
            : empType;
    var statusID = empStatus == null
        ? ""
        : empStatus == "2"
            ? ""
            : empStatus;
    apiController
        .getAdminEmployees(
            branchID: branchID ?? "",
            deviceID: deviceID ?? "",
            typeID: typeID ?? "",
            status: statusID ?? "")
        .then((value) {
      if (value != null) {
        employeesList = [];
        for (var employee in value.data) {
          employeesList.add(employee);
        }
      }
      if (employeesList.isEmpty) {
        noDataMsg = "No Employee to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Employees", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        // branch filter
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
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    size: 20),
                                value: branchDefault,
                                isExpanded: true,
                                elevation: 2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                iconSize: 25,
                                hint: const Text('Branch'),
                                onChanged: (value) {
                                  setState(() {
                                    branchDefault = value;
                                  });
                                  getEmployees();
                                },
                                items: branchList.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item.branchName.toString(),
                                      style: item.branchName == "Select Branch"
                                          ? theme.text14grey
                                          : theme.text14,
                                    ),
                                    value: item.id.toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        // device filter
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
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    size: 20),
                                value: deviceDefault,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                iconSize: 25,
                                hint: const Text('Device'),
                                onChanged: (value) {
                                  setState(() {
                                    deviceDefault = value;
                                  });
                                  getEmployees();
                                },
                                items: deviceList.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item.deviceName.toString(),
                                      style: item.deviceName == "Select Device"
                                          ? theme.text14grey
                                          : theme.text14,
                                    ),
                                    value: item.id.toString(),
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
                      // emp type filter
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
                              value: empType,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              isExpanded: true,
                              elevation: 2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              iconSize: 25,
                              hint: const Text('Type'),
                              onChanged: (String? value) {
                                setState(() {
                                  empType = value;
                                });
                                getEmployees();
                              },
                              items: empTypeList.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item["name"].toString()),
                                  value: item["value"].toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      // emp status filter
                      Container(
                        alignment: Alignment.centerRight,
                        width: size.width / 2.2,
                        height: 38,
                        margin: const EdgeInsets.only(
                            top: 7, bottom: 8, left: 7, right: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: empStatus,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              isExpanded: true,
                              elevation: 2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              iconSize: 25,
                              hint: const Text('Status'),
                              onChanged: (String? value) {
                                setState(() {
                                  empStatus = value;
                                });
                                getEmployees();
                              },
                              items: empStatusList.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item["name"].toString()),
                                  value: item["value"].toString(),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: employeesList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("${i + 1}.", style: theme.text16),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.6,
                                      child: Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: employeesList[i].empCode,
                                              style: theme.text16boldPrimary!
                                                  .copyWith(
                                                      color: Colors.black)),
                                          TextSpan(
                                            text: " | ",
                                            style: theme.text18bold,
                                          ),
                                          TextSpan(
                                              text: employeesList[i].name,
                                              style: theme.text16boldPrimary!
                                                  .copyWith(color: Colors.cyan))
                                        ]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: size.width * 0.61,
                                      child: Text(
                                          "Branch: " +
                                              employeesList[i].branchName +
                                              " | " +
                                              "Dept: " +
                                              employeesList[i].department,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.text14grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: FadeInImage(
                                image: AssetImage("assets/CS_userimg.png"),
                                placeholder:
                                    AssetImage("assets/CS_userimg.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                  child:
                      const SpinKitFadingCircle(color: Colors.cyan, size: 70))),
        ],
      ),
    );
  }
}
