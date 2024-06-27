import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetan_panjika/model/employee_models/employee_daily_update/employee_daily_update_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../common/common_func.dart';
import '../../../controllers/api_controller.dart';
import '../../../main.dart';
import '../../../model/employee_models/employee_daily_update/daily_update_head_model.dart';
import '../employee_dashboard.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'employee_daily_update_add_edit.dart';

class DailyUpdateListPage extends StatefulWidget {
  const DailyUpdateListPage({Key? key}) : super(key: key);

  @override
  State<DailyUpdateListPage> createState() => _DailyUpdateListPageState();
}

class _DailyUpdateListPageState extends State<DailyUpdateListPage> {
  bool showLoader = true;

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

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  String _fromDate = "";
  String _toDate = "";
  var monthYear = "";
  String selectedHead = "";
  String noDataMsg = "";

  // filter
  String? headDropdownValue;
  List<DailyUpdateHeadDataModel> headDropdownItems = [];
  List<EmployeeDailyUpdateDataModel> updatesList = [];

  @override
  initState() {
    super.initState();
    refreshPage();
  }

  refreshPage() {
    showLoader = true;
    getHeadTypeFilter();
    getUpdatesData();
  }

  getHeadTypeFilter() {
    var apiController = ApiController();
    apiController.getDailyUpdateFilter().then((value) {
      if (value!.data.isNotEmpty) {
        headDropdownItems = value.data;
      }
      setState(() {});
    });
  }

  getUpdatesData() {
    showLoader = true;
    var apiController = ApiController();
    apiController
        .getEmployeeUpdatesList(
            headId: selectedHead, fromDate: _fromDate, toDate: _toDate)
        .then((value) {
      if (value != null) {
        updatesList = [];
        for (var data in value.data) {
          updatesList.add(data);
        }
      }
      if (updatesList.isEmpty) {
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
          "Daily Updates",
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
              getUpdatesData();
            },
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // add new expense button
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
                              builder: (context) => const DailyUpdateAddEdit(
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
                            // from date field
                            SizedBox(
                              width: size.width / 2.6,
                              height: 38,
                              child: DateTimePicker(
                                controller: _fromDateController,
                                cursorColor: Colors.cyan,
                                cancelText: "Cancel",
                                confirmText: "Ok",
                                type: DateTimePickerType.date,
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(Icons.date_range),
                                  label: const Text(
                                    "From Date* ",
                                    style: TextStyle(
                                        fontFamily: "latoRegular", color: Colors.black45),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  hintText: "dd/mm/yyyy",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateHintText: "DD/MM/YYYY",
                                dateLabelText: 'From Date* ',
                                style: TextStyle(
                                    fontFamily: "latoRegular",
                                    color: _fromDateController.text != ""
                                        ? Colors.black
                                        : Colors.black45),
                                validator: (val) {
                                  return null;
                                },
                                onChanged: (val) => _fromDate = val,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // to date field
                            Container(
                              alignment: Alignment.centerRight,
                              width: size.width / 2.6,
                              height: 38,
                              child: DateTimePicker(
                                controller: _toDateController,
                                cursorColor: Colors.cyan,
                                cancelText: "Cancel",
                                confirmText: "Ok",
                                type: DateTimePickerType.date,
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(Icons.date_range),
                                  label: const Text(
                                    "To Date* ",
                                    style: TextStyle(
                                        fontFamily: "latoRegular", color: Colors.black45),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  hintText: "dd/mm/yyyy",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateHintText: "DD/MM/YYYY",
                                dateLabelText: 'To Date* ',
                                style: TextStyle(
                                    fontFamily: "latoRegular",
                                    color: _toDateController.text != ""
                                        ? Colors.black
                                        : Colors.black45),
                                validator: (val) {
                                  return null;
                                },
                                onChanged: (val) => _toDate = val,
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
                                    hint: const Text('Project Name'),
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
                            MaterialButton(
                              onPressed: getUpdatesData,
                              minWidth: size.width * 0.3,
                              splashColor: Colors.cyan[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.cyan,
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                const SizedBox(height: 10),
                // expenses list island
                updatesList.isEmpty
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
                                  Text("Daily Updates",
                                      style: theme.text20!.copyWith(
                                          height: 1.2,
                                          fontWeight: FontWeight.w500)),
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
                                  Text("Daily Updates",
                                      style: theme.text20!.copyWith(
                                          height: 1.2,
                                          fontWeight: FontWeight.w500)),
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
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: updatesList.length,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  updatesList[i].projectName,
                                                  style: theme.text16bold,
                                                ),
                                                Padding(
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
                                                          builder: (context) => DailyUpdateAddEdit(
                                                              id: updatesList[i]
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
                                                    updatesList[i].transDateNew,
                                                    style: theme.text14,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          updatesList[i].remark != ""
                                              ? const Divider(
                                                  color: Colors.black)
                                              : Container(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              updatesList[i].remark != ""
                                                  ? Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                              text: "Remark: ",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          TextSpan(
                                                              text:
                                                                  updatesList[i]
                                                                      .remark,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                  height:
                                                      updatesList[i].remark !=
                                                              ""
                                                          ? 3
                                                          : 0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
