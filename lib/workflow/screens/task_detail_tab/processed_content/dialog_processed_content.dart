import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/processed_content.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/processed_content/processed_request.dart';

class DialogProcessedContent extends StatelessWidget {
  var timeController = TextEditingController();

  var describeController = TextEditingController();

  void Function(Map<String, dynamic>) onUpdateListDialog;

  bool isAdd = false;
  ProcessedContent model;
  int position;
  int taskId;

  DialogProcessedContent(
      {this.taskId,
      @required this.isAdd,
      this.model,
      this.position,
      @required this.onUpdateListDialog});

  @override
  Widget build(BuildContext context) {
    if (!isAdd) {
      timeController.text = model?.processTime;
      describeController.text = model?.describe;
    }

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
            isAdd
                ? 'Thêm nội dung xử lý'.toUpperCase()
                : 'Sửa nội dung xử lý'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  DateTimePickerWidget(
                          context: context,
                          onDateTimeSelected: (valueDate) {
                            timeController.text = valueDate;
                          },
                          format: Constant.HHmm)
                      .showOnlyTimePicker();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thời gian'),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: TextField(
                            autofocus: false,
                            controller: timeController,
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                        Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(color: "#DDDDDD".toColor()),
              Container(
                child: TextField(
                  controller: describeController,
                  // textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Giải thích',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Divider(color: "#DDDDDD".toColor()),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('HỦY'),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        if (isNullOrEmpty(timeController.text)) {
                          ToastMessage.show("Thời gian không được để trống",
                              ToastStyle.error);
                          return false;
                        }
                        if (isNullOrEmpty(describeController.text)) {
                          ToastMessage.show("Giải thích không được để trống",
                              ToastStyle.error);
                          return false;
                        }

                        ProcessedRequest processedRequest = ProcessedRequest();
                        processedRequest.describe = describeController.text;
                        processedRequest.time = timeController.text;
                        if (!isAdd) {
                          processedRequest.idJob = model.iDJob;
                          processedRequest.idJobHistory = model.iD;
                        } else {
                          processedRequest.idJob = taskId;
                        }
                        onUpdateListDialog(processedRequest.getParams());
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      child: Text('Xác nhận'.toUpperCase(),
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
