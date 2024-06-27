import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/employee_models/employee_details_model.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BankDetailScreen extends StatefulWidget {
  final EmployeeDetailsModel data;

  BankDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
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
                      getCustomFont("Bank Details", 20.sp, Colors.white, 1,
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
              getVerticalSpace(20.h),
              detailWidget("Bank", widget.data.bankName),
              getVerticalSpace(16.h),
              detailWidget("Account No", widget.data.accountNo),
              getVerticalSpace(16.h),
              detailWidget("IFSC Code", widget.data.ifscCode),
              getVerticalSpace(30.h),
              getCustomFont("Nominee Details", 20.sp, AppColors.blackColor, 1,
                  fontWeight: FontWeight.w600),
              getVerticalSpace(16.h),
              detailWidget("Name", widget.data.nomineeName),
              getVerticalSpace(16.h),
              detailWidget("Relation", widget.data.nomineeRelation),
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
