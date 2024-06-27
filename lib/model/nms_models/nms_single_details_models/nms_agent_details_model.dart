class NMSAgentDetailsResponseDataModel {
  NMSAgentDetailsResponseDataModel({
    required this.data,
  });

  List<NMSAgentDetailsDataModel> data;

  factory NMSAgentDetailsResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentDetailsResponseDataModel(
        data: List<NMSAgentDetailsDataModel>.from(json["AgentDetailsData"]
            .map((x) => NMSAgentDetailsDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "AgentDetailsData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSAgentDetailsDataModel {
  NMSAgentDetailsDataModel({required this.agentDetails, required this.logsData});
  List<NMSAgentDetailsListDataModel> agentDetails;
  List<NMSAgentDetailsLogsDataModel> logsData;

  factory NMSAgentDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentDetailsDataModel(
        agentDetails: List<NMSAgentDetailsListDataModel>.from(
            json["DetailsData"]
                .map((x) => NMSAgentDetailsListDataModel.fromJson(x))),
        logsData: List<NMSAgentDetailsLogsDataModel>.from(json["LogsData"]
            .map((x) => NMSAgentDetailsLogsDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "DetailsData": agentDetails,
    "LogsData": logsData,
  };
}

class NMSAgentDetailsLogsDataModel {
  NMSAgentDetailsLogsDataModel({
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

  factory NMSAgentDetailsLogsDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentDetailsLogsDataModel(
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

class NMSAgentDetailsListDataModel {
  NMSAgentDetailsListDataModel(
      {
        required this.agentName,
        required this.imageUrl,
        required this.publicIp,
        required this.localIp,
        required this.status,
        required this.nosHosts,
        required this.lastSuccessOn,
        required this.lastFailOn,
        required this.lastCriticalOn,
        required this.lastNotMonitored,
        required this.successPer,
        required this.criticalPer,
        required this.failPer,
        required this.notMonitoredPer,
      });
  String agentName;
  String imageUrl;
  String publicIp;
  String localIp;
  String status;
  String nosHosts;
  String lastSuccessOn;
  String lastFailOn;
  String lastCriticalOn;
  String lastNotMonitored;
  String successPer;
  String criticalPer;
  String failPer;
  String notMonitoredPer;

  factory NMSAgentDetailsListDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentDetailsListDataModel(
        agentName: json["AgentName"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        publicIp: json["PublicIP"] == ''
            ? 'N/A' : json["PublicIP"],
        localIp: json["LocalIP"] == ''
            ? 'N/A' : json["LocalIP"],
        status: json["Status"].toString(),
        nosHosts: json["NosHosts"].toString(),
        lastSuccessOn: json["LastSuccessOn"].toString(),
        lastFailOn: json["LastFailOn"].toString(),
        lastCriticalOn: json["LastCriticalOn"].toString(),
        lastNotMonitored: json["LastNotMonitoredOn"].toString(),
        successPer: json["SuccessPer"].toString(),
        criticalPer: json["CriticalPer"].toString(),
        failPer: json["FailPer"].toString(),
        notMonitoredPer: json["NotMonitoredPer"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "AgentName": agentName,
    "ImageUrl": imageUrl,
    "PublicIP": publicIp,
    "LocalIP": localIp,
    "Status": status,
    "NosHosts": nosHosts,
    "LastSuccessOn": lastSuccessOn,
    "LastFailOn": lastFailOn,
    "LastCriticalOn": lastCriticalOn,
    "LastNotMonitoredOn": lastNotMonitored,
    "SuccessPer": successPer,
    "CriticalPer": criticalPer,
    "FailPer": failPer,
    "NotMonitoredPer": notMonitoredPer,
  };
}
