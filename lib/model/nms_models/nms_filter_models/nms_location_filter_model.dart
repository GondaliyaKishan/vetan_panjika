class NMSLocationFilterResponseDataModel {
  NMSLocationFilterResponseDataModel({
    required this.data,
  });

  List<NMSLocationFilterDataModel> data;

  factory NMSLocationFilterResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationFilterResponseDataModel(
        data: List<NMSLocationFilterDataModel>.from(json["LocationFilterData"]
            .map((x) => NMSLocationFilterDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "LocationFilterData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSLocationFilterDataModel {
  NMSLocationFilterDataModel(
      {required this.transNo,
        required this.locationName,
      });
  String transNo;
  String locationName;

  factory NMSLocationFilterDataModel.fromJson(Map<String, dynamic> json) =>
      NMSLocationFilterDataModel(
        transNo: json["TransNo"].toString(),
        locationName: json["LocationName"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "TransNo": transNo,
    "LocationName": locationName,
  };
}
