import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/common/storage_request.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:vetan_panjika/model/filters/expense_head_type_filter.dart';
import '../../../model/filters/expense_head_subtype_filter.dart';
import '../../../utils/color_data.dart';
import '../../../utils/constant.dart';
import '../../../utils/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../employee_dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExpensesAddEdit extends StatefulWidget {
  final String id;
  final String addEdit;

  const ExpensesAddEdit({Key? key, required this.id, required this.addEdit})
      : super(key: key);

  @override
  _ExpensesAddEditState createState() => _ExpensesAddEditState();
}

class _ExpensesAddEditState extends State<ExpensesAddEdit> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _remarkController = TextEditingController();

  // String _amount = "";
  String _type = "";
  String _subtype = "";
  String _date = "";

  // String _remark = "";

  String? headDropdownValue;
  List<ExpenseHeadTypeFilterModel> headDropdownItems = [];
  String? defaultType;
  String? subtypeDropdownValue;
  List<ExpenseHeadSubtypeFilterModel> subtypeDropdownItems = [];
  String? defaultSubtype;

  // image picker
  // final ImagePicker _picker = ImagePicker();
  String imageText = "";
  File? expenseImagePath;

  getDateOnly() {
    DateTime today = DateTime.now();
    _dateController.text =
        DateTime(today.year, today.month, today.day).toString();
  }

  @override
  void initState() {
    super.initState();
    getDateOnly();
    getHeadTypeFilter();
    getSubtypeFilter();
    getExpenseData();
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

  getSubtypeFilter() {
    var apiController = ApiController();
    apiController.getExpenseSubtypeFilter().then((value) {
      if (value!.data.isNotEmpty) {
        subtypeDropdownItems = value.data;
      }
      setState(() {});
    });
  }

  getExpenseData() {
    var apiController = ApiController();
    if (widget.id != "0") {
      apiController.getExpenseById(id: widget.id).then((value) {
        if (value != null) {
          imageText = value.data[0].fileName;
          _amountController.text = value.data[0].amount;
          // _amount = value.data[0].amount;
          var date = value.data[0].dateOld;
          _dateController.text = DateTime(int.parse(date.split("-")[0]),
                  int.parse(date.split("-")[1]), int.parse(date.split("-")[2]))
              .toString();
          _date = DateTime(int.parse(date.split("-")[0]),
                  int.parse(date.split("-")[1]), int.parse(date.split("-")[2]))
              .toString();
          defaultType = value.data[0].headId;
          _type = value.data[0].headId;
          defaultSubtype = value.data[0].subtypeId;
          _subtype = value.data[0].subtypeId;
          _remarkController.text = value.data[0].remark;
          // _remark = value.data[0].remark;
        }
        setState(() {});
      });
    }
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
      //   centerTitle: true,
      //   title: const Text("Expenses"),
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
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                getVerticalSpace(20.h),
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
                          'Select Expenses Type *',
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
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                        value: defaultSubtype,
                        isExpanded: true,
                        elevation: 0,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.fontFamily),
                        iconSize: 25,
                        hint: Text(
                          'Select Expenses Sub Type *',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily),
                        ),
                        onChanged: (value) {
                          setState(() {
                            defaultSubtype = value;
                            _subtype = value!;
                          });
                        },
                        items: subtypeDropdownItems.map((item) {
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
                  child: getCustomFont("Date", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  height: 40.h,
                  child: DateTimePicker(
                    controller: _dateController,
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
                    dateLabelText: 'Date* ',
                    style: TextStyle(
                        fontFamily: Constant.fontFamily,
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => _date = val ?? "",
                  ),
                ),
                getVerticalSpace(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getCustomFont("Amount", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  height: 40.h,
                  child: TextFormField(
                    controller: _amountController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Please Add Amount";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 0.h),
                        hintText: "Amount *",
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d*)')),
                    ],
                    cursorColor: Colors.cyan,
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    // onSaved: (String? val) => _amount = val ?? "",
                  ),
                ),
                getVerticalSpace(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getCustomFont("Document", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                GestureDetector(
                  onTap: () async {
                    // if ((await PermissionRequests().storagePermission()) ==
                    //     "Granted") {
                    // var image;
                    // image = await FilePicker.platform
                    //     .pickFiles(type: FileType.any);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      if (result.files.single.path != null) {
                        File file = File(result.files.single.path!);
                        setState(() {
                          expenseImagePath = file;
                          imageText = file.path.toString().split('/').last;
                        });
                      }
                    } else {
                      // User canceled the picker
                    }
                    // if (image != null) {
                    //   if (image.files[0].path != null) {
                    //     setState(() {
                    //       expenseImagePath = File(image.files[0].path);
                    //       imageText =
                    //           image.files[0].path.toString().split('/').last;
                    //     });
                    //   }
                    // }
                    // } else {
                    //   showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return CupertinoAlertDialog(
                    //           title: const Text("No Storage Permission"),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.pop(context);
                    //               },
                    //               child: const Text("OK"),
                    //             ),
                    //           ],
                    //         );
                    //       });
                    // }
                  },
                  child: imageText.isNotEmpty
                      ? Container(
                          height: 175.h,
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.h),
                              border: Border.all(color: Color(0xFFEDEDED))),
                          alignment: Alignment.center,
                          child: getMultiLineFont(
                              imageText, 16.sp, Color(0xFF0F0F0F),
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center),
                        )
                      : Container(
                          height: 175.h,
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          // padding: EdgeInsets.symmetric(vertical: 26.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.h),
                              border: Border.all(color: Color(0xFFEDEDED))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getAssetImage("upload.png", 50.h, 50.h),
                              getVerticalSpace(20.h),
                              RichText(
                                  text: TextSpan(
                                      text: "Drag & drop files or ",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF0F0F0F),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: Constant.fontFamily),
                                      children: [
                                    TextSpan(
                                      text: "Browse",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF1B6392),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: Constant.fontFamily),
                                    )
                                  ])),
                              getVerticalSpace(8.h),
                              getCustomFont(
                                  "Supported formates: EXCEL, PDF, JPG, JPEF, PNG",
                                  10.sp,
                                  Color(0xFF676767),
                                  1,
                                  fontWeight: FontWeight.w400)
                            ],
                          ),
                        ),
                ),
                getVerticalSpace(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: getCustomFont("Remark", 12.sp, Color(0xFF868686), 1,
                      fontWeight: FontWeight.w400),
                ),
                getVerticalSpace(2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: TextFormField(
                    controller: _remarkController,
                    textCapitalization: TextCapitalization.words,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontFamily: Constant.fontFamily,
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 10.h),
                        hintText: "Remark",
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
                    validator: (String? remarkName) {
                      return null;
                    },
                    // onSaved: (String? val) => _remark = val ?? "",
                  ),
                ),
                getVerticalSpace(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.h),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1)),
                            height: 40.h,
                            alignment: Alignment.center,
                            child: getCustomFont(
                                "Cancel", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      getHorizontalSpace(16.h),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            var apiController = ApiController();
                            if (_type.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please select expenses type.",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } else if (_subtype.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please select expenses sub type.",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } else if (_amountController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter amount.",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } else {
                              Map<String, String> expensesData = {
                                "AddEdit": widget.addEdit,
                                "ID": widget.id,
                                "ExpencesTypeID": _type,
                                "ExpencesSubTypeID": _subtype,
                                "Amount": _amountController.text,
                                "Remark": _remarkController.text,
                                "TransDate": _date,
                              };
                              if (expenseImagePath != null) {
                                expensesData.addAll({
                                  "filePath": expenseImagePath!.path,
                                  "filename": imageText,
                                });
                              }

                              apiController
                                  .addEditEmployeeExpenses(
                                      addEditData: expensesData)
                                  .then((value) {
                                if (value == "Expenses Added Successfully..." ||
                                    value ==
                                        "Expenses Updated Successfully...") {
                                  CommonFunctions().toastMessage(value);
                                  Navigator.pop(context);
                                } else {
                                  CommonFunctions().toastMessage(value);
                                }
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(5.h),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF3197FF).withOpacity(0.5),
                                      offset: Offset(0, 0),
                                      blurRadius: 10)
                                ]),
                            height: 40.h,
                            alignment: Alignment.center,
                            child: getCustomFont(
                                "Save", 16.sp, AppColors.unselectColor, 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // amount field

          // const SizedBox(height: 5),
          // InkWell(
          //   onTap: () async {
          //     if ((await PermissionRequests().storagePermission()) ==
          //         "Granted") {
          //       var image;
          //       image = await FilePicker.platform.pickFiles(type: FileType.any);
          //       if (image != null) {
          //         if (image.files[0].path != null) {
          //           setState(() {
          //             expenseImagePath = File(image.files[0].path);
          //             imageText =
          //                 image.files[0].path.toString().split('/').last;
          //           });
          //         }
          //       }
          //     } else {
          //       showDialog(
          //           context: context,
          //           builder: (context) {
          //             return CupertinoAlertDialog(
          //               title: const Text("No Storage Permission"),
          //               actions: [
          //                 TextButton(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                   child: const Text("OK"),
          //                 ),
          //               ],
          //             );
          //           });
          //     }
          //
          //     // showDialog(
          //     //   context: context,
          //     //   builder: (context) {
          //     //     return AlertDialog(
          //     //       title: const Text("Select Image"),
          //     //       actions: [
          //     //         TextButton.icon(
          //     //             onPressed: () async {
          //     //               Navigator.pop(context);
          //     //               var image;
          //     //               image = await _picker.pickImage(
          //     //                 source: ImageSource.camera,
          //     //               );
          //     //               if (image != null) {
          //     //                 setState(() {
          //     //                   expenseImagePath = File(image.path);
          //     //                   imageText = image.path
          //     //                       .toString()
          //     //                       .split('/')
          //     //                       .last;
          //     //                 });
          //     //               }
          //     //             },
          //     //             icon: const Icon(Icons.photo_camera),
          //     //             label: const Text("Camera")),
          //     //         TextButton.icon(
          //     //           onPressed: () async {
          //     //             Navigator.pop(context);
          //     //             var image;
          //     //             image = await _picker.pickImage(
          //     //               source: ImageSource.gallery,
          //     //             );
          //     //             if (image != null) {
          //     //               setState(() {
          //     //                 expenseImagePath = File(image.path);
          //     //                 imageText =
          //     //                     image.path.toString().split('/').last;
          //     //               });
          //     //             }
          //     //           },
          //     //           icon: const Icon(Icons.image_outlined),
          //     //           label: const Text("Gallery"),
          //     //         ),
          //     //         TextButton.icon(
          //     //           onPressed: () async {
          //     //             Navigator.pop(context);
          //     //             var image;
          //     //             image = await FilePicker.platform.pickFiles();
          //     //             if (image != null) {
          //     //               if(image.files[0].path != null) {
          //     //                 setState(() {
          //     //                   expenseImagePath = File(image.files[0].path);
          //     //                   imageText = image.files[0].path
          //     //                       .toString()
          //     //                       .split('/')
          //     //                       .last;
          //     //                 });
          //     //               }
          //     //             }},
          //     //           icon: const Icon(Icons.insert_drive_file_outlined),
          //     //           label: const Text("File"),
          //     //         ),
          //     //       ],
          //     //     );
          //     //   },
          //     // );
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.only(top: 12, left: 10, right: 8),
          //     width: size.width * 0.85,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(5),
          //       border: Border.all(color: Colors.grey, width: 1),
          //     ),
          //     height: 45,
          //     child: Text(
          //       imageText,
          //       style: TextStyle(
          //         fontSize: 16,
          //         overflow: TextOverflow.ellipsis,
          //         color: imageText == "Upload Your Expense Image"
          //             ? Colors.grey[700]
          //             : Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}
