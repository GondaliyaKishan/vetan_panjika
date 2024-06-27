class AdminDashboardResponseLogsModel {
  AdminDashboardResponseLogsModel({
    required this.data,
  });

  List<AdminDashboardLogsModel> data;

  factory AdminDashboardResponseLogsModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardResponseLogsModel(
        data: List<AdminDashboardLogsModel>.from(json["Table"]
            .map((x) => AdminDashboardLogsModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminDashboardLogsModel {
  AdminDashboardLogsModel(
      {
        required this.totalEmployees,
        required this.onTimeTotal,
        required this.presentTotal,
        required this.absentTotal,
        required this.lessHrsTotal,
        required this.weekOffTotal,
        required this.punchMissingTotal,
        required this.halfDayTotal,
        required this.lateTotal,
      });
  String totalEmployees;
  String onTimeTotal;
  String presentTotal;
  String absentTotal;
  String lessHrsTotal;
  String weekOffTotal;
  String punchMissingTotal;
  String halfDayTotal;
  String lateTotal;

  factory AdminDashboardLogsModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardLogsModel(
        totalEmployees: (int.parse(json["Ontime"].toString()) +
            int.parse(json["Late"].toString()) +
            int.parse(json["Halfday"].toString()) +
            int.parse(json["LessHours"].toString()) +
            int.parse(json["Absent"].toString()) +
            int.parse(json["Punchmissing"].toString())).toString(),
        onTimeTotal: json["Ontime"].toString(),
        presentTotal: (int.parse(json["Ontime"].toString()) +
            int.parse(json["Late"].toString()) +
            int.parse(json["Halfday"].toString()) +
            int.parse(json["LessHours"].toString()) +
            int.parse(json["Punchmissing"].toString()))
            .toString(),
        absentTotal: json["Absent"].toString(),
        lessHrsTotal: json["LessHours"].toString(),
        weekOffTotal: json["WeekOff"].toString(),
        punchMissingTotal: json["Punchmissing"].toString(),
        halfDayTotal: json["Halfday"].toString(),
        lateTotal: json["Late"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "TotalEmployees": totalEmployees,
    "OnTime": onTimeTotal,
    "Present": presentTotal,
    "Absent": absentTotal,
    "LessHours": lessHrsTotal,
    "WeekOff": weekOffTotal,
    "Punchmissing": punchMissingTotal,
    "Halfday": halfDayTotal,
    "Late": lateTotal,
  };
}
