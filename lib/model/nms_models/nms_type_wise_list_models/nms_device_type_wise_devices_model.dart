class NMSDeviceTypeDevicesResponseDataModel {
  NMSDeviceTypeDevicesResponseDataModel({
    required this.data,
  });

  List<NMSDeviceTypeDevicesDataModel> data;

  factory NMSDeviceTypeDevicesResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceTypeDevicesResponseDataModel(
        data: List<NMSDeviceTypeDevicesDataModel>.from(json["DevicesData"]
            .map((x) => NMSDeviceTypeDevicesDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DevicesData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSDeviceTypeDevicesDataModel {
  NMSDeviceTypeDevicesDataModel(
      {required this.deviceId,
        required this.typeId,
        required this.ipAddress,
        required this.templateName,
        required this.deviceName,
        required this.locationName,
        required this.typeName,
        required this.imageUrl,
        required this.status,
      });
  String deviceId;
  String typeId;
  String ipAddress;
  String templateName;
  String deviceName;
  String locationName;
  String typeName;
  String imageUrl;
  String status;

  factory NMSDeviceTypeDevicesDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceTypeDevicesDataModel(
        deviceId: json["DeviceID"].toString(),
        typeId: json["TypeID"].toString(),
        ipAddress: json["IP_Address"].toString(),
        templateName: json["TemplateName"].toString(),
        deviceName: json["DeviceName"].toString(),
        locationName: json["LocationName"].toString(),
        typeName: json["TypeName"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        status: json["STATUS"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "DeviceID": deviceId,
    "TypeID": typeId,
    "IP_Address": ipAddress,
    "TemplateName": templateName,
    "DeviceName": deviceName,
    "LocationName": locationName,
    "TypeName": typeName,
    "ImageUrl": imageUrl,
    "STATUS": status,
  };
}
