import 'package:flutter/material.dart';

class IBox extends StatelessWidget {
  @required
  final Function() press;
  final Widget child;
  final Color color;
  final double radius;
  final double blur;
  const IBox({
    Key? key,
    this.color = Colors.white,
    required this.press,
    required this.child,
    this.radius = 6,
    this.blur = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _child = Container();
    _child = child;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
            color: color,
            child: _child),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(40),
            spreadRadius: radius,
            blurRadius: blur,
            offset: const Offset(2, 2), // changes position of shadow
          ),
        ],
      ),
    );
  }
}