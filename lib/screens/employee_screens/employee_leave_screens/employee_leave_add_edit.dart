import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../../../model/filters/leave_type_filter.dart';
import '../../../utils/color_data.dart';
import '../../../utils/constant.dart';
import '../../../utils/widget.dart';
import '../employee_dashboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeaveAddEdit extends StatefulWidget {
  final String id;
  final String addEdit;

  const LeaveAddEdit({Key? key, required this.id, required this.addEdit})
      : super(key: key);

  @override
  _LeaveAddEditState createState() => _LeaveAddEditState();
}

class _LeaveAddEditState extends State<LeaveAddEdit> {
  final _formKey = GlobalKey<FormState>();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _reasonController = TextEditingController();

  List fullDayHalfDay = [
    {"id": "0", "value": "Select Type"},
    {"id": "1", "value": "Full Day"},
    {"id": "2", "value": "Half Day"},
  ];
  String? fullDayHalfDayDropdown;
  String selectedDayType = "";

  String _type = "";
  String _fromDate = "";
  String _toDate = "";
  // String _reason = "";

  String? leaveTypeDropdownValue;
  List<LeaveTypeFilterModel> leaveTypeDropdownItems = [];
  String? defaultType;

  getDateOnly() {
    DateTime today = DateTime.now();
    _fromDateController.text =
        DateTime(today.year, today.month, today.day).toString();
    _toDateController.text =
        DateTime(today.year, today.month, today.day).toString();
  }

  @override
  void initState() {
    super.initState();
    getDateOnly();
    getHeadTypeFilter();
  }

