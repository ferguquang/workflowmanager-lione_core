import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/detail_register_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/selected_user_search_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_auser_response.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_search_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/detai_register_borrow_document/detail_register_borrow_document_repository.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/detai_register_borrow_document/select_user_single_screen/select_user_search_screen.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_provider.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

class DetailRegisterBorrowDocumentScreen extends StatefulWidget {
  DataBorrowSearch dataBorrowSearch;
  StgDocs item;

  DetailRegisterBorrowDocumentScreen(this.dataBorrowSearch, this.item);

  @override
  State<StatefulWidget> createState() {
    return _DetailRegisterBorrowDocumentSate();
  }
}

class _DetailRegisterBorrowDocumentSate
    extends State<DetailRegisterBorrowDocumentScreen> {
  DetailRegisterBorrowDocumentRepository _repository =
      DetailRegisterBorrowDocumentRepository();
  //sao l??u,?????c,copy,b???n c???ng,b???n sao y
  bool isBorrowBackup = false;
  bool isBorrowRead = false;
  bool isBorrowCopy = false;
  bool isBorrowTake = false;
  bool isBorrowCertifiedCopy = false;

  bool isShowViewFile = false;
  bool isShowViewLeader = false;

  var reasonController = TextEditingController();
  var noteController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var userBorrowController = TextEditingController();
  var phoneController = TextEditingController();

  String fileName, filePath;
  AUser user = AUser();
  int idUser;
  String nameAUser;

  _getUserLogin() async {
    User user = await SharedPreferencesClass.getUser();
    idUser = user.iDUserDocPro;
  }

  @override
  void initState() {
    super.initState();
    _getUserLogin();
    if (widget.dataBorrowSearch.isLD)
      nameAUser = "L??nh ?????o";
    else if (widget.dataBorrowSearch.isVT)
      nameAUser = "V??n th??";
    else
      nameAUser = "Tr?????ng ph??ng";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(builder:
          (context, DetailRegisterBorrowDocumentRepository _repository, _) {
        return Scaffold(
          appBar: AppBar(
            leading: BackIconButton(),
            title: Text('M?????n h??? s?? t??i li???u'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          ImageUtils.instance
                              .getImageType(widget.item?.extension ?? ''),
                          width: 40,
                          height: 40,
                        ),
                        Expanded(
                          child: Text(
                            widget.item?.name ?? '',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    _dividerCustomWidget(),
                    TextFieldValidate(
                      isShowValidate: true,
                      padding: EdgeInsets.only(top: 16),
                      title: 'L?? do',
                      controller: reasonController,
                    ),
                    TextFieldValidate(
                      padding: EdgeInsets.only(top: 16),
                      title: 'Ghi ch??',
                      isShowValidate: false,
                      controller: noteController,
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: const Text(
                        'M???c ????ch',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _selectCheckBoxWidget('Sao l??u', 1),
                              _selectCheckBoxWidget('?????c', 2),
                              _selectCheckBoxWidget('Copy', 3),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              _selectCheckBoxWidget('B???n c???ng', 4),
                              _selectCheckBoxWidget('B???n sao y', 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TagLayoutWidget(
                      isShowValidate: true,
                      horizontalPadding: 0,
                      title: "T??? ng??y",
                      value: startDateController.text ?? '',
                      icon: Icons.date_range,
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        DateTimePickerWidget(
                            minTime: DateTime.now(),
                            format: Constant.ddMMyyyy2,
                            context: context,
                            onDateTimeSelected: (valueDate) {
                              setState(() {
                                startDateController.text = valueDate;
                              });
                              // print(valueDate);
                            }).showOnlyDatePicker();
                      },
                    ),
                    TagLayoutWidget(
                      isShowValidate: true,
                      horizontalPadding: 0,
                      title: "?????n ng??y",
                      value: endDateController.text ?? '',
                      icon: Icons.date_range,
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        DateTimePickerWidget(
                            minTime: DateTime.now(),
                            format: Constant.ddMMyyyy2,
                            context: context,
                            onDateTimeSelected: (valueDate) {
                              setState(() {
                                endDateController.text = valueDate;
                              });
                              // print(valueDate);
                            }).showOnlyDatePicker();
                      },
                    ),
                    Visibility(
                        visible: isShowViewFile,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              fileName ?? '',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            )),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                                size: 18,
                              ),
                              onPressed: () {
                                _eventClickClearFileNamePath();
                              },
                            )
                          ],
                        )),
                    Visibility(
                        visible: isShowViewFile,
                        child: _dividerCustomWidget(sizeTop: 8)),
                    InkWell(
                      onTap: () {
                        _eventClickAddFile(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.attach_file_outlined,
                              color: Colors.grey,
                              size: 18,
                            ),
                            Text(
                              ' Th??m file ????nh k??m',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    _dividerCustomWidget(sizeTop: 4),
                    TextFieldValidate(
                      padding: EdgeInsets.only(top: 16),
                      title: 'Ng?????i m?????n',
                      isShowValidate: true,
                      controller: userBorrowController,
                    ),
                    TextFieldValidate(
                      maxLength: 11,
                      maxLine: 1,
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.only(top: 16),
                      title: 'S??? ??i???n tho???i',
                      isShowValidate: true,
                      controller: phoneController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            nameAUser,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.blue,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              _eventClickAddLeader();
                            },
                          ),
                        ),
                        Visibility(
                            visible: isShowViewLeader,
                            child: CircleNetworkImage(
                                height: 60, width: 60, url: user?.avatar ?? ''))
                      ],
                    ),
                    SaveButton(
                      margin: EdgeInsets.only(top: 8),
                      title: 'M?????N H??? S?? - T??I LI???U',
                      onTap: () {
                        _eventClickRegisterBorrow();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _selectCheckBoxWidget(String name, int check) {
    return InkWell(
      onTap: () {
        _funClickCheckBox(check);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: _funCheckBox(check),
            activeColor: Colors.blue,
            onChanged: (value) {
              _funClickCheckBox(check);
            },
          ),
          Text(name)
        ],
      ),
    );
  }

  _funClickCheckBox(int check) {
    setState(() {
      switch (check) {
        case 1:
          this.isBorrowBackup = !this.isBorrowBackup;
          this.isBorrowRead = false;
          this.isBorrowCopy = false;
          this.isBorrowTake = false;
          this.isBorrowCertifiedCopy = false;
          break;
        case 2:
          this.isBorrowBackup = false;
          this.isBorrowRead = !this.isBorrowRead;
          this.isBorrowCopy = false;
          this.isBorrowTake = false;
          this.isBorrowCertifiedCopy = false;
          break;
        case 3:
          this.isBorrowBackup = false;
          this.isBorrowRead = false;
          this.isBorrowCopy = !this.isBorrowCopy;
          this.isBorrowTake = false;
          this.isBorrowCertifiedCopy = false;
          break;
        case 4:
          this.isBorrowBackup = false;
          this.isBorrowRead = false;
          this.isBorrowCopy = false;
          this.isBorrowTake = !this.isBorrowTake;
          this.isBorrowCertifiedCopy = false;
          break;
        case 5:
          this.isBorrowBackup = false;
          this.isBorrowRead = false;
          this.isBorrowCopy = false;
          this.isBorrowTake = false;
          this.isBorrowCertifiedCopy = !this.isBorrowCertifiedCopy;
          break;
      }
    });
  }

  _funCheckBox(int check) {
    switch (check) {
      case 1:
        return this.isBorrowBackup;
      case 2:
        return this.isBorrowRead;
      case 3:
        return this.isBorrowCopy;
      case 4:
        return this.isBorrowTake;
      case 5:
        return this.isBorrowCertifiedCopy;
    }
  }

  Widget _dividerCustomWidget({double sizeTop}) {
    return Container(
      margin: EdgeInsets.only(top: sizeTop ?? 12),
      color: Colors.grey[300],
      height: 1,
    );
  }

  // click file ????nh k??m
  _eventClickAddFile(BuildContext context) async {
    AttachFilesProvider attachFilesProvider = AttachFilesProvider();
    await attachFilesProvider.addFileToLocal(context);
    setState(() {
      if (attachFilesProvider.files.length > 0) {
        isShowViewFile = true;
        // do c??i n??y ch??? ch???n 1 file l??n fix c???ng 0
        fileName = attachFilesProvider.files[0].name;
        filePath = attachFilesProvider.files[0].path;
      }
    });
  }

  //click IconButton file name
  _eventClickClearFileNamePath() {
    setState(() {
      isShowViewFile = false;
      fileName = '';
      filePath = '';
    });
  }

  // l??nh ?????o, v??n th??
  _eventClickAddLeader() {
    FocusScope.of(context).unfocus();
    SelectedUserSearchRequest request = SelectedUserSearchRequest();
    if (widget.dataBorrowSearch.isLD)
      request.iDModule = widget.dataBorrowSearch.iDModuleLD;
    else if (widget.dataBorrowSearch.isVT)
      request.iDModule = widget.dataBorrowSearch.iDModuleVT;
    else
      request.positionCode = widget.dataBorrowSearch.positionCode;

    request.iDNotIn = idUser ?? 0;
    pushPage(
        context,
        SelectedUserSearchScreen(
            idUserSelected: user?.iD,
            request: request,
            hint: nameAUser,
            onSharedSearchSelected: (user) {
              setState(() {
                if (this.user.iD != user.iD) {
                  this.user = user;
                  isShowViewLeader = true;
                } else {
                  this.user = AUser();
                  isShowViewLeader = false;
                }
              });
            }));
  }

  _eventClickRegisterBorrow() async {
    FocusScope.of(context).unfocus();
    if (isNullOrEmpty(reasonController.text)) {
      ToastMessage.show('L?? do$textNotLeftBlank', ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(startDateController.text)) {
      ToastMessage.show('Ng??y b???t ?????u$textNotLeftBlank', ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(endDateController.text)) {
      ToastMessage.show('Ng??y k???t th??c$textNotLeftBlank', ToastStyle.error);
      return;
    }
    // if (compareDate(
    //         getCurrentDate(Constant.ddMMyyyyHHmm2), startDateController.text) <
    //     0) {
    //   ToastMessage.show(
    //       'Ng??y b???t ?????u ph???i l???n h??n th???i gian hi???n t???i', ToastStyle.error);
    //   return;
    // }
    // if (compareDate(startDateController.text, endDateController.text) < 0) {
    //   ToastMessage.show(
    //       'Ng??y b???t ?????u kh??ng ???????c l???n h??n ng??y k???t th??c', ToastStyle.error);
    //   return;
    // }
    // if (compareDate(startDateController.text, endDateController.text) == 0) {
    //   ToastMessage.show(
    //       'Ng??y b???t ?????u ph???i nh??? h??n ng??y k???t th??c', ToastStyle.error);
    //   return;
    // }

    if (isBorrowTake) {
      if (isNullOrEmpty(fileName) && isNullOrEmpty(filePath)) {
        ToastMessage.show('Ch??a t???i l??n file ????nh k??m!', ToastStyle.error);
        return;
      }
    }

    if (isNullOrEmpty(userBorrowController.text)) {
      ToastMessage.show('Ng?????i m?????n$textNotLeftBlank', ToastStyle.error);
      return;
    }

    if (isNullOrEmpty(phoneController.text)) {
      ToastMessage.show('S??? ??i???n tho???i$textNotLeftBlank', ToastStyle.error);
      return;
    }

    if (isNullOrEmpty(user?.iD)) {
      ToastMessage.show('$nameAUser$textNotLeftBlank', ToastStyle.error);
      return;
    }

    DetailRegisterRequest request = DetailRegisterRequest();
    request.fileName = fileName;
    request.filePath = filePath;

    request.isBorrowRead = isBorrowRead; // ?????c
    request.isBorrowBackup = isBorrowBackup; // sao l??u
    request.isBorrowCopy = isBorrowCopy; // copy
    request.isBorrowTake = isBorrowTake; // b???n c???ng
    request.isBorrowCertifiedCopy = isBorrowCertifiedCopy; // b???n sao y

    request.iDDoc = widget.item.iDDoc;
    request.reason = reasonController.text;
    request.note = noteController.text;
    request.startDate = startDateController.text.replaceAll('/', '-');
    request.endDate = endDateController.text.replaceAll('/', '-');

    request.isLD = widget.dataBorrowSearch.isLD;
    request.isVT = widget.dataBorrowSearch.isVT;

    request.nameBorrower = userBorrowController.text;
    request.phoneNumber = phoneController.text;
    request.consultByName = user?.name ?? '';
    request.idConsultByName = user?.iD ?? 0;
    bool isStatus = await _repository.getBorrowCreated(request);
    if (isStatus) {
      Navigator.of(context).pop(isStatus);
    }
  }
}
