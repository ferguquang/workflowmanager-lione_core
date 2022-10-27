import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/sign_info_response.dart';

class ContractSignInfoScreen extends StatefulWidget {
  List<Info> info;

  ContractSignInfoScreen(this.info);

  @override
  _ContractSignInfoScreenState createState() => _ContractSignInfoScreenState();
}

class _ContractSignInfoScreenState extends State<ContractSignInfoScreen> {
  List<Info> infos;

  @override
  void initState() {
    super.initState();
    infos = widget.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin trình ký"),
      ),
      body: ListView.builder(
        itemCount: infos.length,
        itemBuilder: (context, index) {
          Info info = infos[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/icon_shopping_request_qlms.webp",
                      width: 40,
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.createdBy,
                            style: TextStyle(
                                color: getColor("#29a5ff"), fontSize: 16),
                          ),
                          Text(
                            "Bộ phận: ${info.name}",
                            style: TextStyle(fontSize: 13),
                          ),
                          Row(
                            children: [
                              Text(
                                "Trạng thái: ",
                                style: TextStyle(fontSize: 13),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    color:
                                        getColor(info?.status?.bgColor ?? "")),
                                child: Text(
                                  info?.status?.name ?? "",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Text(
                            "Ý kiến: ${info.describe}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              )
            ],
          );
        },
      ),
    );
  }
}
