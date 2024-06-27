class AdminDashboardDeviceChartResponseModel {
  AdminDashboardDeviceChartResponseModel({
    required this.data,
  });

  List<AdminDashboardDeviceChartModel> data;

  factory AdminDashboardDeviceChartResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardDeviceChartResponseModel(
        data: List<AdminDashboardDeviceChartModel>.from(json["Data"]
            .map((x) => AdminDashboardDeviceChartModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminDashboardDeviceChartModel {
  AdminDashboardDeviceChartModel(
      {
        required this.deviceTotal,
        required this.onlinePercent,
        required this.onlineCount,
        required this.offlinePercent,
        required this.offlineCount,
        required this.highLatencyPercent,
        required this.highLatencyCount,
        required this.notMonitoredPercent,
        required this.notMonitoredCount,
      });
  String deviceTotal;
  String onlinePercent;
  String onlineCount;
  String offlinePercent;
  String offlineCount;
  String highLatencyPercent;
  String highLatencyCount;
  String notMonitoredPercent;
  String notMonitoredCount;

  factory AdminDashboardDeviceChartModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardDeviceChartModel(
        deviceTotal: (double.parse(json["OnlineCount"].toString()) +
            double.parse(json["OfflineCount"].toString()) +
            double.parse(json["HighLatencyCount"].toString()) +
            double.parse(json["NotMonitoredCount"].toString())).toString(),
        onlinePercent: json["OnlinePercentage"].toString(),
        onlineCount: json["OnlineCount"].toString(),
        offlinePercent: json["OfflinePercentage"].toString(),
        offlineCount: json["OfflineCount"].toString(),
        highLatencyPercent: json["HighLatencyPercentage"].toString(),
        highLatencyCount: json["HighLatencyCount"].toString(),
        notMonitoredPercent: json["NotMonitoredPercentage"].toString(),
        notMonitoredCount: json["NotMonitoredCount"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "TotalDevices": deviceTotal,
    "OnlinePercentage": onlinePercent,
    "OnlineCount": onlineCount,
    "OfflinePercentage": offlinePercent,
    "OfflineCount": offlineCount,
    "HighLatencyPercentage": highLatencyPercent,
    "HighLatencyCount": highLatencyCount,
    "NotMonitoredPercentage": notMonitoredPercent,
    "NotMonitoredCount": notMonitoredCount,
  };
}
