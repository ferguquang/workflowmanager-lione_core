import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/models/storage_index_response.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/storage/models/events/bottom_sheet_action_event.dart';
import 'package:workflow_manager/storage/models/params/check_download_file_request.dart';
import 'package:workflow_manager/storage/screens/list_storage/list_storage_repository.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action_repository.dart';
import 'package:workflow_manager/storage/widgets/dialog/dialog_get_pass_word.dart';

import '../../utils/ImageUtils.dart';
import '../dialog/dialog_delete_pass_word.dart';
import '../dialog/dialog_set_pass_word.dart';

class BottomSheetAction {
  BuildContext context;

  DocChildItem dataStorage;

  int idParen;

  String typeExtension;

  BottomSheetAction(this.context, this.dataStorage, this.idParen,
      {this.typeExtension});

  double getHeight() {
    List<bool> listDisplay = List<bool>();
    if (dataStorage.isShowPassWord) {
      listDisplay.add(dataStorage.isShowPassWord);
    }
    if (dataStorage.isMove) {
      listDisplay.add(dataStorage.isMove);
    }
    if (dataStorage.isUpdate) {
      listDisplay.add(dataStorage.isUpdate);
    }
    if (dataStorage.isShowReplace) {
      listDisplay.add(dataStorage.isShowReplace);
    }
    listDisplay.add(!dataStorage.isShowPin);
    if (dataStorage.isShowPassWord) {
      listDisplay.add(dataStorage.isShowPassWord);
    }
    if (dataStorage.isShowChangePassWord) {
      listDisplay.add(dataStorage.isShowChangePassWord);
    }
    if (dataStorage.isShowChangePassWord) {
      listDisplay.add(dataStorage.isShowChangePassWord);
    }
    if (dataStorage.isDelete) {
      listDisplay.add(dataStorage.isDelete);
    }
    return (listDisplay.length * 55.0) + 60.0;
  }

  Future<dynamic> showBottomSheetDialog() async {
    if (isNullOrEmpty(dataStorage)) return null;

    return await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return SizedBox(
            height: getHeight(),
            child: Container(
              color: Colors.white,
              child: BottomSheetActionScreen(
                  this.dataStorage, this.context, idParen),
            ),
          );
        });
  }
}

class BottomSheetActionScreen extends StatefulWidget {
  DocChildItem dataStorage;
  BuildContext
      context; // không dc xóa context này(nếu không sẽ không đóng dc dialog)
  int idParen;

  BottomSheetActionScreen(this.dataStorage, this.context, this.idParen);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetActionState();
  }
}

