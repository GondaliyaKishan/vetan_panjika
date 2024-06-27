class NMSDeviceViewResponseDataModel {
  NMSDeviceViewResponseDataModel({
    required this.data,
  });

  List<NMSDeviceViewDataModel> data;

  factory NMSDeviceViewResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceViewResponseDataModel(
        data: List<NMSDeviceViewDataModel>.from(json["DeviceListData"]
            .map((x) => NMSDeviceViewDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DeviceListData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSDeviceViewDataModel {
  NMSDeviceViewDataModel({required this.percentage, required this.deviceData});
  List<NMSDeviceViewDataPercentageModel> percentage;
  List<NMSDeviceViewDeviceDataModel> deviceData;

  factory NMSDeviceViewDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceViewDataModel(
        percentage: List<NMSDeviceViewDataPercentageModel>.from(
            json["Percentage"]
                .map((x) => NMSDeviceViewDataPercentageModel.fromJson(x))),
        deviceData: List<NMSDeviceViewDeviceDataModel>.from(json["DeviceData"]
            .map((x) => NMSDeviceViewDeviceDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "Percentage": percentage,
    "DeviceData": deviceData,
  };
}

class NMSDeviceViewDataPercentageModel {
  NMSDeviceViewDataPercentageModel({
    required this.upPercentage,
    required this.criticalPercentage,
    required this.offlinePercentage,
    required this.notManagedPercentage,
  });
  String upPercentage;
  String criticalPercentage;
  String offlinePercentage;
  String notManagedPercentage;

  factory NMSDeviceViewDataPercentageModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceViewDataPercentageModel(
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

class NMSDeviceViewDeviceDataModel {
  NMSDeviceViewDeviceDataModel({
    required this.imageUrl,
    required this.typeName,
    required this.typeId,
    required this.online,
    required this.highLatency,
    required this.offline,
    required this.notMonitored,
  });
  String imageUrl;
  String typeName;
  String typeId;
  String online;
  String highLatency;
  String offline;
  String notMonitored;

  factory NMSDeviceViewDeviceDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceViewDeviceDataModel(
        imageUrl: json["ImageUrl"].toString(),
        typeName: json["TypeName"].toString(),
        typeId: json["TypeID"].toString(),
        online: json["Online"].toString(),
        highLatency: json["HighLatency"].toString(),
        offline: json["Offline"].toString(),
        notMonitored: json["NotMonitored"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ImageUrl": imageUrl,
    "TypeName": typeName,
    "TypeID": typeId,
    "Online": online,
    "HighLatency": highLatency,
    "Offline": offline,
    "NotMonitored": notMonitored,
  };
}
