import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action_repository.dart';

class DialogDeletePassWordScreen extends StatefulWidget {
  int id;

  DialogDeletePassWordScreen(this.id);

  @override
  State<StatefulWidget> createState() {
    return DialogDeletePassWordState();
  }
}

class DialogDeletePassWordState extends State<DialogDeletePassWordScreen> {
  TextEditingController currentController = TextEditingController();
  bool isCheckCurent = false;

  BottomSheetActionRepository _repository = BottomSheetActionRepository();

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
            'Hủy mật khẩu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Nhập mật khẩu để được hủy khóa',
            style: TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            obscureText: !this.isCheckCurent,
            controller: currentController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                hintText: 'Nhập mật khẩu',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  onPressed: () {
                    setState(() {
                      isCheckCurent = !isCheckCurent;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: !isCheckCurent ? Colors.grey : Colors.blue,
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
    if (isNullOrEmpty(currentController.text)) {
      ToastMessage.show('Mật khẩu$textNotLeftBlank', ToastStyle.error);
      return;
    }

    await _repository.getDeletePassWord(widget.id, currentController.text);
    Navigator.of(context).pop();
  }
}
