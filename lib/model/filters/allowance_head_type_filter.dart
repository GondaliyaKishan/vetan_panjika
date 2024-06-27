class AllowanceHeadTypeFilterResponseModel {
  AllowanceHeadTypeFilterResponseModel({
    required this.data,
  });

  List<AllowanceHeadTypeFilterModel> data;

  factory AllowanceHeadTypeFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      AllowanceHeadTypeFilterResponseModel(
        data: List<AllowanceHeadTypeFilterModel>.from(
            json["HeadTypeFilters"].map((x) => AllowanceHeadTypeFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "HeadTypeFilters": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllowanceHeadTypeFilterModel {
  AllowanceHeadTypeFilterModel(
      {
        required this.id,
        required this.headName});

  String id;
  String headName;

  factory AllowanceHeadTypeFilterModel.fromJson(Map<String, dynamic> json) => AllowanceHeadTypeFilterModel(
      id: json["ID"],
      headName: json["HeadName"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "HeadName": headName,
  };
}
