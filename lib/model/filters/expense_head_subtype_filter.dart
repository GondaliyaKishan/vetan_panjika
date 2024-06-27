class ExpenseHeadSubtypeFilterResponseModel {
  ExpenseHeadSubtypeFilterResponseModel({
    required this.data,
  });

  List<ExpenseHeadSubtypeFilterModel> data;

  factory ExpenseHeadSubtypeFilterResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ExpenseHeadSubtypeFilterResponseModel(
        data: List<ExpenseHeadSubtypeFilterModel>.from(
            json["HeadSubtypeFilters"]
                .map((x) => ExpenseHeadSubtypeFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "HeadSubtypeFilters": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ExpenseHeadSubtypeFilterModel {
  ExpenseHeadSubtypeFilterModel({required this.id, required this.subtypeName});

  String id;
  String subtypeName;

  factory ExpenseHeadSubtypeFilterModel.fromJson(Map<String, dynamic> json) =>
      ExpenseHeadSubtypeFilterModel(
          id: json["ID"], subtypeName: json["SubTypeName"]);

  Map<String, dynamic> toJson() => {
        "ID": id,
        "SubTypeName": subtypeName,
      };
}
