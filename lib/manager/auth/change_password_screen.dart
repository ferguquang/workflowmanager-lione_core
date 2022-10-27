import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/palette.dart';
import 'package:workflow_manager/manager/models/params/change_pass_request.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'auth_repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  AuthRepository _authRepository = AuthRepository();
  TextEditingController passController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newPassConfirmController = TextEditingController();
  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showNewPasswordConfirm = false;

  @override
  void initState() {
    super.initState();
  }

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  void _changePassword() async {
    ChangePasswordRequest request = ChangePasswordRequest();
    request.currentPass = passController.text;
    request.newPass = newPassController.text;
    request.newPassConfirm = newPassConfirmController.text;
    bool changePasswordStatus = await _authRepository.changePassword(request);
    if (changePasswordStatus) {
      ToastMessage.show(_authRepository.message, ToastStyle.success);
      Navigator.of(context).pop();
    } else {
      ToastMessage.show(_authRepository.message, ToastStyle.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authRepository,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Thay đổi mật khẩu',
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          controller: passController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14, color: "999999".toColor()),
                            hintText: 'Mật khẩu hiện tại',
                            enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.borderEditText.toColor())),
                            prefixIcon: SVGImage(
                              svgName: "ic_password",
                            ),
                          ),
                          obscureText: !this._showPassword,
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vui lòng nhập mật khẩu mới của bạn bên dưới",
                                style: TextStyle(
                                    fontSize: 14, color: "222222".toColor()),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "Tối thiếu 6 kí tự, bao gồm cả chữ và số",
                                  style: TextStyle(
                                      fontSize: 12, color: "80898F".toColor()),
                                ),
                              )
                            ],
                          )),
                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: TextField(
                          controller: newPassController,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: "999999".toColor()),
                              hintText: 'Mật khẩu mới',
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.borderEditText.toColor())),
                              prefixIcon: SVGImage(
                                svgName: "ic_password",
                              )),
                          obscureText: !this._showNewPassword,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          controller: newPassConfirmController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14, color: "999999".toColor()),
                            hintText: 'Xác nhận mật khẩu mới',
                            enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.borderEditText.toColor())),
                            prefixIcon: SVGImage(
                              svgName: "ic_password",
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye_outlined,
                                color: this._showNewPasswordConfirm
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => this._showNewPasswordConfirm =
                                    !this._showNewPasswordConfirm);
                              },
                            ),
                          ),
                          obscureText: !this._showNewPasswordConfirm,
                        ),
                      ),
                    ],
                  ),
                ),
                SaveButton(
                  title: "Xác nhận".toUpperCase(),
                  onTap: () {
                    _changePassword();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    newPassController.dispose();
    newPassConfirmController.dispose();
  }
}
