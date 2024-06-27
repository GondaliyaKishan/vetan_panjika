import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/filters/branch_filter.dart';
import 'package:vetan_panjika/model/filters/employee_filter.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_attendance_summary_date_wise.dart';
import '../../../../main.dart';

class AdminEmployeeWiseAttendance extends StatefulWidget {
  const AdminEmployeeWiseAttendance({Key? key}) : super(key: key);

  @override
  _AdminEmployeeWiseAttendanceState createState() =>
      _AdminEmployeeWiseAttendanceState();
}

class _AdminEmployeeWiseAttendanceState
    extends State<AdminEmployeeWiseAttendance> {
  bool showLoader = false;
  String noDataMsg = "";
  List attendanceSummary = [];
  List attendance = [];
  List attendanceData = [];
  String? branchDropdownValue;
  List<BranchFilterModel> branchDropdownItems = [];
  String? employeeDropdownValue;
  List<EmployeeFilterModel> employeeDropdownItems = [];

  // dropdown
  List monthList = [
    {"month": "January", "id": 1},
    {"month": "February", "id": 2},
    {"month": "March", "id": 3},
    {"month": "April", "id": 4},
    {"month": "May", "id": 5},
    {"month": "June", "id": 6},
    {"month": "July", "id": 7},
    {"month": "August", "id": 8},
    {"month": "September", "id": 9},
    {"month": "October", "id": 10},
    {"month": "November", "id": 11},
    {"month": "December", "id": 12},
  ];
  List yearList = [
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
    "2031",
    "2032",
    "2033",
    "2034",
    "2035",
    "2036",
    "2037",
    "2038",
    "2039",
    "2040"
  ];
  String? monthDropdown;
  String? yearDropdown;
  String selectedMonth = "";
  String selectedYear = "";

  // get month year now
  getMonthYear() async {
    var dateTime = DateTime.now().toUtc();
    selectedMonth = dateTime.month.toString();
    monthDropdown = selectedMonth;
    selectedYear = dateTime.year.toString();
    yearDropdown = selectedYear;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBranchFilter();
    getMonthYear();
  }

  // get branch filters
  getBranchFilter() {
    var apiController = ApiController();
    apiController.getBranchFilter().then((value) {
      if (value!.data.isNotEmpty) {
        for (var data in value.data) {
          branchDropdownItems.add(data);
        }
      }
      if (branchDropdownItems.isNotEmpty) {
        setState(() {});
      }
    });
  }

  // get employee filters
  getEmployeeFilter(String newValue) {
    var apiController = ApiController();
    apiController.getEmployeeFilter(branchId: newValue).then((value) {
      if (value!.data.isNotEmpty) {
        for (var data in value.data) {
          employeeDropdownItems.add(data);
        }
      }
      if (employeeDropdownItems.isNotEmpty) {
        setState(() {});
      }
    });
  }

  // get employee wise report
  getEmployeeWiseReport() {
    var apiController = ApiController();
    apiController
        .getEmployeeWiseReport(
            employeeId: employeeDropdownValue!,
            month: selectedMonth,
            year: selectedYear)
        .then((value) {
      if (value != null) {
        attendance = [];
        for (var data in value.data) {
          attendance.add(data);
        }
      }
      if (attendance.isNotEmpty) {
        attendanceSummary = attendance[0].summary;
        attendanceData = attendance[0].logs;
      }
      if (attendanceSummary.isEmpty) {
        noDataMsg = "No Logs to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Employee Wise Attendance",
          style: theme.text20,
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(10),
            children: [
              // search island
              Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Search",
                              style: theme.text20!.copyWith(
                                  height: 1.2, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // branch filter
                          Container(
                            width: size.width / 2.6,
                            height: 38,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String?>(
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      size: 20),
                                  value: branchDropdownValue,
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
                                      branchDropdownValue = value;
                                    });
                                    if (value! != "0") {
                                      getEmployeeFilter(value);
                                    }
                                  },
                                  items: branchDropdownItems.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        item.branchName.toString(),
                                        style:
                                            item.branchName == "Select Branch"
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
                          const SizedBox(width: 10),
                          // employee filter
                          Container(
                            width: size.width / 2.6,
                            height: 38,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String?>(
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      size: 20),
                                  value: employeeDropdownValue,
                                  isExpanded: true,
                                  elevation: 2,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconSize: 25,
                                  hint: const Text('Employee'),
                                  onChanged: (value) {
                                    setState(() {
                                      employeeDropdownValue = value;
                                    });
                                  },
                                  items: employeeDropdownItems.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        item.employeeName.toString(),
                                        style: item.employeeName ==
                                                "Select Employee"
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // month filter
                          Container(
                            width: size.width / 2.6,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: monthDropdown,
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      size: 20),
                                  isExpanded: true,
                                  elevation: 2,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconSize: 25,
                                  hint: const Text('Month'),
                                  onChanged: (String? value) {
                                    setState(() {
                                      monthDropdown = value;
                                      selectedMonth = value!;
                                    });
                                  },
                                  items: monthList.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item["month"].toString()),
                                      value: item["id"].toString(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // year filter
                          Container(
                            alignment: Alignment.centerRight,
                            width: size.width / 2.6,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String?>(
                                  value: yearDropdown,
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      size: 20),
                                  isExpanded: true,
                                  elevation: 2,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconSize: 25,
                                  hint: const Text('Year'),
                                  onChanged: (String? value) {
                                    setState(() {
                                      yearDropdown = value;
                                      selectedYear = value!;
                                    });
                                  },
                                  items: yearList.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item.toString()),
                                      value: item.toString(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              if (employeeDropdownValue != "" &&
                                  branchDropdownValue != "" &&
                                  selectedMonth != "" &&
                                  selectedYear != "") {
                                getEmployeeWiseReport();
                              }
                            },
                            minWidth: size.width * 0.3,
                            splashColor: Colors.cyan[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.cyan,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Search",
                              style: theme.text18white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // attendance log summary island
              attendanceSummary.isEmpty
                  ? Container()
                  : Material(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: attendanceSummary.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Summary",
                                          style: theme.text20!.copyWith(
                                              height: 1.2,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Table(
                                    children: [
                                      TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                        ),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Present",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[0]
                                                    .presentTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Absent",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[i]
                                                    .absentTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                        ),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Less Hours",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[0]
                                                    .lessHrsTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Week Off",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[i]
                                                    .weekOffTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                        ),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Punch Missing",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[0]
                                                    .punchMissingTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Half Day",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[i]
                                                    .halfDayTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                        ),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 5),
                                            child: Text("Late",
                                                style: theme.text14),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                                attendanceSummary[0].lateTotal,
                                                style: theme.text14bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              // attendance log island
              attendanceData.isEmpty
                  ? Container()
                  : Material(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: attendanceData.isEmpty
                            ? Row(
                                children: [
                                  Text(noDataMsg,
                                      style: theme.text20!.copyWith(
                                          height: 1.2,
                                          fontWeight: FontWeight.w500))
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Attendance",
                                          style: theme.text20!.copyWith(
                                              height: 1.2,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    color: Colors.grey[200],
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: attendanceData.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AttendanceSummaryDateWisePage(
                                                    isAdmin: true,
                                                    employeeId:
                                                        employeeDropdownValue!,
                                                    date: attendanceData[i]
                                                        .dateOld,
                                                    dateNew: attendanceData[i]
                                                        .dateNew,
                                                    day: "",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        attendanceData[i]
                                                            .dateNew,
                                                        style:
                                                            theme.text14bold),
                                                    const SizedBox(height: 3),
                                                    Text(attendanceData[i].day,
                                                        style: theme.text12grey!
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        attendanceData[i]
                                                            .status,
                                                        style:
                                                            theme.text14bold),
                                                    const SizedBox(height: 3),
                                                    Row(
                                                      children: [
                                                        Text("work hrs:  ",
                                                            style: theme
                                                                .text12grey!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black)),
                                                        Text(
                                                            attendanceData[i]
                                                                .duration,
                                                            style: theme
                                                                .text12grey!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    ),
                                  ),
                                ],
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
