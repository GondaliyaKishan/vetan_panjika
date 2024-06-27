import 'package:flutter/material.dart';

import 'package:date_time_picker/date_time_picker.dart';
import '../../../common/common_func.dart';
import '../../../controllers/api_controller.dart';
import '../../../model/employee_models/employee_daily_update/daily_update_head_model.dart';
import '../employee_dashboard.dart';

class DailyUpdateAddEdit extends StatefulWidget {
  final String id;
  final String addEdit;
  const DailyUpdateAddEdit({Key? key, required this.id, required this.addEdit}) : super(key: key);

  @override
  State<DailyUpdateAddEdit> createState() => _DailyUpdateAddEditState();
}

class _DailyUpdateAddEditState extends State<DailyUpdateAddEdit> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();

  String? projectDropdownValue;
  List<DailyUpdateHeadDataModel> projectDropdownItems = [];
  final _dateController = TextEditingController();

  String? defaultProject;
  String _project = "";
  String _remark = "";
  String _date = "";

  @override
  void initState() {
    super.initState();
    getProjects();
    getDateOnly();
    if (widget.id != "") getUpdate();
  }

  getDateOnly() {
    DateTime today = DateTime.now();
    _dateController.text =
        DateTime(today.year, today.month, today.day).toString();
    _date = _dateController.text.split(" ")[0];
  }

  getProjects() {
    var apiController = ApiController();
    apiController.getDailyUpdateFilter().then((value) {
      if (value!.data.isNotEmpty) {
        projectDropdownItems = value.data;
      }
      setState(() {});
    });
  }

  getUpdate() {
    var apiController = ApiController();
    apiController
        .getDailyUpdateById(
        id: widget.id)
        .then((value) {
      if (value != null) {
        var date = value.data[0].transDateOld;
        _dateController.text = DateTime(int.parse(date.split("-")[0]),
            int.parse(date.split("-")[1]), int.parse(date.split("-")[2]))
            .toString();
        _date = _dateController.text.split(" ")[0];
        defaultProject = value.data[0].projectId;
        _project = value.data[0].projectId;
        _remarkController.text = value.data[0].remark;
        _remark = value.data[0].remark;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Daily Update"),
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
                    onSaved: (val) => _date = val!.split(" ")[0],
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 5),
                  // head type field
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: (value) {
                      if (value == null || value == "0") {
                        return "Please Select Project";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Project *",
                      labelStyle: const TextStyle(
                          fontFamily: "latoRegular", color: Colors.black45),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    hint: const Text("Select Project *"),
                    items: projectDropdownItems.map((item) {
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
                    value: defaultProject,
                    onChanged: (String? value) {
                      setState(() {
                        defaultProject = value;
                        _project = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  // remark field
                  TextFormField(
                    controller: _remarkController,
                    textCapitalization: TextCapitalization.words,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: const Text(
                        "Remark",
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
                    maxLength: 300,
                    validator: (String? remarkName) {
                      if (remarkName == "") {
                        return "Please add Remark";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? val) => _remark = val ?? "",
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
                          onPressed: () async {
                            var apiController = ApiController();
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Map<String, String> updateData = {
                                "AddEdit": widget.addEdit,
                                "ID": widget.id,
                                "ProjectID": _project,
                                "Remark": _remark,
                                "TransDate": _date,
                              };
                              apiController
                                  .addEditEmployeeDailyUpdate(
                                  addEditData: updateData)
                                  .then((value) {
                                if (value == "Daily Updates Added Successfully..." ||
                                    value ==
                                        "Daily Updates Updated Successfully...") {
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
