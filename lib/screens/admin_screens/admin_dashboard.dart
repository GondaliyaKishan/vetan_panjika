import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/admin_models/admin_dashboard_model.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/devices.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/employees.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/holiday.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/late_comers.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard_screens/shifts.dart';
import 'package:vetan_panjika/screens/admin_screens/attendance_new_screen.dart';
import 'package:vetan_panjika/screens/admin_screens/new_access_controll_screen.dart';
import 'package:vetan_panjika/screens/admin_screens/new_sales_desk_screen.dart';
import 'package:vetan_panjika/screens/admin_screens/new_support_desk_screen.dart';
import 'package:vetan_panjika/screens/admin_screens/nms_screens/nms_dashboard.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import 'package:vetan_panjika/widgets/card_heading.dart';
import '../../main.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:vetan_panjika/user/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'admin_dashboard_screens/admin_access_control/ac_devices.dart';
import 'admin_dashboard_screens/admin_attendance_report.dart';
import 'admin_dashboard_screens/branches.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String date = "";
  bool showLoader = true;
  String noDataMsg = "";

  var deviceTotal = "";
  var deviceUpPercentage = "";
  var deviceUpCount = "";
  var deviceCriticalPercentage = "";
  var deviceCriticalCount = "";
  var deviceOfflinePercentage = "";
  var deviceOfflineCount = "";
  var deviceNotManagedPercentage = "";
  var deviceNotManagedCount = "";
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String totalEmployees = "";
  List<AdminDashboardLogsModel> attendance = [];
  List<AttendanceLogs> attendanceTitleColor = [];
  List<LeaveRequestsModel> leaveRequestsList = [];
  List<ExpenseDataModel> expenseDataList = [];
  String logo = "";
  List menu = [
    {
      "name": "Branches",
      "color": Colors.red[400],
      "icon": Icons.apartment,
      "route": const Branches()
    },
    {
      "name": "Devices",
      "color": Colors.cyan[400],
      "icon": Icons.devices,
      "route": const Devices()
    },
    {
      "name": "Employees",
      "color": Colors.amber[800],
      "icon": Icons.supervised_user_circle_outlined,
      "route": const Employees()
    },
    {
      "name": "Holiday",
      "color": Colors.green[500],
      "icon": Icons.holiday_village,
      "route": const Holiday()
    },
    {
      "name": "Late Comers",
      "color": Colors.indigo[500],
      "icon": Icons.run_circle_outlined,
      "route": const LateComers()
    },
    {
      "name": "Shifts",
      "color": Colors.purple[400],
      "icon": Icons.access_alarms_rounded,
      "route": const Shifts()
    },
  ];

  @override
  void initState() {
    super.initState();
    getDateOnly();
    getUser();
    getDashboardData();
    getDevicesData();
    getLeavesData();
    getExpensesData();
  }

  getDateOnly() {
    DateTime today = DateTime.now();
    var inputFormat = DateFormat("EEE, MMM d, yyyy");
    date = inputFormat.format(today);
    showLoader = false;
  }

  String _user = "";
  String _companyName = "";

  getUser() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    _user = shared.getString("employee_name") ?? "";
    _companyName = shared.getString("company_name") ?? "";
    logo = shared.getString("logo") ?? "";
    setState(() {});
  }

  getDashboardData() {
    var apiController = ApiController();
    apiController.getAdminDashboard().then((value) {
      if (value != null) {
        attendance = [];
        for (var data in value.data) {
          attendance.add(data);
        }
      }
      if (attendance.isNotEmpty) {
        totalEmployees = attendance[0].totalEmployees;
        attendanceTitleColor = [
          AttendanceLogs(
              title: "Present",
              color: Colors.green,
              count: attendance[0].presentTotal),
          AttendanceLogs(
              title: "On Time",
              color: Colors.teal,
              count: attendance[0].onTimeTotal),
          AttendanceLogs(
              title: "Absent",
              color: Colors.red,
              count: attendance[0].absentTotal),
          AttendanceLogs(
              title: "Less Hours",
              color: Colors.cyan,
              count: attendance[0].lessHrsTotal),
          AttendanceLogs(
              title: "Week Off",
              color: Colors.amber,
              count: attendance[0].weekOffTotal),
          AttendanceLogs(
              title: "Punch Missing",
              color: Colors.blue,
              count: attendance[0].punchMissingTotal),
          AttendanceLogs(
              title: "Half Day",
              color: Colors.pink,
              count: attendance[0].halfDayTotal),
          AttendanceLogs(
              title: "Late",
              color: Colors.purple,
              count: attendance[0].lateTotal),
        ];
      }
      if (attendance.isEmpty) {
        noDataMsg = "No Entry to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  getDevicesData() {
    var apiController = ApiController();
    apiController.getAdminDashboardDevicesData().then((value) {
      if (value != null) {
        deviceTotal = value.data[0].deviceTotal.split(".")[0];
        deviceUpPercentage = value.data[0].onlinePercent;
        deviceUpCount = value.data[0].onlineCount;
        deviceOfflinePercentage = value.data[0].offlinePercent;
        deviceOfflineCount = value.data[0].offlineCount;
        deviceCriticalPercentage = value.data[0].highLatencyPercent;
        deviceCriticalCount = value.data[0].highLatencyCount;
        deviceNotManagedPercentage = value.data[0].notMonitoredPercent;
        deviceNotManagedCount = value.data[0].notMonitoredCount;
      }
      showLoader = false;
      setState(() {});
    });
  }

  getLeavesData() {
    var apiController = ApiController();
    apiController.getAdminDashboardLeavesData().then((value) {
      if (value != null) {
        leaveRequestsList = [
          LeaveRequestsModel(
            title: "Approved",
            color: Colors.green,
            count: value.data[0].approved,
          ),
          LeaveRequestsModel(
            title: "Pending",
            color: Colors.orange,
            count: value.data[0].pending,
          ),
          LeaveRequestsModel(
            title: "Rejected",
            color: Colors.red,
            count: value.data[0].rejected,
          ),
        ];
      }
      showLoader = false;
      setState(() {});
    });
  }

  getExpensesData() {
    var apiController = ApiController();
    apiController.getAdminDashboardExpensesData().then((value) {
      if (value != null) {
        expenseDataList = [
          ExpenseDataModel(
            title: "Approved",
            color: Colors.yellow,
            count: value.data[0].approved,
          ),
          ExpenseDataModel(
            title: "Pending",
            color: Colors.orange,
            count: value.data[0].pending,
          ),
          ExpenseDataModel(
            title: "Rejected",
            color: Colors.red,
            count: value.data[0].rejected,
          ),
          ExpenseDataModel(
            title: "Paid",
            color: Colors.green,
            count: value.data[0].paid,
          ),
        ];
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getUser();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness:
          Brightness.dark, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        key: _key,
        backgroundColor: Color(0xFFF6FBFF),
        // appBar: AppBar(
        //   title: Text("Office Manager", style: theme.text20),
        //   backgroundColor: Colors.white,
        // ),
        drawer: Drawer(
          child: Container(
            color: HexColor("#1b2631"),
            child: ListView(shrinkWrap: true, children: [
              Container(
                padding: const EdgeInsets.only(bottom: 11),
                height: 70,
                child: ListTile(
                  title: Text(
                    _user,
                    maxLines: 1,
                    style: theme.text18bold!.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    _companyName,
                    maxLines: 1,
                    style: theme.text12grey!.copyWith(color: Colors.white),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: logo == ""
                          ? const FadeInImage(
                              image: AssetImage("assets/OM_icon.png"),
                              width: 35,
                              height: 40,
                              placeholder: AssetImage("assets/OM_icon.png"),
                              fit: BoxFit.contain,
                            )
                          : FadeInImage(
                              image: NetworkImage(logo),
                              width: 42,
                              height: 47,
                              placeholder:
                                  const AssetImage("assets/OM_icon.png"),
                              fit: BoxFit.contain,
                            ),
                    ),
                    radius: 23,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white70,
                height: 1.0,
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    leading: Image.asset(
                      "assets/Attendance.png",
                      height: 25,
                      width: 25,
                    ),
                    title: const Text(
                      "Attendance",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AttendanceReports(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  ListTile(
                    leading: Image.asset(
                      "assets/Access_control.png",
                      height: 25,
                      width: 25,
                    ),
                    title: const Text(
                      "Access Control",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ACDevices(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                  ListTile(
                    leading: Image.asset(
                      "assets/leave_management.png",
                      height: 25,
                      width: 25,
                    ),
                    title: const Text(
                      "Leaves",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => const Devices(),
                      //   ),
                      // );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  ListTile(
                    leading: Image.asset(
                      "assets/Expences.png",
                      height: 25,
                      width: 25,
                    ),
                    title: const Text(
                      "Expenses",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => const Employees(),
                      //   ),
                      // );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                  // ListTile(
                  //   leading: Image.asset("assets/HR_management.png", height: 25, width: 25,),
                  //   title: const Text(
                  //     "HR",
                  //     style: TextStyle(color: Colors.white, fontSize: 15),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigator.push(
                  //     //   context,
                  //     //   CupertinoPageRoute(
                  //     //     builder: (context) => const Holiday(),
                  //     //   ),
                  //     // );
                  //   },
                  // ),
                  // const Divider(
                  //   color: Colors.white,
                  //   height: 1,
                  // ),
                  ListTile(
                    leading: Image.asset(
                      "assets/NMS.png",
                      height: 25,
                      width: 25,
                    ),
                    title: const Text(
                      "NMS",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NMSDashboard(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                  // ListTile(
                  //   leading: Image.asset("assets/books.png", height: 25, width: 25,),
                  //   title: const Text(
                  //     "Books",
                  //     style: TextStyle(color: Colors.white, fontSize: 15),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigator.push(
                  //     //   context,
                  //     //   CupertinoPageRoute(
                  //     //     builder: (context) => const Shifts(),
                  //     //   ),
                  //     // );
                  //   },
                  // ),
                  // const Divider(
                  //   color: Colors.white,
                  //   height: 1,
                  // ),
                  // ListTile(
                  //   leading: Image.asset("assets/crm.png", height: 25, width: 25,),
                  //   title: const Text(
                  //     "CRM",
                  //     style: TextStyle(color: Colors.white, fontSize: 15),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigator.push(
                  //     //   context,
                  //     //   CupertinoPageRoute(
                  //     //     builder: (context) => const Shifts(),
                  //     //   ),
                  //     // );
                  //   },
                  // ),
                  // const Divider(
                  //   color: Colors.white,
                  //   height: 1,
                  // ),
                  ListTile(
                    leading: Image.asset(
                      "assets/settings.png",
                      height: 25,
                      width: 25,
                    ),
                    title: const Text(
                      "Server Settings",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => const Shifts(),
                      //   ),
                      // );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      SharedPreferences shared =
                          await SharedPreferences.getInstance();
                      shared.setString("access_token", "");
                      shared.setString("profile_base64", "");
                      shared.setString("employee_name", "");
                      shared.setString("user_email", "");
                      shared.setString("logo", "");
                      shared.setString("company_name", "");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ]),
          ),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15.h,
                        offset: Offset(0, 0))
                  ],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(32.h))),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 52.h, bottom: 25.h, left: 20.h, right: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: getAssetImage("menu.png", 18.h, 22.h),
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                        ),
                        getHorizontalSpace(13.h),
                        Container(
                          height: 38.h,
                          width: 38.h,
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: logo == ""
                                  ? FadeInImage(
                                      image: AssetImage("assets/OM_icon.png"),
                                      width: 38.h,
                                      height: 38.h,
                                      placeholder:
                                          AssetImage("assets/OM_icon.png"),
                                      fit: BoxFit.contain,
                                    )
                                  : FadeInImage(
                                      image: NetworkImage(logo),
                                      width: 38.h,
                                      height: 38.h,
                                      placeholder:
                                          AssetImage("assets/OM_icon.png"),
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                        ),
                        getHorizontalSpace(10.h),
                        getCustomFont(_user, 20.sp, Colors.black, 1,
                            fontWeight: FontWeight.w600)
                      ],
                    ),
                    getAssetImage("notification.png", 36.h, 36.h)
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: Stack(
            //     children: [
            //       RefreshIndicator(
            //         backgroundColor: Colors.white,
            //         color: Colors.cyan,
            //         onRefresh: () async {
            //           setState(() {
            //             showLoader = true;
            //           });
            //           getDashboardData();
            //           getDevicesData();
            //           getLeavesData();
            //           getExpensesData();
            //         },
            //         child: ListView(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 10, vertical: 10),
            //           children: [
            //             Material(
            //               elevation: 10,
            //               borderRadius: BorderRadius.circular(5),
            //               child: Container(
            //                 padding: const EdgeInsets.only(top: 15),
            //                 child: Column(
            //                   children: [
            //                     CardHeading.cardHeading(
            //                         text: date,
            //                         textStyle: theme.text16bold,
            //                         align: MainAxisAlignment.start),
            //                     CardHeading.cardHeading(
            //                         text: "Total Employees: $totalEmployees",
            //                         textStyle: theme.text16bold,
            //                         align: MainAxisAlignment.end),
            //                     GridView.builder(
            //                       physics: const NeverScrollableScrollPhysics(),
            //                       shrinkWrap: true,
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 15, vertical: 5),
            //                       gridDelegate:
            //                           const SliverGridDelegateWithFixedCrossAxisCount(
            //                               crossAxisCount: 3,
            //                               crossAxisSpacing: 8.0,
            //                               mainAxisSpacing: 5.0,
            //                               childAspectRatio: 210 / 100),
            //                       itemCount: attendanceTitleColor.length,
            //                       itemBuilder:
            //                           (BuildContext context, int index) {
            //                         return Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               vertical: 3),
            //                           decoration: BoxDecoration(
            //                             color: attendanceTitleColor[index]
            //                                 .color
            //                                 .withOpacity(0.45),
            //                             borderRadius: BorderRadius.circular(5),
            //                           ),
            //                           child: Column(
            //                             children: [
            //                               Text(
            //                                   attendanceTitleColor[index].title,
            //                                   style: theme.text14!.copyWith(
            //                                       color: Colors.grey[600])),
            //                               const SizedBox(height: 4),
            //                               Text(
            //                                   attendanceTitleColor[index]
            //                                       .count
            //                                       .toString(),
            //                                   style: theme.text16),
            //                             ],
            //                           ),
            //                         );
            //                       },
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 20),
            //             Visibility(
            //               visible: false,
            //               child: Material(
            //                 elevation: 10,
            //                 borderRadius: BorderRadius.circular(5),
            //                 child: Column(
            //                   children: [
            //                     const SizedBox(height: 10.0),
            //                     CardHeading.cardHeading(
            //                         text: "Dashboard",
            //                         textStyle: theme.text18bold,
            //                         align: MainAxisAlignment.start),
            //                     Container(
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 5, vertical: 10),
            //                       child: GridView.builder(
            //                         shrinkWrap: true,
            //                         physics:
            //                             const NeverScrollableScrollPhysics(),
            //                         gridDelegate:
            //                             const SliverGridDelegateWithFixedCrossAxisCount(
            //                                 crossAxisCount: 3,
            //                                 crossAxisSpacing: 8.0,
            //                                 mainAxisSpacing: 5.0,
            //                                 childAspectRatio: 130 / 90),
            //                         itemCount: menu.length,
            //                         itemBuilder: (BuildContext context, int i) {
            //                           return GestureDetector(
            //                             onTap: () {
            //                               Navigator.push(
            //                                       context,
            //                                       CupertinoPageRoute(
            //                                         builder: (context) =>
            //                                             menu[i]["route"],
            //                                       ))
            //                                   .then((value) => setState(() {}));
            //                             },
            //                             child: Column(
            //                               children: [
            //                                 const SizedBox(height: 3.0),
            //                                 Container(
            //                                   decoration: const BoxDecoration(
            //                                     shape: BoxShape.circle,
            //                                     boxShadow: [
            //                                       BoxShadow(
            //                                         color: Colors.black,
            //                                         blurRadius: 0.9,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   child: CircleAvatar(
            //                                       radius: 20.0,
            //                                       backgroundColor: menu[i]
            //                                           ["color"],
            //                                       child: Icon(
            //                                         menu[i]["icon"],
            //                                         color: Colors.white,
            //                                       )),
            //                                 ),
            //                                 const SizedBox(height: 3.0),
            //                                 Text(menu[i]["name"]),
            //                               ],
            //                             ),
            //                           );
            //                         },
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             Material(
            //               elevation: 10,
            //               borderRadius: BorderRadius.circular(5),
            //               child: Column(
            //                 children: [
            //                   const SizedBox(height: 10.0),
            //                   CardHeading.cardHeading(
            //                       text: "Total Devices: $deviceTotal",
            //                       textStyle: theme.text18bold,
            //                       align: MainAxisAlignment.end),
            //                   Container(
            //                     padding: const EdgeInsets.symmetric(
            //                         horizontal: 5, vertical: 10),
            //                     child: PieChart(
            //                       dataMap: {
            //                         "Online": double.parse(
            //                             deviceUpPercentage == ""
            //                                 ? "0.00"
            //                                 : deviceUpPercentage),
            //                         "Offline": double.parse(
            //                             deviceOfflinePercentage == ""
            //                                 ? "0.00"
            //                                 : deviceOfflinePercentage),
            //                         "High Latency": double.parse(
            //                             deviceCriticalPercentage == ""
            //                                 ? "0.00"
            //                                 : deviceCriticalPercentage),
            //                         "Not Monitored": double.parse(
            //                             deviceNotManagedPercentage == ""
            //                                 ? "0.00"
            //                                 : deviceNotManagedPercentage),
            //                       },
            //                       animationDuration:
            //                           const Duration(milliseconds: 1000),
            //                       chartLegendSpacing: 40,
            //                       chartRadius: size.width / 2.6,
            //                       colorList: const [
            //                         Colors.green,
            //                         Colors.red,
            //                         Colors.orange,
            //                         Colors.purple
            //                       ],
            //                       initialAngleInDegree: 270,
            //                       chartType: ChartType.ring,
            //                       ringStrokeWidth: 28,
            //                       legendOptions: const LegendOptions(
            //                         showLegendsInRow: false,
            //                         legendPosition: LegendPosition.right,
            //                         showLegends: true,
            //                         legendShape: BoxShape.circle,
            //                         legendTextStyle: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),
            //                       chartValuesOptions: const ChartValuesOptions(
            //                         showChartValueBackground: false,
            //                         chartValueStyle: TextStyle(
            //                             fontSize: 16,
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.black),
            //                         showChartValues: false,
            //                         showChartValuesInPercentage: true,
            //                         showChartValuesOutside: false,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             const SizedBox(height: 20),
            //             Material(
            //               elevation: 10,
            //               borderRadius: BorderRadius.circular(5),
            //               child: Container(
            //                 padding: const EdgeInsets.only(top: 15),
            //                 child: Column(
            //                   children: [
            //                     CardHeading.cardHeading(
            //                         text: "Leave Requests",
            //                         textStyle: theme.text16bold,
            //                         align: MainAxisAlignment.end),
            //                     GridView.builder(
            //                       physics: const NeverScrollableScrollPhysics(),
            //                       shrinkWrap: true,
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 15, vertical: 5),
            //                       gridDelegate:
            //                           const SliverGridDelegateWithFixedCrossAxisCount(
            //                               crossAxisCount: 3,
            //                               crossAxisSpacing: 8.0,
            //                               mainAxisSpacing: 5.0,
            //                               childAspectRatio: 210 / 100),
            //                       itemCount: leaveRequestsList.length,
            //                       itemBuilder:
            //                           (BuildContext context, int index) {
            //                         return Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               vertical: 3),
            //                           decoration: BoxDecoration(
            //                             color: leaveRequestsList[index]
            //                                 .color
            //                                 .withOpacity(0.45),
            //                             borderRadius: BorderRadius.circular(5),
            //                           ),
            //                           child: Column(
            //                             children: [
            //                               Text(leaveRequestsList[index].title,
            //                                   style: theme.text14!.copyWith(
            //                                       color: Colors.grey[600])),
            //                               const SizedBox(height: 4),
            //                               Text(
            //                                   leaveRequestsList[index]
            //                                       .count
            //                                       .toString(),
            //                                   style: theme.text16),
            //                             ],
            //                           ),
            //                         );
            //                       },
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 20),
            //             Material(
            //               elevation: 10,
            //               borderRadius: BorderRadius.circular(5),
            //               child: Container(
            //                 padding: const EdgeInsets.only(top: 15),
            //                 child: Column(
            //                   children: [
            //                     CardHeading.cardHeading(
            //                         text: "Expenses",
            //                         textStyle: theme.text16bold,
            //                         align: MainAxisAlignment.end),
            //                     GridView.builder(
            //                       physics: const NeverScrollableScrollPhysics(),
            //                       shrinkWrap: true,
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 15, vertical: 5),
            //                       gridDelegate:
            //                           const SliverGridDelegateWithFixedCrossAxisCount(
            //                               crossAxisCount: 2,
            //                               crossAxisSpacing: 8.0,
            //                               mainAxisSpacing: 8.0,
            //                               childAspectRatio: 210 / 100),
            //                       itemCount: expenseDataList.length,
            //                       itemBuilder:
            //                           (BuildContext context, int index) {
            //                         return Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               vertical: 3),
            //                           decoration: BoxDecoration(
            //                             color: expenseDataList[index]
            //                                 .color
            //                                 .withOpacity(0.45),
            //                             borderRadius: BorderRadius.circular(5),
            //                           ),
            //                           child: Column(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceAround,
            //                             children: [
            //                               Text(expenseDataList[index].title,
            //                                   style: theme.text16!.copyWith(
            //                                       color: Colors.grey[600])),
            //                               const SizedBox(height: 4),
            //                               Text(
            //                                   expenseDataList[index]
            //                                       .count
            //                                       .toString(),
            //                                   style: theme.text18),
            //                             ],
            //                           ),
            //                         );
            //                       },
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Visibility(
            //           visible: showLoader,
            //           child: Container(
            //               width: size.width,
            //               height: size.height,
            //               color: Colors.white70,
            //               child: const SpinKitFadingCircle(
            //                   color: Colors.cyan, size: 70))),
            //     ],
            //   ),
            // ),
            getVerticalSpace(20.h),
            Expanded(
              child: GridView(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                primary: true,
                shrinkWrap: false,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 90.h,
                    crossAxisSpacing: 16.h,
                    mainAxisSpacing: 16.h),
                children: [
                  GestureDetector(
                    child: dashBoardWidget(
                        "Attendance",
                        Color(0xFFE31F25).withOpacity(0.05),
                        "attendance (1).png"),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AttendanceNewScreen(),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NewAccessControllScreen(),
                        ),
                      );
                    },
                    child: dashBoardWidget(
                        "Access Control",
                        Color(0xFF009847).withOpacity(0.05),
                        "access_control (1).png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NewSalesDeskScreen(),
                        ),
                      );
                    },
                    child: dashBoardWidget("Sales Desk",
                        Color(0xFF00A0E4).withOpacity(0.05), "sales-desk.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NewSupportDeskScreen(),
                        ),
                      );
                    },
                    child: dashBoardWidget(
                        "Support Desk",
                        Color(0xFF1E9B1B).withOpacity(0.05),
                        "support-desk.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NMSDashboard(),
                        ),
                      );
                    },
                    child: dashBoardWidget("NMS",
                        Color(0xFFE9532A).withOpacity(0.05), "NMS (1).png"),
                  ),
                  dashBoardWidget("Self Services",
                      Color(0xFF395A7F).withOpacity(0.05), "self_service.png")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dashBoardWidget(String name, Color color, String image) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: Offset(0, 0),
                blurRadius: 15.h)
          ],
          borderRadius: BorderRadius.circular(10.h)),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10.h)),
            child: getAssetImage(image, 22.h, 22.h),
          ),
          getVerticalSpace(5.h),
          getCustomFont(name, 14.sp, AppColors.textBlackColor, 1,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}

class AttendanceLogs {
  final String title;
  final Color color;
  final String count;

  AttendanceLogs(
      {required this.title, required this.color, required this.count});
}

class LeaveRequestsModel {
  final String title;
  final Color color;
  final String count;

  LeaveRequestsModel(
      {required this.title, required this.color, required this.count});
}

class ExpenseDataModel {
  final String title;
  final Color color;
  final String count;

  ExpenseDataModel(
      {required this.title, required this.color, required this.count});
}
