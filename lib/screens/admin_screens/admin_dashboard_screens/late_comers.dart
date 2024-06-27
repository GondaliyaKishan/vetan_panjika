import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../main.dart';

class LateComers extends StatefulWidget {
  const LateComers({Key? key}) : super(key: key);

  @override
  _LateComersState createState() => _LateComersState();
}

class _LateComersState extends State<LateComers> {
  bool showLoader = true;

  getHolidays() async {
    await Future.delayed(const Duration(milliseconds: 500));
    showLoader = false;
    setState(() { });
  }

  @override
  void initState() {
    super.initState();
    getHolidays();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Late Comers", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const FadeInImage(
                    image: AssetImage("assets/coming_soon.png"),
                    placeholder:
                    AssetImage("assets/coming_soon.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
          Visibility(
              visible: showLoader,
              child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.white70,
                  child:
                  const SpinKitFadingCircle(color: Colors.cyan, size: 70))),
        ],
      ),
    );
  }
}
