class NMSLocationWiseDevicesResponseDataModel {
  NMSLocationWiseDevicesResponseDataModel({
    required this.data,
  });

  List<NMSLocationWiseDevicesDataModel> data;

  factory NMSLocationWiseDevicesResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationWiseDevicesResponseDataModel(
        data: List<NMSLocationWiseDevicesDataModel>.from(json["DevicesData"]
            .map((x) => NMSLocationWiseDevicesDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DevicesData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSLocationWiseDevicesDataModel {
  NMSLocationWiseDevicesDataModel(
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

  factory NMSLocationWiseDevicesDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationWiseDevicesDataModel(
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
