import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/employee_models/employee_details_model.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfileScreen extends StatefulWidget {
  final EmployeeDetailsModel data;

  MyProfileScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness:
          Brightness.light, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 74.h, bottom: 28.h, left: 20.h, right: 20.h),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32.h))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      getAssetImage("back.png", 14.h, 10.h),
                      getHorizontalSpace(9.h),
                      getCustomFont("My Profile", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                getAssetImage("white_edit.png", 20.h, 20.h)
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              children: [
                getVerticalSpace(19.h),
                getCustomFont(
                    "Personal Details", 20.sp, AppColors.blackColor, 1,
                    fontWeight: FontWeight.w600),
                getVerticalSpace(16.h),
                detailWidget("Employee Code", widget.data.empCode),
                getVerticalSpace(16.h),
                detailWidget("Father Name", widget.data.fatherName),
                getVerticalSpace(16.h),
                detailWidget("Department", widget.data.department),
                getVerticalSpace(16.h),
                detailWidget("Branch", widget.data.branch),
                getVerticalSpace(16.h),
                detailWidget("Dob", widget.data.dob),
                getVerticalSpace(16.h),
                detailWidget("Gender", widget.data.gender),
                getVerticalSpace(16.h),
                detailWidget("Married", widget.data.maritalStatus),
                getVerticalSpace(29.h),
                getCustomFont(
                    "Employer Details", 20.sp, AppColors.blackColor, 1,
                    fontWeight: FontWeight.w600),
                getVerticalSpace(16.h),
                detailWidget("Shift", widget.data.shift),
                getVerticalSpace(16.h),
                detailWidget("Employee Type", widget.data.empType),
                getVerticalSpace(16.h),
                detailWidget("Date of joining", widget.data.doj),
                getVerticalSpace(16.h),
                detailWidget(
                    "Emergency Contact",
                    widget.data.emergencyContact.isEmpty
                        ? "-"
                        : widget.data.emergencyContact),
                getVerticalSpace(16.h),
                detailWidget("Policy Name", widget.data.policy),
                getVerticalSpace(16.h),
                detailWidget(
                    "Contractor Company",
                    widget.data.contractorCompany.isEmpty
                        ? "-"
                        : widget.data.contractorCompany),
                getVerticalSpace(16.h),
                detailWidget("Reporting To", widget.data.reportingTo),
                getVerticalSpace(16.h),
                detailWidget(
                    "Education Qualification",
                    widget.data.educationQualification.isEmpty
                        ? "-"
                        : widget.data.educationQualification),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget detailWidget(String text, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont(text, 12.sp, Color(0xFF989898), 1,
            fontWeight: FontWeight.w400),
        getVerticalSpace(3.h),
        getCustomFont(value, 14.sp, AppColors.blackColor, 1,
            fontWeight: FontWeight.w500),
        getVerticalSpace(2.h),
        Divider(
          height: 0,
          color: AppColors.containerBorderColor,
          thickness: 1,
        )
      ],
    );
  }
}
