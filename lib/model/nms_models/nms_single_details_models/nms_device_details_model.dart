class NMSDeviceDetailsResponseDataModel {
  NMSDeviceDetailsResponseDataModel({
    required this.data,
  });

  List<NMSDeviceDetailsDataModel> data;

  factory NMSDeviceDetailsResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceDetailsResponseDataModel(
        data: List<NMSDeviceDetailsDataModel>.from(json["DeviceDetailsData"]
            .map((x) => NMSDeviceDetailsDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DeviceDetailsData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSDeviceDetailsDataModel {
  NMSDeviceDetailsDataModel({required this.deviceDetails, required this.logsData});
  List<NMSDeviceDetailsListDataModel> deviceDetails;
  List<NMSDeviceDetailsLogsDataModel> logsData;

  factory NMSDeviceDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceDetailsDataModel(
        deviceDetails: List<NMSDeviceDetailsListDataModel>.from(
            json["DetailsData"]
                .map((x) => NMSDeviceDetailsListDataModel.fromJson(x))),
        logsData: List<NMSDeviceDetailsLogsDataModel>.from(json["LogsData"]
            .map((x) => NMSDeviceDetailsLogsDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "DetailsData": deviceDetails,
    "LogsData": logsData,
  };
}

class NMSDeviceDetailsLogsDataModel {
  NMSDeviceDetailsLogsDataModel({
    required this.srNo,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });
  String srNo;
  String status;
  String startTime;
  String endTime;
  String duration;

  factory NMSDeviceDetailsLogsDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceDetailsLogsDataModel(
        srNo: json["SNo"].toString(),
        status: json["Status"].toString(),
        startTime: json["StartTime"].toString(),
        endTime: json["EndTime"].toString(),
        duration: json["Duration"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "SNo": srNo,
    "Status": status,
    "StartTime": startTime,
    "EndTime": endTime,
    "Duration": duration,
  };
}

class NMSDeviceDetailsListDataModel {
  NMSDeviceDetailsListDataModel(
      {
        required this.deviceName,
        required this.imageUrl,
        required this.ipAddress,
        required this.agentName,
        required this.locationName,
        required this.status,
        required this.typeName,
        required this.lastSuccessOn,
        required this.lastFailOn,
        required this.lastCriticalOn,
        required this.successPer,
        required this.criticalPer,
        required this.failPer,
      });
  String deviceName;
  String imageUrl;
  String ipAddress;
  String agentName;
  String locationName;
  String status;
  String typeName;
  String lastSuccessOn;
  String lastFailOn;
  String lastCriticalOn;
  String successPer;
  String criticalPer;
  String failPer;

  factory NMSDeviceDetailsListDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceDetailsListDataModel(
        deviceName: json["DeviceName"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        ipAddress: json["IPAddress"] == ''
            ? 'N/A' : json["IPAddress"],
        agentName: json["AgentName"].toString(),
        locationName: json["LocationName"].toString(),
        status: json["Status"].toString(),
        typeName: json["TypeName"].toString(),
        lastSuccessOn: json["LastSuccessOn"].toString(),
        lastFailOn: json["LastFailOn"].toString(),
        lastCriticalOn: json["LastCriticalOn"].toString(),
        successPer: json["SuccessPer"].toString(),
        criticalPer: json["CriticalPer"].toString(),
        failPer: json["FailPer"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "DeviceName": deviceName,
    "ImageUrl": imageUrl,
    "IPAddress": ipAddress,
    "AgentName": agentName,
    "LocationName": locationName,
    "Status": status,
    "TypeName": typeName,
    "LastSuccessOn": lastSuccessOn,
    "LastFailOn": lastFailOn,
    "LastCriticalOn": lastCriticalOn,
    "SuccessPer": successPer,
    "CriticalPer": criticalPer,
    "FailPer": failPer,
  };
}
