import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

import 'file_contract_repository.dart';

// lần sau có thể xóa code thừa
class FileContractScreen extends StatefulWidget {
  List<Attachments> attachments;
  List<Attachments> attachmentsDeploy;
  bool isOnlyView;
  // bool isAddFile;
  // int iDTarget;

  FileContractScreen(
      {this.attachments,
      this.attachmentsDeploy,
      this.isOnlyView /*, this.isAddFile, this.iDTarget*/});

  @override
  _FileContractScreenState createState() => _FileContractScreenState();
}

class _FileContractScreenState extends State<FileContractScreen> {
  FileContractRepository _repository = FileContractRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, FileContractRepository __repository1, child) {
          return Container(
            color: Colors.white,
            child: isNullOrEmpty(widget.attachments) &&
                    isNullOrEmpty(widget.attachmentsDeploy)
                ? EmptyScreen()
                : ListView(
                    children: [
                      _getListViewFileHeader('file đính kèm hợp đồng gốc',
                          widget.attachments?.length),
                      _getListViewFile(widget.attachments, true),
                      _getListViewFileHeader(
                          'file đính kèm hợp đồng triển khai',
                          widget.attachmentsDeploy?.length),
                      _getListViewFile(widget.attachmentsDeploy, false),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _getListViewFile(List<Attachments> listData, bool isCheck) {
    return Visibility(
      visible: isNotNullOrEmpty(listData),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listData?.length ?? 0,
        itemBuilder: (context, index) {
          Attachments item = listData[index];
          return _itemFile(item, isCheck);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget _getListViewFileHeader(String title, int sizeList) {
    return Visibility(
      visible: sizeList == 0 ? false : true,
      child: Container(
        padding: EdgeInsets.all(16),
        color: getColor('#f1f1f1'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${sizeList ?? 0} $title',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            // module hiện tại ẩn tạo mới và xóa file
            // Visibility(
            //   visible: !widget.isOnlyView && !widget.isAddFile,
            //   child: InkWell(
            //     onTap: () {
            //       _eventClickAddFile();
            //     },
            //     child: Container(
            //       padding: EdgeInsets.symmetric(
            //           horizontal: 16, vertical: 4),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(50),
            //           color: Colors.white),
            //       child: Text('Thêm mới +'),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // _eventClickAddFile() async {
  //   Attachments model =
  //       await _repository.eventClickAddFile(context, widget.iDTarget);
  //   if (model != null) {
  //     setState(() {
  //       widget.attachments?.add(model);
  //     });
  //   }
  // }

  Widget _itemFile(Attachments item, bool isCheck) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                ImageUtils.instance.getImageType(item?.filePath ?? ''),
                width: 32,
                height: 32,
              ),
              Expanded(
                child: Text(
                  item?.fileName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: getColor('#3e444b')),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // xem
              Visibility(
                visible: item.isView ?? true,
                child: InkWell(
                  onTap: () {
                    if (isNotNullOrEmpty(item?.filePath))
                      FileUtils.instance.downloadFileAndOpen(
                          item?.fileName, item?.filePath, context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 4, bottom: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: getColor('#8cc474'),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Xem ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.download_sharp,
                          color: Colors.white,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // xóa
              Visibility(
                visible: !widget.isOnlyView && item.isDelete,
                child: InkWell(
                  onTap: () {
                    if (!widget.isOnlyView && item.isDelete) {
                      _eventCallApiDeleteFile(item, isCheck);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey,
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Xóa ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // xóa
  _eventCallApiDeleteFile(Attachments item, bool isCheck) {
    ConfirmDialogFunction(
        content: 'Bạn có muốn xóa file đính kèm này không?',
        context: context,
        onAccept: () async {
          bool status = await _repository.getDeleteFileOpportunity(item?.iD);
          if (status) {
            setState(() {
              isCheck
                  ? widget.attachments?.remove(item)
                  : widget.attachmentsDeploy?.remove(item);
            });
          }
        }).showConfirmDialog();
  }
}
