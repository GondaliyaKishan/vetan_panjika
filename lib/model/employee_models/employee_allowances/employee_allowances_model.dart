class EmployeeAllowancesResponseDataModel {
  EmployeeAllowancesResponseDataModel({
    required this.data,
  });

  List<EmployeeAllowancesDataModel> data;

  factory EmployeeAllowancesResponseDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeAllowancesResponseDataModel(
        data: List<EmployeeAllowancesDataModel>.from(json["EmployeeAllowancesData"]
            .map((x) => EmployeeAllowancesDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "EmployeeAllowancesData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EmployeeAllowancesDataModel {
  EmployeeAllowancesDataModel(
      {required this.id,
        required this.headId,
        required this.headName,
        required this.amount,
        required this.remark,
        required this.statusId,
        required this.statusName,
        required this.expensesDateOld,
        required this.dateNew,
      });
  String id;
  String headId;
  String headName;
  String amount;
  String remark;
  String statusId;
  String statusName;
  String expensesDateOld;
  String dateNew;

  factory EmployeeAllowancesDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeAllowancesDataModel(
        id: json["ID"].toString(),
        headId: json["HeadID"].toString(),
        headName: json["HeadName"].toString(),
        amount: json["Amount"].toString(),
        remark: json["Remark"].toString(),
        statusId: json["StatusID"].toString(),
        statusName: json["StatusName"].toString(),
        expensesDateOld: json["TransDateold"].toString(),
        dateNew: json["NewTransDate"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "HeadID": headId,
    "HeadName": headName,
    "Amount": amount,
    "Remark": remark,
    "StatusID": statusId,
    "StatusName": statusName,
    "TransDateold": expensesDateOld,
    "NewTransDate": dateNew,
  };
}
