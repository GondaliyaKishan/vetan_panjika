class EmployeeDailyUpdateResponseDataModel {
  EmployeeDailyUpdateResponseDataModel({
    required this.data,
  });

  List<EmployeeDailyUpdateDataModel> data;

  factory EmployeeDailyUpdateResponseDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDailyUpdateResponseDataModel(
        data: List<EmployeeDailyUpdateDataModel>.from(json["EmployeeDailyUpdateData"]
            .map((x) => EmployeeDailyUpdateDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "EmployeeDailyUpdateData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EmployeeDailyUpdateDataModel {
  EmployeeDailyUpdateDataModel(
      {required this.id,
        required this.statusName,
        required this.projectName,
        required this.partyName,
        required this.fullName,
        required this.remark,
        required this.transDateOld,
        required this.transDateNew,
      });
  String id;
  String statusName;
  String projectName;
  String partyName;
  String fullName;
  String remark;
  String transDateOld;
  String transDateNew;

  factory EmployeeDailyUpdateDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDailyUpdateDataModel(
        id: json["ID"].toString(),
        statusName: json["StatusName"].toString(),
        projectName: json["ProjectName"].toString(),
        partyName: json["PartyName"].toString(),
        fullName: json["FullName"].toString(),
        remark: json["Remark"].toString(),
        transDateOld: json["TransDateOld"].toString(),
        transDateNew: json["TransDateNew"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "StatusName": statusName,
    "ProjectName": projectName,
    "PartyName": partyName,
    "FullName": fullName,
    "Remark": remark,
    "TransDateOld": transDateOld,
    "TransDateNew": transDateNew,
  };
}
