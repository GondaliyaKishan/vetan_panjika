import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/common/common_func.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/admin_models/holiday_model.dart';
import '../../../main.dart';

class Holiday extends StatefulWidget {
  const Holiday({Key? key}) : super(key: key);

  @override
  _HolidayState createState() => _HolidayState();
}

class _HolidayState extends State<Holiday> {
  String noDataMsg = "";
  bool showLoader = true;

  DateTime? dateNow;
  DateTime? dateMonthYear;
  List<AdminHolidayModel> holidayList = [];

  @override
  void initState() {
    super.initState();
    getHoliday();
  }

  getHoliday() {
    var dateTime = DateTime.now().toUtc();
    dateNow = dateTime;
    dateMonthYear = dateTime;
    var apiController = ApiController();
    apiController
        .getAdminHoliday("${dateMonthYear!.year}")
        .then((value) {
      if (value != null) {
        for (var branch in value.data) {
          holidayList.add(branch);
        }
      }
      if (holidayList.isEmpty) {
        noDataMsg = "No Holiday to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Holiday", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            children: [
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            dateMonthYear = dateMonthYear!.copyWithAdditional(years: -1);
                          });
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Text(dateMonthYear!.year.toString(), style: theme.text16),
                      IconButton(
                        onPressed: DateFormat.yMMMd().format(dateMonthYear!) == DateFormat.yMMMd().format(dateNow!) ? null : () {
                          setState(() {
                            dateMonthYear = dateMonthYear!.copyWithAdditional(years: 1);
                          });
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: holidayList.isEmpty
                    ? Center(
                    child: Text(noDataMsg,
                        style: theme.text18bold))
                    : ListView.separated(
                  shrinkWrap: true,
                  itemCount: holidayList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: FadeInImage(
                          image: AssetImage("assets/holiday.png"),
                          placeholder: AssetImage("assets/holiday.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(holidayList[i].name, style: theme.text16bold!.copyWith(color: Colors.cyan)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(holidayList[i].date,
                              style: theme.text14grey),
                          Text("Description: " + holidayList[i].description,
                              style: theme.text14!.copyWith(color: Colors.red[400])),
                        ],
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                    );
                  },
                  separatorBuilder: (BuildContext context, int i) =>
                      const Divider(height: 1, color: Colors.cyan),
                ),
              ),
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
