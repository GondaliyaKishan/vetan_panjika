class ExpensesHeadResponseDataModel {
  ExpensesHeadResponseDataModel({
    required this.data,
  });

  List<ExpensesHeadDataModel> data;

  factory ExpensesHeadResponseDataModel.fromJson(Map<String, dynamic> json) =>
      ExpensesHeadResponseDataModel(
        data: List<ExpensesHeadDataModel>.from(json["ExpensesHead"]
            .map((x) => ExpensesHeadDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "ExpensesHead": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ExpensesHeadDataModel {
  ExpensesHeadDataModel(
      {required this.id,
        required this.headName,
      });
  String id;
  String headName;

  factory ExpensesHeadDataModel.fromJson(Map<String, dynamic> json) =>
      ExpensesHeadDataModel(
        id: json["ID"].toString(),
        headName: json["HeadName"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "HeadName": headName,
  };
}
