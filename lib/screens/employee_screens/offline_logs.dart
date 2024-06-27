import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/controllers/local_db_controller.dart';
import '../../common/common_func.dart';
import '../../common/image_dialog_widget.dart';
import '../../controllers/background_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../main.dart';
import '../../model/employee_models/offline_logs_model.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'employee_dashboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfflineLogs extends StatefulWidget {
  const OfflineLogs({Key? key}) : super(key: key);

  @override
  State<OfflineLogs> createState() => _OfflineLogsState();
}

class _OfflineLogsState extends State<OfflineLogs> {
  bool showLoader = false;
  String noDataMsg = "";
  List<OfflineLogsDataModel> attendanceLogs = [];

  @override
  initState() {
    super.initState();
    getOfflineLogs();
  }

  getOfflineLogs() async {
    final _localDBController = LocalDBController();
    _localDBController.getAttendanceLogsLocal().then((value) {
      if (value != null) {
        attendanceLogs = [];
        for (var data in value.data) {
          attendanceLogs.add(data);
        }
      } else {
        attendanceLogs = [];
      }
      if (attendanceLogs.isEmpty) {
        noDataMsg = "No record found";
      }
      showLoader = false;
      setState(() {});
    });
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
      // appBar: AppBar(
      //   title: Text(
      //     "Offline Logs",
      //     style: theme.text20,
      //   ),
      //   actions: [
      //     FutureBuilder(
      //       future: CommonFunctions().networkStatusDot(setState),
      //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //         return Padding(
      //           padding: const EdgeInsets.only(right: 10),
      //           child: Container(
      //             width: 15,
      //             height: 15,
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               color: dialogShown ? Colors.red : Colors.green,
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
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
                      getCustomFont("Offline Logs", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.cyan,
                  onRefresh: () async {
                    getOfflineLogs();
                  },
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 7.0, vertical: 6.0),
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10.0, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        attendanceLogs.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showLoader = true;
                                  });
                                  BackgroundController()
                                      .sendAttendanceToServer()
                                      .then((value) {
                                    if (value == "No Connection") {
                                      CommonFunctions().toastMessage(value);
                                      getOfflineLogs();
                                    } else {
                                      getOfflineLogs();
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Send to Server",
                                        style: theme.text16bold),
                                    const Icon(
                                      Icons.upload,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        attendanceLogs.isNotEmpty
                            ? const Divider(thickness: 1, color: Colors.grey)
                            : Container(),
                        SizedBox(height: attendanceLogs.isNotEmpty ? 10 : 0),
                        attendanceLogs.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 4),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: attendanceLogs.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ImageDialog(
                                                  imageUrl:
                                                      attendanceLogs[index]
                                                          .logImg,
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.memory(
                                                base64.decode(
                                                    attendanceLogs[index]
                                                        .logImg),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                attendanceLogs[index].dateTime),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                ),
                              )
                            : emptyDataWidget()
                      ],
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
        ],
      ),
    );
  }
}
