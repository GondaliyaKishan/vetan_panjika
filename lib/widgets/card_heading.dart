import 'package:flutter/material.dart';

class CardHeading {
  static Widget cardHeading(
      {required String text, required textStyle, required align}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: align,
            children: [
              Text(text, style: textStyle),
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey),
        ],
      ),
    );
  }
}
