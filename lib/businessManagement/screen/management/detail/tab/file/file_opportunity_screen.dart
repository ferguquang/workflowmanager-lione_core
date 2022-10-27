import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/add_file_phase_dialog.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

import 'file_opportunity_repository.dart';

class FileOpportunityScreen extends StatefulWidget {
  List<Attachments> attachments;
  bool isOnlyView;
  bool isAddFile;
  List<Status> listPhaseFile;
  int idOpportunity;

  FileOpportunityScreen(this.attachments, this.isOnlyView, this.isAddFile,
      this.listPhaseFile, this.idOpportunity);

  @override
  _FileOpportunityScreenState createState() => _FileOpportunityScreenState();
}

class _FileOpportunityScreenState extends State<FileOpportunityScreen> {
  FileOpportunityRepository _repository = FileOpportunityRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, FileOpportunityRepository __repository1, child) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: getColor('#f1f1f1'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.attachments?.length ?? 0} tài liệu',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Visibility(
                        visible: /*!widget.isOnlyView && */ widget.isAddFile ??
                            false,
                        child: InkWell(
                          onTap: () {
                            _eventCallApiCreateFile();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            child: Text('Tạo mới +'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.attachments?.length ?? 0,
                    itemBuilder: (context, index) {
                      Attachments item = widget.attachments[index];
                      return _itemFile(item);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemFile(Attachments item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              // sửa
              Visibility(
                visible: !widget.isOnlyView && item.isEdit,
                child: InkWell(
                  onTap: () {
                    if (!widget.isOnlyView && item.isEdit) {
                      _eventCallApiChangeFile(item);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue,
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Sửa ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.edit,
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
                      _eventCallApiDeleteFile(item);
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
          Text(item?.phaseName)
        ],
      ),
    );
  }

  //tạo mói file
  _eventCallApiCreateFile() {
    CustomDialogWidget(
            context,
            AddFilePhaseDialog(
              isCreate: false,
              listPhaseFile: widget.listPhaseFile,
              idOpportunity: widget.idOpportunity,
              onModel: (data) {
                setState(() {
                  widget.attachments.add(data);
                });
              },
            ),
            isClickOutWidget: true)
        .show();
  }

  // chính sửa
  _eventCallApiChangeFile(Attachments item) {
    Status phase = Status();
    phase.iD = item?.phaseID;
    phase.name = item?.phaseName;
    CustomDialogWidget(
            context,
            AddFilePhaseDialog(
              phase: phase,
              fileName: item?.fileName ?? '',
              idFile: item?.iD ?? 0,
              isCreate: true,
              listPhaseFile: widget.listPhaseFile,
              idOpportunity: widget.idOpportunity,
              onModel: (data) {
                setState(() {
                  widget.attachments[widget.attachments
                      .indexWhere((element) => element.iD == data.iD)] = data;
                });
              },
            ),
            isClickOutWidget: true)
        .show();
  }

  // xóa
  _eventCallApiDeleteFile(Attachments item) {
    ConfirmDialogFunction(
        content: 'Bạn có muốn xóa file đính kèm không?',
        context: context,
        onAccept: () async {
          bool status = await _repository.getDeleteFileOpportunity(item?.iD);
          if (status) {
            setState(() {
              widget.attachments?.remove(item);
            });
          }
        }).showConfirmDialog();
  }
}
