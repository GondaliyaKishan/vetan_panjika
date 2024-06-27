import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/color_data.dart';
import '../../utils/constant.dart';
import '../../utils/widget.dart';

class NewSupportDeskScreen extends StatefulWidget {
  const NewSupportDeskScreen({super.key});

  @override
  State<NewSupportDeskScreen> createState() => _NewSupportDeskScreenState();
}

class _NewSupportDeskScreenState extends State<NewSupportDeskScreen> {
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
                    getCustomFont("Support Desk", 20.sp, Colors.black, 1,
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
                dashBoardWidget(
                    "Create Ticket",
                    Color(0xFFE31F25).withOpacity(0.05),
                    "support-ticket (1) 1.png"),
                dashBoardWidget("Reports", Color(0xFF009847).withOpacity(0.05),
                    "reports 1.png"),
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
