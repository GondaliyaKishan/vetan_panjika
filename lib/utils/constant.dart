import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Constant{
  static const String fontFamily = "Poppins";
  static const String assetPath = "assets/";

  static void setScreenUtil(BuildContext context) {
    return ScreenUtil.init(context, designSize: const Size(428, 896));
  }
}