  getHeadTypeFilter() {
    var apiController = ApiController();
    apiController.getLeaveTypeFilter().then((value) {
      if (value!.data.isNotEmpty) {
        leaveTypeDropdownItems = value.data;
      }
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
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  getAssetImage("back.png", 14.h, 10.h),
                  getHorizontalSpace(9.h),
                  getCustomFont("Apply Leave", 20.sp, Colors.white, 1,
                      fontWeight: FontWeight.w600),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                getVerticalSpace(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getCustomFont(
                      "Leave Type", 12.sp, Color(0xFF868686), 1,
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
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                        value: defaultType,
                        isExpanded: true,
                        elevation: 0,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.fontFamily),
                        iconSize: 25,
                        hint: Text(
                          'Select Type *',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily),
                        ),
                        onChanged: (value) {
                          setState(() {
                            defaultType = value;
                            _type = value!;
                          });
                        },
                        items: leaveTypeDropdownItems.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item.typeName.toString(),
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
                  child: getCustomFont("Day", 12.sp, Color(0xFF868686), 1,
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
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                        value: fullDayHalfDayDropdown,
                        isExpanded: true,
                        elevation: 0,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.fontFamily),
                        iconSize: 25,
                        hint: Text(
                          'Select Full Day/ Half Day *',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fullDayHalfDayDropdown = value;
                            selectedDayType = value!;
                          });
                        },
                        items: fullDayHalfDay.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item["value"].toString(),
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
                      "Start Date", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  height: 40.h,
                  child: DateTimePicker(
                    controller: _fromDateController,
                    cursorColor: Colors.cyan,
                    cancelText: "Cancel",
                    confirmText: "Ok",
                    type: DateTimePickerType.date,
                    decoration: InputDecoration(
                      suffixIconConstraints:
                          BoxConstraints(maxWidth: 28.h, minWidth: 28.h),
                      suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 10.h),
                          child: getAssetImage("calendar.png", 18.h, 18.h)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.h, vertical: 2.h),
                      hintText: "dd/mm/yyyy",
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                    ),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateHintText: "DD/MM/YYYY",
                    dateLabelText: 'From Date* ',
                    style: TextStyle(
                        fontFamily: Constant.fontFamily,
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => _fromDate = val ?? "",
                  ),
                ),
                getVerticalSpace(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getCustomFont("End Date", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  height: 40.h,
                  child: DateTimePicker(
                    controller: _toDateController,
                    cursorColor: Colors.cyan,
                    cancelText: "Cancel",
                    confirmText: "Ok",
                    type: DateTimePickerType.date,
                    decoration: InputDecoration(
                      suffixIconConstraints:
                          BoxConstraints(maxWidth: 28.h, minWidth: 28.h),
                      suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 10.h),
                          child: getAssetImage("calendar.png", 18.h, 18.h)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.h, vertical: 2.h),
                      hintText: "dd/mm/yyyy",
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(color: Color(0xFFEDEDED))),
                    ),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateHintText: "DD/MM/YYYY",
                    dateLabelText: 'To Date* ',
                    style: TextStyle(
                        fontFamily: Constant.fontFamily,
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => _toDate = val ?? "",
                  ),
                ),
                getVerticalSpace(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getCustomFont(
                      "Reason For Leave", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: TextFormField(
                    controller: _reasonController,
                    textCapitalization: TextCapitalization.words,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                        fontFamily: Constant.fontFamily,
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 10.h),
                        hintText: "Reason *",
                        hintStyle: TextStyle(
                            fontFamily: Constant.fontFamily,
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.h),
                            borderSide: BorderSide(color: Color(0xFFEDEDED))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.h),
                            borderSide: BorderSide(color: Color(0xFFEDEDED))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.h),
                            borderSide: BorderSide(color: Color(0xFFEDEDED))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.h),
                            borderSide: BorderSide(color: Color(0xFFEDEDED))),
                        counterText: ""),
                    cursorColor: Colors.cyan,
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                    validator: (String? reasonName) {
                      return null;
                    },
                    // onSaved: (String? val) => _reason = val ?? "",
                  ),
                ),
                getVerticalSpace(60.h),
                GestureDetector(
                  onTap: () {
                    var apiController = ApiController();
                    if (_type.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please select leave type.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } else if (selectedDayType.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please select day.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } else if (_reasonController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please enter reason for leave.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } else {
                      Map<String, String> leaveData = {
                        "AddEdit": widget.addEdit,
                        "ID": widget.id,
                        "LeaveType": _type,
                        "FullDayHalfDay": selectedDayType,
                        "LeaveDate": _fromDate,
                        "LeaveToDate": _toDate,
                        "Reason": _reasonController.text,
                      };

                      apiController
                          .addEditEmployeeLeave(addEditData: leaveData)
                          .then((value) {
                        if (value == "Leave Marked Successfully..." ||
                            value == "Leave Updated Successfully...") {
                          CommonFunctions().toastMessage(value);
                          Navigator.pop(context);
                        } else {
                          CommonFunctions().toastMessage(value);
                        }
                      });
                    }
                  },
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
                    child: getCustomFont("Apply Leave", 16.sp, Colors.white, 1,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // // Reason field
          //
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 40),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       MaterialButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         minWidth: 100.0,
          //         splashColor: Colors.red[200],
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)),
          //         color: Colors.cyan,
          //         padding: const EdgeInsets.symmetric(vertical: 10),
          //         child: const Text(
          //           "Cancel",
          //           style: TextStyle(
          //             fontSize: 18.0,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       MaterialButton(
          //         onPressed: () {
          //           var apiController = ApiController();
          //           if (_formKey.currentState!.validate()) {
          //             _formKey.currentState!.save();
          //             Map<String, String> leaveData = {
          //               "AddEdit": widget.addEdit,
          //               "ID": widget.id,
          //               "LeaveType": _type,
          //               "FullDayHalfDay": selectedDayType,
          //               "LeaveDate": _fromDate,
          //               "LeaveToDate": _toDate,
          //               "Reason": _reason,
          //             };
          //
          //             apiController
          //                 .addEditEmployeeLeave(addEditData: leaveData)
          //                 .then((value) {
          //               if (value == "Leave Marked Successfully..." ||
          //                   value == "Leave Updated Successfully...") {
          //                 CommonFunctions().toastMessage(value);
          //                 Navigator.pop(context);
          //               } else {
          //                 CommonFunctions().toastMessage(value);
          //               }
          //             });
          //           }
          //         },
          //         minWidth: 100.0,
          //         splashColor: Colors.red[200],
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)),
          //         color: Colors.red,
          //         padding: const EdgeInsets.symmetric(vertical: 10),
          //         child: const Text(
          //           "Submit",
          //           style: TextStyle(
          //             fontSize: 18.0,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
