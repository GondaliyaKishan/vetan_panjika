class LeaveTypeFilterResponseModel {
  LeaveTypeFilterResponseModel({
    required this.data,
  });

  List<LeaveTypeFilterModel> data;

  factory LeaveTypeFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      LeaveTypeFilterResponseModel(
        data: List<LeaveTypeFilterModel>.from(json["LeaveTypeFilters"]
            .map((x) => LeaveTypeFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "LeaveTypeFilters": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LeaveTypeFilterModel {
  LeaveTypeFilterModel({
    required this.id,
    required this.typeName,
    required this.shortCode,
  });

  String id;
  String typeName;
  String shortCode;

  factory LeaveTypeFilterModel.fromJson(Map<String, dynamic> json) =>
      LeaveTypeFilterModel(
        id: json["ID"],
        typeName: json["TypeName"],
        shortCode: json["ShortCode"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TypeName": typeName,
        "ShortCode": shortCode,
      };
}
