import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/main.dart';
import 'package:intl/intl.dart';
import 'package:vetan_panjika/model/employee_models/employee_allowances/employee_allowances_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/model/filters/allowance_head_type_filter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../common/common_func.dart';
import '../../../model/employee_models/employee_allowances/allowances_head_model.dart';
import '../employee_dashboard.dart';
import 'employee_allowances_add_edit.dart';

class AllowancesListPage extends StatefulWidget {
  const AllowancesListPage({Key? key}) : super(key: key);

  @override
  _AllowancesListPageState createState() => _AllowancesListPageState();
}

class _AllowancesListPageState extends State<AllowancesListPage> {
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
  List<EmployeeAllowancesDataModel> allowancesList = [];
  List<AllowancesHeadDataModel> headList = [];
  String noDataMsg = "";
  bool showLoader = false;
  String allowanceTotal = "0";

  // filter
  String? headDropdownValue;
  List<AllowanceHeadTypeFilterModel> headDropdownItems = [];

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  refreshPage() {
    showLoader = true;
    getMonthYear();
    getHeadTypeFilter();
    getAllowancesData();
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

  getHeadTypeFilter() {
    var apiController = ApiController();
    apiController.getAllowanceHeadTypeFilter().then((value) {
      if (value!.data.isNotEmpty) {
        headDropdownItems = value.data;
      }
      setState(() {});
    });
  }

  getAllowancesData() {
    showLoader = true;
    double total = 0;
    var apiController = ApiController();
    apiController
        .getEmployeeAllowancesList(
            headId: selectedHead, month: selectedMonth, year: selectedYear, status: selectedStatus)
        .then((value) {
      if (value != null) {
        allowancesList = [];
        allowanceTotal = "0";
        for (var data in value.data) {
          allowancesList.add(data);
          total += double.parse(data.amount);
        }
      }
      allowanceTotal = total.toStringAsFixed(2);
      if (allowancesList.isEmpty) {
        noDataMsg = "No record found";
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
          "Allowances",
          style: theme.text20,
        ),
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
              })
        ],
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
              getAllowancesData();
            },
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // add new allowance button
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AllowancesAddEdit(
                                  id: "0", addEdit: "A"),
                            ),
                          ).then((value) => refreshPage());
                        },
                        minWidth: 120.0,
                        splashColor: Colors.red[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          "Add New",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // search island
                Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // head type filter
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
                                    value: headDropdownValue,
                                    isExpanded: true,
                                    elevation: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    iconSize: 25,
                                    hint: const Text('Allowance Type'),
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
                                          style: item.headName == "Select Type"
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
                            // status type filter
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
                                    value: statusDropdown,
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
                                        statusDropdown = value;
                                        selectedStatus = value!;
                                      });
                                    },
                                    items: statusList.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(item["status"].toString()),
                                        value: item["id"].toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        MaterialButton(
                          onPressed: getAllowancesData,
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
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                // allowance list island
                allowancesList.isEmpty
                    ? Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 2,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Allowances",
                                      style: theme.text20!.copyWith(
                                          height: 1.2,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "Total: " +
                                        allowanceTotal,
                                    style: theme.text20!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0, bottom: 6),
                                child: Divider(
                                  color: Colors.black,
                                  height: 0.5,
                                ),
                              ),
                              Text("No Record Found",
                                  style: theme.text18!.copyWith(
                                      height: 1.2,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      )
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Allowances",
                                      style: theme.text20!.copyWith(
                                          height: 1.2,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "Total: " "\u{20B9}" +
                                        allowanceTotal,
                                    style: theme.text20!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 0.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                color: Colors.grey[200],
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: allowancesList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 5),
                                      decoration: BoxDecoration(
                                        border:
                                        Border.all(color: Colors.black54),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  allowancesList[i].headName,
                                                  style: theme.text16bold,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          color: allowancesList[i]
                                                              .statusName ==
                                                              "Approved"
                                                              ? Colors.green
                                                              : allowancesList[i]
                                                              .statusName ==
                                                              "Pending"
                                                              ? Colors.red
                                                              : allowancesList[i]
                                                              .statusName ==
                                                              "Rejected"
                                                              ? Colors
                                                              .orange
                                                              : Colors
                                                              .blue),
                                                      margin: const EdgeInsets.only(right: 5),
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 2.0, horizontal: 7),
                                                      child: Text(
                                                        allowancesList[i]
                                                            .statusName,
                                                        style: theme.text14grey!
                                                            .copyWith(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    allowancesList[i].statusName !=
                                                        "Approved"
                                                        ? Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          top: 5.0),
                                                      child:
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) => AllowancesAddEdit(
                                                                  id: allowancesList[
                                                                  i]
                                                                      .id,
                                                                  addEdit:
                                                                  "E"),
                                                            ),
                                                          ).then((value) =>
                                                              refreshPage());
                                                        },
                                                        child: const FaIcon(
                                                            FontAwesomeIcons
                                                                .pencil,
                                                            size: 15,
                                                            color: Colors
                                                                .blue),
                                                      ),
                                                    )
                                                        : Container(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(color: Colors.black),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.cyan,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    allowancesList[i].dateNew,
                                                    style: theme.text14,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "\u{20B9}" +
                                                    allowancesList[i].amount,
                                                style: theme.text14bold,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 3.0),
                                            child: Row(
                                              children: [
                                                allowancesList[i].remark != ""
                                                    ? Text(
                                                    allowancesList[i].remark,
                                                    style: theme.text12grey!
                                                        .copyWith(
                                                        color: Colors
                                                            .black))
                                                    : Container(),
                                                SizedBox(
                                                    height: allowancesList[i]
                                                        .remark !=
                                                        ""
                                                        ? 3
                                                        : 0),
                                              ],
                                            ),
                                          ),
                                        ],
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
