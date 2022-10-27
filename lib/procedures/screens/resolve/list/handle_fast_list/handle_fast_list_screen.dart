import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/record_is_resolve_list_response.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/handle_fast_item.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_sign_pass_widget.dart';

class HandleFastListScreen extends StatefulWidget {
  DataRecordIsResolveList data;
  void Function(List<ServiceRecordsResolve>, String) onDone;
  void Function(List<ServiceRecordsResolve>, String) onCheckSignPass;

  HandleFastListScreen({this.data, this.onDone, this.onCheckSignPass});

  @override
  _HandleFastListScreenState createState() => _HandleFastListScreenState();
}

class _HandleFastListScreenState extends State<HandleFastListScreen> {
  @override
  Widget build(BuildContext context) {
    List<ServiceRecordsResolve> list = widget.data.serviceRecords;
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận giải quyết nhanh hồ sơ"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HandleFastItem(
                      model: list[index],
                      onUpdate: (ServiceRecordsResolve selected) {
                        setState(() {
                          list[list.indexWhere((element) => element.iDServiceRecord == selected.iDServiceRecord)] = selected;
                        });
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),
              SaveButton(
                title: "XONG",
                onTap: () async {
                  if (widget.data.isHasToSign == 1) {
                    String password = await SharedPreferencesClass.get(SharedPreferencesClass.PASSWORD_SIGNAL);
                    // nếu pass chưa đc lưu:
                    if (password == null || password.isEmpty) {
                      pushPage(context, InputSignPassWidget(
                        title: "Mật khẩu chữ ký số",
                        onSendText: (String password) {
                          widget.onDone(list, password);
                          Navigator.pop(context);
                        },
                      ));
                    } else {
                      // nếu pass đã được lưu:
                      widget.onCheckSignPass(list, password);
                      Navigator.pop(context);
                    }
                  } else {
                    widget.onDone(list, "");
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
