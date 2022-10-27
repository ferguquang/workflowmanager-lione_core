import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action_repository.dart';

class DialogSetPassWordScreen extends StatefulWidget {
  int id;
  String name;
  bool isPassWord;

  DialogSetPassWordScreen(this.id, this.name, this.isPassWord);

  @override
  State<StatefulWidget> createState() {
    return DialogSetPassWordState();
  }
}

class DialogSetPassWordState extends State<DialogSetPassWordScreen> {
  TextEditingController currentController = TextEditingController();
  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  bool isCheckCurent = false, isCheckOne = false, isCheckTwo = false;

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
          Text(
            !widget.isPassWord ? 'Đặt mật khẩu' : 'Thay mật khẩu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${widget.name}',
            style: TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(
            height: 16,
          ),
          Visibility(
            visible: widget.isPassWord,
            child: TextField(
              obscureText: !this.isCheckCurent,
              controller: currentController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  hintText: 'Mật khẩu hiện tại',
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
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: !this.isCheckOne,
            controller: oneController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                hintText:
                    !widget.isPassWord ? 'Nhập mật khẩu' : 'Mật khẩu mới',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  onPressed: () {
                    setState(() {
                      isCheckOne = !isCheckOne;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: !isCheckOne ? Colors.grey : Colors.blue,
                    size: 20,
                  ),
                )),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: !this.isCheckTwo,
            controller: twoController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                hintText: !widget.isPassWord
                    ? 'Xác nhận mật khẩu'
                    : 'Xác nhận mật khẩu mới',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  onPressed: () {
                    setState(() {
                      isCheckTwo = !isCheckTwo;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: !isCheckTwo ? Colors.grey : Colors.blue,
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
    if (widget.isPassWord && isNullOrEmpty(currentController.text)) {
      ToastMessage.show('Mật khẩu hiện tại$textNotLeftBlank', ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(oneController.text)) {
      ToastMessage.show(
          !widget.isPassWord
              ? 'Mật khẩu$textNotLeftBlank'
              : 'Mật khẩu mới$textNotLeftBlank',
          ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(twoController.text)) {
      ToastMessage.show(
          !widget.isPassWord
              ? 'Xác nhận mật khẩu$textNotLeftBlank'
              : 'Xác nhận mật khẩu mới$textNotLeftBlank',
          ToastStyle.error);
      return;
    }

    if (oneController.text.toString() != twoController.text.toString()) {
      ToastMessage.show('Mật khẩu không giống nhau', ToastStyle.error);
      return;
    }
    await _repository.getSetPassWord(widget.id, twoController.text,
        widget.isPassWord ? currentController.text : null);
    Navigator.of(context).pop();
  }
}
