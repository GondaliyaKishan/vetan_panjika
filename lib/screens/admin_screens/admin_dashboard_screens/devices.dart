import 'package:flutter/material.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/admin_models/devices_model.dart';
import 'package:vetan_panjika/model/filters/branch_filter.dart';
import '../../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  List<AdminDevicesModel> devicesList = [];

  String? dropdownValue;
  List<BranchFilterModel> dropdownItems = [];
  String noDataMsg = "";
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    getBranchFilter();
    getDevices("", "1");
  }

  getBranchFilter() {
    var apiController = ApiController();
    apiController.getBranchFilter().then((value) {
      if (value!.data.isNotEmpty) {
        dropdownItems = value.data;
      }
    });
  }

  getDevices(branchID, catId) {
    var apiController = ApiController();
    apiController
        .getAdminDevices(branchID, catId)
        .then((value) {
      if (value != null) {
        devicesList = [];
        for (var device in value.data) {
          devicesList.add(device);
        }
      }
      if (devicesList.isEmpty) {
        noDataMsg = "No Device to show";
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
        title: Text("Devices", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.cyan,
            onRefresh: () async {
              setState(() {
                showLoader = true;
              });
              Future.delayed(const Duration(seconds: 2));
              var branchID = dropdownValue == null ? "" : dropdownValue == "0" ? "" : dropdownValue;
              getDevices(branchID, "1");
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: "Select Branch",
                            border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 15, maxWidth: 10, minHeight: 15, minWidth: 10
                          ),
                        ),
                        isExpanded: true,
                        // Initial Value
                        value: dropdownValue,
                        // Down Arrow Icon
                        icon: Container(),
                        // Array list of items
                        items: dropdownItems.map((item) {
                          return DropdownMenuItem(
                            value: item.id,
                            child: Text(item.branchName,
                                style: item.branchName == "Select Branch" ? theme.text14grey : theme.text14,
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                          if (newValue != "0") {
                            getDevices(newValue, "1");
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: devicesList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          leading: Text("${i + 1}.", style: theme.text16),
                          minLeadingWidth: 0,
                          title: Text(devicesList[i].name,
                              style: theme.text16boldPrimary!
                                  .copyWith(color: Colors.cyan)),
                          subtitle: Text("Branch: " + devicesList[i].branchName,
                              style: theme.text14grey),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Status: ", style: theme.text16bold),
                                  TextSpan(
                                      text: devicesList[i].status,
                                      style: theme.text16bold!.copyWith(
                                          color:
                                          devicesList[i].status == "Online"
                                              ? Colors.green
                                              : Colors.red)),
                                ],
                              )),
                              const SizedBox(height: 5),
                              Text("IP: " + devicesList[i].ipAddress,
                                  style: theme.text14grey),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
