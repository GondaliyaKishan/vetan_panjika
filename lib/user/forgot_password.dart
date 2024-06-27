import  'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import '../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'otp_verify.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // forgot password formKey
  final _formKey = GlobalKey<FormState>();
  bool showLoader = false;
  String _mobileNo = "";

  Future<String> checkUserInLocalDB(mobileNo) async {
    String returnMsg = "";
    LocalDB _localDB = LocalDB();
    await _localDB.getDB();
    var v = await _localDB.getDataTable(
        queryForDB:
        "select * from employee_details where mobile_no='$mobileNo'");
    if (v.isEmpty) {
      returnMsg = "User doesn't Exist";
    } else if (v.isNotEmpty) {
      returnMsg = "User Exist";
    }
    return returnMsg;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            child: Image(
                                image: AssetImage("assets/OM_logo.png"), height: 65),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Forgot Password",
                              style: theme.text22!.copyWith(
                                  color: Colors.red, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // mobile no field
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              showCursor: true,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.phone,
                              validator: (mobileNo) {
                                if (mobileNo!.isEmpty) {
                                  return 'Please enter Mobile No';
                                } else if (mobileNo.length < 10) {
                                  return 'Please enter valid Mobile No';
                                } else {
                                  return null;
                                }
                              },
                              maxLength: 10,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              cursorColor: Colors.blue,
                              decoration: const InputDecoration(
                                prefixIcon:
                                Icon(Icons.phone_android, color: Colors.blueAccent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                hintText: 'Enter Mobile No',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onSaved: (mobileNo) => _mobileNo = mobileNo!.trim(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          // cancel & submit buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    MaterialButton(
                                      onPressed: () => Navigator.pop(context),
                                      minWidth: 120.0,
                                      splashColor: Colors.white60,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          setState(() {
                                            showLoader = true;
                                          });
                                          final apiController = ApiController();
                                          checkUserInLocalDB(_mobileNo)
                                              .then((value) {
                                            if (value == "User doesn't Exist") {
                                              setState(() {
                                                showLoader = false;
                                              });
                                              CommonFunctions()
                                                  .toastMessage(value);
                                            } else {
                                              apiController
                                                  .sendOtp(mobileNo: _mobileNo)
                                                  .then((value) {
                                                String status =
                                                value.split("|||||")[0];
                                                if (status == "Success") {
                                                  setState(() {
                                                    showLoader = false;
                                                  });
                                                  String id =
                                                  value.split("|||||")[1];
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          OTPVerify(
                                                            mobileNo: _mobileNo,
                                                            otpType: "forgot",
                                                            id: id,
                                                            userInfo: const {},
                                                            fcmTopic: "",
                                                          ),
                                                    ),
                                                  );
                                                } else if (status ==
                                                    "Invailid Company ID") {
                                                  setState(() {
                                                    showLoader = false;
                                                  });
                                                  CommonFunctions()
                                                      .toastMessage(status);
                                                } else if (status ==
                                                    "Invailid Mobile No") {
                                                  setState(() {
                                                    showLoader = false;
                                                  });
                                                  CommonFunctions()
                                                      .toastMessage(status);
                                                }
                                              });
                                            }
                                          });
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
                            ],
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
                  const SpinKitFadingCircle(color: Colors.blueAccent, size: 70))),
        ],
      ),
    );
  }
}
