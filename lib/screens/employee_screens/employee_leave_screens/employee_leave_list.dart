import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/bottomsheet/leave_balance_bottomsheet.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/dialog/filter_dialog.dart';
import 'package:vetan_panjika/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import 'package:vetan_panjika/utils/widget.dart';
import '../../../common/common_func.dart';
import '../../../model/employee_models/employee_leaves/employee_leaves_model.dart';
import '../../../utils/constant.dart';
import '../employee_dashboard.dart';
import 'employee_leave_add_edit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveListPage extends StatefulWidget {
  const LeaveListPage({Key? key}) : super(key: key);

  @override
  _LeaveListPageState createState() => _LeaveListPageState();
}

class _LeaveListPageState extends State<LeaveListPage> {
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
  var monthYear = "";
  String selectedMonth = "";
  String selectedYear = "";
  String selectedStatus = "1";
  List<EmployeeLeavesDataModel> leavesList = [];
  String noDataMsg = "";
  bool showLoader = false;

  // filter
  String statusDropdownValue = "Approved";
  List<StatusFilterModel> statusDropdownItems = [
    StatusFilterModel(statusName: "Approved", id: "1"),
    StatusFilterModel(statusName: "Pending", id: "0"),
    StatusFilterModel(statusName: "Rejected", id: "2"),
  ];

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  refreshPage() {
    showLoader = true;
    getMonthYear();
    getLeavesData();
  }

  getMonthYear() async {
    var dateTime = DateTime.now().toUtc();
    String formattedDate = DateFormat.yMMM().format(dateTime);
    monthYear = formattedDate.replaceAll(" ", ", ");
    selectedMonth = dateTime.month.toString();
    monthDropdown = selectedMonth;
    selectedYear = dateTime.year.toString();
    yearDropdown = selectedYear;
  }

