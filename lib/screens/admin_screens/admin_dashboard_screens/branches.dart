import 'package:flutter/material.dart';
import 'package:vetan_panjika/controllers/api_controller.dart';
import 'package:vetan_panjika/model/admin_models/branches_model.dart';
import '../../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Branches extends StatefulWidget {
  const Branches({Key? key}) : super(key: key);

  @override
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  List<AdminBranchesModel> branchesList = [];
  bool showLoader = true;
  String noDataMsg = "";

  getBranches() {
    var apiController = ApiController();
    apiController.getAdminBranches().then((value) {
      if (value != null) {
        branchesList = [];
        for (var branch in value.data) {
          branchesList.add(branch);
        }
      }
      if (branchesList.isEmpty) {
        noDataMsg = "No Branches to show";
      }
      showLoader = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getBranches();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Branches", style: theme.text20),
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
              getBranches();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: branchesList.isEmpty
                        ? Center(
                            child: Text(noDataMsg, style: theme.text18bold))
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: branchesList.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("${i + 1}.", style: theme.text16),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(branchesList[i].branchName,
                                                style: theme.text16boldPrimary!
                                                    .copyWith(
                                                        color: Colors.cyan)),
                                            const SizedBox(height: 5),
                                            Text(
                                                "Employees: " +
                                                    branchesList[i]
                                                        .totalEmployee,
                                                style: theme.text14grey),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "Devices: " +
                                            branchesList[i].totalDevices,
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
