class AdminEmployeesResponseModel {
  AdminEmployeesResponseModel({
    required this.data,
  });

  List<AdminEmployeesModel> data;

  factory AdminEmployeesResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminEmployeesResponseModel(
        data: List<AdminEmployeesModel>.from(
            json["MobileEmployees"].map((x) => AdminEmployeesModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "MobileEmployees": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminEmployeesModel {
  AdminEmployeesModel(
      {
        required this.id,
        required this.empCode,
        required this.name,
        required this.image,
        required this.designationName,
        required this.department,
        required this.branchName,
        required this.status,
      });
  String id;
  String empCode;
  String name;
  String image;
  String designationName;
  String department;
  String branchName;
  bool status;

  factory AdminEmployeesModel.fromJson(Map<String, dynamic> json) => AdminEmployeesModel(
      id: json["ID"],
      empCode: json["EmpCode"],
      name: json["EmpFirst"].toString() + json["EmpLast"].toString(),
      image: json["ProfilePicture"].toString(),
      designationName: json["DesignationName"].toString(),
      department: json["DName"].toString(),
      branchName: json["BranchName"].toString(),
      status: json["IsActive"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "EmpCode": empCode,
    "EmpName": name,
    "ProfilePicture": image,
    "DesignationName": designationName,
    "DName": department,
    "BranchName": branchName,
    "IsActive": status
  };
}
