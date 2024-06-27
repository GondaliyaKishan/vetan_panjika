import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_native/phoenix_native.dart';
import 'package:vetan_panjika/model/admin_models/admin_dashboard_model.dart';
import 'package:vetan_panjika/model/admin_models/branches_model.dart';
import 'package:vetan_panjika/model/admin_models/day_wise_attendance_report_model.dart';
import 'package:vetan_panjika/model/admin_models/devices_model.dart';
import 'package:vetan_panjika/model/admin_models/employee_wise_attendance_report_model.dart';
import 'package:vetan_panjika/model/admin_models/employees_model.dart';
import 'package:vetan_panjika/model/admin_models/holiday_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_allowances/employee_allowance_form_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_allowances/employee_allowances_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_attendance_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_dashboard_data_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_dashboard_logs_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_details_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_expenses/employee_expense_form_model.dart';
import 'package:vetan_panjika/model/employee_models/employee_expenses/employee_expenses_model.dart';
import 'package:vetan_panjika/model/filters/branch_filter.dart';
import 'package:vetan_panjika/model/filters/device_filter.dart';
import 'package:vetan_panjika/model/filters/employee_filter.dart';
import 'package:vetan_panjika/model/filters/expense_head_type_filter.dart';
import 'package:vetan_panjika/model/nms_models/nms_filter_models/nms_agent_filter_model.dart';
import 'package:vetan_panjika/model/nms_models/nms_filter_models/nms_location_filter_model.dart';
import 'package:vetan_panjika/screens/employee_screens/employee_dashboard.dart';
import 'package:vetan_panjika/user/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../common/database_helper.dart';
import '../main.dart';
import '../model/admin_models/access_control_models/door_lock_model.dart';
import '../model/admin_models/admin_dashboard_device_chart_model.dart';
import '../model/admin_models/admin_dashboard_expenses_model.dart';
import '../model/admin_models/admin_dashboard_leaves_model.dart';
import '../model/employee_models/employee_daily_update/daily_update_head_model.dart';
import '../model/employee_models/employee_daily_update/employee_daily_update_form_model.dart';
import '../model/employee_models/employee_daily_update/employee_daily_update_model.dart';
import '../model/employee_models/employee_leaves/employee_leaves_model.dart';
import '../model/filters/allowance_head_type_filter.dart';
import '../model/filters/expense_head_subtype_filter.dart';
import '../model/filters/leave_type_filter.dart';
import '../model/nms_models/nms_asset_summary_model.dart';
import '../model/nms_models/nms_dashboard_model.dart';
import '../model/nms_models/nms_agent_list_model.dart';
import '../model/nms_models/nms_device_view_model.dart';
import '../model/nms_models/nms_filter_models/nms_device_type_filter_model.dart';
import '../model/nms_models/nms_location_view_model.dart';
import '../model/nms_models/nms_overview_model.dart';
import '../model/nms_models/nms_single_details_models/nms_agent_details_model.dart';
import '../model/nms_models/nms_single_details_models/nms_device_details_model.dart';
import '../model/nms_models/nms_type_wise_list_models/nms_device_type_wise_devices_model.dart';
import '../model/nms_models/nms_type_wise_list_models/nms_location_wise_devices_model.dart';
import '../screens/admin_screens/admin_dashboard.dart';
import '../user/otp_verify.dart';

