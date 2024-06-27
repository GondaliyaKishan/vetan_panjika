class EmployeeLeavesResponseDataModel {
  EmployeeLeavesResponseDataModel({
    required this.data,
  });

  List<EmployeeLeavesDataModel> data;

  factory EmployeeLeavesResponseDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeLeavesResponseDataModel(
        data: List<EmployeeLeavesDataModel>.from(json["EmployeeLeavesData"]
            .map((x) => EmployeeLeavesDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "EmployeeLeavesData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EmployeeLeavesDataModel {
  EmployeeLeavesDataModel(
      {required this.id,
        required this.statusId,
        required this.statusName,
        required this.fullName,
        required this.leaveType,
        required this.leaveDate,
        required this.transDateOld,
        required this.newTransDate,
        required this.reason,
      });
  String id;
  String statusId;
  String statusName;
  String fullName;
  String leaveType;
  String leaveDate;
  String transDateOld;
  String newTransDate;
  String reason;

  factory EmployeeLeavesDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeLeavesDataModel(
        id: json["ID"].toString(),
        statusId: json["StatusID"].toString(),
        statusName: json["Status"].toString(),
        fullName: json["FullName"].toString(),
        leaveType: json["TypeName"].toString(),
        leaveDate: json["LeaveDate"].toString(),
        transDateOld: json["TransDateold"].toString(),
        newTransDate: json["NewTransDate"].toString(),
        reason: json["Reason"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "StatusID": statusId,
    "Status": statusName,
    "FullName": fullName,
    "TypeName": leaveType,
    "LeaveDate": leaveDate,
    "TransDateold": transDateOld,
    "NewTransDate": newTransDate,
    "Reason": reason,
  };
}
