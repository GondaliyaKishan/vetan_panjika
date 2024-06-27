class DayWiseReportResponseModel {
  DayWiseReportResponseModel({
    required this.data,
  });

  List<DayWiseReportModel> data;

  factory DayWiseReportResponseModel.fromJson(Map<String, dynamic> json) =>
      DayWiseReportResponseModel(
        data: List<DayWiseReportModel>.from(
            json["MobileDayWiseReport"].map((x) => DayWiseReportModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "MobileDayWiseReport": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


class DayWiseReportModel {
  DayWiseReportModel(
      {required this.summary,
        required this.logs});
  List<DayWiseReportSummaryModel> summary;
  List<DayWiseEmployeeAttendanceReportDataModel> logs;

  factory DayWiseReportModel.fromJson(Map<String, dynamic> json) =>
      DayWiseReportModel(
        summary: List<DayWiseReportSummaryModel>.from(
            json["Table1"].map((x) => DayWiseReportSummaryModel.fromJson(x))),
        logs: List<DayWiseEmployeeAttendanceReportDataModel>.from(
            json["Table"].map((x) => DayWiseEmployeeAttendanceReportDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "Table1": summary,
    "Table": logs,
  };
}

class DayWiseReportSummaryModel {
  DayWiseReportSummaryModel(
      {required this.presentTotal,
        required this.absentTotal,
        required this.lessHrsTotal,
        required this.weekOffTotal,
        required this.punchMissingTotal,
        required this.halfDayTotal,
        required this.leaveTotal,
      });
  String presentTotal;
  String absentTotal;
  String lessHrsTotal;
  String weekOffTotal;
  String punchMissingTotal;
  String halfDayTotal;
  String leaveTotal;

  factory DayWiseReportSummaryModel.fromJson(Map<String, dynamic> json) =>
      DayWiseReportSummaryModel(
        presentTotal: json["P"].toString(),
        absentTotal: json["A"].toString(),
        lessHrsTotal: json["LH"].toString(),
        weekOffTotal: json["WO"].toString(),
        punchMissingTotal: json["PM"].toString(),
        halfDayTotal: json["HD"].toString(),
        leaveTotal: json["L"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "P": presentTotal,
    "A": absentTotal,
    "LH": lessHrsTotal,
    "WO": weekOffTotal,
    "PM": punchMissingTotal,
    "HD": halfDayTotal,
    "L": leaveTotal,
  };
}

class DayWiseEmployeeAttendanceReportDataModel {
  DayWiseEmployeeAttendanceReportDataModel(
      {required this.empID,
        required this.fullName,
        required this.logTime,
        required this.duration,
        required this.status});
  String empID;
  String fullName;
  String logTime;
  String duration;
  String status;

  factory DayWiseEmployeeAttendanceReportDataModel.fromJson(Map<String, dynamic> json) =>
      DayWiseEmployeeAttendanceReportDataModel(
        empID: json["EmployeeID"],
        fullName: json["FullName"],
        logTime: json["LogTime"].toString(),
        duration: json["Duration"].toString(),
        status: json["Status"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "EmployeeID": empID,
    "FullName": fullName,
    "LogTime": logTime,
    "Duration": duration,
    "Status": status,
  };
}
