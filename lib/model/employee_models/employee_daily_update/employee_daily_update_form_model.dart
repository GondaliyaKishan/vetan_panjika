class DailyUpdateAddEditResponseModel {
  DailyUpdateAddEditResponseModel({
    required this.data,
  });

  List<DailyUpdateAddEditModel> data;

  factory DailyUpdateAddEditResponseModel.fromJson(Map<String, dynamic> json) =>
      DailyUpdateAddEditResponseModel(
        data: List<DailyUpdateAddEditModel>.from(
            json["UpdateById"].map((x) => DailyUpdateAddEditModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "UpdateById": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DailyUpdateAddEditModel {
  DailyUpdateAddEditModel(
      {required this.id,
        required this.statusName,
        required this.projectId,
        required this.projectName,
        required this.partyName,
        required this.fullName,
        required this.remark,
        required this.transDateOld,
        required this.transDateNew,
      });
  String id;
  String statusName;
  String projectId;
  String projectName;
  String partyName;
  String fullName;
  String remark;
  String transDateOld;
  String transDateNew;

  factory DailyUpdateAddEditModel.fromJson(Map<String, dynamic> json) => DailyUpdateAddEditModel(
    id: json["ID"].toString(),
    statusName: json["StatusName"].toString(),
    projectId: json["ProjectID"].toString(),
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
    "ProjectID": projectId,
    "ProjectName": projectName,
    "PartyName": partyName,
    "FullName": fullName,
    "Remark": remark,
    "TransDateOld": transDateOld,
    "TransDateNew": transDateNew,
  };
}
