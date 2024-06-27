import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/src/face_detector.dart';
import 'package:google_mlkit_commons/src/input_image.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:vetan_panjika/common/image_dialog_widget.dart';
import 'package:vetan_panjika/controllers/background_controller.dart';
import 'package:vetan_panjika/model/employee_models/employee_dashboard_data_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_dashboard_logs_model.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/main.dart';
import 'package:vetan_panjika/screens/admin_screens/admin_dashboard.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_allowances_screens/employee_allowances_list.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_leave_screens/employee_leave_list.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_personl_info.dart';
import 'package:vetan_panjika/screens/in_app_server_config.dart';
import 'package:vetan_panjika/user/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/common_func.dart';
import 'employee_attendance_summary.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:image_picker/image_picker.dart';
import 'employee_daily_update_screens/employee_daily_update_list.dart';
import 'employee_expenses_screens/employee_expenses_list.dart';
import 'face_camera.dart';
import 'offline_logs.dart';

bool dialogShown = true;
Timer? mobileInternet;

class EmployeeDashboard extends StatefulWidget {
  final Uint8List? bytes;

  const EmployeeDashboard({Key? key, required this.bytes}) : super(key: key);

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  String date = "";
  bool marked = false;
  bool showLoader = true;
  String noDataMsg = "";
  String monthName = "";
  List<EmployeeDashboardDataModel> attendance = [];

  List<AttendanceLogs> attendanceTitleColor = [];
  List<EmployeeDashboardLogsModel> dashboardDataLogs = [];
  String logImgBaseUrl = "";

  Timer? attendanceService;

  // connectivity variables
  late StreamSubscription connectivitySubscription;
  late ConnectivityResult oldRes;

