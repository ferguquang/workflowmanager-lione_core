import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/date.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/extension/int.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/models/events/update_image_event.dart';
import 'package:workflow_manager/manager/models/params/update_profile_request.dart';
import 'package:workflow_manager/manager/models/response/update_profile_response.dart';
import 'package:workflow_manager/manager/widgets/info_text_field.dart';
import 'package:workflow_manager/manager/widgets/info_text_view.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/workflow/models/response/pair_reponse.dart';

import '../../main.dart';
import 'auth_repository.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateProfileState();
  }
}

class _UpdateProfileState extends State<UpdateProfileScreen> {
  AuthRepository _authRepository = AuthRepository();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  static final GlobalKey<FormFieldState> nameKey = GlobalKey<FormFieldState>();

  ProfileDetailModel _user;

  int gender;

  int birthday;
  bool isHRM = true;
  List<Pair> listGender = [
    Pair(key: 0, value: "Khác"),
    Pair(key: 1, value: "Nam"),
    Pair(key: 2, value: "Nữ"),
  ];

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    ProfileDetailModel user = await _authRepository.getProfile();
    isHRM = user.isHRM == true;
    listGender.forEach((element) {
      if (element.key == user.userDocPro.gender) {
        element.selectType = 1; //
        return; // cứ set khác null là được
      }
    });
    setState(() {
      _user = user;
      nameController.text = _user?.userDocPro?.name ?? "";
      emailController.text = _user?.userDocPro?.email ?? "";
      addressController.text = _user?.userDocPro?.address ?? "";
      phoneController.text = _user?.userDocPro?.phone ?? "";
    });
  }

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  void showGenderPopup() async {
    BottomSheetDialog bottomSheetDialog = BottomSheetDialog(
      context: context,
      title: "Chọn giới tính",
      onTapListener: (item) async {
        listGender.forEach((element) {
          if (element.key == item.key) {
            element.selectType = item.selectType;
            return;
          }
        });
        this.gender = item.key;
        setState(() {
          _user?.userDocPro?.gender = item.key;
        });
      },
    );
    await bottomSheetDialog.showBottomSheetDialogWithCheckIcon(listGender);
  }

  void showDateTimeDialog() {
    DateTimePickerWidget(
        format: Constant.yyyyMMdd,
        context: context,
        maxTime: DateTime.now(),
        onDateTimeSelected: (valueDate) {
          this.birthday = valueDate.toDate().toInt();
          setState(() {
            _user?.userDocPro?.birthday = valueDate.toDate().toInt();
          });
          // print(valueDate);
        }).showOnlyDatePicker();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authRepository,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            isHRM ? "Thông tin cá nhân" : 'Cập nhật thông tin',
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Divider(thickness: 8, color: "EFF0F5".toColor()),
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InfoTextField(
                          "Họ và tên",
                          nameController,
                          isRequire: !isHRM,
                          isEnable: !isHRM,
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InfoTextField(
                          "Thư điện tử",
                          emailController,
                          isRequire: !isHRM,
                          isEnable: !isHRM,
                        )),
                    Divider(thickness: 8, color: "EFF0F5".toColor()),
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InfoTextField(
                          "Số điện thoại",
                          phoneController,
                          isRequire: !isHRM,
                          isEnable: !isHRM,
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InfoTextField(
                          "Địa chỉ",
                          addressController,
                          isRequire: !isHRM,
                          isEnable: !isHRM,
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InfoTextView("Giới tính",
                            info: listGender
                                    .firstWhere(
                                        (element) =>
                                            element.key ==
                                            _user?.userDocPro?.gender,
                                        orElse: () => listGender.first)
                                    .value ??
                                "",
                            icon: Icons.keyboard_arrow_down, onPressed: () {
                          if (!isHRM) showGenderPopup();
                        })),
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InfoTextView("Ngày sinh",
                            info: _user?.userDocPro?.birthday == 0
                                ? ""
                                : _user?.userDocPro?.birthday
                                        ?.toDate(Constant.ddMMyyyy) ??
                                    "",
                            onDelete: isHRM
                                ? null
                                : () {
                                    _user?.userDocPro?.birthday = 0;
                                    birthday = 0;
                                    _authRepository.notifyListeners();
                                    setState(() {});
                                  },
                            icon: Icons.date_range, onPressed: () {
                          if (!isHRM) showDateTimeDialog();
                        })),
                  ],
                ),
              ),
              Visibility(
                visible: !isHRM,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SaveButton(
                    title: "Cập nhật".toUpperCase(),
                    onTap: () {
                      _updateProfile();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    UpdateProfileRequest request = UpdateProfileRequest();
    request.userName = nameController.text;
    request.email = emailController.text;
    request.address = addressController.text;
    request.gender = this.gender;
    request.birthday = this.birthday;
    request.numberPhone = phoneController.text;
    bool updateProfileStatus = await _authRepository.updateProfile(request);
    if (updateProfileStatus) {
      ToastMessage.show(_authRepository.message, ToastStyle.success);
      // await _authRepository.login(context, username, pass);
      User user = await SharedPreferencesClass.getUser();
      if (isNotNullOrEmpty(nameController.text)) {
        user.name = nameController.text;
      }
      if (isNotNullOrEmpty(emailController.text)) {
        user.email = emailController.text;
      }
      if (isNotNullOrEmpty(addressController.text)) {
        user.address = addressController.text;
      }
      if (isNotNullOrEmpty(this.gender)) {
        user.gender = this.gender;
      }
      if (isNotNullOrEmpty(this.birthday)) {
        user.birthday = this.birthday;
      }
      if (isNotNullOrEmpty(phoneController.text)) {
        user.phone = phoneController.text;
      }
      await SharedPreferencesClass.saveUser(user);
      eventBus.fire(UpdateProfileEvent());
      Navigator.of(context).pop(true);
    } else {
      ToastMessage.show(_authRepository.message, ToastStyle.error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
  }
}
