import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class UpdateProgressDialog extends StatefulWidget {
  double padding = 20;
  double progress = 0;
  ValueChanged<double> onProgressChanged;

  UpdateProgressDialog({this.progress = 0, this.onProgressChanged});

  @override
  State<StatefulWidget> createState() {
    return _UpdateProgressDialog();
  }
}

class _UpdateProgressDialog extends State<UpdateProgressDialog> {
  double sliderValue = 0.2;
  String value = "0";

  setProgress(double progress) {
    setState(() {
      sliderValue = progress;
      value = "${(100 * progress).toInt()}";
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.progress > 1) {
      widget.progress = widget.progress / 100;
    }
    setProgress(widget.progress);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleDialog(
                  "Cập nhật tiến độ",
                  padding: widget.padding,
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: widget.padding),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text(value,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              Text("0"),
                              Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      child: Slider(
                                        onChangeEnd: (value) {
                                          sliderValue = value;
                                        },
                                        value: sliderValue,
                                        onChanged: setProgress,
                                      ))),
                              Text("100"),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: SaveButton(
                                title: "Cập nhật tiến độ",
                                onTap: () async {
                                  if (widget.onProgressChanged != null) {
                                    var response = await widget
                                        .onProgressChanged(sliderValue);
                                  }
                                },
                              ))
                        ]))
              ],
            ))
      ],
    );
  }
}
