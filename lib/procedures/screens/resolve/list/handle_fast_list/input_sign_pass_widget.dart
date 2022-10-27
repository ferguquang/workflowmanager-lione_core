import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';

class InputSignPassWidget extends StatefulWidget {
  String title, content;
  void Function(String) onSendText;

  InputSignPassWidget({this.title, this.content, this.onSendText});

  @override
  _InputSignPassWidgetState createState() => _InputSignPassWidgetState();
}

class _InputSignPassWidgetState extends State<InputSignPassWidget> {
  TextEditingController controller = TextEditingController();

  bool isSelectRememberPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  obscureText: true,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Nhập mật khẩu"
                  ),
                ),
                CheckboxListTile(
                  title: Text("Nhớ mật khẩu"),
                  value: isSelectRememberPass,
                  onChanged: (newValue) async {
                    setState(() {
                      isSelectRememberPass = newValue;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                SaveButton(
                  margin: EdgeInsets.only(top: 32),
                  title: "XONG",
                  onTap: () async {
                    if (isSelectRememberPass) {
                      await SharedPreferencesClass.save(SharedPreferencesClass.PASSWORD_SIGNAL, controller.text);
                    }
                    widget.onSendText(controller.text);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
      ),
    );
  }
}