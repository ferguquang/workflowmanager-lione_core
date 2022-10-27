import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/processed_content.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/processed_content/dialog_processed_content.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';

class ProcessedContentItem extends StatelessWidget {
  ProcessedContent model;
  int taskType;
  int position;

  void Function(ProcessedContent) onDelete;
  void Function(Map<String, dynamic>, int position) onEdit;
  void Function(Map<String, dynamic>) onAdd;

  ProcessedContentItem(
      {@required this.model,
      this.position,
      this.onDelete,
      this.onEdit,
      this.onAdd});

  Widget _displayPopup(BuildContext context) {
    return Visibility(
      visible:
          context.findAncestorWidgetOfExactType<TaskDetailsScreen>().typeTask ==
              1,
      child: PopupMenuButton<int>(
        child: Icon(Icons.more_vert),
        offset: Offset(0, -20),
        onSelected: (int result) {
          if (result == 1) {
            ConfirmDialogFunction(
              content: 'Bạn có muốn xóa nội dung này không?',
              context: context,
              onAccept: () {
                onDelete(model);
                return true;
              },
            ).showConfirmDialog();
          } else if (result == 0) {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return DialogProcessedContent(
                    isAdd: false,
                    model: model,
                    onUpdateListDialog: (Map<String, dynamic> params) {
                      onEdit(params, position);
                    },
                  );
                });
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<int>(
            value: 0,
            child: Text('Sửa'),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.blue,
            size: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('${model.created.toDate()} | ${model.processTime.toTime()}'),
                  Text(
                      '${model.created.toDateFormat()} | ${model.processTime}'),
                  Text(model.describe),
                ],
              ),
            ),
          ),
          _displayPopup(context)
        ],
      ),
    );
  }
}