class ApiController {
  // check server config
  Future<String> checkServerConfig(
      {required String baseUrl, required String companyId}) async {
    String returnMsg = "";
    bool connectivity = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectivity = true;
      }
    } on SocketException catch (_) {
      connectivity = false;
    }
    if (connectivity) {
      try {
        String url = baseUrl +
            urlController.checkConfig +
            urlController.appCode +
            "&CompanyCode=$companyId";

        var configResponse =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

        var response = configResponse.body.toString();
        print("url==============${response}");
        returnMsg = response;
      } catch (e) {
        returnMsg = "Server Unreachable";
        debugPrint(e.toString());
      }
    }
    return returnMsg;
  }

  // employee login info
  Future<String> employeeLoginInfo(_userId, _password) async {
    String returnString = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    String _companyID = shared.getString("CompanyID") ?? "";
    bool connectivity = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectivity = true;
      }
    } on SocketException catch (_) {
      connectivity = false;
    }
    if (connectivity) {
      try {
        var baseURL = shared.getString("baseURL") ?? "";
        var loginUrl = baseURL +
            urlController.employeeLoginInfoUrl +
            urlController.appCode +
            "&MobileNo=$_userId&CompanyCode=$_companyID";
        const headers = {'Content-Type': 'application/json'};
        var loginResponse = await http
            .get(
              Uri.parse(loginUrl),
              headers: headers,
            )
            .timeout(const Duration(seconds: 8));

        var responseJson = json.decode(loginResponse.body);
        if (responseJson["Table"][0]["Status"] == "Success") {
          String _profilePic = "";
          if (responseJson["Table1"][0]["MobileProfilePic"] != null) {
            if (responseJson["Table1"][0]["MobileProfilePic"] == "") {
              _profilePic =
                  ((responseJson["Table1"][0]["ProfilePicture"] ?? "") != ""
                      ? (baseURL +
                          urlController.imgUrl +
                          responseJson["Table1"][0]["ProfilePicture"])
                      : "");
              if (_profilePic != "") {
                http.Response response = await http.get(Uri.parse(_profilePic));
                String bytes = base64.encode(response.bodyBytes);
                if (bytes != "") {
                  shared.setString("profile_base64", bytes);
                }
              }
            } else if (responseJson["Table1"][0]["MobileProfilePic"] != "") {
              _profilePic = responseJson["Table1"][0]["MobileProfilePic"];
              shared.setString("profile_base64", _profilePic);
            }
          }
          String logo = responseJson["Table1"][0]["Logo"] ?? "";
          if (logo != "") {
            logo = baseURL + urlController.imgUrl + logo;
          }

          // shared.setString("access_token", responseJson["token"]);
          shared.setBool("attendance_permission",
              responseJson["Table1"][0]["IsMarkAttendancePer"] ?? false);
          shared.setInt("attendance_type",
              responseJson["Table1"][0]["FaceVerification"] ?? 0);
          shared.setString(
              "employee_name",
              responseJson["Table1"][0]["EName"] ??
                  responseJson["Table1"][0]["UserName"]);
          shared.setString(
              "user_email", responseJson["Table1"][0]["Email"] ?? "");
          shared.setString(
              "user_mobile", responseJson["Table1"][0]["MobileNo"] ?? "");
          shared.setString("logo", logo);
          shared.setString(
              "company_name", responseJson["Table1"][0]["CompanyName"]);
          // shared.setString("Fcm_topic_id", responseJson["FCMTopicID"]);

          returnString = "Success";
        } else {
          returnString = responseJson["Table"][0]["Status"].toString();
        }
      } catch (e) {
        returnString = "Server Unreachable";
        debugPrint(e.toString());
      }
    } else {
      returnString = "No Connection";
    }
    return returnString;
  }

  // admin login
  Future<String> userLogin(_userId, _password) async {
    String returnString = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    String _companyID = shared.getString("CompanyID") ?? "";
    bool connectivity = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectivity = true;
      }
    } on SocketException catch (_) {
      connectivity = false;
    }
    if (connectivity) {
      try {
        var baseURL = shared.getString("baseURL") ?? "";
        var loginUrl = baseURL + urlController.adminLoginUrl;
        const headers = {'Content-Type': 'application/json'};
        var loginResponse = await http
            .post(
              Uri.parse(loginUrl),
              headers: headers,
              body: json.encode(
                {
                  "CompanyID": _companyID,
                  "UserID": _userId,
                  "Password": _password
                },
              ),
            )
            .timeout(const Duration(seconds: 15));

        var responseJson = json.decode(loginResponse.body);
        if (responseJson["Status"] == "Success") {
          String _profilePic = "";
          if (responseJson["MobileProfilePic"] != null) {
            if (responseJson["MobileProfilePic"] == "") {
              _profilePic = ((responseJson["ProfilePicture"] ?? "") != ""
                  ? (baseURL +
                      urlController.imgUrl +
                      responseJson["ProfilePicture"])
                  : "");
              if (_profilePic != "") {
                http.Response response = await http.get(Uri.parse(_profilePic));
                String bytes = base64.encode(response.bodyBytes);
                if (bytes != "") {
                  shared.setString("profile_base64", bytes);
                }
              }
            } else if (responseJson["MobileProfilePic"] != "") {
              _profilePic = responseJson["MobileProfilePic"];
              shared.setString("profile_base64", _profilePic);
            }
          }
          String logo = responseJson["Logo"] ?? "";
          if (logo != "") {
            logo = baseURL + urlController.imgUrl + logo;
          }

          shared.setString("access_token", responseJson["token"]);
          shared.setString("employee_name",
              responseJson["EmployeeName"] ?? responseJson["UserName"]);
          shared.setString("user_email", responseJson["Email"] ?? "");
          shared.setString("logo", logo);
          shared.setString("company_name", responseJson["CompanyName"]);
          // shared.setString("Fcm_topic_id", responseJson["FCMTopicID"]);

          returnString = "Success";
        } else {
          returnString = responseJson["Status"].toString();
        }
      } catch (e) {
        returnString = "Server Unreachable";
        debugPrint(e.toString());
      }
    } else {
      returnString = "No Connection";
    }
    return returnString;
  }

  // user signup & forgot password send otp
  Future<String> sendOtp({required String mobileNo}) async {
    String returnMsg = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL + urlController.signUpOtpSend;
    // String accessToken = shared.getString("access_token") ?? "";

    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"MobileNo": mobileNo, "CompanyCode": _companyID}));
    var data = jsonDecode(resp.body);
    returnMsg = data["Status"];
    return returnMsg;
  }

  // user signup & forgot password verify otp
  Future<String> verifyOtp(
      {required String otpValue, required String id}) async {
    String returnMsg = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.signUpOtpVerify;
    // String accessToken = shared.getString("access_token") ?? "";

    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"OTPValue": otpValue, "ID": id, "TypeID": "1"}));
    var data = jsonDecode(resp.body);
    returnMsg = data["Status"];
    return returnMsg;
  }

  // employee auto login
  Future<Widget> autoLogin() async {
    Widget returnScreen = const Login();
    SharedPreferences shared = await SharedPreferences.getInstance();
    bool isSuccess =
        (shared.getString("loginSuccess") ?? "") == "Success" ? true : false;

    returnScreen =
        isSuccess ? const EmployeeDashboard(bytes: null) : returnScreen;
    return returnScreen;
  }

  // admin auto login
  Future<Widget> adminAutoLogin() async {
    Widget returnScreen = const Login();
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    if (baseURL != "") {
      var userType = shared.getString("userType") ?? "Admin";
      bool connectivity = false;
      String accessToken = shared.getString("access_token") ?? "";

      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          connectivity = true;
        }
      } on SocketException catch (_) {
        connectivity = false;
      }
      if (connectivity) {
        if (accessToken != "") {
          try {
            var autoLoginUrl = baseURL + urlController.adminAutoLoginUrl;
            final headers = {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            };
            var autoLoginResp = await http
                .get(
                  Uri.parse(autoLoginUrl),
                  headers: headers,
                )
                .timeout(const Duration(seconds: 5));

            if (autoLoginResp.statusCode == 200) {
              if (userType == "Admin") {
                returnScreen = const AdminDashboard();
              } else if (userType == "Employee") {
                returnScreen = const EmployeeDashboard(bytes: null);
              }
            }
          } catch (e) {
            debugPrint(e.toString());
            return returnScreen;
          }
        }
      }
    }
    return returnScreen;
  }

  // admin dashboard page filters
  // get branch filter
  Future<BranchFilterResponseModel?> getBranchFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.branchesFilter;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "BranchName": "Select Branch"}
        ];
        data1.addAll(bodyData);
        data.addAll({"BranchFilters": data1});
        var filterData = BranchFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get device filter
  Future<DeviceFilterResponseModel?> getDeviceFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.devicesFilter;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "DeviceName": "Select Device"}
        ];
        data1.addAll(bodyData);
        data.addAll({"DeviceFilters": data1});
        var filterData = DeviceFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee filter
  Future<EmployeeFilterResponseModel?> getEmployeeFilter(
      {required String branchId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.employeeFilter + "&BranchID=$branchId";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeFilter": bodyData});
        var filterData = EmployeeFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // -- //

  // list admin dashboard pages data

  // get admin dashboard data
  Future<AdminDashboardResponseLogsModel?> getAdminDashboard() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.adminDashboardUrl;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"Table": bodyData});
          var dashboardData = AdminDashboardResponseLogsModel.fromJson(data);
          return dashboardData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get admin dashboard device chart data
  Future<AdminDashboardDeviceChartResponseModel?>
      getAdminDashboardDevicesData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.adminDashboardDeviceChartUrl;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"Data": bodyData});
          var deviceChartData =
              AdminDashboardDeviceChartResponseModel.fromJson(data);
          return deviceChartData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get admin dashboard leaves data
  Future<AdminDashboardLeavesResponseModel?>
      getAdminDashboardLeavesData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.adminDashboardLeavesUrl;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"Data": bodyData});
          var leavesData = AdminDashboardLeavesResponseModel.fromJson(data);
          return leavesData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get admin dashboard expenses data
  Future<AdminDashboardExpensesResponseModel?>
      getAdminDashboardExpensesData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.adminDashboardExpensesUrl;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"Data": bodyData});
          var leavesData = AdminDashboardExpensesResponseModel.fromJson(data);
          return leavesData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // -- //

  // get branches
  Future<AdminBranchesResponseModel?> getAdminBranches() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.adminBranchesUrl;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"MobileBranches": bodyData});
          var branchesData = AdminBranchesResponseModel.fromJson(data);
          return branchesData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get devices
  Future<AdminDevicesResponseModel?> getAdminDevices(
      String branchID, String catId) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.adminDevicesUrl +
        "?CategoryID=$catId" +
        "&BranchID$branchID";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"MobileDevices": bodyData});
          var branchesData = AdminDevicesResponseModel.fromJson(data);
          return branchesData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employees
  Future<AdminEmployeesResponseModel?> getAdminEmployees(
      {required String branchID,
      required String deviceID,
      required String typeID,
      required String status}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.adminEmployeesUrl +
        "BranchID=$branchID&DeviceID=$deviceID&TypeID=$typeID&StatusID=$status";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"MobileEmployees": bodyData});
          var branchesData = AdminEmployeesResponseModel.fromJson(data);
          return branchesData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get holidays
  Future<AdminHolidayResponseModel?> getAdminHoliday(String year) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.adminHolidayUrl + year;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"MobileHolidays": bodyData});
          var holidayData = AdminHolidayResponseModel.fromJson(data);
          return holidayData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // admin attendance reports
  // employee wise attendance report
  Future<EmployeeWiseReportResponseModel?> getEmployeeWiseReport({
    required String employeeId,
    required String month,
    required String year,
  }) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.employeeWiseReportUrl +
        "EmployeeID=$employeeId&Month=$month&Year=$year";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({
            "MobileEmployeeWiseReport": [bodyData]
          });
          var report = EmployeeWiseReportResponseModel.fromJson(data);
          return report;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // day wise attendance report
  Future<DayWiseReportResponseModel?> getDayWiseReport({
    required String branchId,
    required String date,
  }) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.dayWiseReportUrl +
        "ID=&Date=$date&BranchID=$branchId&Department=&DesignationID=&IsActive=1";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({
            "MobileDayWiseReport": [bodyData]
          });
          var report = DayWiseReportResponseModel.fromJson(data);
          return report;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // single day attendance page
  // admin get employee attendance logs date wise
  Future<EmployeeDashboardResponseLogsModel?>
      getAdminEmployeeAttendanceDateWise(
          {required String employeeId, required String date}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.employeeDateWiseReportUrl +
        "DateOld=$date&EmployeeID=$employeeId";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"EmployeeDashboardData": bodyData});
          var dashboardData = EmployeeDashboardResponseLogsModel.fromJson(data);
          return dashboardData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get devices locks
  Future<AdminDoorLocksResponseModel?> getAdminDoorLocks() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.doorLocksUrl;
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"DoorLocks": bodyData});
          var lockData = AdminDoorLocksResponseModel.fromJson(data);
          return lockData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String> adminDoorOpenClose(
      {required lockId, required deviceId, required functionName}) async {
    String returnString = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.doorOpenClose +
        "LockID=$lockId&DeviceID=$deviceId&FunctionName=$functionName";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          if (response.body == "[]") {
            returnString = "Device Offline!!";
            return returnString;
          } else {
            returnString = bodyData[0]["subStatusCode"] == "ok"
                ? "Success"
                : "Failed! Try Again..";
            return returnString;
          }
        } else {
          returnString = "Failed! Try Again..";
          return returnString;
        }
      } else {
        PhoenixNative.restartApp();
        return returnString;
      }
    } catch (e) {
      log(e.toString());
      returnString = "Error Occurred!!";
      return returnString;
    }
  }

  // -- //

  // employee dashboard pages

  // get expense type filter
  Future<ExpenseHeadTypeFilterResponseModel?> getExpenseHeadTypeFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.expenseTypeFilterUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "ExpensesType": "Select Expenses Type"}
        ];
        data1.addAll(bodyData["Data"]);
        data.addAll({"HeadTypeFilters": data1});
        var filterData = ExpenseHeadTypeFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get expense subtype filter
  Future<ExpenseHeadSubtypeFilterResponseModel?>
      getExpenseSubtypeFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.expenseSubtypeFilterUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "SubTypeName": "Select Expenses Sub Type"}
        ];
        data1.addAll(bodyData["Data"]);
        data.addAll({"HeadSubtypeFilters": data1});
        var filterData = ExpenseHeadSubtypeFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get allowance type filter
  Future<AllowanceHeadTypeFilterResponseModel?>
      getAllowanceHeadTypeFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.allowanceTypeFilterUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "HeadName": "Select Type"}
        ];
        data1.addAll(bodyData["Data"]);
        data.addAll({"HeadTypeFilters": data1});
        var filterData = AllowanceHeadTypeFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get leave type filter
  Future<LeaveTypeFilterResponseModel?> getLeaveTypeFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.leaveTypeFilterUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "TypeName": "Select Type", "ShortCode": "ST"}
        ];
        data1.addAll(bodyData["Response"]);
        data.addAll({"LeaveTypeFilters": data1});
        var filterData = LeaveTypeFilterResponseModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get dailyUpdate filter (project name)
  Future<DailyUpdateHeadResponseDataModel?> getDailyUpdateFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.projectNameFilterUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        List data1 = [
          {"ID": "0", "ProjectName": "Select Type"}
        ];
        data1.addAll(bodyData["Data"]);
        data.addAll({"DailyUpdateHead": data1});
        var filterData = DailyUpdateHeadResponseDataModel.fromJson(data);
        return filterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee dashboard data
  Future<EmployeeDashboardResponseDataModel?> getEmployeeDashboardData(
      {required String month, required String year}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeDashboardUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID" +
        "&Month=$month&Year=$year";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 8));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        var attendanceLogs =
            EmployeeDashboardResponseDataModel.fromJson(bodyData);
        return attendanceLogs;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee dashboard data logs
  Future<EmployeeDashboardResponseLogsModel?> getEmployeeDashboardLogs() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeDashboardLogsUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 8));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeDashboardData": bodyData["Data"]});
        var dashboardData = EmployeeDashboardResponseLogsModel.fromJson(data);
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee personal info
  Future<EmployeeDetailsResponseModel?> getEmployeeInfo() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeePersonalInfoUrl +
        "AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"MobileEmployeeDetails": bodyData["Data"]});
        data["MobileEmployeeDetails"][0].addAll({"baseUrl": baseURL});
        var employeeDetails = EmployeeDetailsResponseModel.fromJson(data);
        return employeeDetails;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee attendance logs
  Future<EmployeeAttendanceLogResponseModel?> getAttendanceData(
      {required String month, required String year}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeAttendanceLogUrl +
        "?Month=$month&Year=$year" +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";
    print("attendence=============${url}");
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({
          "EmployeeAttendanceLog": [bodyData]
        });
        var attendanceLogs = EmployeeAttendanceLogResponseModel.fromJson(data);
        return attendanceLogs;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee attendance logs date wise
  Future<EmployeeDashboardResponseLogsModel?> getEmployeeAttendanceDateWise(
      {required String date}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeAttendanceLogDateWiseUrl +
        date +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeDashboardData": bodyData["Data"]});
        var dashboardData = EmployeeDashboardResponseLogsModel.fromJson(data);
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee expenses list
  Future<EmployeeExpensesResponseDataModel?> getEmployeeExpensesList({
    required String headId,
    required String subheadId,
    required String month,
    required String year,
    required String status,
  }) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeExpensesListUrl +
        "?ExpencesTypeID=$headId&ExpensesSubTypeID=$subheadId&Month=$month&Year=$year&StatusID=$status" +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";

    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeExpensesData": bodyData["Data"]});
        var dashboardData = EmployeeExpensesResponseDataModel.fromJson(data);
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee expense by id
  Future<ExpensesAddEditResponseModel?> getExpenseById(
      {required String id}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeExpensesByIdUrl +
        id +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    String accessToken = shared.getString("access_token") ?? "";
    print("sdsdsd============${url}");
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"ExpensesById": bodyData["Data"]});
        var dashboardData = ExpensesAddEditResponseModel.fromJson(data);
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // add edit employee expense
  Future<String> addEditEmployeeExpenses(
      {required Map<String, dynamic> addEditData}) async {
    String returnMsg = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";

    var dio = Dio();
    dio.options.baseUrl = baseURL;
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    FormData formData = FormData();
    formData.fields.add(MapEntry("ID", addEditData["ID"]!));
    formData.fields.add(MapEntry("AddEdit", addEditData["AddEdit"]!));
    formData.fields
        .add(MapEntry("ExpencesTypeID", addEditData["ExpencesTypeID"]!));
    formData.fields
        .add(MapEntry("ExpencesSubTypeID", addEditData["ExpencesSubTypeID"]!));
    formData.fields.add(MapEntry("Amount", addEditData["Amount"]!));
    formData.fields.add(MapEntry("Remark", addEditData["Remark"]!));
    formData.fields.add(MapEntry("TransDate", addEditData["TransDate"]!));
    formData.fields.add(MapEntry("AppCode", urlController.appCode));
    formData.fields.add(MapEntry("CompanyCode", _companyID));
    formData.fields.add(MapEntry("MobileNo", mobileNo));

    if (addEditData["filePath"] != null) {
      var image = await MultipartFile.fromFile(addEditData["filePath"],
          filename: addEditData["filename"]);
      formData.files.add(MapEntry("file", image));
    }
    var response = await dio.post(
        baseURL +
            '/api/api/MobileExpenses/ExpensesAddEdit' +
            "?ID=${addEditData["ID"]!}&ExpencesTypeID=${addEditData["ExpencesTypeID"]!}&ExpencesSubTypeID=${addEditData["ExpencesSubTypeID"]!}&Amount=${addEditData["Amount"]!}&Remark=${addEditData["Remark"]!}&TransDate=${addEditData["TransDate"]!}&AppCode=${urlController.appCode}&CompanyCode=$_companyID&MobileNo=$mobileNo&AddEdit=${addEditData["AddEdit"]!}&file=",
        data: formData,
        options: Options(method: 'POST'));

    var responseBody = response.data["Status"];
    if (responseBody == "Success") {
      returnMsg = response.data["Data"];
    } else {
      returnMsg = "Error Occurred";
    }

    return returnMsg;
  }

  // get employee allowances list
  Future<EmployeeAllowancesResponseDataModel?> getEmployeeAllowancesList({
    required String headId,
    required String month,
    required String year,
    required String status,
  }) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeAllowancesListUrl +
        "?HeadID=$headId&Month=$month&Year=$year&StatusID=$status" +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeAllowancesData": bodyData["Data"]});
        var allowancesData = EmployeeAllowancesResponseDataModel.fromJson(data);
        return allowancesData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee allowance by id
  Future<AllowanceAddEditResponseModel?> getAllowanceById(
      {required String id}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeAllowancesByIdUrl +
        id +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"AllowanceById": bodyData["Data"]});
        var allowanceAddEditData = AllowanceAddEditResponseModel.fromJson(data);
        return allowanceAddEditData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // add edit employee allowance
  Future<String> addEditEmployeeAllowance(
      {required Map<String, dynamic> addEditData}) async {
    String returnMsg = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.employeeAllowancesAddEditUrl;
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";

    var dio = Dio();
    dio.options.baseUrl = baseURL;
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    FormData formData = FormData();
    formData.fields.add(MapEntry("ID", addEditData["ID"]!));
    formData.fields.add(MapEntry("AddEdit", addEditData["AddEdit"]!));
    formData.fields.add(MapEntry("HeadID", addEditData["HeadID"]!));
    formData.fields.add(MapEntry("Amount", addEditData["Amount"]!));
    formData.fields.add(MapEntry("Remark", addEditData["Remark"]!));
    formData.fields.add(MapEntry("TransDate", addEditData["TransDate"]!));
    formData.fields.add(MapEntry("AppCode", urlController.appCode));
    formData.fields.add(MapEntry("CompanyCode", _companyID));
    formData.fields.add(MapEntry("MobileNo", mobileNo));

    if (addEditData["filePath"] != null) {
      var image = await MultipartFile.fromFile(addEditData["filePath"],
          filename: addEditData["filename"]);
      formData.files.add(MapEntry("file", image));
    }
    var response = await dio.post(
        url +
            "?ID=${addEditData["ID"]!}&HeadID=${addEditData["HeadID"]!}&Amount=${addEditData["Amount"]!}&Remark=${addEditData["Remark"]!}&TransDate=${addEditData["TransDate"]!}&AppCode=${urlController.appCode}&CompanyCode=$_companyID&MobileNo=$mobileNo&AddEdit=${addEditData["AddEdit"]!}&file=",
        data: formData,
        options: Options(method: 'POST'));

    var responseBody = response.data["Status"];
    if (responseBody == "Success") {
      returnMsg = response.data["Data"];
    } else {
      returnMsg = "Error Occurred";
    }

    return returnMsg;
  }

  // get employee leave list
  Future<EmployeeLeavesResponseDataModel?> getEmployeeLeavesList(
      {required String id,
      required String month,
      required String year,
      required String statusId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeLeaveListUrl +
        "?ID=$id&Month=$month&Year=$year&StatusID=$statusId" +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    // String accessToken = shared.getString("access_token") ?? "";
    print("data===========${url}");
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'Authorization': 'Bearer $accessToken',
            // },
          )
          .timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeLeavesData": bodyData["Response"]});
        var dashboardData = EmployeeLeavesResponseDataModel.fromJson(data);
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // add edit employee leave
  Future<String> addEditEmployeeLeave(
      {required Map<String, String> addEditData}) async {
    String returnMsg = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.employeeLeaveAddEditUrl;
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    // String accessToken = shared.getString("access_token") ?? "";
    addEditData.addAll({
      "CompanyCode": _companyID,
      "MobileNo": mobileNo,
      "AppCode": urlController.appCode,
    });

    var resp = await http.post(Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          //   'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(addEditData));
    var data = jsonDecode(resp.body);
    debugPrint(data["Status"]);
    returnMsg = data["Response"];
    return returnMsg;
  }

  // get employee daily update list
  Future<EmployeeDailyUpdateResponseDataModel?> getEmployeeUpdatesList({
    required String headId,
    required String fromDate,
    required String toDate,
  }) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeUpdatesListUrl +
        "?ProjectID=$headId&FromDate=$fromDate&ToDate=$toDate" +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"EmployeeDailyUpdateData": bodyData["Data"]});
        var dashboardData = EmployeeDailyUpdateResponseDataModel.fromJson(data);
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // get employee dailyUpdate by id
  Future<DailyUpdateAddEditResponseModel?> getDailyUpdateById(
      {required String id}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    String url = baseURL +
        urlController.employeeUpdatesByIdUrl +
        id +
        "&AppCode=${urlController.appCode}&MobileNo=$mobileNo&CompanyCode=$_companyID";
    String accessToken = shared.getString("access_token") ?? "";

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"UpdateById": bodyData["Data"]});
        var dailyUpdateAddEditData =
            DailyUpdateAddEditResponseModel.fromJson(data);
        return dailyUpdateAddEditData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // add edit employee daily update
  Future<String> addEditEmployeeDailyUpdate(
      {required Map<String, String> addEditData}) async {
    String returnMsg = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    var baseURL = shared.getString("baseURL") ?? "";
    var mobileNo = shared.getString("user_mobile") ?? "";
    String _companyID = shared.getString("CompanyID") ?? "";
    // String accessToken = shared.getString("access_token") ?? "";
    addEditData.addAll({
      "CompanyCode": _companyID,
      "MobileNo": mobileNo,
      "AppCode": urlController.appCode,
    });
    String url = baseURL +
        urlController.employeeUpdatesAddEditUrl +
        "?ID=${addEditData["ID"]}&Date=${addEditData["TransDate"]}"
            "&ProjectID=${addEditData["ProjectID"]}&Remark=${addEditData["Remark"]}"
            "&AppCode=${urlController.appCode}&CompanyCode=$_companyID&MobileNo=$mobileNo&AddEdit=${addEditData["AddEdit"]}";

    var resp = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        //   'Authorization': 'Bearer $accessToken',
      },
    );
    var data = jsonDecode(resp.body);
    debugPrint(data["Status"]);
    returnMsg = data["Data"];
    return returnMsg;
  }

  // -- //

  // employee profile upload
  Future<String> employeeProfileUpload({required String img}) async {
    String returnString = "";
    SharedPreferences shared = await SharedPreferences.getInstance();
    bool connectivity = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectivity = true;
      }
    } on SocketException catch (_) {
      connectivity = false;
    }
    if (connectivity) {
      try {
        var baseURL = shared.getString("baseURL") ?? "";
        var mobileNo = shared.getString("user_mobile") ?? "";
        String _companyID = shared.getString("CompanyID") ?? "";
        var url = baseURL + urlController.employeeProfileUpload;
        var uploadResponse = await http
            .post(Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                  "ImageBase64": img,
                  "AppCode": urlController.appCode,
                  "MobileNo": mobileNo,
                  "CompanyCode": _companyID
                }))
            .timeout(const Duration(seconds: 5));

        if (uploadResponse.statusCode == 200) {
          var responseJson = uploadResponse.body;

          if (responseJson.toString() == "Success") {
            shared.setString("profile_base64", img);
            returnString = "Profile Updated Successfully";
          } else {
            returnString = responseJson.toString();
          }
        } else {
          returnString = "Error Uploading";
        }
      } catch (e) {
        debugPrint(e.toString());
        return returnString;
      }
    } else {
      returnString = "No Connection";
    }
    return returnString;
  }

  //// -----     NMS api functions     ----- ////

  // nms dashboard data function
  Future<NMSDashboardResponseDataModel?> getNmsDashboardData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsDashboardDataUrl;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"DashboardData": bodyData});
          var dashboardData = NMSDashboardResponseDataModel.fromJson(data);
          return dashboardData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms overview data function
  Future<NMSOverviewResponseDataModel?> getNmsOverviewData({
    required String agentId,
    required String deviceTypeId,
    required String locationId,
  }) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.nmsOverviewDataUrl +
        "AgentID=$agentId&LocationID=$locationId&DeviceTypeID=$deviceTypeId";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> percentage = {};
          percentage.addAll({
            "UpPercentage": bodyData[0]["UpPercentage"],
            "CriticalPercentage": bodyData[0]["CriticalPercentage"],
            "OfflinePercentage": bodyData[0]["OfflinePercentage"],
            "NotMonitoredPercentage": bodyData[0]["NotMonitoredPercentage"],
          });
          Map<String, dynamic> data = {};
          data.addAll({
            "Percentage": [percentage],
            "IpsData": bodyData[0]["IpsData"]
          });
          Map<String, dynamic> overviewInfo = {};
          overviewInfo.addAll({
            "OverviewData": [data]
          });
          var overviewData =
              NMSOverviewResponseDataModel.fromJson(overviewInfo);
          return overviewData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms agents list function
  Future<NMSAgentListResponseDataModel?> getNmsAgentsList() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsAgentsListUrl;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      var bodyData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body != null) {
          Map<String, dynamic> percentage = {};
          percentage.addAll({
            "UpPercentage": bodyData[0]["UpPercentage"],
            "CriticalPercentage": bodyData[0]["CriticalPercentage"],
            "OfflinePercentage": bodyData[0]["OfflinePercentage"],
            "NotMonitoredPercentage": bodyData[0]["NotMonitoredPercentage"],
          });
          Map<String, dynamic> data = {};
          data.addAll({
            "Percentage": [percentage],
            "AgentData": bodyData[0]["AgentsData"]
          });
          Map<String, dynamic> agentInfo = {};
          agentInfo.addAll({
            "AgentListData": [data]
          });
          var agentDashboardData =
              NMSAgentListResponseDataModel.fromJson(agentInfo);
          return agentDashboardData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms location view function
  Future<NMSLocationViewResponseDataModel?> getNmsLocationViewData(
      String agentId) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsLocationViewUrl + agentId;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> percentage = {};
          percentage.addAll({
            "UpPercentage": bodyData[0]["UpPercentage"],
            "CriticalPercentage": bodyData[0]["HighLatencyPercentage"],
            "OfflinePercentage": bodyData[0]["OfflinePercentage"],
            "NotMonitoredPercentage": bodyData[0]["NotMonitored"],
          });
          Map<String, dynamic> data = {};
          data.addAll({
            "Percentage": [percentage],
            "LocationData": bodyData[0]["LocsData"]
          });
          Map<String, dynamic> locationInfo = {};
          locationInfo.addAll({
            "LocationListData": [data]
          });
          var locationViewData =
              NMSLocationViewResponseDataModel.fromJson(locationInfo);
          return locationViewData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms device view function
  Future<NMSDeviceViewResponseDataModel?> getNmsDeviceViewData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsDeviceViewUrl;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      var bodyData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body != null) {
          Map<String, dynamic> percentage = {};
          percentage.addAll({
            "UpPercentage": bodyData[0]["OnlinePercentage"],
            "CriticalPercentage": bodyData[0]["HighLatencyPercentage"],
            "OfflinePercentage": bodyData[0]["OfflinePercentage"],
            "NotMonitoredPercentage": bodyData[0]["NotMonitoredPercentage"],
          });
          Map<String, dynamic> data = {};
          data.addAll({
            "Percentage": [percentage],
            "DeviceData": bodyData[0]["DevicesSummaryData"]
          });
          Map<String, dynamic> locationInfo = {};
          locationInfo.addAll({
            "DeviceListData": [data]
          });
          var deviceViewData =
              NMSDeviceViewResponseDataModel.fromJson(locationInfo);
          return deviceViewData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms asset summary data function
  Future<NMSAssetSummaryResponseDataModel?> getNmsAssetSummaryData(
      {required String agentId,
      required String locationId,
      required String deviceTypeId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.nmsAssetSummaryUrl +
        "$agentId&id=$locationId&DeviceTypeID=$deviceTypeId";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"SummaryData": bodyData});
          var summaryData = NMSAssetSummaryResponseDataModel.fromJson(data);
          return summaryData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  //// ---- nms type wise devices function ---- ////
  // nms location wise devices data function
  Future<NMSLocationWiseDevicesResponseDataModel?>
      getNmsLocationWiseDevicesData(
          {required String locationId, required String deviceTypeId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.nmsLocationWiseDevicesUrl +
        "$locationId&DeviceTypeID=$deviceTypeId";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"DevicesData": bodyData["Table"]});
          var dashboardData =
              NMSLocationWiseDevicesResponseDataModel.fromJson(data);
          return dashboardData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms deviceType wise devices data function
  Future<NMSDeviceTypeDevicesResponseDataModel?>
      getNmsDeviceTypeWiseDevicesData(
          {required String agentId,
          required String locationId,
          required String deviceTypeId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL +
        urlController.nmsDeviceTypeWiseDevicesUrl +
        "$agentId&id=$locationId&DeviceTypeID=$deviceTypeId";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> data = {};
          data.addAll({"DevicesData": bodyData["Table"]});
          var dashboardData =
              NMSDeviceTypeDevicesResponseDataModel.fromJson(data);
          return dashboardData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  //// ----- nms single details data function ----- ////
  // nms agent details data
  Future<NMSAgentDetailsResponseDataModel?> getNmsAgentDetails(
      {required String agentId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsAgentDetailsUrl + agentId;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> details = {};
          details.addAll({
            "AgentName": bodyData[0]["AgentName"],
            "ImageUrl": bodyData[0]["ImageUrl"],
            "PublicIP": bodyData[0]["PublicIP"],
            "LocalIP": bodyData[0]["LocalIP"],
            "Status": bodyData[0]["Status"],
            "NosHosts": bodyData[0]["NosHosts"],
            "SuccessCount": bodyData[0]["SuccessCount"],
            "FailCount": bodyData[0]["FailCount"],
            "CriticalCount": bodyData[0]["CriticalCount"],
            "LastSuccessOn": bodyData[0]["LastSuccessOn"],
            "LastFailOn": bodyData[0]["LastFailOn"],
            "LastCriticalOn": bodyData[0]["LastCriticalOn"],
            "LastNotMonitoredOn": bodyData[0]["LastNotMonitoredOn"],
            "SuccessPer": bodyData[0]["SuccessPer"],
            "CriticalPer": bodyData[0]["CriticalPer"],
            "FailPer": bodyData[0]["FailPer"],
            "NotMonitoredPer": bodyData[0]["NotMonitoredPer"],
          });
          Map<String, dynamic> dataList = {};
          dataList.addAll({
            "DetailsData": [details],
            "LogsData": bodyData[0]["AgentTimeDurationData"]
          });
          Map<String, dynamic> data = {};
          data.addAll({
            "AgentDetailsData": [dataList]
          });
          var agentDetailsData =
              NMSAgentDetailsResponseDataModel.fromJson(data);
          return agentDetailsData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms agent details data
  Future<NMSDeviceDetailsResponseDataModel?> getNmsDeviceDetails(
      {required String deviceId}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsDeviceDetailsUrl + deviceId;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      if (response.statusCode == 200) {
        var bodyData = json.decode(response.body);
        if (response.body != null) {
          Map<String, dynamic> details = {};
          details.addAll({
            "DeviceName": bodyData[0]["DeviceName"],
            "ImageUrl": bodyData[0]["ImageUrl"],
            "IPAddress": bodyData[0]["IPAddress"],
            "AgentName": bodyData[0]["AgentName"],
            "LocationName": bodyData[0]["LocationName"],
            "Status": bodyData[0]["Status"],
            "TypeName": bodyData[0]["TypeName"],
            "LastSuccessOn": bodyData[0]["LastSuccessOn"],
            "LastFailOn": bodyData[0]["LastFailOn"],
            "LastCriticalOn": bodyData[0]["LastCriticalOn"],
            "SuccessPer": bodyData[0]["SuccessPer"],
            "CriticalPer": bodyData[0]["CriticalPer"],
            "FailPer": bodyData[0]["FailPer"],
          });
          Map<String, dynamic> dataList = {};
          dataList.addAll({
            "DetailsData": [details],
            "LogsData": bodyData[0]["MobileTimeDurationData"]
          });
          Map<String, dynamic> data = {};
          data.addAll({
            "DeviceDetailsData": [dataList]
          });
          var deviceDetailsData =
              NMSDeviceDetailsResponseDataModel.fromJson(data);
          return deviceDetailsData;
        } else {
          return null;
        }
      } else {
        PhoenixNative.restartApp();
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  //// ----- nms filters ----- ////
  // nms agent filter function
  Future<NMSAgentFilterResponseDataModel?> getNmsAgentFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsAgentFilterUrl;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"AgentFilterData": bodyData});
        var agentFilterData = NMSAgentFilterResponseDataModel.fromJson(data);
        return agentFilterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms deviceType filter function
  Future<NMSDeviceTypeFilterResponseDataModel?> getNmsDeviceTypeFilter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsDeviceTypeFilterUrl;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"DeviceTypeFilterData": bodyData});
        var deviceTypeFilterData =
            NMSDeviceTypeFilterResponseDataModel.fromJson(data);
        return deviceTypeFilterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // nms location filter function
  Future<NMSLocationFilterResponseDataModel?> getNmsLocationFilter(
      String agentId) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + "${urlController.nmsLocationFilterUrl}$agentId";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'bearer $accessToken'});
      var bodyData = json.decode(response.body);
      if (response.body != null) {
        Map<String, dynamic> data = {};
        data.addAll({"LocationFilterData": bodyData});
        var locationFilterData =
            NMSLocationFilterResponseDataModel.fromJson(data);
        return locationFilterData;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
