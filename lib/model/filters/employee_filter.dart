class EmployeeFilterResponseModel {
  EmployeeFilterResponseModel({
    required this.data,
  });

  List<EmployeeFilterModel> data;

  factory EmployeeFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      EmployeeFilterResponseModel(
        data: List<EmployeeFilterModel>.from(
            json["EmployeeFilter"].map((x) => EmployeeFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "EmployeeFilter": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EmployeeFilterModel {
  EmployeeFilterModel(
      {
        required this.id,
        required this.employeeName});

  String id;
  String employeeName;

  factory EmployeeFilterModel.fromJson(Map<String, dynamic> json) => EmployeeFilterModel(
      id: json["ID"],
      employeeName: json["FullName"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "FullName": employeeName,
  };
}
