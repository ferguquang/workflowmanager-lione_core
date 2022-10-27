import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/procedures/models/response/FCFileModel.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/base/single_field_widget_base.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class SingleFieldFileWidget extends SingleFieldWidgetBase {
  SingleFieldFileWidget(Field field, bool isReadonly, bool isViewInOneRow,
      {GlobalKey key, double verticalPadding = 4})
      : super(field, isReadonly, isViewInOneRow,
            key: key, verticalPadding: verticalPadding);

  @override
  _SingleFieldFileWidgetState createState() => _SingleFieldFileWidgetState();
}

class _SingleFieldFileWidgetState
    extends SingleFieldWidgetBaseState<SingleFieldFileWidget> {
  List<FCFileModel> files = [];

  @override
  void initState() {
    super.initState();
    field = widget.field;
    files = [];
    if (isNotNullOrEmpty(field.value)) {
      var json = jsonDecode(field.value);
      if (isNotNullOrEmpty(json)) {
        json.forEach((v) {
          files.add(FCFileModel.fromJson(v));
        });
      }
    }
  }
  bool _isReadonly(){
    return widget.isReadonly || widget.field.isReadonly;
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible(),
      child: WidgetListItem(
        isShowInRowInList: isShowInRowInList,
        child: InkWell(
          onTap: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Wrap(
                    children: [
                      Column(
                        children: [
                          TitleDialog(
                            widget.field.name,
                            isShowCloseButton: !_isReadonly(),
                            iconData: Icons.add_circle_outline_rounded,
                            onTab: () async {
                              if (field.isMultiple == false &&
                                  files.length == 1) {
                                showErrorToast("Chỉ được chọn 1 file.");
                                return;
                              }
                              UploadModel file = await FileUtils.instance
                                  .uploadFileFromSdcard(context);
                              if (file != null) {
                                files.add(
                                    FCFileModel(file.fileName, file.filePath));
                                var json =
                                    files.map((e) => e.toJson()).toList();
                                String value = jsonEncode(json);
                                field.value = value;
                                setState(() {});
                              }
                            },
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: isNullOrEmpty(files)
                                ? Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Text("Không có file nào."),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: files.length,
                                    itemBuilder: (context, index) {
                                      FCFileModel fileModel = files[index];
                                      return InkWell(
                                        onTap: () {
                                          FileUtils.instance
                                              .downloadFileAndOpen(
                                                  fileModel.fileName,
                                                  fileModel.filePath,
                                                  context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  files[index]?.fileName ?? "",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                              Visibility(
                                                visible: !_isReadonly(),
                                                child: InkWell(
                                                  onTap: () {
                                                    ConfirmDialogFunction
                                                        dialog =
                                                        ConfirmDialogFunction(
                                                      context: context,
                                                      content:
                                                          "Bạn có muốn xóa file này không?",
                                                      onAccept: () {
                                                        files.removeAt(index);
                                                        var json = files
                                                            .map((e) =>
                                                                e.toJson())
                                                            .toList();
                                                        String value =
                                                            jsonEncode(json);
                                                        field.value = value;
                                                        setState(() {});
                                                      },
                                                    );
                                                    dialog.showConfirmDialog();
                                                  },
                                                  child: Container(
                                                    child: Icon(Icons.close),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SaveButton(
                                title: "Xong",
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                });
              },
            );
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  child: SVGImage(
                    svgName: "attach_file",
                  ),
                ),
                Text(field.name),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(files.length.toString()),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.orange),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
