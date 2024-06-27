class AdminDevicesResponseModel {
  AdminDevicesResponseModel({
    required this.data,
  });

  List<AdminDevicesModel> data;

  factory AdminDevicesResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminDevicesResponseModel(
        data: List<AdminDevicesModel>.from(
            json["MobileDevices"].map((x) => AdminDevicesModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "MobileDevices": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminDevicesModel {
  AdminDevicesModel(
      {
        required this.id,
        required this.name,
        required this.branchName,
        required this.ipAddress,
        required this.status,
      });
  String id;
  String name;
  String branchName;
  String ipAddress;
  String status;

  factory AdminDevicesModel.fromJson(Map<String, dynamic> json) => AdminDevicesModel(
      id: json["ID"],
      name: json["DeviceName"].toString(),
      branchName: json["BranchName"].toString(),
      ipAddress: json["IPAddress"].toString(),
      status: json["Status"].toString()
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "DeviceName": name,
    "BranchName": branchName,
    "IPAddress": ipAddress,
    "Status": status
  };
}
