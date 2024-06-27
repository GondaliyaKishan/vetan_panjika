class ExpenseHeadTypeFilterResponseModel {
  ExpenseHeadTypeFilterResponseModel({
    required this.data,
  });

  List<ExpenseHeadTypeFilterModel> data;

  factory ExpenseHeadTypeFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      ExpenseHeadTypeFilterResponseModel(
        data: List<ExpenseHeadTypeFilterModel>.from(
            json["HeadTypeFilters"].map((x) => ExpenseHeadTypeFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "HeadTypeFilters": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ExpenseHeadTypeFilterModel {
  ExpenseHeadTypeFilterModel(
      {
        required this.id,
        required this.headName});

  String id;
  String headName;

  factory ExpenseHeadTypeFilterModel.fromJson(Map<String, dynamic> json) => ExpenseHeadTypeFilterModel(
      id: json["ID"],
      headName: json["ExpensesType"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "ExpensesType": headName,
  };
}
