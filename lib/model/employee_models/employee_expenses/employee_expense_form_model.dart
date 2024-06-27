class ExpensesAddEditResponseModel {
  ExpensesAddEditResponseModel({
    required this.data,
  });

  List<ExpensesAddEditModel> data;

  factory ExpensesAddEditResponseModel.fromJson(Map<String, dynamic> json) =>
      ExpensesAddEditResponseModel(
        data: List<ExpensesAddEditModel>.from(
            json["ExpensesById"].map((x) => ExpensesAddEditModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "ExpensesById": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ExpensesAddEditModel {
  ExpensesAddEditModel({
    required this.id,
    required this.amount,
    required this.headId,
    required this.headName,
    required this.subtypeId,
    required this.statusId,
    required this.statusName,
    required this.remark,
    required this.dateOld,
    required this.dateNew,
    required this.fileName,
  });
  String id;
  String amount;
  String headId;
  String headName;
  String subtypeId;
  String statusId;
  String statusName;
  String remark;
  String dateOld;
  String dateNew;
  String fileName;

  factory ExpensesAddEditModel.fromJson(Map<String, dynamic> json) =>
      ExpensesAddEditModel(
        id: json["ID"],
        amount: json["Amount"].toString(),
        headId: json["ExpensesTypeID"],
        headName: json["ExpensesType"],
        subtypeId: json["ExpensesSubTypeID"],
        statusId: json["StatusID"].toString(),
        statusName: json["StatusName"],
        remark: json["Remark"],
        dateOld: json["TransDateold"],
        dateNew: json["NewExpensesTransDate"],
        fileName: json["FileName"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Amount": amount,
        "ExpensesTypeID": headId,
        "ExpensesType": headName,
        "ExpensesSubTypeID": subtypeId,
        "StatusID": statusId,
        "StatusName": statusName,
        "Remark": remark,
        "TransExpensesDateold": dateOld,
        "NewExpensesTransDate": dateNew,
        "FileName": fileName,
      };
}
