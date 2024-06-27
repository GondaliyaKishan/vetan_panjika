class AdminDoorLocksResponseModel {
  AdminDoorLocksResponseModel({
    required this.data,
  });

  List<AdminDoorLocksModel> data;

  factory AdminDoorLocksResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminDoorLocksResponseModel(
        data: List<AdminDoorLocksModel>.from(
            json["DoorLocks"].map((x) => AdminDoorLocksModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DoorLocks": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminDoorLocksModel {
  AdminDoorLocksModel(
      {
        required this.lockId,
        required this.openClose,
        required this.deviceId,
        required this.deviceName,
        required this.lockName,
        required this.isDashboardView,
      });
  String lockId;
  String openClose;
  String deviceId;
  String deviceName;
  String lockName;
  String isDashboardView;

  factory AdminDoorLocksModel.fromJson(Map<String, dynamic> json) => AdminDoorLocksModel(
      lockId: json["LockID"].toString(),
      openClose: json["OpenClose"].toString(),
      deviceId: json["DeviceID"].toString(),
      deviceName: json["DeviceName"].toString(),
      lockName: json["LockName"].toString(),
      isDashboardView: json["IsDashboardView"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "LockID": lockId,
    "OpenClose": openClose,
    "DeviceID": deviceId,
    "DeviceName": deviceName,
    "LockName": lockName,
    "IsDashboardView": isDashboardView,
  };
}
