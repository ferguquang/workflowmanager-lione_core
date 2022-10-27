import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class DialogGetPassWordScreen extends StatefulWidget {

  final void Function(String) onGetPassListener;

  final Function onExitPassListener;

  DialogGetPassWordScreen({this.onGetPassListener, this.onExitPassListener});

  @override
  State<StatefulWidget> createState() {
    return _DialogGetPassWordState();
  }
}

class _DialogGetPassWordState extends State<DialogGetPassWordScreen> {
  TextEditingController passwordController = TextEditingController();
  bool isCheckCurrent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xác thực mật khẩu',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Nhập mật khẩu để được mở khóa',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            obscureText: !this.isCheckCurrent,
            controller: passwordController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                hintText: 'Mật khẩu',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  onPressed: () {
                    setState(() {
                      isCheckCurrent = !isCheckCurrent;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: !isCheckCurrent ? Colors.grey : Colors.blue,
                    size: 20,
                  ),
                )),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Spacer(),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if(widget.onExitPassListener != null) {
                    widget.onExitPassListener();
                  }
                  // Navigator.of(context).pop();
                },
                child: const Text(
                  'HỦY BỎ',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: () {
                  _eventClickDone();
                },
                child: const Text(
                  'ĐỒNG Ý',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _eventClickDone() async {
    if (isNullOrEmpty(passwordController.text)) {
      ToastMessage.show('Mật khẩu$textNotLeftBlank', ToastStyle.error);
      return;
    }
    Navigator.of(context).pop();
    if (widget.onGetPassListener != null) {
      this.widget.onGetPassListener(passwordController.text);
    }
  }
}
