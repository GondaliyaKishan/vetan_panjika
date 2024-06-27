import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/common/database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

class ResetPassword extends StatefulWidget {
  final String mobileNo;

  const ResetPassword({Key? key, required this.mobileNo}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool showLoader = false;
  // reset password formKey
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool showPassword = true;

  String _confirmPassword = "";

  Future<String> resetPasswordLocal({required String password}) async {
    String returnMsg = "";
    try {
      LocalDB _localDB = LocalDB();
      await _localDB.getDB();
      var v = await _localDB.updateTable(queryForDB: """
      UPDATE employee_details
      SET password = '$password'
      where mobile_no='${widget.mobileNo}'
      """);
      debugPrint(v.toString());
      returnMsg = "password updated";
    } catch (e) {
      debugPrint(e.toString());
      returnMsg = "error occurred";
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
                              image: AssetImage("assets/OM_logo.png"),
                              height: 65),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Reset Password",
                            style: theme.text22!.copyWith(
                                color: Colors.red, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // password field
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            showCursor: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: showPassword,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.blue,
                            validator: (password) {
                              if (password!.isEmpty) {
                                return 'Invalid password';
                              } else {
                                return null;
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30)
                            ],
                            onFieldSubmitted: (_) {
                              _fieldFocusChange(
                                  context, _passwordFocus, _confirmPasswordFocus);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.vpn_key_outlined,
                                  color: Colors.blueAccent),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: showPassword
                                    ? const FaIcon(FontAwesomeIcons.solidEye,
                                        size: 20, color: Colors.grey)
                                    : const FaIcon(FontAwesomeIcons.eyeSlash,
                                        size: 20, color: Colors.blue),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              hintText: 'Enter password',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // confirm password field
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            showCursor: true,
                            focusNode: _confirmPasswordFocus,
                            obscureText: showPassword,
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.blue,
                            validator: (password) {
                              if (password!.isEmpty) {
                                return 'Invalid password';
                              } else if (password != _passwordController.text) {
                                return "Password doesn't match";
                              } else {
                                return null;
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30)
                            ],
                            onSaved: (password) =>
                                _confirmPassword = password!.trim(),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.vpn_key_outlined,
                                  color: Colors.blueAccent),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: showPassword
                                    ? const FaIcon(FontAwesomeIcons.solidEye,
                                        size: 20, color: Colors.grey)
                                    : const FaIcon(FontAwesomeIcons.eyeSlash,
                                        size: 20, color: Colors.blue),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              hintText: 'Enter password',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // cancel submit buttons
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
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
                                        resetPasswordLocal(
                                                password: _confirmPassword)
                                            .then(
                                          (value) {
                                            CommonFunctions().toastMessage(value);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        );
                                      }
                                    },
                                    minWidth: 120.0,
                                    splashColor: Colors.red[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    color: Colors.red,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
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
                  child: const SpinKitFadingCircle(
                      color: Colors.blueAccent, size: 70))),
        ],
      ),
    );
  }

  // field focus change function
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
