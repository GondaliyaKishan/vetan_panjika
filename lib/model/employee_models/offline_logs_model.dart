class OfflineLogsResponseDataModel {
  OfflineLogsResponseDataModel({
    required this.data,
  });

  List<OfflineLogsDataModel> data;

  factory OfflineLogsResponseDataModel.fromJson(Map<String, dynamic> json) =>
      OfflineLogsResponseDataModel(
        data: List<OfflineLogsDataModel>.from(json["OfflineLogsData"]
            .map((x) => OfflineLogsDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "OfflineLogsData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OfflineLogsDataModel {
  OfflineLogsDataModel(
      {required this.id,
        required this.logImg,
        required this.dateTime,
        required this.longitude,
        required this.latitude,
      });
  String id;
  String logImg;
  String dateTime;
  String longitude;
  String latitude;

  factory OfflineLogsDataModel.fromJson(Map<String, dynamic> json) =>
      OfflineLogsDataModel(
        id: json["id"].toString(),
        logImg: json["img_string"].toString(),
        dateTime: json["date_time"].toString(),
        longitude: json["longitude"].toString(),
        latitude: json["latitude"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img_string": logImg,
    "date_time": dateTime,
    "longitude": longitude,
    "latitude": latitude,
  };
}
