import 'package:flutter/material.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import 'package:vetan_panjika/utils/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalanceBottomsheet extends StatefulWidget {
  const LeaveBalanceBottomsheet({Key? key}) : super(key: key);

  @override
  State<LeaveBalanceBottomsheet> createState() =>
      _LeaveBalanceBottomsheetState();
}

class _LeaveBalanceBottomsheetState extends State<LeaveBalanceBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          getVerticalSpace(13.h),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 5.h,
              width: 62.h,
              decoration: BoxDecoration(
                  color: Color(0xFFD6D6D6),
                  borderRadius: BorderRadius.circular(5.h)),
            ),
          ),
          getVerticalSpace(19.h),
          getCustomFont("Leave Balance", 20.sp, AppColors.blackColor, 1,
              fontWeight: FontWeight.w600),
          getVerticalSpace(12.h),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFEFF8FF),
              borderRadius: BorderRadius.circular(10.h),
            ),
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(
                        "Paid Leave (12)", 12.sp, Color(0xFF008AD0), 1,
                        fontWeight: FontWeight.w500),
                    getCustomFont("6 Days Left", 12.sp, Color(0xFF36BBFF), 1,
                        fontWeight: FontWeight.w500)
                  ],
                ),
                getVerticalSpace(6.h),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Color(0xFFC7ECFF),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.h),
                  color: Color(0xFF008AD0),
                )
              ],
            ),
          ),
          getVerticalSpace(16.h),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFF5DC),
              borderRadius: BorderRadius.circular(10.h),
            ),
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(
                        "Sick Leave (02)", 12.sp, Color(0xFFE7AD18), 1,
                        fontWeight: FontWeight.w500),
                    getCustomFont("1 Days Left", 12.sp, Color(0xFFE7AD18), 1,
                        fontWeight: FontWeight.w500)
                  ],
                ),
                getVerticalSpace(6.h),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Color(0xFFE7AD18).withOpacity(0.3),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.h),
                  color: Color(0xFFE7AD18),
                )
              ],
            ),
          ),
          getVerticalSpace(16.h),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFE3FFF0),
              borderRadius: BorderRadius.circular(10.h),
            ),
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(
                        "Holiday Leave (05)", 12.sp, Color(0xFF009847), 1,
                        fontWeight: FontWeight.w500),
                    getCustomFont("3 Days Left", 12.sp, Color(0xFF009847), 1,
                        fontWeight: FontWeight.w500)
                  ],
                ),
                getVerticalSpace(6.h),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Color(0xFF009847).withOpacity(0.3),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.h),
                  color: Color(0xFF009847),
                )
              ],
            ),
          ),
          getVerticalSpace(16.h),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFEFFD),
              borderRadius: BorderRadius.circular(10.h),
            ),
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(
                        "Festival Leave (15)", 12.sp, Color(0xFFE200C6), 1,
                        fontWeight: FontWeight.w500),
                    getCustomFont("10 Days Left", 12.sp, Color(0xFFE200C6), 1,
                        fontWeight: FontWeight.w500)
                  ],
                ),
                getVerticalSpace(6.h),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Color(0xFFE200C6).withOpacity(0.3),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.h),
                  color: Color(0xFFE200C6),
                )
              ],
            ),
          ),
          getVerticalSpace(16.h),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFE9E9),
              borderRadius: BorderRadius.circular(10.h),
            ),
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(
                        "Emergency  Leave (00)", 12.sp, Color(0xFFE10000), 1,
                        fontWeight: FontWeight.w500),
                    getCustomFont("00 Days Left", 12.sp, Color(0xFFE10000), 1,
                        fontWeight: FontWeight.w500)
                  ],
                ),
                getVerticalSpace(6.h),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Color(0xFFE10000).withOpacity(0.3),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.h),
                  color: Color(0xFFE10000),
                )
              ],
            ),
          ),
          getVerticalSpace(16.h),
        ],
      ),
    );
  }
}
