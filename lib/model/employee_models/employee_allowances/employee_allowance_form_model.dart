class AllowanceAddEditResponseModel {
  AllowanceAddEditResponseModel({
    required this.data,
  });

  List<AllowanceAddEditModel> data;

  factory AllowanceAddEditResponseModel.fromJson(Map<String, dynamic> json) =>
      AllowanceAddEditResponseModel(
        data: List<AllowanceAddEditModel>.from(
            json["AllowanceById"].map((x) => AllowanceAddEditModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "AllowanceById": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllowanceAddEditModel {
  AllowanceAddEditModel(
      {required this.id,
        required this.amount,
        required this.headId,
        required this.headName,
        required this.statusId,
        required this.statusName,
        required this.remark,
        required this.dateOld,
        required this.dateNew,
      });
  String id;
  String amount;
  String headId;
  String headName;
  String statusId;
  String statusName;
  String remark;
  String dateOld;
  String dateNew;

  factory AllowanceAddEditModel.fromJson(Map<String, dynamic> json) => AllowanceAddEditModel(
      id: json["ID"],
      amount: json["Amount"].toString(),
      headId: json["HeadID"],
      headName: json["HeadName"],
      statusId: json["StatusID"].toString(),
      statusName: json["StatusName"],
      remark: json["Remark"],
      dateOld: json["TransDateold"],
      dateNew: json["NewTransDate"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Amount": amount,
    "HeadID": headId,
    "HeadName": headName,
    "StatusID": statusId,
    "StatusName": statusName,
    "Remark": remark,
    "TransDateold": dateOld,
    "NewTransDate": dateNew,
  };
}
