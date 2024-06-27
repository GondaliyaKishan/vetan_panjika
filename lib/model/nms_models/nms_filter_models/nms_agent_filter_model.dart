class NMSAgentFilterResponseDataModel {
  NMSAgentFilterResponseDataModel({
    required this.data,
  });

  List<NMSAgentFilterDataModel> data;

  factory NMSAgentFilterResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentFilterResponseDataModel(
        data: List<NMSAgentFilterDataModel>.from(json["AgentFilterData"]
            .map((x) => NMSAgentFilterDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "AgentFilterData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSAgentFilterDataModel {
  NMSAgentFilterDataModel(
      {required this.transNo,
        required this.agentName,
      });
  String transNo;
  String agentName;

  factory NMSAgentFilterDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAgentFilterDataModel(
        transNo: json["TransNo"].toString(),
        agentName: json["AgentName"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "TransNo": transNo,
    "AgentName": agentName,
  };
}
