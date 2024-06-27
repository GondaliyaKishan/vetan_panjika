import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetan_panjika/common/common_func.dart';
import '../../../../controllers/api_controller.dart';
import '../../../../main.dart';
import '../../../../model/admin_models/access_control_models/door_lock_model.dart';

class ACDeviceLocks extends StatefulWidget {
  final String deviceName;
  const ACDeviceLocks({Key? key, required this.deviceName}) : super(key: key);

  @override
  State<ACDeviceLocks> createState() => _ACDeviceLocksState();
}

class _ACDeviceLocksState extends State<ACDeviceLocks> {
  bool showLoader = true;
  String noDataMsg = "";
  List<AdminDoorLocksModel> lockList = [];

  @override
  initState() {
    super.initState();
    getLocks();
  }

  getLocks() {
    var apiController = ApiController();
    apiController.getAdminDoorLocks().then((value) {
      if (value != null) {
        lockList = [];
        for (var device in value.data) {
          lockList.add(device);
        }
      }
      if (lockList.isEmpty) {
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
        title: Text(widget.deviceName, style: theme.text20),
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
              getLocks();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
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
                      itemCount: lockList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          leading: Text("${i + 1}.", style: theme.text16),
                          minLeadingWidth: 0,
                          title: Text(lockList[i].lockName,
                              style: theme.text16boldPrimary!
                                  .copyWith(color: Colors.cyan)),
                          subtitle: Text("Device: " + lockList[i].deviceName,
                              style: theme.text14grey),
                          trailing: GestureDetector(
                            onTap: () {
                              final apiController = ApiController();
                              String functionName =
                              lockList[i].openClose == "1"
                                  ? "close"
                                  : "open";
                              apiController
                                  .adminDoorOpenClose(
                                  lockId: lockList[i].lockId,
                                  deviceId: lockList[i].deviceId,
                                  functionName: functionName)
                                  .then((value) {
                                if (value == "Success") {
                                  lockList[i].openClose = functionName == "open" ? "1" : "0";
                                  setState(() { });
                                } else {
                                  CommonFunctions()
                                      .toastMessage(value);
                                }
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                lockList[i].openClose == "1"
                                    ? const FadeInImage(
                                      image:
                                          AssetImage("assets/Open_Door.png"),
                                      width: 35,
                                      height: 40,
                                      placeholder: AssetImage(
                                          "assets/Closed_Door.png"),
                                      fit: BoxFit.contain,
                                    )
                                    : const FadeInImage(
                                      image: AssetImage(
                                          "assets/Closed_Door.png"),
                                      width: 42,
                                      height: 47,
                                      placeholder: AssetImage(
                                          "assets/Closed_Door.png"),
                                      fit: BoxFit.contain,
                                    ),
                              ],
                            ),
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
