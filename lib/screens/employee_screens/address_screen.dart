import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/employee_models/employee_details_model.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatefulWidget {
  final EmployeeDetailsModel data;

  AddressScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
                      getCustomFont("Address", 20.sp, Colors.white, 1,
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
                  "Correspondence Address", 20.sp, AppColors.blackColor, 1,
                  fontWeight: FontWeight.w600),
              getVerticalSpace(16.h),
              detailWidget("Address",
                  "${widget.data.corrAddress1}, ${widget.data.corrAddress2}, ${widget.data.corrAddress3}"),
              getVerticalSpace(16.h),
              detailWidget("City", widget.data.corrCity),
              getVerticalSpace(16.h),
              detailWidget("State", widget.data.corrState),
              getVerticalSpace(16.h),
              detailWidget("Pincode", widget.data.corrPinCode),
              getVerticalSpace(30.h),
              getCustomFont("Permanent Address", 20.sp, AppColors.blackColor, 1,
                  fontWeight: FontWeight.w600),
              getVerticalSpace(16.h),
              detailWidget("Address",
                  "${widget.data.perAddress1}, ${widget.data.perAddress2}, ${widget.data.perAddress3}"),
              getVerticalSpace(16.h),
              detailWidget("City", widget.data.perCity),
              getVerticalSpace(16.h),
              detailWidget("State", widget.data.perState),
              getVerticalSpace(16.h),
              detailWidget("Pincode", widget.data.perPinCode),
            ],
          ))
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
        getMultiLineFont(value, 14.sp, AppColors.blackColor,
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
