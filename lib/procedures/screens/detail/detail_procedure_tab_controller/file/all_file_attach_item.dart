import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

class AllFileAttachItem extends StatelessWidget {
  AllAttachedFiles model;

  void Function(AllAttachedFiles) onViewFile;
  void Function(AllAttachedFiles) onDownloadFile;
  void Function(AllAttachedFiles) onDeleteFile;

  AllFileAttachItem({this.model, this.onViewFile, this.onDownloadFile, this.onDeleteFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageUtils.instance.getImageType(model.name),
            width: 40,
            height: 40,
          ),
          SizedBox(width: 8,),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.name ?? "", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildRow(Icon(Icons.person, color: Colors.grey, size: 18), model.uploader.name ?? ""),
                _buildRow(Icon(Icons.info_outline, color: Colors.grey, size: 18), "Tên bước: ${model.stepUploadName}"),
                _buildRow(Icon(Icons.access_time_outlined, color: Colors.grey, size: 18), convertTimeStampToHumanDate(model.uploadAt, "dd/MM/yyyy")),
                _buildRow(Icon(model.isEnableSigned ? Icons.check_box_outlined : Icons.check_box_outline_blank, color: model.isEnableSigned ? Colors.blue : Colors.grey, size: 18), "Trình ký")
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const Icon(Icons.remove_red_eye, color: Colors.white, size: 18,),
                  ],
                ),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),),
                onTap: () {
                  onViewFile(model);
                },
              ),
              SizedBox(width: 4),
              InkWell(
                child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                  ],
                ),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50))),
                onTap: () {
                  onDownloadFile(model);
                },
              ),
              Visibility(
                visible: model.isRemovable,
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 4),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outlined, color: Colors.white, size: 18,),
                      ],
                    ),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(50)),),
                  onTap: () {
                    ConfirmDialogFunction(
                      context: context,
                      content: "Bạn có muốn xóa file này không?",
                      onAccept: () {
                        onDeleteFile(model);
                      }
                    ).showConfirmDialog();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRow(Icon icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        Padding(padding: EdgeInsets.only(right: 4)),
        Expanded(child: Text("$value"))
      ],
    );
  }
}
