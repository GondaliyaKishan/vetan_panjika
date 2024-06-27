import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';
import 'attendance_new_screen.dart';

class NewSalesDeskScreen extends StatefulWidget {
  const NewSalesDeskScreen({super.key});

  @override
  State<NewSalesDeskScreen> createState() => _NewSalesDeskScreenState();
}

class _NewSalesDeskScreenState extends State<NewSalesDeskScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness:
          Brightness.dark, // For iOS (dark icons) // status bar color
    ));
    Constant.setScreenUtil(context);
    return Scaffold(
      backgroundColor: Color(0xFFF6FBFF),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15.h,
                      offset: Offset(0, 0))
                ],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32.h))),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 66.h, bottom: 29.h, left: 20.h, right: 20.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    getAssetImage("back_black.png", 22.h, 22.h),
                    getHorizontalSpace(10.h),
                    getCustomFont("Sales Desk", 20.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600)
                  ],
                ),
              ),
            ),
          ),
          getVerticalSpace(20.h),
          Expanded(
            child: GridView(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              primary: true,
              shrinkWrap: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 90.h,
                  crossAxisSpacing: 16.h,
                  mainAxisSpacing: 16.h),
              children: [
                dashBoardWidget("Overview", Color(0xFFE31F25).withOpacity(0.05),
                    "product-overview 1 (1).png"),
                dashBoardWidget(
                    "Leads", Color(0xFF009847).withOpacity(0.05), "lead 1.png"),
                dashBoardWidget("Qoutations",
                    Color(0xFF00A0E4).withOpacity(0.05), "file-setting 1.png"),
                dashBoardWidget("Delivery Challanges",
                    Color(0xFF1E9B1B).withOpacity(0.05), "challenges 1.png"),
                dashBoardWidget("Perform Invoice",
                    Color(0xFFE9532A).withOpacity(0.05), "invoice 1.png"),
                dashBoardWidget("Purchase Order",
                    Color(0xFF395A7F).withOpacity(0.05), "order 1.png")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dashBoardWidget(String name, Color color, String image) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: Offset(0, 0),
                blurRadius: 15.h)
          ],
          borderRadius: BorderRadius.circular(10.h)),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10.h)),
            child: getAssetImage(image, 22.h, 22.h),
          ),
          getVerticalSpace(5.h),
          getCustomFont(name, 14.sp, AppColors.textBlackColor, 1,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
