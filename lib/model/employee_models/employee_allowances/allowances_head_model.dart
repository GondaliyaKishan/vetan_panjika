class AllowancesHeadResponseDataModel {
  AllowancesHeadResponseDataModel({
    required this.data,
  });

  List<AllowancesHeadDataModel> data;

  factory AllowancesHeadResponseDataModel.fromJson(Map<String, dynamic> json) =>
      AllowancesHeadResponseDataModel(
        data: List<AllowancesHeadDataModel>.from(json["AllowancesHead"]
            .map((x) => AllowancesHeadDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "AllowancesHead": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllowancesHeadDataModel {
  AllowancesHeadDataModel(
      {required this.id,
        required this.headName,
      });
  String id;
  String headName;

  factory AllowancesHeadDataModel.fromJson(Map<String, dynamic> json) =>
      AllowancesHeadDataModel(
        id: json["ID"].toString(),
        headName: json["HeadName"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "HeadName": headName,
  };
}
