import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import '../common/common_func.dart';
import '../common/database_helper.dart';
import '../controllers/api_controller.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'employee_screens/employee_dashboard.dart';

class InAppServerConfig extends StatefulWidget {
  const InAppServerConfig({Key? key}) : super(key: key);

  @override
  State<InAppServerConfig> createState() => _InAppServerConfigState();
}

class _InAppServerConfigState extends State<InAppServerConfig> {

  bool showLoader = false;
  // local settings formKey
  final _serverSetFormKey = GlobalKey<FormState>();
  // server configuration //
  final _companyIdController = TextEditingController();
  final _softwareUrlController = TextEditingController();

  String? _companyID;
  String? _softwareUrl;

  String _verticalGroupValue = "Admin";
  List<String> options = ["Admin", "Employee"];
  // -- //

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  // to get server settings
  getSettings() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String url = shared.getString("baseURL") ?? "";
    _verticalGroupValue = shared.getString("userType") ?? "Admin";
    String _companyIDStored = shared.getString("CompanyID") ?? "";
    if (url.isNotEmpty) {
      _softwareUrl = url;
      _softwareUrlController.text = _softwareUrl ?? "";
    }
    if (_companyIDStored.isNotEmpty) {
      _companyID = _companyIDStored;
      _companyIdController.text = _companyIDStored;
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Server Settings",
          style: theme.text20,
        ),
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
      body: _serverConfiguration(size),
    );
  }

  _serverConfiguration(size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(40),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Form(
              key: _serverSetFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // admin or employee
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: _verticalGroupValue,
                        activeColor: Colors.cyan,
                        horizontalAlignment:
                        MainAxisAlignment.spaceAround,
                        onChanged: (value) => setState(() {
                          _verticalGroupValue = value!;
                        }),
                        items: options,
                        textStyle: const TextStyle(
                            fontSize: 15, color: Colors.black),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ],
                  ),
                  // companyID
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        controller: _companyIdController,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.blue,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'Please Enter Company ID';
                          } else {
                            return null;
                          }
                        },
                        maxLength: 50,
                        onSaved: (companyID) =>
                        _companyID = companyID!.trim(),
                        decoration: const InputDecoration(
                          prefixIcon:
                          Icon(Icons.person, color: Colors.cyan),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          hintText: 'Enter Company Id',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  const SizedBox(height: 5),
                  // ip address
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: _softwareUrlController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      cursorColor: Colors.blue,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Software Url can't be empty";
                        } else {
                          return null;
                        }
                      },
                      maxLength: 200,
                      onSaved: (ipAddress) =>
                      _softwareUrl = ipAddress!.trim(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        hintText: 'Enter Software Url',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // submit button
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        if (_verticalGroupValue == "Admin") {
                          SharedPreferences shared =
                          await SharedPreferences.getInstance();
                          if (_serverSetFormKey.currentState!.validate()) {
                            _serverSetFormKey.currentState!.save();
                            showLoader = true;
                            String baseURL = _softwareUrl!;
                            LocalDB localDB = LocalDB();
                            await localDB.getDB();
                            await localDB.updateTable(queryForDB: "update background_data set companyId='$_companyID', baseUrl='$baseURL', userType='$_verticalGroupValue'");
                            final apiController = ApiController();
                            apiController.checkServerConfig(baseUrl: baseURL, companyId: _companyID!).then((value) {
                              if (value == "Success") {
                                shared.setString("CompanyID", _companyID!);
                                shared.setString(
                                    "userType", _verticalGroupValue);
                                shared.setString("baseURL", baseURL);
                                showLoader = false;
                                Navigator.pop(context);
                              } else {
                                showLoader = false;
                                CommonFunctions().toastMessage(value);
                              }
                            });
                          }
                        }
                        if (_verticalGroupValue != "Admin") {
                          SharedPreferences shared =
                          await SharedPreferences.getInstance();
                          if (_serverSetFormKey.currentState!.validate()) {
                            _serverSetFormKey.currentState!.save();
                            showLoader = true;
                            String baseURL = _softwareUrl!;
                            LocalDB localDB = LocalDB();
                            await localDB.getDB();
                            await localDB.updateTable(queryForDB: "update background_data set companyId='$_companyID', baseUrl='$baseURL', userType='$_verticalGroupValue'");
                            final apiController = ApiController();
                            apiController.checkServerConfig(baseUrl: baseURL, companyId: _companyID!).then((value) {
                              if (value == "Success") {
                                shared.setString("CompanyID", _companyID!);
                                shared.setString(
                                    "userType", _verticalGroupValue);
                                shared.setString("baseURL", baseURL);
                                showLoader = false;
                                Navigator.pop(context);
                              } else {
                                showLoader = false;
                                CommonFunctions().toastMessage(value);
                              }
                            });
                          }
                        }
                      },
                      minWidth: 120.0,
                      splashColor: Colors.red[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
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
            ),
          ],
        ),
      ),
    );
  }
}
