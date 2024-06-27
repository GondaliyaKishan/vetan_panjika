class AdminBranchesResponseModel {
  AdminBranchesResponseModel({
    required this.data,
  });

  List<AdminBranchesModel> data;

  factory AdminBranchesResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminBranchesResponseModel(
        data: List<AdminBranchesModel>.from(
            json["MobileBranches"].map((x) => AdminBranchesModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "MobileBranches": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminBranchesModel {
  AdminBranchesModel(
      {
        required this.id,
        required this.branchName,
        required this.totalEmployee,
        required this.totalDevices,
      });
  String id;
  String branchName;
  String totalEmployee;
  String totalDevices;

  factory AdminBranchesModel.fromJson(Map<String, dynamic> json) => AdminBranchesModel(
      id: json["ID"],
      branchName: json["BranchName"].toString(),
      totalEmployee: json["TotalEmployees"].toString(),
      totalDevices: json["TotalDevices"].toString()
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "BranchName": branchName,
    "TotalEmployees": totalEmployee,
    "TotalDevices": totalDevices
  };
}
