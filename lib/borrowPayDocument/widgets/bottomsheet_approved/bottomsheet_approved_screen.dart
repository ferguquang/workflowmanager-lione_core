import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_approved_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/selected_user_search_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_auser_response.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/detai_register_borrow_document/select_user_single_screen/select_user_search_screen.dart';
import 'package:workflow_manager/borrowPayDocument/widgets/bottomsheet_approved/bottomsheet_approved_repository.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_provider.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

class BottomSheetApprovedScreen extends StatefulWidget {
  int status = 0;
  StgDocBorrows item;

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetApprovedState();
  }

  BottomSheetApprovedScreen(this.status, this.item);
}

class _BottomSheetApprovedState extends State<BottomSheetApprovedScreen> {
  BottomSheetApprovedRepository _repository = BottomSheetApprovedRepository();

  //sao lưu,đọc,copy,bản cứng,bản sao y
  bool isBorrowBackup = false;
  bool isBorrowRead = false;
  bool isBorrowCopy = false;
  bool isBorrowTake = false;
  bool isBorrowCertifiedCopy = false;

  bool isShowViewFile = false;
  bool isShowAddFile = false;
  bool isShowLeader = false;
  bool isShowReject = false;
  bool isShowUserLeader = false;

  String nameButtonSave = '';
  String fileName, filePath;

  var reasonController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var rejectController = TextEditingController();

  int idUser;
  String nameAUser;
  AUser user;

  _getUserLogin() async {
    var user = await SharedPreferencesClass.getUser();
    idUser = user.iDUserDocPro;
    print(idUser);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLogin();
    _getDataBottomSheet();
  }

