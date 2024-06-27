import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:vetan_panjika/model/filters/allowance_head_type_filter.dart';
import '../../../common/storage_request.dart';
import '../employee_dashboard.dart';

class AllowancesAddEdit extends StatefulWidget {
  final String id;
  final String addEdit;
  const AllowancesAddEdit({Key? key, required this.id, required this.addEdit})
      : super(key: key);

  @override
  _AllowancesAddEditState createState() => _AllowancesAddEditState();
}

class _AllowancesAddEditState extends State<AllowancesAddEdit> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _remarkController = TextEditingController();

  String _amount = "";
  String _type = "";
  String _date = "";
  String _remark = "";

  String? headDropdownValue;
  List<AllowanceHeadTypeFilterModel> headDropdownItems = [];
  String? defaultType;


  String imageText = "Upload Your Image";
  File? allowanceImagePath;

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
    getAllowanceData();
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

  getAllowanceData() {
    var apiController = ApiController();
    if (widget.id != "0") {
      apiController.getAllowanceById(id: widget.id).then((value) {
        if (value != null) {
          _amountController.text = value.data[0].amount;
          _amount = value.data[0].amount;
          var date = value.data[0].dateOld;
          _dateController.text = DateTime(int.parse(date.split("-")[0]),
                  int.parse(date.split("-")[1]), int.parse(date.split("-")[2]))
              .toString();
          _date = DateTime(int.parse(date.split("-")[0]),
                  int.parse(date.split("-")[1]), int.parse(date.split("-")[2]))
              .toString();
          defaultType = value.data[0].headId;
          _type = value.data[0].headId;
          _remarkController.text = value.data[0].remark;
          _remark = value.data[0].remark;
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Allowances"),
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
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  // date field
                  DateTimePicker(
                    controller: _dateController,
                    cursorColor: Colors.cyan,
                    cancelText: "Cancel",
                    confirmText: "Ok",
                    type: DateTimePickerType.date,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.date_range),
                      label: const Text(
                        "Date* ",
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
                    dateLabelText: 'Date* ',
                    style: TextStyle(
                        fontFamily: "latoRegular",
                        color: _dateController.text != ""
                            ? Colors.black
                            : Colors.black45),
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => _date = val ?? "",
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 5),
                  // head type field
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: (value) {
                      if (value == null || value == "0") {
                        return "Please Select Type";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Type *",
                      labelStyle: const TextStyle(
                          fontFamily: "latoRegular", color: Colors.black45),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    hint: const Text("Select Type *"),
                    items: headDropdownItems.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.headName.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: item.id == "0"
                                    ? Colors.black45
                                    : Colors.black)),
                        value: item.id.toString(),
                      );
                    }).toList(),
                    value: defaultType,
                    onChanged: (String? value) {
                      setState(() {
                        defaultType = value;
                        _type = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  // amount field
                  TextFormField(
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
                      label: const Text(
                        "Amount *",
                        style: TextStyle(
                            fontFamily: "latoRegular", color: Colors.black45),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d*)')),
                    ],
                    cursorColor: Colors.cyan,
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    onSaved: (String? val) => _amount = val ?? "",
                  ),
                  const SizedBox(height: 5),
                  // remark field
                  TextFormField(
                    controller: _remarkController,
                    textCapitalization: TextCapitalization.words,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: const Text(
                        "Remark *",
                        style: TextStyle(
                            fontFamily: "latoRegular", color: Colors.black45),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    cursorColor: Colors.cyan,
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                    validator: (String? remarkName) {
                      return null;
                    },
                    onSaved: (String? val) => _remark = val ?? "",
                  ),
                  const SizedBox(height: 5),
                  // select file field
                  InkWell(
                    onTap: () async {
                      if ((await PermissionRequests().storagePermission()) == "Granted") {
                        var image;
                        image = await FilePicker.platform.pickFiles(type: FileType.any);
                        if (image != null) {
                          if(image.files[0].path != null) {
                            setState(() {
                              allowanceImagePath = File(image.files[0].path);
                              imageText = image.files[0].path
                                  .toString()
                                  .split('/')
                                  .last;
                            });
                          }
                        }
                      } else {
                        showDialog(context: context, builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text("No Storage Permission"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        });
                      }

                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text("Select Image"),
                      //       actions: [
                      //         TextButton.icon(
                      //             onPressed: () async {
                      //               Navigator.pop(context);
                      //               var image;
                      //               image = await _picker.pickImage(
                      //                 source: ImageSource.camera,
                      //               );
                      //               if (image != null) {
                      //                 setState(() {
                      //                   expenseImagePath = File(image.path);
                      //                   imageText = image.path
                      //                       .toString()
                      //                       .split('/')
                      //                       .last;
                      //                 });
                      //               }
                      //             },
                      //             icon: const Icon(Icons.photo_camera),
                      //             label: const Text("Camera")),
                      //         TextButton.icon(
                      //           onPressed: () async {
                      //             Navigator.pop(context);
                      //             var image;
                      //             image = await _picker.pickImage(
                      //               source: ImageSource.gallery,
                      //             );
                      //             if (image != null) {
                      //               setState(() {
                      //                 expenseImagePath = File(image.path);
                      //                 imageText =
                      //                     image.path.toString().split('/').last;
                      //               });
                      //             }
                      //           },
                      //           icon: const Icon(Icons.image_outlined),
                      //           label: const Text("Gallery"),
                      //         ),
                      //         TextButton.icon(
                      //           onPressed: () async {
                      //             Navigator.pop(context);
                      //             var image;
                      //             image = await FilePicker.platform.pickFiles();
                      //             if (image != null) {
                      //               if(image.files[0].path != null) {
                      //                 setState(() {
                      //                   expenseImagePath = File(image.files[0].path);
                      //                   imageText = image.files[0].path
                      //                       .toString()
                      //                       .split('/')
                      //                       .last;
                      //                 });
                      //               }
                      //             }},
                      //           icon: const Icon(Icons.insert_drive_file_outlined),
                      //           label: const Text("File"),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.only(top: 12, left: 10, right: 8),
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      height: 45,
                      child: Text(
                        imageText,
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          color: imageText == "Upload Your Image"
                              ? Colors.grey[700]
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          minWidth: 100.0,
                          splashColor: Colors.red[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.cyan,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            var apiController = ApiController();
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Map<String, String> allowanceData = {
                                "AddEdit": widget.addEdit,
                                "ID": widget.id,
                                "HeadID": _type,
                                "Amount": _amount,
                                "Remark": _remark,
                                "TransDate": _date,
                              };
                              if (allowanceImagePath != null) {
                                allowanceData.addAll({
                                  "filePath": allowanceImagePath!.path,
                                  "filename": imageText,
                                });
                              }

                              apiController
                                  .addEditEmployeeAllowance(
                                      addEditData: allowanceData)
                                  .then((value) {
                                if (value == "Allowances Added Successfully..." ||
                                    value ==
                                        "Allowances Updated Successfully...") {
                                  CommonFunctions().toastMessage(value);
                                  Navigator.pop(context);
                                } else {
                                  CommonFunctions().toastMessage(value);
                                }
                              });
                            }
                          },
                          minWidth: 100.0,
                          splashColor: Colors.red[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
