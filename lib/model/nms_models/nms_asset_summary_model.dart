class NMSAssetSummaryResponseDataModel {
  NMSAssetSummaryResponseDataModel({
    required this.data,
  });

  List<NMSAssetSummaryDataModel> data;

  factory NMSAssetSummaryResponseDataModel.fromJson(
          Map<dynamic, dynamic> json) =>
      NMSAssetSummaryResponseDataModel(
        data: List<NMSAssetSummaryDataModel>.from(json["SummaryData"]
            .map((x) => NMSAssetSummaryDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "SummaryData": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NMSAssetSummaryDataModel {
  NMSAssetSummaryDataModel({
    required this.typeNames,
    required this.typeColors,
    required this.countValues,
    required this.totalCount,
  });
  List<dynamic> typeNames;
  List<dynamic> typeColors;
  List<dynamic> countValues;
  String totalCount;

  factory NMSAssetSummaryDataModel.fromJson(Map<String, dynamic> json) =>
      NMSAssetSummaryDataModel(
        typeNames: json["TypeNames"],
        typeColors: json["TypeColors"],
        countValues: json["CountValues"],
        totalCount: json["TotalCount"],
      );

  Map<String, dynamic> toJson() => {
        "TypeNames": typeNames,
        "TypeColors": typeColors,
        "CountValues": countValues,
        "TotalCount": totalCount,
      };
}
