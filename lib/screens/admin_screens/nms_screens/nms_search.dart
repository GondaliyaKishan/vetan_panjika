import 'dart:convert';

import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart' as flappy_search;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetan_panjika/model/nms_models/nms_search_model.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';
import 'nms_single_details_screens/nms_device_details_page.dart';

class NMSSearch extends StatefulWidget {
  const NMSSearch({Key? key}) : super(key: key);

  @override
  State<NMSSearch> createState() => _NMSSearchState();
}

class _NMSSearchState extends State<NMSSearch> {
  List<NMSSearchDataModel> searchList = [];

  Future<List<dynamic>> _search(String? search) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String accessToken = shared.getString("access_token") ?? "";
    var baseURL = shared.getString("baseURL") ?? "";
    String url = baseURL + urlController.nmsSearchUrl + search!;
    var response = await http
        .get(
        Uri.parse(url), headers: {'Authorization': 'bearer $accessToken'});
    var bodyData = json.decode(response.body);

    Map<String, dynamic> data = {};
    data.addAll({
      "SearchData": bodyData
    });
    setState(() {
    var dashboardData = NMSSearchResponseDataModel.fromJson(data);
      searchList = dashboardData.data;
    });
    List<dynamic> list = searchList;
    return list;
  }

  String baseUrl = "";
  getImgBaseUrl() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    baseUrl = shared.getString("baseURL") ?? "";
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getImgBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<NMSSearchDataModel> dSearchList = searchList;

    return Scaffold(
      backgroundColor: const Color(0xFFDFE0DF),
      appBar: AppBar(
        title: Text("Search", style: theme.text20),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: flappy_search.SearchBar<dynamic>(
          hintText: 'Search',
          onSearch: _search,
          minimumChars: 3,
          searchBarPadding: const EdgeInsets.only(left: 20, right: 20),
          onItemFound: (list, int searchIndex) {
            return (dSearchList.isEmpty)
                ? const Center(
                    child: Text(
                      "No Search Result Found",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => NMSDeviceDetails(
                                  deviceId: dSearchList[searchIndex]
                                      .transNo
                                      .toString()),
                            ));
                      },
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const Padding(padding: EdgeInsets.all(5)),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, bottom: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        image:
                                            "$baseUrl/assets/images/Devices/${dSearchList[searchIndex].imageUrl}",
                                        placeholder: 'assets/SplashPlace.JPG',
                                        fit: BoxFit.contain,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Expanded(
                                      child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 100,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: screenWidth - 200,
                                              child: Text(
                                                dSearchList[searchIndex]
                                                    .friendlyName,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            const Spacer()
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text(
                                                dSearchList[searchIndex]
                                                        .ipAddress
                                                        .toString() +
                                                    '  /  ' +
                                                    ((dSearchList[searchIndex]
                                                            .subnetMask)
                                                        .toString()
                                                        .split('/')[1]),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            const Spacer()
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 3,
                                              ),
                                              child: Text(
                                                dSearchList[searchIndex]
                                                    .typeName,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            const Spacer()
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: <Widget>[
                                            const Spacer(),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                dSearchList[searchIndex]
                                                    .typeName,
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              Container(
                                color: Colors.grey.withOpacity(0.8),
                                height: 1,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
        // child: Container(),
      ),
    );
  }
}
