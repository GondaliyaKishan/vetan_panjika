class AdminDashboardExpensesResponseModel {
  AdminDashboardExpensesResponseModel({
    required this.data,
  });

  List<AdminDashboardExpensesModel> data;

  factory AdminDashboardExpensesResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardExpensesResponseModel(
        data: List<AdminDashboardExpensesModel>.from(json["Data"]
            .map((x) => AdminDashboardExpensesModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminDashboardExpensesModel {
  AdminDashboardExpensesModel(
      {
        required this.pending,
        required this.approved,
        required this.rejected,
        required this.paid,
      });
  String pending;
  String approved;
  String rejected;
  String paid;

  factory AdminDashboardExpensesModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardExpensesModel(
        pending: json["Pending"].toString(),
        approved: json["Approved"].toString(),
        rejected: json["Rejected"].toString(),
        paid: json["Paid"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "Pending": pending,
    "Approved": approved,
    "Rejected": rejected,
    "Paid": paid,
  };
}