  @override
  void initState() {
    super.initState();
    connect();
    mobileInternet = Timer.periodic(const Duration(seconds: 60),
        (Timer t) => CommonFunctions().checkInternet());
    getDashboardLogs();
    getDashboardData();
    getDateOnly();
    getPermissions();
    FlutterBackgroundService().invoke("setAsBackground");
    getUser();

    if (widget.bytes != null) {
      processImage(widget.bytes, 1);
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
    connect();
    connectivitySubscription.cancel();
    super.dispose();
  }

  void connect() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult resNow) async {
      if (resNow == ConnectivityResult.none) {
        setState(() {
          dialogShown = true;
        });
      } else {
        await CommonFunctions().checkInternet();
      }
      oldRes = resNow;
    });
  }

  // offline & online face detection
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableTracking: true,
        enableLandmarks: true,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.accurate),
  );
  final ImagePicker _imagePicker = ImagePicker();

  // -- user profile capture & upload functions -- //
  // if employee profile pic not available
  Future _getImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        showLoader = true;
      });
      await pickedFile.readAsBytes().then((value) {
        var base64 = base64Encode(value);
        _processPickedFile(File(pickedFile.path), base64);
      });
    }
  }

  Future _processPickedFile(File? pickedFile, String base64) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    final inputImage = InputImage.fromFilePath(path);
    profileUpload(inputImage, base64);
  }

  // employee profile pic upload
  profileUpload(InputImage inputImage, String base64) async {
    final apiController = ApiController();
    final faces = await _faceDetector.processImage(inputImage);
    if (faces.isNotEmpty) {
      showLoader = true;
      apiController.employeeProfileUpload(img: base64).then((value) {
        showLoader = false;
        showDialog(
          context: context,
          builder: (context) {
            getUser();
            return CupertinoAlertDialog(
              title: Text(value),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      });
    } else {
      showLoader = false;
      showDialog(
        context: context,
        builder: (context) {
          getUser();
          return CupertinoAlertDialog(
            title: const Text("Face Not Captured! Please try Again."),
            actions: [
              ElevatedButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  // -- end -- //

  // -- attendance functions -- //
  // save captured image & show dialog for success or error
  Future<String> processImage(Uint8List? bytes, int attendanceType) async {
    String returnMsg = "";
    var base64 = bytes != null ? base64Encode(bytes) : "";
    if (attendanceType == 1 && base64 != "") {
      try {
        locationController.getLocation().then((value) {
          if (value != null) {
            insertToLocalDB(base64, value.longitude, value.latitude).then(
              (value) {
                setState(() {
                  showLoader = false;
                });
                if (value == "success") {
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Marked Attendance Successfully"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            getDashboardLogs();
                            getDashboardData();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Face Not Clear Please Try Again!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            getDashboardLogs();
                            getDashboardData();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            setState(() {
              showLoader = false;
            });
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Location missing Please Try Again!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getDashboardLogs();
                      getDashboardData();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        });
      } catch (e) {
        setState(() {
          showLoader = false;
        });
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Face Not Clear Please Try Again!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  getDashboardLogs();
                  getDashboardData();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else if (attendanceType != 1) {
      try {
        locationController.getLocation().then((value) {
          if (value != null) {
            insertToLocalDB(base64, value.longitude, value.latitude).then(
              (value) {
                setState(() {
                  showLoader = false;
                });
                if (value == "success") {
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Marked Attendance Successfully"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            getDashboardLogs();
                            getDashboardData();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Face Not Clear Please Try Again!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            getDashboardLogs();
                            getDashboardData();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            setState(() {
              showLoader = false;
            });
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Location missing Please Try Again!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getDashboardLogs();
                      getDashboardData();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        });
      } catch (e) {
        setState(() {
          showLoader = false;
        });
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Error Occurred Please Try Again!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  getDashboardLogs();
                  getDashboardData();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        showLoader = false;
      });
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Face Not Captured Try Again!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                getDashboardLogs();
                getDashboardData();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
    return returnMsg;
  }

  // save captured image to offline attendance data (localDB)
  Future<String> insertToLocalDB(imgString, longitude, latitude) async {
    longitude = longitude == 0.0 ? "" : longitude;
    latitude = latitude == 0.0 ? "" : latitude;
    try {
      LocalDB _localDB = LocalDB();
      await _localDB.getDB();
      var v =
          await _localDB.insertToDB(queryForDB: """INSERT INTO attendance_logs
      (date_time, img_string, longitude, latitude)
      values (datetime('now','localtime'), '$imgString', '$longitude', '$latitude')""");
      debugPrint(v.toString());
      return "success";
    } catch (e) {
      debugPrint(e.toString());
      return "error";
    }
  }

  // -- end -- //

  // get dashboardData (summary)
  getDashboardData() {
    DateTime today = DateTime.now();
    var apiController = ApiController();
    apiController
        .getEmployeeDashboardData(
            month: today.month.toString(), year: today.year.toString())
        .then((value) {
      if (value != null) {
        attendance = [];
        for (var data in value.data) {
          attendance.add(data);
        }
      }
      if (attendance.isNotEmpty) {
        attendanceTitleColor = [
          AttendanceLogs(
              title: "Present",
              color: Colors.green,
              count: attendance[0].presentTotal),
          AttendanceLogs(
              title: "On Time",
              color: Colors.orange,
              count: attendance[0].onTime),
          AttendanceLogs(
              title: "Absent",
              color: Colors.red,
              count: attendance[0].absentTotal),
          AttendanceLogs(
              title: "Less Hours",
              color: Colors.cyan,
              count: attendance[0].lessHrsTotal),
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
          AttendanceLogs(
              title: "Holidays",
              color: Colors.green,
              count: attendance[0].holidayTotal),
          AttendanceLogs(
              title: "Holiday Work",
              color: Colors.cyan,
              count: attendance[0].totalHolidaysWorking),
          AttendanceLogs(
              title: "Week Off",
              color: Colors.red,
              count: attendance[0].weekOffTotal),
          AttendanceLogs(
              title: "Working WO",
              color: Colors.amber,
              count: attendance[0].totalWeekOffsWorking),
          AttendanceLogs(
              title: "Overtime",
              color: Colors.blue,
              count: attendance[0].totalOverTime),
          AttendanceLogs(
              title: "Working Hrs",
              color: Colors.pink,
              count: attendance[0].totalWorkingHrs),
        ];
      }
      if (attendance.isEmpty) {
        attendanceTitleColor = [
          AttendanceLogs(title: "Present", color: Colors.green, count: "0"),
          AttendanceLogs(title: "Absent", color: Colors.red, count: "0"),
          AttendanceLogs(title: "Less Hours", color: Colors.cyan, count: "0"),
          AttendanceLogs(title: "Week Off", color: Colors.amber, count: "0"),
          AttendanceLogs(
              title: "Punch Missing", color: Colors.blue, count: "0"),
          AttendanceLogs(title: "Half Day", color: Colors.pink, count: "0"),
          AttendanceLogs(title: "Late", color: Colors.purple, count: "0"),
          AttendanceLogs(title: "Present", color: Colors.green, count: "0"),
          AttendanceLogs(title: "Absent", color: Colors.red, count: "0"),
          AttendanceLogs(title: "Less Hours", color: Colors.cyan, count: "0"),
          AttendanceLogs(title: "Week Off", color: Colors.amber, count: "0"),
          AttendanceLogs(
              title: "Punch Missing", color: Colors.blue, count: "0"),
          AttendanceLogs(title: "Half Day", color: Colors.pink, count: "0"),
          AttendanceLogs(title: "Late", color: Colors.purple, count: "0"),
        ];
      }
      showLoader = false;
      setState(() {});
    });
  }

  // get dashboardData (attendance log)
  getDashboardLogs() {
    var apiController = ApiController();
    apiController.getEmployeeDashboardLogs().then((value) {
      if (value != null) {
        dashboardDataLogs = [];
        for (var data in value.data) {
          dashboardDataLogs.add(data);
        }
      }
      if (dashboardDataLogs.isEmpty) {
        noDataMsg = "No Entry to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  // get date today
  getDateOnly() {
    DateTime today = DateTime.now().toUtc();
    var inputFormat = DateFormat("EEE, MMM d, yyyy");
    String formattedDate = DateFormat.yMMM().format(today);
    date = inputFormat.format(today);
    monthName = formattedDate.replaceAll(" ", ", ");
  }

  String _user = "";
  String _companyName = "";
  String _profilePic = "";

  // get loggedIn user info
  Future<String> getUser() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    _user = shared.getString("employee_name") ?? "";
    _companyName = shared.getString("company_name") ?? "";
    _profilePic = shared.getString("profile_base64") ?? "";
    String base = (shared.getString("baseURL") ?? "");
    logImgBaseUrl = base == "" ? "" : base + urlController.attendanceImgUrl;
    setState(() {});
    return "done";
  }

  // get attendance permissions
  bool attendancePermission = false;
  int attendanceType = 0;

  getPermissions() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    attendancePermission = shared.getBool("attendance_permission") ?? false;
    attendanceType = shared.getInt("attendance_type") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        appBar: AppBar(
          title: Text("Office Manager", style: theme.text20),
          backgroundColor: Colors.white,
          actions: [
            FutureBuilder(
              future: CommonFunctions().networkStatusDot(setState),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dialogShown ? Colors.red : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDFE0DF),
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
                      borderRadius: BorderRadius.circular(23),
                      child: _profilePic == ""
                          ? const FadeInImage(
                              image: AssetImage("assets/OM_icon.png"),
                              width: 42,
                              height: 47,
                              placeholder: AssetImage("assets/OM_icon.png"),
                              fit: BoxFit.contain,
                            )
                          : Image.memory(
                              base64.decode(_profilePic),
                              width: _profilePic != "" ? 47 : 42,
                              height: _profilePic != "" ? 47 : 50,
                              fit: BoxFit.fill,
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
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.info,
                      color: Colors.cyan,
                      size: 25,
                    ),
                    title: const Text(
                      "Personal Info",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const EmpPersonalInfo(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.idCard,
                      color: Colors.amber,
                      size: 25,
                    ),
                    title: const Text(
                      "Attendance Summary",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AttendanceSummaryPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.leaf,
                      color: Colors.red,
                      size: 25,
                    ),
                    title: const Text(
                      "Leaves",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const LeaveListPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.cashRegister,
                      color: Colors.green,
                      size: 25,
                    ),
                    title: const Text(
                      "Expenses",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ExpensesListPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  // ListTile(
                  //   leading: const FaIcon(
                  //     FontAwesomeIcons.battleNet,
                  //     color: Colors.blue,
                  //     size: 25,
                  //   ),
                  //   title: const Text(
                  //     "Daily Update",
                  //     style: TextStyle(color: Colors.white, fontSize: 15),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //         builder: (context) => const DailyUpdateListPage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // const Divider(
                  //   color: Colors.white,
                  //   height: 0.5,
                  // ),
                  // ListTile(
                  //   leading: const Icon(
                  //     Icons.add_task,
                  //     color: Colors.purple,
                  //     size: 25,
                  //   ),
                  //   title: const Text(
                  //     "Allowances",
                  //     style: TextStyle(color: Colors.white, fontSize: 15),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //         builder: (context) => const AllowancesListPage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // const Divider(
                  //   color: Colors.white,
                  //   height: 0.5,
                  // ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.powerOff,
                      color: Colors.orange,
                      size: 25,
                    ),
                    title: const Text(
                      "Offline Logs",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const OfflineLogs(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.pink,
                      size: 25,
                    ),
                    title: const Text(
                      "Server Settings",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const InAppServerConfig(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 0.5,
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
                      shared.setString("user_mobile", "");
                      shared.setString("loginSuccess", "");
                      shared.setString("logo", "");
                      shared.setString("company_name", "");
                      // attendanceService!.cancel();
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
        body: Stack(
          children: [
            RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.cyan,
              onRefresh: () async {
                setState(() {
                  showLoader = true;
                });
                getDashboardLogs();
                getDashboardData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 2,
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Summary | " + monthName,
                                            style: theme.text16bold),
                                      ],
                                    ),
                                    const Divider(
                                        thickness: 1, color: Colors.grey),
                                    attendanceTitleColor.isNotEmpty
                                        ? GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 8.0,
                                                    mainAxisSpacing: 5.0,
                                                    childAspectRatio:
                                                        210 / 100),
                                            itemCount:
                                                attendanceTitleColor.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: attendanceTitleColor[
                                                          index]
                                                      .color
                                                      .withOpacity(0.45),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        attendanceTitleColor[
                                                                index]
                                                            .title,
                                                        style: theme.text14!
                                                            .copyWith(
                                                                color:
                                                                    Colors.grey[
                                                                        600])),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                        attendanceTitleColor[
                                                                index]
                                                            .count
                                                            .toString(),
                                                        style: theme.text16),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : Text(
                                            noDataMsg,
                                            style: theme.text14bold,
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 2,
                        child: Container(
                          width: size.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 6.0),
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Today Logs | " + date,
                                      style: theme.text16bold),
                                  GestureDetector(
                                    onTap: () {
                                      BackgroundController()
                                          .sendAttendanceToServer()
                                          .then((value) {
                                        setState(() {
                                          showLoader = true;
                                        });
                                        getDashboardLogs();
                                        getDashboardData();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.sync,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 1, color: Colors.grey),
                              const SizedBox(height: 10),
                              dashboardDataLogs.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 4),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: dashboardDataLogs.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap:
                                                    dashboardDataLogs[index]
                                                                .mode ==
                                                            "FingerPrint"
                                                        ? () {}
                                                        : dashboardDataLogs[
                                                                        index]
                                                                    .mode ==
                                                                "Manual"
                                                            ? () {}
                                                            : () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ImageDialog(
                                                                      imageUrl: dashboardDataLogs[index].logImg.contains(
                                                                              ".")
                                                                          ? (logImgBaseUrl +
                                                                              dashboardDataLogs[index].logImg)
                                                                          : dashboardDataLogs[index].logImg,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                child: Container(
                                                  height: 45,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: dashboardDataLogs[
                                                                    index]
                                                                .mode ==
                                                            "Manual"
                                                        ? Image.asset(
                                                            "assets/CS_userimg.png",
                                                            fit: BoxFit.fill)
                                                        : dashboardDataLogs[
                                                                        index]
                                                                    .mode ==
                                                                "Face"
                                                            ? FadeInImage(
                                                                image: NetworkImage(
                                                                    logImgBaseUrl +
                                                                        dashboardDataLogs[index]
                                                                            .logImg),
                                                                placeholder:
                                                                    const AssetImage(
                                                                        "assets/CS_userimg.png"),
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : dashboardDataLogs[
                                                                            index]
                                                                        .mode ==
                                                                    "FingerPrint"
                                                                ? const FadeInImage(
                                                                    image: AssetImage(
                                                                        "assets/fingerprint.png"),
                                                                    placeholder:
                                                                        AssetImage(
                                                                            "assets/CS_userimg.png"),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : Image.memory(
                                                                    base64.decode(
                                                                        dashboardDataLogs[index]
                                                                            .logImg),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(dashboardDataLogs[index]
                                                      .time),
                                                  Text(dashboardDataLogs[index]
                                                      .mode),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                      ),
                                    )
                                  : Text(
                                      noDataMsg,
                                      style: theme.text14bold,
                                    ),
                              const SizedBox(height: 10),
                              attendancePermission
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          MaterialButton(
                                            onPressed: () async {
                                              if (attendanceType == 1) {
                                                if (_profilePic == "") {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: const Text(
                                                          "Face Not Registered! Capture face to register face",
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "CANCEL"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              _getImage(
                                                                  ImageSource
                                                                      .camera);
                                                            },
                                                            child: const Text(
                                                                "OK"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  if (await locationController
                                                      .getLocationEnabled()) {
                                                    if (await locationController
                                                        .getLocationAccess()) {
                                                      final status =
                                                          await Permission
                                                              .camera.status;
                                                      if (status.isGranted ||
                                                          status.isLimited) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const FaceCameraPage()));
                                                        // _getImage(ImageSource.camera);
                                                      } else if (status
                                                          .isPermanentlyDenied) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              CupertinoAlertDialog(
                                                            title: const Text(
                                                                "Please Allow Camera Permission!"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  OpenAppSettings
                                                                      .openAppSettings();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "OK"),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        await Permission.camera
                                                            .request()
                                                            .then((value) {
                                                          if (value ==
                                                                  PermissionStatus
                                                                      .granted ||
                                                              status
                                                                  .isLimited) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const FaceCameraPage()));
                                                            // _getImage(ImageSource.camera);
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CupertinoAlertDialog(
                                                          title: const Text(
                                                              "Please Allow Location Permission!"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                OpenAppSettings
                                                                    .openAppSettings();
                                                              },
                                                              child: const Text(
                                                                  "OK"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                              } else {
                                                if (await locationController
                                                    .getLocationEnabled()) {
                                                  if (await locationController
                                                      .getLocationAccess()) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CupertinoAlertDialog(
                                                        title: const Text(
                                                            "Do you want to mark attendance?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "NO"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              processImage(null,
                                                                  attendanceType);
                                                            },
                                                            child: const Text(
                                                                "YES"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CupertinoAlertDialog(
                                                        title: const Text(
                                                            "Please Allow Location Permission!"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              OpenAppSettings
                                                                  .openAppSettings();
                                                            },
                                                            child: const Text(
                                                                "OK"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                            minWidth: size.width * 0.75,
                                            splashColor: Colors.cyan[200],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            color: Colors.cyan,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Mark Attendance",
                                              style: theme.text18white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}
