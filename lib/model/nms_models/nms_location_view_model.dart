class NMSLocationViewResponseDataModel {
  NMSLocationViewResponseDataModel({
    required this.data,
  });

  List<NMSLocationViewDataModel> data;

  factory NMSLocationViewResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationViewResponseDataModel(
        data: List<NMSLocationViewDataModel>.from(json["LocationListData"]
            .map((x) => NMSLocationViewDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "LocationListData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSLocationViewDataModel {
  NMSLocationViewDataModel({required this.percentage, required this.locationData});
  List<NMSLocationViewDataPercentageModel> percentage;
  List<NMSLocationViewLocationDataModel> locationData;

  factory NMSLocationViewDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationViewDataModel(
        percentage: List<NMSLocationViewDataPercentageModel>.from(
            json["Percentage"]
                .map((x) => NMSLocationViewDataPercentageModel.fromJson(x))),
        locationData: List<NMSLocationViewLocationDataModel>.from(json["LocationData"]
            .map((x) => NMSLocationViewLocationDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "Percentage": percentage,
    "LocationData": locationData,
  };
}

class NMSLocationViewDataPercentageModel {
  NMSLocationViewDataPercentageModel({
    required this.upPercentage,
    required this.criticalPercentage,
    required this.offlinePercentage,
    required this.notManagedPercentage,
  });
  String upPercentage;
  String criticalPercentage;
  String offlinePercentage;
  String notManagedPercentage;

  factory NMSLocationViewDataPercentageModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationViewDataPercentageModel(
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

class NMSLocationViewLocationDataModel {
  NMSLocationViewLocationDataModel({
    required this.locationId,
    required this.locationName,
    required this.contactName,
    required this.contactNo,
    required this.address,
    required this.online,
    required this.highLatency,
    required this.offline,
    required this.notMonitored,
    required this.total,
  });
  String locationId;
  String locationName;
  String contactName;
  String contactNo;
  String address;
  String online;
  String highLatency;
  String offline;
  String notMonitored;
  String total;

  factory NMSLocationViewLocationDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationViewLocationDataModel(
        locationId: json["LocationID"].toString(),
        locationName: json["LocationName"].toString(),
        contactName: json["ContactName"].toString(),
        contactNo: json["ContactNo"].toString(),
        address: json["Address"].toString(),
        online: json["Online"].toString(),
        highLatency: json["HighLatency"].toString(),
        offline: json["Offline"].toString(),
        notMonitored: json["NotMonitored"].toString(),
        total: json["Total"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "LocationID": locationId,
    "LocationName": locationName,
    "ContactName": contactName,
    "ContactNo": contactNo,
    "Address": address,
    "Online": online,
    "HighLatency": highLatency,
    "Offline": offline,
    "NotMonitored": notMonitored,
    "Total": total,
  };
}
