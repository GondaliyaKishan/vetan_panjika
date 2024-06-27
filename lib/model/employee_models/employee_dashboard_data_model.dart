class EmployeeDashboardResponseDataModel {
  EmployeeDashboardResponseDataModel({
    required this.data,
  });

  List<EmployeeDashboardDataModel> data;

  factory EmployeeDashboardResponseDataModel.fromJson(
          Map<String, dynamic> json) =>
      EmployeeDashboardResponseDataModel(
        data: List<EmployeeDashboardDataModel>.from(
            json["Data"].map((x) => EmployeeDashboardDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmployeeDashboardDataModel {
  EmployeeDashboardDataModel({
    required this.onTime,
    required this.presentTotal,
    required this.absentTotal,
    required this.lessHrsTotal,
    required this.weekOffTotal,
    required this.punchMissingTotal,
    required this.halfDayTotal,
    required this.lateTotal,
    required this.holidayTotal,
    required this.totalHolidaysWorking,
    required this.totalWeekOffsWorking,
    required this.totalOverTime,
    required this.totalWorkingHrs,
  });
  String onTime;
  String presentTotal;
  String absentTotal;
  String lessHrsTotal;
  String weekOffTotal;
  String punchMissingTotal;
  String halfDayTotal;
  String lateTotal;
  String holidayTotal;
  String totalHolidaysWorking;
  String totalWeekOffsWorking;
  String totalOverTime;
  String totalWorkingHrs;

  factory EmployeeDashboardDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDashboardDataModel(
        onTime: json["P"].toString(),
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
        punchMissingTotal: json["PM"].toString(),
        halfDayTotal: json["HD"].toString(),
        lateTotal: json["L"].toString(),
        holidayTotal: json["HL"].toString(),
        totalHolidaysWorking: json["TotalHolidaysWorking"].toString(),
        totalWeekOffsWorking: json["TotalWeekOffsWorking"].toString(),
        totalOverTime: json["TotalOverTime"].toString(),
        totalWorkingHrs: json["TotalWorkingHrs"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "OnTime": onTime,
        "P": presentTotal,
        "A": absentTotal,
        "LH": lessHrsTotal,
        "WO": weekOffTotal,
        "PM": punchMissingTotal,
        "HD": halfDayTotal,
        "L": lateTotal,
        "HL": holidayTotal,
        "TotalHolidaysWorking": totalHolidaysWorking,
        "TotalWeekOffsWorking": totalWeekOffsWorking,
        "TotalOverTime": totalOverTime,
        "TotalWorkingHrs": totalWorkingHrs,
      };
}
