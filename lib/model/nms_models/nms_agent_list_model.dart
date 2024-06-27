class NMSAgentListResponseDataModel {
  NMSAgentListResponseDataModel({
    required this.data,
  });

  List<NMSAgentListDataModel> data;

  factory NMSAgentListResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentListResponseDataModel(
        data: List<NMSAgentListDataModel>.from(json["AgentListData"]
            .map((x) => NMSAgentListDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "AgentListData": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NMSAgentListDataModel {
  NMSAgentListDataModel({required this.percentage, required this.agentData});
  List<NMSAgentListDataPercentageModel> percentage;
  List<NMSAgentListAgentDataModel> agentData;

  factory NMSAgentListDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentListDataModel(
        percentage: List<NMSAgentListDataPercentageModel>.from(
            json["Percentage"]
                .map((x) => NMSAgentListDataPercentageModel.fromJson(x))),
        agentData: List<NMSAgentListAgentDataModel>.from(json["AgentData"]
            .map((x) => NMSAgentListAgentDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Percentage": percentage,
        "AgentData": agentData,
      };
}

class NMSAgentListDataPercentageModel {
  NMSAgentListDataPercentageModel({
    required this.upPercentage,
    required this.criticalPercentage,
    required this.offlinePercentage,
    required this.notManagedPercentage,
  });
  String upPercentage;
  String criticalPercentage;
  String offlinePercentage;
  String notManagedPercentage;

  factory NMSAgentListDataPercentageModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentListDataPercentageModel(
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

class NMSAgentListAgentDataModel {
  NMSAgentListAgentDataModel({
    required this.agentId,
    required this.agentName,
    required this.systemIp,
    required this.publicIp,
    required this.status,
  });
  String agentId;
  String agentName;
  String systemIp;
  String publicIp;
  String status;

  factory NMSAgentListAgentDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentListAgentDataModel(
        agentId: json["AgentID"].toString(),
        agentName: json["AgentName"].toString(),
        systemIp: json["SystemIP"].toString(),
        publicIp: json["PublicIP"].toString(),
        status: json["Status"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "AgentID": agentId,
        "AgentName": agentName,
        "SystemIP": systemIp,
        "PublicIP": publicIp,
        "Status": status,
      };
}
