class NMSDeviceTypeFilterResponseDataModel {
  NMSDeviceTypeFilterResponseDataModel({
    required this.data,
  });

  List<NMSDeviceTypeFilterDataModel> data;

  factory NMSDeviceTypeFilterResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceTypeFilterResponseDataModel(
        data: List<NMSDeviceTypeFilterDataModel>.from(json["DeviceTypeFilterData"]
            .map((x) => NMSDeviceTypeFilterDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "DeviceTypeFilterData": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NMSDeviceTypeFilterDataModel {
  NMSDeviceTypeFilterDataModel(
      {required this.transNo,
        required this.typeName,
      });
  String transNo;
  String typeName;

  factory NMSDeviceTypeFilterDataModel.fromJson(Map<String, dynamic> json) =>
      NMSDeviceTypeFilterDataModel(
        transNo: json["TransNo"].toString(),
        typeName: json["TypeName"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "TransNo": transNo,
    "TypeName": typeName,
  };
}
