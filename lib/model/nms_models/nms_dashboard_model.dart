class NMSDashboardResponseDataModel {
  NMSDashboardResponseDataModel({
    required this.data,
  });

  List<NMSDashboardDataModel> data;

  factory NMSDashboardResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDashboardResponseDataModel(
        data: List<NMSDashboardDataModel>.from(json["DashboardData"]
            .map((x) => NMSDashboardDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DashboardData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSDashboardDataModel {
  NMSDashboardDataModel(
      {required this.upPercentage,
        required this.criticalPercentage,
        required this.offlinePercentage,
        required this.notManagedPercentage,
      });
  String upPercentage;
  String criticalPercentage;
  String offlinePercentage;
  String notManagedPercentage;

  factory NMSDashboardDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDashboardDataModel(
        upPercentage: json["OnlinePercentage"].toString(),
        criticalPercentage: json["HighLatencyPercentage"].toString(),
        offlinePercentage: json["OfflinePercentage"].toString(),
        notManagedPercentage: json["NotMonitoredPercentage"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "OnlinePercentage": upPercentage,
    "HighLatencyPercentage": criticalPercentage,
    "OfflinePercentage": offlinePercentage,
    "NotMonitoredPercentage": notManagedPercentage,
  };
}