class _BottomSheetActionState extends State<BottomSheetActionScreen> {
  BottomSheetActionRepository _repository = BottomSheetActionRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return ChangeNotifierProvider(
      create: (context) => _repository,
      child: Consumer(
        builder: (context, BottomSheetActionRepository _repository, child) {
          return Scaffold(
            body: SafeArea(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32, top: 16, right: 32, bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: Image.asset(ImageUtils.instance
                                  .checkImageFileWith(
                                      widget.dataStorage?.typeExtension ?? 0)),
                              width: 32,
                              height: 32,
                            ),
                            Expanded(
                              child: Text(
                                widget.dataStorage?.name ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      _iconAndTextWidget(0, widget.dataStorage.isShowDownload,
                          Icons.download_sharp, 'Tải xuống'),
                      _iconAndTextWidget(1, widget.dataStorage.isMove,
                          Icons.folder_special, 'Di chuyển'),
                      _iconAndTextWidget(2, widget.dataStorage.isUpdate,
                          Icons.edit, 'Đổi tên'),
                      _iconAndTextWidget(3, widget.dataStorage.isShowReplace,
                          Icons.content_copy_outlined, 'Thay thế'),
                      _iconAndTextWidget(4, true, Icons.star_border, 'Ghim',
                          isCheckToggle: true),
                      // mặc định là hiển thị isShow = true, isCheckToggle = true
                      _iconAndTextWidget(5, widget.dataStorage.isShowPassWord,
                          Icons.lock, 'Đặt mật khẩu'),
                      _iconAndTextWidget(
                          6,
                          widget.dataStorage.isShowChangePassWord,
                          Icons.lock,
                          'Thay mật khẩu'),
                      _iconAndTextWidget(
                          7,
                          widget.dataStorage.isShowChangePassWord,
                          Icons.lock_open_outlined,
                          'Hủy mật khẩu'),
                      _iconAndTextWidget(
                          8, widget.dataStorage.isDelete, Icons.delete, 'Xóa'),
                    ],
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconAndTextWidget(position, isShow, icon, text, {isCheckToggle}) {
    return Visibility(
      visible: isShow,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          switch (position) {
            case 0: //Tải xuống
              _showFile();
              break;
            case 1: //Di chuyển
              eventBus.fire(GetIDMoveFileEvent(widget.dataStorage?.iD, null));
              break;

            case 2: //Đổi tên
              CustomDialogWidget(widget.context, _showDialogChangeName())
                  .show();
              break;

            case 3: // Thay thế file
              _uploadOtherFile();
              break;

            case 4: //Ghim
              _repository.getPinDoc(widget.dataStorage?.iD.toString(),
                  !widget.dataStorage.isShowPin);
              break;

            case 5: //Đặt mật khẩu
            case 6: //Thay mật khẩu
              _eventClickSavePassWord();
              break;

            case 7: //Hủy mật khẩu
              CustomDialogWidget(context,
                      DialogDeletePassWordScreen(widget.dataStorage?.iD))
                  .show();
              break;

            case 8: //Xóa
              ConfirmDialogFunction(
                  content: 'Bạn có muốn xóa không?',
                  context: widget.context,
                  onAccept: () {
                    _showDialogDelete();
                  }).showConfirmDialog();
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
                icon,
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
              Visibility(
                visible: isCheckToggle == null ? false : isCheckToggle,
                child: Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      !widget.dataStorage.isShowPin
                          ? Icons.toggle_off
                          : Icons.toggle_on_outlined,
                      color: !widget.dataStorage.isShowPin
                          ? Colors.grey
                          : Colors.blue,
                      size: 32,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDialogDelete({String passWord}) async {
    int errorCode = await _repository.getDeletesListFile(
        widget.dataStorage.iD.toString(), passWord);
    if (isNotNullOrEmpty(errorCode) && errorCode == 1002) {
      CustomDialogWidget(this.widget.context, DialogGetPassWordScreen(
        onGetPassListener: (String passWord) async {
          _showDialogDelete(passWord: passWord);
        },
      )).show();
    }
  }

  // Download và xem chi tiết 1 file
  _showFile({String passWord}) async {
    ListStorageRepository _listStorageRepository = ListStorageRepository();
    CheckDownloadFileRequest request = CheckDownloadFileRequest();
    request.idDoc = widget.dataStorage.iD;
    request.accessSafePassword = passWord;
    bool status = await _listStorageRepository.checkBeforeDownloadFile(request);
    if (status) {
      FileUtils.instance.downloadFileAndOpen(widget.dataStorage.name,
          widget.dataStorage.path, this.widget.context);
    } else if (!status && _listStorageRepository.errorCode == 1002) {
      CustomDialogWidget(this.widget.context, DialogGetPassWordScreen(
        onGetPassListener: (String passWord) async {
          _showFile(passWord: passWord);
        },
      )).show();
    }
  }

  // đặt mật khẩu, thay mật khẩu
  _eventClickSavePassWord() {
    String sName = widget.dataStorage.isFolder
        ? 'Thư mục: ${widget.dataStorage?.name}'
        : 'Tài liệu: ${widget.dataStorage?.name}';
    CustomDialogWidget(
            widget.context,
            DialogSetPassWordScreen(
                widget.dataStorage?.iD, sName, widget.dataStorage?.isPassword))
        .show();
  }

  _changeName(String name, int idParent, {String password}) async {
    bool status = await _repository.changeName(
        widget.dataStorage.iD, name, password, idParent);
    if (!status && _repository.errorCode == 1002) {
      // this._eventAuthenPassWord(2); //position = 2: Đổi tên
      CustomDialogWidget(this.widget.context, DialogGetPassWordScreen(
        onGetPassListener: (String passWord) async {
          _changeName(name, idParent, password: passWord);
        },
      )).show();
    }
  }

  _uploadOtherFile({String password, String pathFile}) async {
    String filePathRoot = await _repository.uploadOtherFile(
        this.widget.context, widget.dataStorage?.iD,
        passWord: password, pathFile: pathFile);
    if (filePathRoot != null && _repository.errorCode == 1002) {
      CustomDialogWidget(this.widget.context, DialogGetPassWordScreen(
        onGetPassListener: (String passWord) async {
          _uploadOtherFile(password: passWord, pathFile: filePathRoot);
        },
      )).show();
    }
  }

  // Hiển thị dialog đổi tên
  Widget _showDialogChangeName({String passWord}) {
    TextEditingController searchController =
        TextEditingController(text: widget.dataStorage?.name);
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đổi tên',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: searchController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(),
              FlatButton(
                onPressed: () {
                  Navigator.of(widget.context).pop();
                },
                child: const Text(
                  'HỦY BỎ',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: () {
                  _changeName(searchController.text, widget.idParen,
                      password: passWord);
                  Navigator.of(widget.context).pop();
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
}
