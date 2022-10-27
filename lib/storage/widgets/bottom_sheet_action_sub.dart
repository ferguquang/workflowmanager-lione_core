import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/storage/models/events/bottom_sheet_action_event.dart';
import 'package:workflow_manager/storage/screens/list_storage/list_storage_repository.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action_repository.dart';
import 'package:workflow_manager/storage/widgets/dialog/dialog_authen_pass_word.dart';

class BottomSheetActionSub extends StatelessWidget {
  BuildContext context;

  // List<DocChildItem> listCheckDocs = [];
  ListStorageRepository _listStorageRepository;
  bool isCheckMove;

  BottomSheetActionSub(
      this.context, this._listStorageRepository, this.isCheckMove);

  List<String> listString = List();
  bool isCheckPin = true;
  int isCheckPassWord = 0;
  int isCheckPermissionMove = 0;
  int isCheckPermissionDelete = 0;

  @override
  Widget build(BuildContext _context) {
    _listStorageRepository.listCheckDocs.forEach((element) {
      listString.add(element.iD.toString());
      if (isCheckPin) {
        isCheckPin = element.isPin == 1 ? true : false;
      }
      if (element.isPassword) {
        isCheckPassWord++;
      }
      if (!element.isMove) {
        isCheckPermissionMove++;
      }
      if (!element.isDelete) {
        isCheckPermissionDelete++;
      }
    });

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
            child: Text(
              '${_listStorageRepository.listCheckDocs.length} mục',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
          _iconAndTextWidget(1, Icons.folder_special, 'Di chuyển', isCheckMove),
          InkWell(
            onTap: () {
              getPinListFolder();
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 12, right: 16, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star_border,
                    size: 24,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Ghim',
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        !isCheckPin
                            ? Icons.toggle_off
                            : Icons.toggle_on_outlined,
                        color: !isCheckPin ? Colors.grey : Colors.blue,
                        size: 32,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _iconAndTextWidget(2, Icons.delete, 'Xóa', true),
          InkWell(
            onTap: () {
              eventBus.fire(GetRemoveCheckEventBus());
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 12, right: 16, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                    width: 40,
                  ),
                  Text(
                    'Xóa lựa chọn',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconAndTextWidget(position, icon, text, isShow) {
    return Visibility(
      visible: isShow,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          switch (position) {
            case 1:
              getMoveListFolder();
              break;
            case 2:
              getDeletesListFolder();
              break;
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon ?? "",
                size: 24,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // xóa
  void getDeletesListFolder() {
    if (isCheckPermissionDelete > 0) {
      ToastMessage.show(
          'Có $isCheckPermissionDelete tài liệu không có quyền xóa',
          ToastStyle.error);
      return;
    }

    switch (isCheckPassWord) {
      case 0:
        // tất cả folder không có mật khẩu
        ConfirmDialogFunction(
            content: 'Bạn có muốn xóa không?',
            context: context,
            onAccept: () {
              BottomSheetActionRepository _deleteRepository =
                  BottomSheetActionRepository();
              _deleteRepository.getDeletesListFile(
                  FileUtils.instance.getListStringConvertString(listString),
                  null);
            }).showConfirmDialog();
        break;

      case 1:
        // 1 folder và folder đó có mật khẩu
        if (_listStorageRepository.listCheckDocs.length == 1) {
          ConfirmDialogFunction(
              content: 'Bạn có muốn xóa không?',
              context: context,
              onAccept: () {
                _eventDeleteList();
              }).showConfirmDialog();
        } else {
          ToastMessage.show(
              'Bạn không thể xóa nhiều tài liệu có mật khẩu', ToastStyle.error);
        }
        break;

      default:
        // tất cả folder có nhiều hơn 1 mật khẩu
        ToastMessage.show(
            'Bạn không thể xóa nhiều tài liệu có mật khẩu', ToastStyle.error);
        break;
    }
  }

  _eventDeleteList({String passWord}) async {
    BottomSheetActionRepository _deleteRepository =
        BottomSheetActionRepository();
    int errorCode =
        await _deleteRepository.getDeletesListFile(listString[0], passWord);
    if (isNotNullOrEmpty(errorCode) && errorCode == 1002) {
      _eventDialogAuthenPassWordDelete();
    }
  }

  _eventDialogAuthenPassWordDelete() {
    CustomDialogWidget(
            this.context,
            DialogAuthenPassWordScreen(
              int.parse(listString[0]),
              onSuccessPassWord: (int value, String passWordSuccess) {
                if (value == 1) {
                  // BottomSheetActionRepository _deleteRepository =
                  // BottomSheetActionRepository();
                  // _deleteRepository.getDeletesListFile(listString[0], passWord);
                  _eventDeleteList(passWord: passWordSuccess);
                } else {
                  _eventDialogAuthenPassWordDelete();
                }
              },
            ),
            isClickOutWidget: true)
        .show();
  }

  // di chuyển
  void getMoveListFolder() {
    if (isCheckPermissionMove > 0) {
      ToastMessage.show(
          'Có $isCheckPermissionMove tài liệu không có quyền di chuyển',
          ToastStyle.error);
      return;
    }

    switch (isCheckPassWord) {
      case 0:
        // tất cả folder không có mật khẩu
        eventBus.fire(GetMoveListFileEvent(
            FileUtils.instance.getListStringConvertString(listString), null));
        break;

      case 1:
        // 1 folder và folder đó có mật khẩu
        if (_listStorageRepository.listCheckDocs.length == 1) {
          eventBus.fire(GetMoveListFileEvent(
              FileUtils.instance.getListStringConvertString(listString), null));
        } else {
          ToastMessage.show(
              'Bạn không thể di chuyển nhiều tài liệu có mật khẩu',
              ToastStyle.error);
        }
        break;

      default:
        // tất cả folder có nhiều hơn 1 mật khẩu
        ToastMessage.show('Bạn không thể di chuyển nhiều tài liệu có mật khẩu',
            ToastStyle.error);
        break;
    }
  }

  // ghim
  void getPinListFolder() {
    BottomSheetActionRepository bottomSheetActionRepository =
        BottomSheetActionRepository();
    bottomSheetActionRepository.getPinDoc(
        FileUtils.instance.getListStringConvertString(listString), !isCheckPin);
  }
}

class GetRemoveCheckEventBus {
  GetRemoveCheckEventBus();
}
