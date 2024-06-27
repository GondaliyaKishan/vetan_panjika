class DailyUpdateHeadResponseDataModel {
  DailyUpdateHeadResponseDataModel({
    required this.data,
  });

  List<DailyUpdateHeadDataModel> data;

  factory DailyUpdateHeadResponseDataModel.fromJson(Map<String, dynamic> json) =>
      DailyUpdateHeadResponseDataModel(
        data: List<DailyUpdateHeadDataModel>.from(json["DailyUpdateHead"]
            .map((x) => DailyUpdateHeadDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DailyUpdateHead": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DailyUpdateHeadDataModel {
  DailyUpdateHeadDataModel(
      {required this.id,
        required this.headName,
      });
  String id;
  String headName;

  factory DailyUpdateHeadDataModel.fromJson(Map<String, dynamic> json) =>
      DailyUpdateHeadDataModel(
        id: json["ID"].toString(),
        headName: json["ProjectName"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "ProjectName": headName,
  };
}
