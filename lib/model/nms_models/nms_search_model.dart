class NMSSearchResponseDataModel {
  NMSSearchResponseDataModel({
    required this.data,
  });

  List<NMSSearchDataModel> data;

  factory NMSSearchResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NMSSearchResponseDataModel(
        data: List<NMSSearchDataModel>.from(
            json["SearchData"].map((x) => NMSSearchDataModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "SearchData": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NMSSearchDataModel {
  NMSSearchDataModel({
    required this.transNo,
    required this.locationId,
    required this.locationName,
    required this.rackId,
    required this.rackPortion,
    required this.friendlyName,
    required this.macAddress,
    required this.isPing,
    required this.isNotification,
    required this.ipAddress,
    required this.description,
    required this.isActive,
    required this.subnetMaskId,
    required this.subnetMask,
    required this.typeName,
    required this.imageUrl,
    required this.deviceLogin,
    required this.devicePassword,
    required this.agentName,
    required this.agentId,
  });
  String transNo;
  String locationId;
  String locationName;
  String rackId;
  String rackPortion;
  String friendlyName;
  String macAddress;
  String isPing;
  String isNotification;
  String ipAddress;
  String description;
  String isActive;
  String subnetMaskId;
  String subnetMask;
  String typeName;
  String imageUrl;
  String deviceLogin;
  String devicePassword;
  String agentName;
  String agentId;

  factory NMSSearchDataModel.fromJson(Map<String, dynamic> json) =>
      NMSSearchDataModel(
        transNo: json["TransNo"].toString(),
        locationId: json["LocationID"].toString(),
        locationName: json["LocationName"].toString(),
        rackId: json["RackID"].toString(),
        rackPortion: json["RackPortion"].toString(),
        friendlyName: json["FriendlyName"].toString(),
        macAddress: json["Macaddress"].toString(),
        isPing: json["IsPing"].toString(),
        isNotification: json["IsNotification"].toString(),
        ipAddress: json["IP_Address"].toString(),
        description: json["Description"].toString(),
        isActive: json["isActive"].toString(),
        subnetMaskId: json["SubnetMaskID"].toString(),
        subnetMask: json["SubnetMasks"].toString(),
        typeName: json["TypeName"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        deviceLogin: json["DeviceLogin"].toString(),
        devicePassword: json["DevicePassword"].toString(),
        agentName: json["AgentName"].toString(),
        agentId: json["AgentID"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "TransNo": transNo,
        "LocationID": locationId,
        "LocationName": locationName,
        "RackID": rackId,
        "RackPortion": rackPortion,
        "FriendlyName": friendlyName,
        "Macaddress": macAddress,
        "IsPing": isPing,
        "IsNotification": isNotification,
        "IP_Address": ipAddress,
        "Description": description,
        "isActive": isActive,
        "SubnetMaskID": subnetMaskId,
        "SubnetMasks": subnetMask,
        "TypeName": typeName,
        "ImageUrl": imageUrl,
        "DeviceLogin": deviceLogin,
        "DevicePassword": devicePassword,
        "AgentName": agentName,
        "AgentID": agentId,
      };
}
