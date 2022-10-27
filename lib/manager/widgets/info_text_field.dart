import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';

class InfoTextField extends StatefulWidget {
  String name;

  String info;

  bool isRequire;
  bool isEnable;

  TextEditingController infoController = TextEditingController();

  InfoTextField(this.name, this.infoController,
      {this.isRequire = false, this.isEnable = true});

  @override
  State<StatefulWidget> createState() {
    return _InfoTextFieldState();
  }
}

class _InfoTextFieldState extends State<InfoTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      Text(
                        widget.name,
                        style:
                            TextStyle(color: "999999".toColor(), fontSize: 14),
                      ),
                      Visibility(
                          visible: widget.isRequire,
                          child: Text(
                            " *",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: TextField(
                        style:
                            TextStyle(color: "222222".toColor(), fontSize: 14),
                        textAlign: TextAlign.end,
                        enabled: widget.isEnable,
                        controller: widget.infoController,
                        decoration: null),
                  ),
                )
                // TextField(widget.info, style: TextStyle(color: "666666".toColor()),)
              ],
            ),
          ),
        ),
        Container(
          child: Divider(color: "E9ECEF".toColor()),
        )
      ],
    );
  }
}
