class BranchFilterResponseModel {
  BranchFilterResponseModel({
    required this.data,
  });

  List<BranchFilterModel> data;

  factory BranchFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      BranchFilterResponseModel(
        data: List<BranchFilterModel>.from(
            json["BranchFilters"].map((x) => BranchFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "BranchFilters": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BranchFilterModel {
  BranchFilterModel(
      {
        required this.id,
        required this.branchName});

  String id;
  String branchName;

  factory BranchFilterModel.fromJson(Map<String, dynamic> json) => BranchFilterModel(
      id: json["ID"],
      branchName: json["BranchName"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "BranchName": branchName,
  };
}
