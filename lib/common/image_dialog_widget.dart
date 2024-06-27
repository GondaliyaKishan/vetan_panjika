import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetan_panjika/utils/widget.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  const ImageDialog({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      insetAnimationDuration: const Duration(seconds: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.h)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.h),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getCustomFont('Theresa Webb', 18.sp, Colors.black, 1,
                    fontWeight: FontWeight.w600),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: getAssetImage("close.png", 24.h, 24.h))
              ],
            ),
            getVerticalSpace(15.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.h),
              child: imageUrl.contains(".")
                  ? FadeInImage.assetNetwork(
                      image: imageUrl,
                      placeholder: "assets/CS_userimg.png",
                      fit: BoxFit.cover,
                      height: 308.h,
                    )
                  : Image.memory(
                      base64.decode(imageUrl),
                      height: 308.h,
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
