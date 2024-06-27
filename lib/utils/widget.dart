import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant.dart';

Widget getCustomFont(String text, double fontSize, Color textColor, int maxLine,
    {FontWeight? fontWeight,
    TextDecoration? textDecoration,
    TextAlign textAlign = TextAlign.start,
    String? fontFamily,
    TextOverflow textOverflow = TextOverflow.clip}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? Constant.fontFamily,
        decoration: textDecoration),
    maxLines: maxLine,
    textAlign: textAlign,
    overflow: textOverflow,
  );
}

Widget getMultiLineFont(String text, double fontSize, Color textColor,
    {FontWeight? fontWeight,
      TextDecoration? textDecoration,
      TextAlign textAlign = TextAlign.start,
      String? fontFamily,
      TextOverflow textOverflow = TextOverflow.clip}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? Constant.fontFamily,
        decoration: textDecoration),
    textAlign: textAlign,
    overflow: textOverflow,
  );
}

Widget getAssetImage(String image, double height, double width,
    {BoxFit? fit = BoxFit.fill}) {
  return Image.asset(
    Constant.assetPath + image,
    height: height,
    width: width,
    fit: fit,
  );
}

Widget getHorizontalSpace(double width) {
  return SizedBox(width: width,);
}

Widget getVerticalSpace(double height) {
  return SizedBox(height: height,);
}


Widget emptyDataWidget(){
  return Padding(
    padding: EdgeInsets.only(top: 30.h,bottom: 50.h),
    child: Column(
      children: [
        getAssetImage("no_data.png", 100.h, 110.h),
        getVerticalSpace(20.h),
        Align(
          alignment: Alignment.topCenter,
          child: getCustomFont(
              "No Record Found", 20.sp, Colors.black, 1,
              fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