  getLeavesData() {
    showLoader = true;
    var apiController = ApiController();
    apiController
        .getEmployeeLeavesList(
            id: "",
            month: selectedMonth,
            year: selectedYear,
            statusId: selectedStatus)
        .then((value) {
      if (value != null) {
        leavesList = [];
        for (var data in value.data) {
          leavesList.add(data);
        }
      }
      if (leavesList.isEmpty) {
        noDataMsg = "No record found";
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      getCustomFont("Leaves", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      child: getAssetImage("add_icon.png", 23.h, 23.h),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                const LeaveAddEdit(id: "0", addEdit: "A"),
                          ),
                        ).then((value) => refreshPage());
                      },
                    ),
                    getHorizontalSpace(12.h),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FilterDialog();
                            },
                          );
                        },
                        child: getAssetImage("filter.png", 20.h, 20.h))
                  ],
                )
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
                    setState(() {
                      showLoader = true;
                    });
                    getLeavesData();
                  },
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: getCustomFont(
                                "Search", 16.sp, AppColors.blackColor, 1,
                                fontWeight: FontWeight.w600),
                          ),
                          getVerticalSpace(10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        color: AppColors.fillColor,
                                        border: Border.all(
                                            color: AppColors.strokeColor),
                                        borderRadius:
                                            BorderRadius.circular(5.h)),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: monthDropdown,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20),
                                          isExpanded: true,
                                          elevation: 0,
                                          style: TextStyle(
                                              color: AppColors.textBlackColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: Constant.fontFamily),
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
                                              child: Text(
                                                item["month"].toString(),
                                                style: TextStyle(
                                                    color: AppColors
                                                        .textBlackColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        Constant.fontFamily),
                                              ),
                                              value: item["id"].toString(),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.fillColor,
                                      border: Border.all(
                                          color: AppColors.strokeColor),
                                      borderRadius: BorderRadius.circular(5.h),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String?>(
                                          value: yearDropdown,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20),
                                          isExpanded: true,
                                          elevation: 0,
                                          style: TextStyle(
                                              color: AppColors.textBlackColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: Constant.fontFamily),
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
                                              child: Text(
                                                item.toString(),
                                                style: TextStyle(
                                                    color: AppColors
                                                        .textBlackColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        Constant.fontFamily),
                                              ),
                                              value: item.toString(),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                ElevatedButton(
                                  onPressed: getLeavesData,
                                  child: getCustomFont(
                                      "Search", 16.sp, Colors.white, 1,
                                      fontWeight: FontWeight.w500),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppColors.primaryColor,
                                      maximumSize: Size(132.h, 40.h),
                                      minimumSize: Size(132.h, 40.h),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.h))),
                                )
                              ],
                            ),
                          ),
                          getVerticalSpace(20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30.h))),
                                        builder: (context) {
                                          return LeaveBalanceBottomsheet();
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.09),
                                              offset: Offset(0, 0),
                                              blurRadius: 15,
                                            )
                                          ],
                                          border: Border.all(
                                              color: AppColors
                                                  .containerBorderColor,
                                              width: 1.h)),
                                      padding: EdgeInsets.all(12.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.blueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5.h),
                                            ),
                                            height: 50.h,
                                            width: 50.h,
                                            alignment: Alignment.center,
                                            child: getCustomFont(
                                                "15", 28.sp, Colors.white, 1,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          getHorizontalSpace(12.h),
                                          getMultiLineFont("Leave \nBalance",
                                              16.sp, AppColors.textBlackColor,
                                              fontWeight: FontWeight.w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.h),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.09),
                                            offset: Offset(0, 0),
                                            blurRadius: 15,
                                          )
                                        ],
                                        border: Border.all(
                                            color:
                                                AppColors.containerBorderColor,
                                            width: 1.h)),
                                    padding: EdgeInsets.all(12.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.greenColor,
                                            borderRadius:
                                                BorderRadius.circular(5.h),
                                          ),
                                          height: 50.h,
                                          width: 50.h,
                                          alignment: Alignment.center,
                                          child: getCustomFont(
                                              "05", 28.sp, Colors.white, 1,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorizontalSpace(12.h),
                                        getMultiLineFont("Leave \nApproved",
                                            16.sp, AppColors.textBlackColor,
                                            fontWeight: FontWeight.w500)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          getVerticalSpace(16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.h),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.09),
                                            offset: Offset(0, 0),
                                            blurRadius: 15,
                                          )
                                        ],
                                        border: Border.all(
                                            color:
                                                AppColors.containerBorderColor,
                                            width: 1.h)),
                                    padding: EdgeInsets.all(12.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.yellowColor,
                                            borderRadius:
                                                BorderRadius.circular(5.h),
                                          ),
                                          height: 50.h,
                                          width: 50.h,
                                          alignment: Alignment.center,
                                          child: getCustomFont(
                                              "08", 28.sp, Colors.white, 1,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorizontalSpace(12.h),
                                        getMultiLineFont("Leave \nPending",
                                            16.sp, AppColors.textBlackColor,
                                            fontWeight: FontWeight.w500)
                                      ],
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.h),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.09),
                                            offset: Offset(0, 0),
                                            blurRadius: 15,
                                          )
                                        ],
                                        border: Border.all(
                                            color:
                                                AppColors.containerBorderColor,
                                            width: 1.h)),
                                    padding: EdgeInsets.all(12.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.redColor,
                                            borderRadius:
                                                BorderRadius.circular(5.h),
                                          ),
                                          height: 50.h,
                                          width: 50.h,
                                          alignment: Alignment.center,
                                          child: getCustomFont(
                                              "12", 28.sp, Colors.white, 1,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorizontalSpace(12.h),
                                        getMultiLineFont("Leave \nCancelled",
                                            16.sp, AppColors.textBlackColor,
                                            fontWeight: FontWeight.w500)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          getVerticalSpace(30.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        statusDropdownValue =
                                            statusDropdownItems[0].statusName;
                                        selectedStatus =
                                            statusDropdownItems[0].id;
                                      });
                                      getLeavesData();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              statusDropdownValue == "Approved"
                                                  ? AppColors.primaryColor
                                                  : AppColors.unselectColor,
                                          borderRadius:
                                              BorderRadius.circular(5.h)),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.h),
                                      child: getCustomFont(
                                          statusDropdownItems[0].statusName,
                                          16.sp,
                                          statusDropdownValue == "Approved"
                                              ? Colors.white
                                              : Colors.black,
                                          1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        statusDropdownValue =
                                            statusDropdownItems[1].statusName;
                                        selectedStatus =
                                            statusDropdownItems[1].id;
                                      });
                                      getLeavesData();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color:
                                              statusDropdownValue == "Pending"
                                                  ? AppColors.primaryColor
                                                  : AppColors.unselectColor,
                                          borderRadius:
                                              BorderRadius.circular(5.h)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.h),
                                      child: getCustomFont(
                                          statusDropdownItems[1].statusName,
                                          16.sp,
                                          statusDropdownValue == "Pending"
                                              ? Colors.white
                                              : Colors.black,
                                          1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                getHorizontalSpace(16.h),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        statusDropdownValue =
                                            statusDropdownItems[2].statusName;
                                        selectedStatus =
                                            statusDropdownItems[2].id;
                                      });
                                      getLeavesData();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color:
                                              statusDropdownValue == "Rejected"
                                                  ? AppColors.primaryColor
                                                  : AppColors.unselectColor,
                                          borderRadius:
                                              BorderRadius.circular(5.h)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.h),
                                      child: getCustomFont(
                                          statusDropdownItems[2].statusName,
                                          16.sp,
                                          statusDropdownValue == "Rejected"
                                              ? Colors.white
                                              : Colors.black,
                                          1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),

                      getVerticalSpace(12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getAssetImage("pdf.png", 19.h, 17.h),
                            getHorizontalSpace(12.h),
                            getAssetImage("xls.png", 19.h, 18.h),
                          ],
                        ),
                      ),
                      getVerticalSpace(12.h),
                      // leaves list island
                      leavesList.isEmpty
                          ? emptyDataWidget()
                          : ListView.separated(
                              separatorBuilder: (context, index) {
                                return getVerticalSpace(16.h);
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                  left: 20.h, right: 20.h, bottom: 20.h),
                              primary: false,
                              shrinkWrap: true,
                              itemCount: leavesList.length,
                              itemBuilder: (context, index) {
                                EmployeeLeavesDataModel data =
                                    leavesList[index];
                                return Container(
                                  padding: EdgeInsets.all(14.h),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.h),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.12),
                                            blurRadius: 12.h,
                                            offset: Offset(0, 0))
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getCustomFont("Date", 12.sp,
                                                    AppColors.greyTextColor, 1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                getVerticalSpace(2.h),
                                                getMultiLineFont(
                                                    "${convertDate(data.newTransDate)}",
                                                    14.sp,
                                                    Colors.black,
                                                    fontWeight: FontWeight.w500)
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: statusTypeColor(
                                                        data.statusName),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.h)),
                                                child: getCustomFont(
                                                    data.statusName,
                                                    10.sp,
                                                    Colors.white,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                height: 25.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.h),
                                                alignment: Alignment.center,
                                              ),
                                              getHorizontalSpace(10.h),
                                              data.statusName == "Pending"
                                                  ? getAssetImage(
                                                      "edit.png", 16.h, 16.h)
                                                  : SizedBox(),
                                              data.statusName == "Pending"
                                                  ? getHorizontalSpace(12.h)
                                                  : SizedBox(),
                                              getAssetImage(
                                                  "download.png", 16.h, 16.h),
                                              getHorizontalSpace(12.h),
                                              getAssetImage(
                                                  "delete.png", 16.h, 16.h),
                                            ],
                                          )
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      getVerticalSpace(12.h),
                                      Divider(
                                        height: 0,
                                        color: AppColors.dividerColor,
                                        thickness: 1.h,
                                      ),
                                      getVerticalSpace(12.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getCustomFont(
                                                    "Apply Date",
                                                    10.sp,
                                                    AppColors.greyTextColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                getVerticalSpace(2.h),
                                                getMultiLineFont(
                                                    "-", 12.sp, Colors.black,
                                                    fontWeight: FontWeight.w500)
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(10.h),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getCustomFont(
                                                    "Leave Type",
                                                    10.sp,
                                                    AppColors.greyTextColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                getVerticalSpace(2.h),
                                                getMultiLineFont(data.leaveType,
                                                    12.sp, Colors.black,
                                                    fontWeight: FontWeight.w500)
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(10.h),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getCustomFont(
                                                    "Approved By",
                                                    10.sp,
                                                    AppColors.greyTextColor,
                                                    1,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                getVerticalSpace(2.h),
                                                getMultiLineFont(
                                                    "-", 12.sp, Colors.black,
                                                    fontWeight: FontWeight.w500)
                                              ],
                                            ),
                                          )
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                    ],
                  ),
                ),
                Visibility(
                    visible: showLoader,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: const SpinKitFadingCircle(
                            color: Colors.cyan, size: 70))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color statusTypeColor(String status) {
    if (status == "Approved") {
      return AppColors.greenColor;
    } else if (status == "Pending") {
      return AppColors.yellowColor;
    } else {
      return AppColors.redColor;
    }
  }

  String dateConvert(String inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);
    String formattedDate = DateFormat("MMM d, y").format(parsedDate);
    return formattedDate;
  }

  String convertDate(String inputDate) {
    // Define the input format
    DateFormat inputFormat = DateFormat('d MMM yyyy');

    // Parse the input date string to a DateTime object
    DateTime dateTime = inputFormat.parse(inputDate);

    // Define the output format
    DateFormat outputFormat = DateFormat('MMM d, yyyy');

    // Format the DateTime object to the desired output format
    String outputDate = outputFormat.format(dateTime);

    return outputDate;
  }
}

class StatusFilterModel {
  String id;
  String statusName;

  StatusFilterModel({required this.id, required this.statusName});
}
