class EmployeeWiseReportResponseModel {
  EmployeeWiseReportResponseModel({
    required this.data,
  });

  List<EmployeeWiseReportModel> data;

  factory EmployeeWiseReportResponseModel.fromJson(Map<String, dynamic> json) =>
      EmployeeWiseReportResponseModel(
        data: List<EmployeeWiseReportModel>.from(
            json["MobileEmployeeWiseReport"].map((x) => EmployeeWiseReportModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "MobileEmployeeWiseReport": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


class EmployeeWiseReportModel {
  EmployeeWiseReportModel(
      {required this.summary,
        required this.logs});
  List<EmployeeWiseReportSummaryModel> summary;
  List<EmployeeAttendanceReportDataModel> logs;

  factory EmployeeWiseReportModel.fromJson(Map<String, dynamic> json) =>
      EmployeeWiseReportModel(
        summary: List<EmployeeWiseReportSummaryModel>.from(
            json["Table1"].map((x) => EmployeeWiseReportSummaryModel.fromJson(x))),
        logs: List<EmployeeAttendanceReportDataModel>.from(
            json["Table"].map((x) => EmployeeAttendanceReportDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "Table1": summary,
    "Table": logs,
  };
}

class EmployeeWiseReportSummaryModel {
  EmployeeWiseReportSummaryModel(
      {required this.presentTotal,
        required this.absentTotal,
        required this.lessHrsTotal,
        required this.weekOffTotal,
        required this.punchMissingTotal,
        required this.halfDayTotal,
        required this.lateTotal,
      });
  String presentTotal;
  String absentTotal;
  String lessHrsTotal;
  String weekOffTotal;
  String punchMissingTotal;
  String halfDayTotal;
  String lateTotal;

  factory EmployeeWiseReportSummaryModel.fromJson(Map<String, dynamic> json) =>
      EmployeeWiseReportSummaryModel(
        presentTotal: json["P"].toString(),
        absentTotal: json["A"].toString(),
        lessHrsTotal: json["LH"].toString(),
        weekOffTotal: json["WO"].toString(),
        punchMissingTotal: json["PM"].toString(),
        halfDayTotal: json["HD"].toString(),
        lateTotal: json["L"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "P": presentTotal,
    "A": absentTotal,
    "LH": lessHrsTotal,
    "WO": weekOffTotal,
    "PM": punchMissingTotal,
    "HD": halfDayTotal,
    "L": lateTotal,
  };
}

class EmployeeAttendanceReportDataModel {
  EmployeeAttendanceReportDataModel(
      {required this.dateNew,
        required this.dateOld,
        required this.day,
        required this.duration,
        required this.status});
  String dateNew;
  String dateOld;
  String day;
  String duration;
  String status;

  factory EmployeeAttendanceReportDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeAttendanceReportDataModel(
        dateNew: json["DateNew"],
        dateOld: json["DateOld"],
        day: json["WeekDays"].toString(),
        duration: json["Duration"].toString(),
        status: json["Status"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "DateNew": dateNew,
    "DateOld": dateOld,
    "WeekDays": day,
    "Duration": duration,
    "Status": status,
  };
}
