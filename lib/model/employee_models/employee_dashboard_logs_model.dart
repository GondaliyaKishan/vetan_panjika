class EmployeeDashboardResponseLogsModel {
  EmployeeDashboardResponseLogsModel({
    required this.data,
  });

  List<EmployeeDashboardLogsModel> data;

  factory EmployeeDashboardResponseLogsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDashboardResponseLogsModel(
        data: List<EmployeeDashboardLogsModel>.from(json["EmployeeDashboardData"]
            .map((x) => EmployeeDashboardLogsModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "EmployeeDashboardData": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmployeeDashboardLogsModel {
  EmployeeDashboardLogsModel(
      {required this.id,
      required this.time,
      required this.attendanceDate,
      required this.mode,
      required this.logImg});
  String id;
  String time;
  String attendanceDate;
  String mode;
  String logImg;

  factory EmployeeDashboardLogsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDashboardLogsModel(
        id: json["ID"],
        time: json["Time"],
        attendanceDate: json["AttendenceDate"].toString(),
        mode: json["Mode"].toString(),
        logImg: (json["Log_picture"] ?? "").toString(),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Time": time,
        "Mode": mode,
        "AttendenceDate": attendanceDate,
        "Log_picture": logImg,
      };
}
