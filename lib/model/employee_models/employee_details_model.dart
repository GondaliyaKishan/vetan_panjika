import 'package:vetan_panjika/main.dart';

class EmployeeDetailsResponseModel {
  EmployeeDetailsResponseModel({
    required this.data,
  });

  List<EmployeeDetailsModel> data;

  factory EmployeeDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDetailsResponseModel(
        data: List<EmployeeDetailsModel>.from(json["MobileEmployeeDetails"]
            .map((x) => EmployeeDetailsModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "MobileEmployeeDetails":
            List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmployeeDetailsModel {
  EmployeeDetailsModel(
      {required this.id,
      required this.empCode,
      required this.empType,
      required this.name,
      required this.fatherName,
      required this.email,
      required this.dob,
      required this.profileImg,
      required this.gender,
      required this.doj,
      required this.branch,
      required this.department,
      required this.shift,
      required this.designation,
      required this.mobileNo,
      required this.emergencyContact,
      required this.maritalStatus,
      required this.nomineeName,
      required this.nomineeRelation,
      required this.bankName,
      required this.accountNo,
      required this.ifscCode,
      required this.branchName,
      required this.corrAddress1,
      required this.corrAddress2,
      required this.corrAddress3,
      required this.corrCity,
      required this.corrState,
      required this.corrPinCode,
      required this.perAddress1,
      required this.perAddress2,
      required this.perAddress3,
      required this.perCity,
      required this.perState,
      required this.perPinCode,
      required this.policy,
      required this.contractorCompany,
      required this.reportingTo,
      required this.educationQualification,
      });
  String id;
  String empCode;
  String empType;
  String name;
  String fatherName;
  String email;
  String dob;
  String profileImg;
  String gender;
  String doj;
  String branch;
  String department;
  String shift;
  String designation;
  String mobileNo;
  String emergencyContact;
  String maritalStatus;
  String nomineeName;
  String nomineeRelation;
  String bankName;
  String accountNo;
  String ifscCode;
  String branchName;
  String corrAddress1;
  String corrAddress2;
  String corrAddress3;
  String corrCity;
  String corrState;
  String corrPinCode;
  String perAddress1;
  String perAddress2;
  String perAddress3;
  String perCity;
  String perState;
  String perPinCode;
  String policy;
  String contractorCompany;
  String reportingTo;
  String educationQualification;

  factory EmployeeDetailsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDetailsModel(
          id: json["ID"],
          empCode: json["EmpCode"],
          empType: json["EmpType"].toString(),
          name: json["EmployeeName"].toString(),
          fatherName: json["FatherName"].toString(),
          email: json["Email"].toString(),
          dob: json["DOB"].toString(),
          profileImg: (json["ProfilePicture"] ?? "") != ""
              ? (json["baseUrl"] + urlController.imgUrl + json["ProfilePicture"]).toString()
              : "",
          gender: json["Gender"],
          doj: json["DOJ"],
          branch: json["EmployeeBranch"],
          department: json["DepartmentName"],
          shift: json["GroupName"],
          designation: json["DesignationName"],
          mobileNo: json["MobileNo"],
          emergencyContact: json["EmergencyContactNo"],
          maritalStatus: json["IsMarried"],
          nomineeName: json["NomineeName"],
          nomineeRelation: json["NomineeRelation"],
          bankName: json["BankName"],
          accountNo: json["Accno"],
          ifscCode: json["IFSC"],
          branchName: json["BranchName"],
          corrAddress1: json["CorrAddress1"],
          corrAddress2: json["CorrAddress2"],
          corrAddress3: json["CorrAddress3"],
          corrCity: json["CorrCity"],
          corrState: json["CorrState"] ?? "",
          corrPinCode: json["CorrPincode"],
          perAddress1: json["PermntAddress1"],
          perAddress2: json["PermntAddress2"],
          perAddress3: json["PermntAddress3"],
          perCity: json["PermntCity"],
          perState: json["PermntState"] ?? "",
          perPinCode: json["PermntPincode"],
          policy: json["PolicyName"] ?? "",
          contractorCompany: json["ContractorCompanyName"] ?? "",
          reportingTo: json["ReportingTo"] ?? "",
          educationQualification: json["EducationQualification"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "EmpCode": empCode,
        "EmpTypeID": empType,
        "EmployeeName": name,
        "Email": email,
        "DOB": dob,
        "ProfilePicture": profileImg,
        "GenderID": gender,
        "DOJ": doj,
        "EmployeeBranch": branch,
        "DName": department,
        "GroupName": shift,
        "DesignationName": designation,
        "MobileNo": mobileNo,
        "EmergencyContactNo": emergencyContact,
        "IsMarried": maritalStatus,
        "NomineeName": nomineeName,
        "NomineeRelation": nomineeRelation,
        "bankname": bankName,
        "Accno": accountNo,
        "IFSC": ifscCode,
        "BranchName": branchName,
        "CorrAddress1": corrAddress1,
        "CorrAddress2": corrAddress2,
        "CorrAddress3": corrAddress3,
        "CorrCity": corrCity,
        "CorrState": corrState,
        "CorrPincode": corrPinCode,
        "PermntAddress1": perAddress1,
        "PermntAddress2": perAddress2,
        "PermntAddress3": perAddress3,
        "PermntCity": perCity,
        "PermntState": perState,
        "PermntPincode": perPinCode,
      };
}
