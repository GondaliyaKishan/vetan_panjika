class AdminHolidayResponseModel {
  AdminHolidayResponseModel({
    required this.data,
  });

  List<AdminHolidayModel> data;

  factory AdminHolidayResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminHolidayResponseModel(
        data: List<AdminHolidayModel>.from(
            json["MobileHolidays"].map((x) => AdminHolidayModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
    "MobileHolidays": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdminHolidayModel {
  AdminHolidayModel(
      {
        required this.name,
        required this.date,
        required this.description,
      });
  String name;
  String date;
  String description;

  factory AdminHolidayModel.fromJson(Map<String, dynamic> json) => AdminHolidayModel(
      name: json["HolidayName"].toString(),
      date: json["year"].toString().split("T")[0],
      description: json["Description"].toString()
  );

  Map<String, dynamic> toJson() => {
    "HolidayName": name,
    "year": date,
    "Description": description
  };
}