  _getDataBottomSheet() {
    //duyệt: 1, từ chối: 2, chuyển tiếp: 3, mượn trả: 4, thu hồi: 5, đóng hồ sơ: 6
    switch (widget.status) {
      case 1:
        {
          nameButtonSave = 'DUYỆT HỒ SƠ';
          break;
        }
      case 2:
        {
          nameButtonSave = 'TỪ CHỐI DUYỆT HỒ SƠ';
          isShowReject = true;
          break;
        }
      case 3:
        {
          nameButtonSave = widget.item.isForwardLD
              ? widget.item.titleForwardLD.toUpperCase()
              : widget.item.titleForwardVT.toUpperCase();
          isShowLeader = true;
          break;
        }
      case 4:
        {
          nameButtonSave = 'XÁC NHẬN CHO MƯỢN';
          break;
        }
      case 5:
        {
          nameButtonSave = 'XÁC NHẬN THU HỒI';
          break;
        }
      case 6:
        {
          isShowAddFile = true;
          nameButtonSave = 'ĐÓNG HỒ SƠ';
          break;
        }
    }

    reasonController.text = widget.item?.reason;
    isBorrowBackup = widget.item?.isBorrowBackup; // sao lưu
    isBorrowRead = widget.item?.isBorrowRead; // đọc
    isBorrowCopy = widget.item?.isBorrowCopy; // copy
    isBorrowTake = widget.item?.isBorrowTake; // bản cứng
    isBorrowCertifiedCopy = widget.item?.isBorrowCertifiedCopy; // bản sao y

    startDateController.text =
        convertTimeStampToHumanDate(widget.item?.startDate, Constant.ddMMyyyy);
    endDateController.text =
        convertTimeStampToHumanDate(widget.item?.endDate, Constant.ddMMyyyy);

    nameAUser = widget.item.isForwardLD ? 'Lãnh đạo' : 'Văn thư';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
        builder: (context, BottomSheetApprovedRepository _repository, child) {
          return Container(
            color: Colors.white,
            margin: MediaQuery.of(context).viewInsets,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImageUtils.instance
                          .getImageType(widget.item?.extension ?? ''),
                      width: 32,
                      height: 32,
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
                  padding: EdgeInsets.only(top: 16),
                  title: 'Lý do',
                  isShowValidate: true,
                  controller: reasonController,
                ),
                const Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: const Text(
                    'Mục đích',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _selectCheckBoxWidget('Sao lưu', 1),
                //     _selectCheckBoxWidget('Đọc', 2),
                //     _selectCheckBoxWidget('Copy', 3),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     _selectCheckBoxWidget('Bản cứng', 4),
                //     _selectCheckBoxWidget('Bản sao y', 5),
                //   ],
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _selectCheckBoxWidget('Sao lưu', 1),
                          _selectCheckBoxWidget('Đọc', 2),
                          _selectCheckBoxWidget('Copy', 3),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _selectCheckBoxWidget('Bản cứng', 4),
                          _selectCheckBoxWidget('Bản sao y', 5),
                        ],
                      ),
                    ),
                  ],
                ),
                TagLayoutWidget(
                  isShowValidate: true,
                  horizontalPadding: 0,
                  title: "Từ ngày",
                  value: startDateController.text ?? '',
                  icon: Icons.date_range,
                  openFilterListener: () {
                    FocusScope.of(context).unfocus();
                    DateTimePickerWidget(
                        format: Constant.ddMMyyyy,
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
                  title: "Đến ngày",
                  value: endDateController.text ?? '',
                  icon: Icons.date_range,
                  openFilterListener: () {
                    FocusScope.of(context).unfocus();
                    DateTimePickerWidget(
                        format: Constant.ddMMyyyy,
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
                            child: Text(fileName ?? '',
                                style: TextStyle(color: Colors.blue))),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                            size: 18,
                          ),
                          onPressed: () {},
                        )
                      ],
                    )),
                Visibility(
                    visible: isShowViewFile,
                    child: _dividerCustomWidget(sizeTop: 8)),
                Visibility(
                  visible: isShowAddFile,
                  child: InkWell(
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
                            'Thêm file đính kèm',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: isShowAddFile,
                    child: _dividerCustomWidget(sizeTop: 4)),
                Visibility(
                  visible: isShowReject,
                  child: TextFieldValidate(
                    padding: EdgeInsets.only(top: 16),
                    title: 'Lý do từ chối',
                    isShowValidate: true,
                    controller: rejectController,
                  ),
                ),
                Visibility(
                  visible: isShowLeader,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          nameAUser,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isShowLeader,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
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
                      const SizedBox(
                        width: 8,
                      ),
                      Visibility(
                          visible: isShowUserLeader,
                          child: CircleNetworkImage(
                              height: 60, width: 60, url: ""))
                    ],
                  ),
                ),
                SaveButton(
                  color: widget.status == 2 || widget.status == 6
                      ? Colors.red
                      : null,
                  margin: EdgeInsets.only(top: 8),
                  title: nameButtonSave,
                  onTap: () {
                    _eventClickSaveApproved();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _eventClickAddLeader() {
    if (isNullOrEmpty(user)) user = AUser();
    SelectedUserSearchRequest request = SelectedUserSearchRequest();
    if (widget.item.isForwardLD)
      request.iDModule = widget.item.iDModuleLD;
    else if (widget.item.isForwardVT) request.iDModule = widget.item.iDModuleVT;

    request.iDNotIn = idUser ?? 0;
    pushPage(
        context,
        SelectedUserSearchScreen(
            idUserSelected: user?.iD ?? 0,
            request: request,
            hint: nameAUser,
            onSharedSearchSelected: (user) {
              setState(() {
                if (this.widget.item.iD != user.iD) {
                  this.user = user;
                  isShowUserLeader = true;
                } else {
                  this.user = AUser();
                  isShowUserLeader = false;
                }
              });
            }));
  }

  // 5 cái checkbox
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

  // 5 cái checkbox
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

  // click file đính kèm
  _eventClickAddFile(BuildContext context) async {
    AttachFilesProvider attachFilesProvider = AttachFilesProvider();
    await attachFilesProvider.addFileToLocal(context);
    setState(() {
      if (attachFilesProvider.files.length > 0) {
        isShowViewFile = true;
        // do cái này chỉ chọn 1 file lên fix cứng 0
        fileName = attachFilesProvider.files[0].name;
        filePath = attachFilesProvider.files[0].path;
      }
    });
  }

  Widget _dividerCustomWidget({double sizeTop}) {
    return Container(
      margin: EdgeInsets.only(top: sizeTop ?? 12),
      color: Colors.grey[300],
      height: 1,
    );
  }

  _eventClickSaveApproved() async {
    FocusScope.of(context).unfocus();

    if (isNullOrEmpty(reasonController.text)) {
      ToastMessage.show('Lý do$textNotLeftBlank', ToastStyle.error);
      return;
    }

    var request = BorrowApprovedRequest();
    request.reason = reasonController.text;
    request.isBorrowRead = isBorrowRead;
    request.isBorrowBackup = isBorrowBackup;
    request.isBorrowCopy = isBorrowCopy;
    request.isBorrowTake = isBorrowTake;
    request.isBorrowCertifiedCopy = isBorrowCertifiedCopy;
    request.startDate = startDateController.text.replaceAll('/', '-');
    request.endDate = endDateController.text.replaceAll('/', '-');
    request.id = widget.item?.iD;
    request.idDoc = widget.item?.iDDoc;

    switch (widget.status) {
      //duyệt: 1
      case 1:
      //chuyển tiếp: 3
      case 3:
        if (widget.status == 3) {
          if (isNullOrEmpty(user) || isNullOrEmpty(user?.iD)) {
            ToastMessage.show('$nameAUser$textNotLeftBlank', ToastStyle.error);
            return;
          }

          if (widget.item.isForwardVT) {
            // có quyền chuyển tiếp cho văn thư
            request.archiveByName = user?.name;
            request.archiveBy = user?.iD;
          } else if (widget.item.isForwardLD) {
            // có quyền chuyển tiếp cho lãnh đạo
            request.consultByName = user?.name;
            request.consultBy = user?.iD;
          }
        }
        bool status = await _repository.getBorrowOption(
            AppUrl.getBorrowApproved, request);
        if (status) Navigator.of(context).pop();
        break;

      //từ chối: 2
      case 2:
        if (isNullOrEmpty(rejectController.text.trim())) {
          ToastMessage.show(
              'Trường lý do từ chối$textNotLeftBlank', ToastStyle.error);
          return;
        }
        request.reasonRejected = rejectController.text;
        bool status = await _repository.getBorrowOption(
            AppUrl.getBorrowRejected, request);
        if (status) Navigator.of(context).pop();
        break;

      // mượn trả: 4
      case 4:
        bool status = await _repository.getBorrowOption(
            AppUrl.getBorrowBorrowed, request);
        if (status) Navigator.of(context).pop();
        break;

      //thu hồi: 5
      case 5:
        // if (isNullOrEmpty(fileName) && isNullOrEmpty(filePath)) {
        //   ToastMessage.show('Chưa tải lên file đính kèm!', ToastStyle.error);
        //   return;
        // }
        //
        // request.reasonDisabled = rejectController.text;
        // request.fileName = fileName ?? '';
        // request.filePath = filePath ?? '';
        bool status = await _repository.getBorrowOption(
            AppUrl.getBorrowDisabled, request);
        if (status) Navigator.of(context).pop();
        break;

      //đóng hồ sơ: 6
      case 6:
        // /*if (isBorrowTake) */ if (isNullOrEmpty(fileName) &&
        //     isNullOrEmpty(filePath)) {
        //   // ToastMessage.show(
        //   //     'Cần tải thêm file nếu muốn mượn bản cứng', ToastStyle.error);
        //   ToastMessage.show('Chưa tải lên file đính kèm!', ToastStyle.error);
        //   return;
        // }

        // request.note; // ? doceye view mặc định là ẩn ?
        request.reasonDisabled = rejectController.text;
        request.fileName = fileName ?? '';
        request.filePath = filePath ?? '';

        bool status =
            await _repository.getBorrowOption(AppUrl.getBorrowClosed, request);
        if (status) Navigator.of(context).pop();
        break;
    }
  }
}
