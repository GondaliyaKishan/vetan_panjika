import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetan_panjika/utils/color_data.dart';
import 'package:vetan_panjika/utils/widget.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int type = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.h),
      ),
      // insetPadding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.h),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  type = 0;
                });
              },
              child: Row(
                children: [
                  getAssetImage(
                      type == 0 ? "check.png" : "uncheck_box.png", 20.h, 20.h),
                  getHorizontalSpace(10.h),
                  getCustomFont("Sick leave", 14.sp, AppColors.blackColor, 1,
                      fontWeight: FontWeight.w400)
                ],
              ),
            ),
            getVerticalSpace(16.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  type = 1;
                });
              },
              child: Row(
                children: [
                  getAssetImage(
                      type == 1 ? "check.png" : "uncheck_box.png", 20.h, 20.h),
                  getHorizontalSpace(10.h),
                  getCustomFont("Planned Leave", 14.sp, AppColors.blackColor, 1,
                      fontWeight: FontWeight.w400)
                ],
              ),
            ),
            getVerticalSpace(16.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  type = 2;
                });
              },
              child: Row(
                children: [
                  getAssetImage(
                      type == 2 ? "check.png" : "uncheck_box.png", 20.h, 20.h),
                  getHorizontalSpace(10.h),
                  getCustomFont("Holiday", 14.sp, AppColors.blackColor, 1,
                      fontWeight: FontWeight.w400)
                ],
              ),
            ),
            getVerticalSpace(24.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.h),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF3197FF).withOpacity(0.5),
                                offset: Offset(0, 0),
                                blurRadius: 10)
                          ]),
                      child: getCustomFont("Apply", 16.sp, Colors.white, 1,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                getHorizontalSpace(16.h),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.h),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1)),
                      height: 40.h,
                      alignment: Alignment.center,
                      child: getCustomFont("Reset", 16.sp, Colors.black, 1,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
