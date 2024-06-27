import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/main.dart';
import 'package:intl/intl.dart';
import 'package:vetan_panjika/model/employee_models/employee_expenses/employee_expenses_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/model/employee_models/employee_expenses/expenses_head_model.dart';
import 'package:vetan_panjika/model/filters/expense_head_type_filter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../common/common_func.dart';
import '../../../model/filters/expense_head_subtype_filter.dart';
import '../../../utils/color_data.dart';
import '../../../utils/constant.dart';
import '../../../utils/widget.dart';
import '../employee_dashboard.dart';
import '../employee_leave_screens/employee_leave_add_edit.dart';
import 'employee_expenses_add_edit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpensesListPage extends StatefulWidget {
  const ExpensesListPage({Key? key}) : super(key: key);

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
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
  List statusList = [
    {"id": "0", "status": "Pending"},
    {"id": "1", "status": "Approved"},
    {"id": "2", "status": "Rejected"},
    {"id": "3", "status": "Paid"}
  ];
  String? monthDropdown;
  String? yearDropdown;
  String? statusDropdown;
  var monthYear = "";
  String selectedMonth = "";
  String selectedYear = "";
  String selectedStatus = "";
  String selectedHead = "";
  String selectedSubhead = "";
  List<EmployeeExpensesDataModel> expensesList = [];
  List<ExpensesHeadDataModel> headList = [];
  String noDataMsg = "";
  bool showLoader = false;

  String expenseTotal = "0";

  // filter
  String? headDropdownValue;
  List<ExpenseHeadTypeFilterModel> headDropdownItems = [];
  String? subheadDropdownValue;
  List<ExpenseHeadSubtypeFilterModel> subheadDropdownItems = [];

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  refreshPage() {
    showLoader = true;
    getMonthYear();
    getHeadTypeFilter();
    getSubHeadTypeFilter();
    getExpensesData();
    getBaseUrl();
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

  // for expense image if any
  String imgBaseUrl = "";

  getBaseUrl() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String base = (shared.getString("baseURL") ?? "");
    imgBaseUrl = base == "" ? "" : base + urlController.imgUrl;
  }

  getHeadTypeFilter() {
    var apiController = ApiController();
    apiController.getExpenseHeadTypeFilter().then((value) {
      if (value!.data.isNotEmpty) {
        headDropdownItems = value.data;
      }
      setState(() {});
    });
  }

  getSubHeadTypeFilter() {
    var apiController = ApiController();
    apiController.getExpenseSubtypeFilter().then((value) {
      if (value!.data.isNotEmpty) {
        subheadDropdownItems = value.data;
      }
      setState(() {});
    });
  }

  getExpensesData() {
    showLoader = true;
    double total = 0;
    var apiController = ApiController();
    apiController
        .getEmployeeExpensesList(
            headId: selectedHead,
            subheadId: selectedSubhead,
            month: selectedMonth,
            year: selectedYear,
            status: selectedStatus)
        .then((value) {
      if (value != null) {
        expenseTotal = "0";
        expensesList = [];
        for (var data in value.data) {
          expensesList.add(data);
          total += double.parse(data.amount);
        }
      }
      expenseTotal = total.toStringAsFixed(2);
      if (expensesList.isEmpty) {
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
      //     "Expenses",
      //     style: theme.text20,
      //   ),
      //   actions: [
      //     FutureBuilder(
      //         future: CommonFunctions().networkStatusDot(setState),
      //         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //           return Padding(
      //             padding: const EdgeInsets.only(right: 10),
      //             child: Container(
      //               width: 15,
      //               height: 15,
      //               decoration: BoxDecoration(
      //                 shape: BoxShape.circle,
      //                 color: dialogShown ? Colors.red : Colors.green,
      //               ),
      //             ),
      //           );
      //         })
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
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  getAssetImage("back.png", 14.h, 10.h),
                  getHorizontalSpace(9.h),
                  getCustomFont("Expenses", 20.sp, Colors.white, 1,
                      fontWeight: FontWeight.w600),
                ],
              ),
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
                    getExpensesData();
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      getVerticalSpace(22.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCustomFont(
                                "Search", 16.sp, AppColors.blackColor, 1,
                                fontWeight: FontWeight.w600),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const ExpensesAddEdit(
                                        id: "0", addEdit: "A"),
                                  ),
                                ).then((value) => refreshPage());
                              },
                              child: Container(
                                height: 31.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.h),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.h),
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1)),
                                alignment: Alignment.center,
                                child: getCustomFont(
                                    "Add new", 14.sp, AppColors.primaryColor, 1,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      getVerticalSpace(15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Expenses Type", 12.sp, Color(0xFF868686), 1,
                            fontWeight: FontWeight.w400),
                      ),
                      getVerticalSpace(2.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEDEDED)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String?>(
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              value: headDropdownValue,
                              isExpanded: true,
                              elevation: 0,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.fontFamily),
                              iconSize: 25,
                              hint: Text(
                                'Select Expenses Type',
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Constant.fontFamily),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  headDropdownValue = value!;
                                  selectedHead = value;
                                });
                              },
                              items: headDropdownItems.map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                    item.headName.toString(),
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.fontFamily),
                                  ),
                                  value: item.id.toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpace(16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Expenses Sub Type", 12.sp, Color(0xFF868686), 1,
                            fontWeight: FontWeight.w400),
                      ),
                      getVerticalSpace(2.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEDEDED)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String?>(
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              value: subheadDropdownValue,
                              isExpanded: true,
                              elevation: 0,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.fontFamily),
                              iconSize: 25,
                              hint: Text(
                                'Select Expenses Sub Type',
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Constant.fontFamily),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  subheadDropdownValue = value!;
                                  selectedSubhead = value;
                                });
                              },
                              items: subheadDropdownItems.map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                    item.subtypeName.toString(),
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.fontFamily),
                                  ),
                                  value: item.id.toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpace(16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Month", 12.sp, Color(0xFF868686), 1,
                            fontWeight: FontWeight.w400),
                      ),
                      getVerticalSpace(2.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEDEDED)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: monthDropdown,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              isExpanded: true,
                              elevation: 0,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.fontFamily),
                              iconSize: 25,
                              hint: Text(
                                'Month',
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Constant.fontFamily),
                              ),
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
                                        color: AppColors.blackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.fontFamily),
                                  ),
                                  value: item["id"].toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpace(16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Year", 12.sp, Color(0xFF868686), 1,
                            fontWeight: FontWeight.w400),
                      ),
                      getVerticalSpace(2.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEDEDED)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String?>(
                              value: yearDropdown,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              isExpanded: true,
                              elevation: 0,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.fontFamily),
                              iconSize: 25,
                              hint: Text(
                                'Year',
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Constant.fontFamily),
                              ),
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
                                        color: AppColors.blackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.fontFamily),
                                  ),
                                  value: item.toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpace(16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: getCustomFont(
                            "Status", 12.sp, Color(0xFF868686), 1,
                            fontWeight: FontWeight.w400),
                      ),
                      getVerticalSpace(2.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFEDEDED)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String?>(
                              value: statusDropdown,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20),
                              isExpanded: true,
                              elevation: 0,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.fontFamily),
                              iconSize: 25,
                              hint: Text('Status',
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Constant.fontFamily)),
                              onChanged: (String? value) {
                                setState(() {
                                  statusDropdown = value;
                                  selectedStatus = value!;
                                });
                              },
                              items: statusList.map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                    item["status"].toString(),
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.fontFamily),
                                  ),
                                  value: item["id"].toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpace(16.h),
                      GestureDetector(
                        onTap: getExpensesData,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5.h),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF3197FF).withOpacity(0.5),
                                    offset: Offset(0, 0),
                                    blurRadius: 10)
                              ]),
                          child: getCustomFont("Search", 16.sp, Colors.white, 1,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      getVerticalSpace(25.h),
                      expensesList.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: getCustomFont("Expenses List",
                                            20, AppColors.blackColor, 1,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          getAssetImage("pdf.png", 19.h, 17.h),
                                          getHorizontalSpace(12.h),
                                          getAssetImage("xls.png", 19.h, 18.h),
                                          getHorizontalSpace(7.h),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(7.h),
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.12),
                                                      blurRadius: 12,
                                                      offset: Offset(0, 0))
                                                ]),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11.h,
                                                vertical: 5.h),
                                            child: getCustomFont(
                                                "Total: INR " + expenseTotal,
                                                14.sp,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  emptyDataWidget()
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: getCustomFont("Expenses List",
                                            20, AppColors.blackColor, 1,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          getAssetImage("pdf.png", 19.h, 17.h),
                                          getHorizontalSpace(12.h),
                                          getAssetImage("xls.png", 19.h, 18.h),
                                          getHorizontalSpace(7.h),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(7.h),
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.12),
                                                      blurRadius: 12,
                                                      offset: Offset(0, 0))
                                                ]),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11.h,
                                                vertical: 5.h),
                                            child: getCustomFont(
                                                "Total: INR " + expenseTotal,
                                                14.sp,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                getVerticalSpace(15.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: expensesList.length,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.h),
                                  itemBuilder: (BuildContext context, int i) {
                                    EmployeeExpensesDataModel data =
                                        expensesList[i];
                                    return Container(
                                      padding: EdgeInsets.all(14.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.12),
                                                offset: Offset(0, 0),
                                                blurRadius: 12)
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
                                                    getCustomFont(
                                                        "Date",
                                                        12.sp,
                                                        AppColors.greyTextColor,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    getVerticalSpace(2.h),
                                                    getMultiLineFont(
                                                        "${convertDate(data.dateNew)}",
                                                        14.sp,
                                                        Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500)
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
                                                            BorderRadius
                                                                .circular(5.h)),
                                                    child: getCustomFont(
                                                        data.statusName,
                                                        10.sp,
                                                        Colors.white,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    height: 25.h,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 14.h),
                                                    alignment: Alignment.center,
                                                  ),
                                                  getHorizontalSpace(10.h),
                                                  data.statusName == "Pending"
                                                      ? GestureDetector(
                                                          child: getAssetImage(
                                                              "edit.png",
                                                              16.h,
                                                              16.h),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder: (context) =>
                                                                    ExpensesAddEdit(
                                                                        id: data
                                                                            .id,
                                                                        addEdit:
                                                                            "E"),
                                                              ),
                                                            ).then((value) =>
                                                                refreshPage());
                                                          },
                                                        )
                                                      : SizedBox(),
                                                  data.statusName == "Pending"
                                                      ? getHorizontalSpace(12.h)
                                                      : SizedBox(),
                                                  getAssetImage("download.png",
                                                      16.h, 16.h),
                                                  getHorizontalSpace(12.h),
                                                  getAssetImage(
                                                      "delete.png", 16.h, 16.h),
                                                ],
                                              )
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      getCustomFont(
                                                          "Exp. Type",
                                                          10.sp,
                                                          AppColors
                                                              .greyTextColor,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      getVerticalSpace(2.h),
                                                      getMultiLineFont(
                                                          data.headName,
                                                          12.sp,
                                                          Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)
                                                    ],
                                                  ),
                                                  getHorizontalSpace(30.h),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      getCustomFont(
                                                          "Exp. Sub Type",
                                                          10.sp,
                                                          AppColors
                                                              .greyTextColor,
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      getVerticalSpace(2.h),
                                                      getMultiLineFont(
                                                          data.subHeadName,
                                                          12.sp,
                                                          Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              getCustomFont(
                                                  "\u{20B9}" +
                                                      expensesList[i].amount,
                                                  12.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w500)
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                    // return Container(
                                    //   margin: const EdgeInsets.only(bottom: 6),
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 4, vertical: 5),
                                    //   decoration: BoxDecoration(
                                    //     border:
                                    //         Border.all(color: Colors.black54),
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     color: Colors.white,
                                    //   ),
                                    //   child: Column(
                                    //     children: [
                                    //       Padding(
                                    //         padding: const EdgeInsets.symmetric(
                                    //             horizontal: 3.0),
                                    //         child: Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment
                                    //                   .spaceBetween,
                                    //           children: [
                                    //             Text(
                                    //               expensesList[i].headName,
                                    //               style: theme.text16bold,
                                    //             ),
                                    //             Row(
                                    //               children: [
                                    //                 Container(
                                    //                   decoration: BoxDecoration(
                                    //                       borderRadius:
                                    //                           BorderRadius
                                    //                               .circular(15),
                                    //                       color: expensesList[i]
                                    //                                   .statusName ==
                                    //                               "Approved"
                                    //                           ? Colors.green
                                    //                           : expensesList[i]
                                    //                                       .statusName ==
                                    //                                   "Pending"
                                    //                               ? Colors.red
                                    //                               : expensesList[i]
                                    //                                           .statusName ==
                                    //                                       "Rejected"
                                    //                                   ? Colors
                                    //                                       .orange
                                    //                                   : Colors
                                    //                                       .blue),
                                    //                   margin:
                                    //                       const EdgeInsets.only(
                                    //                           right: 5),
                                    //                   padding: const EdgeInsets
                                    //                       .symmetric(
                                    //                       vertical: 2.0,
                                    //                       horizontal: 7),
                                    //                   child: Text(
                                    //                     expensesList[i]
                                    //                         .statusName,
                                    //                     style: theme.text14grey!
                                    //                         .copyWith(
                                    //                             color: Colors
                                    //                                 .white),
                                    //                   ),
                                    //                 ),
                                    //                 const SizedBox(width: 6),
                                    //                 expensesList[i]
                                    //                             .statusName !=
                                    //                         "Approved"
                                    //                     ? Padding(
                                    //                         padding:
                                    //                             const EdgeInsets
                                    //                                 .only(
                                    //                                 top: 5.0),
                                    //                         child:
                                    //                             GestureDetector(
                                    //                           onTap: () {
                                    //                             Navigator.push(
                                    //                               context,
                                    //                               CupertinoPageRoute(
                                    //                                 builder: (context) => ExpensesAddEdit(
                                    //                                     id: expensesList[i]
                                    //                                         .id,
                                    //                                     addEdit:
                                    //                                         "E"),
                                    //                               ),
                                    //                             ).then((value) =>
                                    //                                 refreshPage());
                                    //                           },
                                    //                           child: const FaIcon(
                                    //                               FontAwesomeIcons
                                    //                                   .pencil,
                                    //                               size: 15,
                                    //                               color: Colors
                                    //                                   .blue),
                                    //                         ),
                                    //                       )
                                    //                     : Container(),
                                    //               ],
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       const Divider(color: Colors.black),
                                    //       Padding(
                                    //         padding: const EdgeInsets.only(
                                    //             left: 3.0, bottom: 3.0),
                                    //         child: Row(
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 5),
                                    //               child: Container(
                                    //                 width: 7,
                                    //                 height: 7,
                                    //                 decoration:
                                    //                     const BoxDecoration(
                                    //                   shape: BoxShape.circle,
                                    //                   color: Colors.green,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Text(
                                    //               expensesList[i].subHeadName,
                                    //               style: theme.text14bold,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Row(
                                    //             children: [
                                    //               const Icon(
                                    //                 Icons.calendar_today,
                                    //                 color: Colors.cyan,
                                    //                 size: 15,
                                    //               ),
                                    //               const SizedBox(width: 5),
                                    //               Text(
                                    //                 expensesList[i].dateNew,
                                    //                 style: theme.text14,
                                    //               ),
                                    //             ],
                                    //           ),
                                    //           Text(
                                    //             "\u{20B9}" +
                                    //                 expensesList[i].amount,
                                    //             style: theme.text14bold,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       expensesList[i].remark != ""
                                    //           ? const Divider(
                                    //               color: Colors.black)
                                    //           : Container(),
                                    //       Row(
                                    //         children: [
                                    //           expensesList[i].remark != ""
                                    //               ? Text.rich(
                                    //                   TextSpan(
                                    //                     children: [
                                    //                       const TextSpan(
                                    //                           text: "Remark: ",
                                    //                           style: TextStyle(
                                    //                               fontSize: 12,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600)),
                                    //                       TextSpan(
                                    //                           text:
                                    //                               expensesList[
                                    //                                       i]
                                    //                                   .remark,
                                    //                           style:
                                    //                               const TextStyle(
                                    //                                   fontSize:
                                    //                                       12)),
                                    //                     ],
                                    //                   ),
                                    //                 )
                                    //               : Container(),
                                    //           SizedBox(
                                    //               height:
                                    //                   expensesList[i].remark !=
                                    //                           ""
                                    //                       ? 3
                                    //                       : 0),
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // );
                                  },
                                ),
                              ],
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
                        child: const SpinKitFadingCircle(
                            color: Colors.cyan, size: 70))),
              ],
            ),
          ),
        ],
      ),
    );
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

  Color statusTypeColor(String status) {
    if (status == "Approved") {
      return AppColors.greenColor;
    } else if (status == "Pending") {
      return AppColors.yellowColor;
    } else {
      return AppColors.redColor;
    }
  }
}
