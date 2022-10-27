import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/procedures/models/response/files.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

class VersionFileDetail extends StatefulWidget {
  List<Files> files;

  VersionFileDetail(this.files);

  @override
  _VersionFileDetailState createState() => _VersionFileDetailState();
}

class _VersionFileDetailState extends State<VersionFileDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File đính kèm"),
      ),
      body: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              FileUtils.instance.downloadFileAndOpen(
                  widget.files[index].fileName,
                  widget.files[index].filePath,
                  context);
            },
            child: WidgetListItem(
              isShowInRowInList: true,
              child: Row(
                children: [
                  Expanded(child: Text(widget.files[index].fileName)),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black.withAlpha(120),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
