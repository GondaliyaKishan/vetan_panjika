class DeviceFilterResponseModel {
  DeviceFilterResponseModel({
    required this.data,
  });

  List<DeviceFilterModel> data;

  factory DeviceFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      DeviceFilterResponseModel(
        data: List<DeviceFilterModel>.from(
            json["DeviceFilters"].map((x) => DeviceFilterModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DeviceFilters": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DeviceFilterModel {
  DeviceFilterModel(
      {
        required this.id,
        required this.deviceName});

  String id;
  String deviceName;

  factory DeviceFilterModel.fromJson(Map<String, dynamic> json) => DeviceFilterModel(
      id: json["ID"],
      deviceName: json["DeviceName"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "DeviceName": deviceName,
  };
}
