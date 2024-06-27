class AdminDashboardLeavesResponseModel {
  AdminDashboardLeavesResponseModel({
    required this.data,
  });

  List<AdminDashboardLeavesModel> data;

  factory AdminDashboardLeavesResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardLeavesResponseModel(
        data: List<AdminDashboardLeavesModel>.from(json["Data"]
            .map((x) => AdminDashboardLeavesModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminDashboardLeavesModel {
  AdminDashboardLeavesModel(
      {
        required this.pending,
        required this.approved,
        required this.rejected,
      });
  String pending;
  String approved;
  String rejected;

  factory AdminDashboardLeavesModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardLeavesModel(
        pending: json["Pending"].toString(),
        approved: json["Approved"].toString(),
        rejected: json["Rejected"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "Pending": pending,
    "Approved": approved,
    "Rejected": rejected,
  };
}
