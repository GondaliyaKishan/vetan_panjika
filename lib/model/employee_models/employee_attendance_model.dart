class EmployeeAttendanceLogResponseModel {
  EmployeeAttendanceLogResponseModel({
    required this.data,
  });

  List<EmployeeAttendanceLogModel> data;

  factory EmployeeAttendanceLogResponseModel.fromJson(
          Map<String, dynamic> json) =>
      EmployeeAttendanceLogResponseModel(
        data: List<EmployeeAttendanceLogModel>.from(
            json["EmployeeAttendanceLog"]
                .map((x) => EmployeeAttendanceLogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EmployeeAttendanceLog":
            List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmployeeAttendanceLogModel {
  EmployeeAttendanceLogModel({required this.dashboard, required this.logs});

  List<EmployeeAttendanceLogSummaryModel> dashboard;
  List<EmployeeAttendanceLogDataModel> logs;

  factory EmployeeAttendanceLogModel.fromJson(Map<String, dynamic> json) =>
      EmployeeAttendanceLogModel(
        dashboard: List<EmployeeAttendanceLogSummaryModel>.from(json["Summary"]
            .map((x) => EmployeeAttendanceLogSummaryModel.fromJson(x))),
        logs: List<EmployeeAttendanceLogDataModel>.from(json["Details"]
            .map((x) => EmployeeAttendanceLogDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Summary": dashboard,
        "Details": logs,
      };
}

class EmployeeAttendanceLogSummaryModel {
  EmployeeAttendanceLogSummaryModel({
    required this.onTimeTotal,
    required this.presentTotal,
    required this.absentTotal,
    required this.lateTotal,
    required this.lessHrsTotal,
    required this.punchMissingTotal,
    required this.halfDayTotal,
    required this.holidayTotal,
    required this.holidayWorkingTotal,
    required this.weekOffTotal,
    required this.weekOffWorkingTotal,
    required this.overtimeTotal,
    required this.workingHrsTotal,
  });

  String onTimeTotal;
  String presentTotal;
  String absentTotal;
  String lateTotal;
  String lessHrsTotal;
  String punchMissingTotal;
  String halfDayTotal;
  String holidayTotal;
  String holidayWorkingTotal;
  String weekOffTotal;
  String weekOffWorkingTotal;
  String overtimeTotal;
  String workingHrsTotal;

  factory EmployeeAttendanceLogSummaryModel.fromJson(
          Map<String, dynamic> json) =>
      EmployeeAttendanceLogSummaryModel(
          onTimeTotal: json["P"].toString(),
          presentTotal: (int.parse(json["P"].toString()) +
                  int.parse(json["L"].toString()) +
                  int.parse(json["HD"].toString()) +
                  int.parse(json["LH"].toString()) +
                  int.parse(json["PM"].toString()) +
                  int.parse(json["TotalHolidaysWorking"].toString()) +
                  int.parse(json["TotalWeekOffsWorking"].toString()))
              .toString(),
          absentTotal: json["A"].toString(),
          lessHrsTotal: json["LH"].toString(),
          weekOffTotal: json["WO"].toString(),
          weekOffWorkingTotal: json["TotalWeekOffsWorking"],
          punchMissingTotal: json["PM"].toString(),
          halfDayTotal: json["HD"].toString(),
          holidayTotal: json["HL"].toString(),
          holidayWorkingTotal: json["TotalHolidaysWorking"].toString(),
          lateTotal: json["L"].toString(),
          overtimeTotal: json["OvertimeHours"].toString(),
          workingHrsTotal: json["TotalWorkingHrs"].toString());

  Map<String, dynamic> toJson() => {
        "OnTime": onTimeTotal,
        "P": presentTotal,
        "A": absentTotal,
        "LH": lessHrsTotal,
        "WO": weekOffTotal,
        "TotalWeekOffsWorking": weekOffWorkingTotal,
        "PM": punchMissingTotal,
        "HD": halfDayTotal,
        "HL": holidayTotal,
        "TotalHolidaysWorking": holidayWorkingTotal,
        "L": lateTotal,
        "OvertimeHours": overtimeTotal,
        "TotalWorkingHrs": workingHrsTotal,
      };
}

class EmployeeAttendanceLogDataModel {
  EmployeeAttendanceLogDataModel(
      {required this.dateNew,
      required this.dateOld,
      required this.day,
      required this.duration,
      required this.overtime,
      required this.status,
      required this.isWeekOffWork,
      required this.isHolidayWork,
      required this.isHoliday,
      required this.isWeekOff});

  String dateNew;
  String dateOld;
  String day;
  String duration;
  String overtime;
  String status;
  int isWeekOffWork;
  int isHolidayWork;
  int isHoliday;
  int isWeekOff;

  factory EmployeeAttendanceLogDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeAttendanceLogDataModel(
        dateNew: json["DateNew"],
        dateOld: json["DateOld"],
        day: json["WeekDays"].toString(),
        duration: json["Duration"].toString(),
        overtime: json["OvertimeHours"].toString(),
        status: json["Status"].toString(),
        isWeekOffWork: json["IsWeekOffWork"],
        isHolidayWork: json["IsHolidayWork"],
        isHoliday: json["IsHoliday"],
        isWeekOff: json["IsWeekOff"],
      );

  Map<String, dynamic> toJson() => {
        "DateNew": dateNew,
        "DateOld": dateOld,
        "WeekDays": day,
        "Duration": duration,
        "OvertimeHours": overtime,
        "Status": status,
        "IsWeekOffWork": isWeekOffWork,
        "IsHolidayWork": isHolidayWork,
        "IsHoliday": isHoliday,
        "IsWeekOff": isWeekOff,
      };
}
