import 'package:flutter/material.dart';

import '../../../../main.dart';

class NMSReports extends StatefulWidget {
  const NMSReports({Key? key}) : super(key: key);

  @override
  State<NMSReports> createState() => _NMSReportsState();
}

class _NMSReportsState extends State<NMSReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Reports", style: theme.text20),
        backgroundColor: Colors.white,
      ),
    );
  }
}
