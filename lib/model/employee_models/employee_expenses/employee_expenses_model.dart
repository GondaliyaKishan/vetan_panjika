class EmployeeExpensesResponseDataModel {
  EmployeeExpensesResponseDataModel({
    required this.data,
  });

  List<EmployeeExpensesDataModel> data;

  factory EmployeeExpensesResponseDataModel.fromJson(
          Map<String, dynamic> json) =>
      EmployeeExpensesResponseDataModel(
        data: List<EmployeeExpensesDataModel>.from(json["EmployeeExpensesData"]
            .map((x) => EmployeeExpensesDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "EmployeeExpensesData": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmployeeExpensesDataModel {
  EmployeeExpensesDataModel({
    required this.id,
    required this.headId,
    required this.headName,
    required this.subHeadName,
    required this.amount,
    required this.remark,
    required this.statusId,
    required this.statusName,
    required this.expensesDateOld,
    required this.dateNew,
    required this.fileName,
  });
  String id;
  String headId;
  String headName;
  String subHeadName;
  String amount;
  String remark;
  String statusId;
  String statusName;
  String expensesDateOld;
  String dateNew;
  String fileName;

  factory EmployeeExpensesDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeExpensesDataModel(
        id: json["ID"].toString(),
        headId: json["ExpensesTypeID"].toString(),
        headName: json["ExpensesType"].toString(),
        subHeadName: json["SubTypeName"].toString(),
        amount: json["Amount"].toString(),
        remark: json["Remark"].toString(),
        statusId: json["StatusID"].toString(),
        statusName: json["StatusName"].toString(),
        expensesDateOld: json["TransExpensesDateold"].toString(),
        dateNew: json["NewExpensesTransDate"].toString(),
        fileName: json["FileName"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ExpensesTypeID": headId,
        "ExpensesType": headName,
        "SubTypeName": subHeadName,
        "Amount": amount,
        "Remark": remark,
        "StatusID": statusId,
        "StatusName": statusName,
        "TransExpensesDateold": expensesDateOld,
        "NewExpensesTransDate": dateNew,
        "FileName": fileName,
      };
}
