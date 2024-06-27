import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/api_controller.dart';

class CommonFunctions {

  networkStatusDot(setState) async {
    setState(() {
      dialogShown;
    });
  }

  // connectivity subscription to check internet connectivity
  Future<void> checkInternet()  async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences shared = await SharedPreferences.getInstance();
        final apiController = ApiController();
        String baseURL = shared.getString("baseURL") ?? "";
        String _companyID = shared.getString("CompanyID") ?? "";
        apiController
            .checkServerConfig(baseUrl: baseURL, companyId: _companyID)
            .then((value) {
          if (value == "Success") {
            dialogShown = false;
          } else {
            dialogShown = true;
          }
        });
      }
    } on SocketException catch (_) {
      dialogShown = true;
    }
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.black,
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        fontSize: 18.0);
  }
}

// extension to change dateTime day/ month/ year
extension CopyWithAdditional on DateTime {
  DateTime copyWithAdditional({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    return DateTime(
      year + years,
      month + months,
      day + days,
      hour + hours,
      minute + minutes,
      second + seconds,
      millisecond + milliseconds,
      microsecond + microseconds,
    );
  }
}
