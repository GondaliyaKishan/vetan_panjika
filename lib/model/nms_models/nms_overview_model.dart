class NMSOverviewResponseDataModel {
  NMSOverviewResponseDataModel({
    required this.data,
  });

  List<NMSOverviewDataModel> data;

  factory NMSOverviewResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSOverviewResponseDataModel(
        data: List<NMSOverviewDataModel>.from(json["OverviewData"]
            .map((x) => NMSOverviewDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "OverviewData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSOverviewDataModel {
  NMSOverviewDataModel(
      {required this.percentage,
        required this.ipsData});
  List<NMSOverviewDataPercentageModel> percentage;
  List<NMSOverviewDataIpsDataModel> ipsData;

  factory NMSOverviewDataModel.fromJson(Map<String, dynamic> json) =>
      NMSOverviewDataModel(
        percentage: List<NMSOverviewDataPercentageModel>.from(
            json["Percentage"].map((x) => NMSOverviewDataPercentageModel.fromJson(x))),
        ipsData: List<NMSOverviewDataIpsDataModel>.from(
            json["IpsData"].map((x) => NMSOverviewDataIpsDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "Percentage": percentage,
    "IpsData": ipsData,
  };
}

class NMSOverviewDataPercentageModel {
  NMSOverviewDataPercentageModel(
      {required this.upPercentage,
        required this.criticalPercentage,
        required this.offlinePercentage,
        required this.notManagedPercentage,
      });
  String upPercentage;
  String criticalPercentage;
  String offlinePercentage;
  String notManagedPercentage;

  factory NMSOverviewDataPercentageModel.fromJson(Map<String, dynamic> json) =>
      NMSOverviewDataPercentageModel(
        upPercentage: json["UpPercentage"].toString(),
        criticalPercentage: json["CriticalPercentage"].toString(),
        offlinePercentage: json["OfflinePercentage"].toString(),
        notManagedPercentage: json["NotMonitoredPercentage"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "UpPercentage": upPercentage,
    "CriticalPercentage": criticalPercentage,
    "OfflinePercentage": offlinePercentage,
    "NotMonitoredPercentage": notManagedPercentage,
  };
}

class NMSOverviewDataIpsDataModel {
  NMSOverviewDataIpsDataModel(
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

  factory NMSOverviewDataIpsDataModel.fromJson(Map<String, dynamic> json) =>
      NMSOverviewDataIpsDataModel(
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
