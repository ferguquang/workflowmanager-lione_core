import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/step_template_file.dart';

class StepTemplateFileItem extends StatelessWidget {
  StepTemplateFile stepTemplateFile;

  void Function(StepTemplateFile) onDownloadFile;
  void Function(StepTemplateFile) onUploadOrDeleteFile;

  StepTemplateFileItem({this.stepTemplateFile, this.onUploadOrDeleteFile, this.onDownloadFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stepTemplateFile.name),
                    stepTemplateFile.isRequired ? Text("*", style: TextStyle(color: Colors.red),) : Container()
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      child: Icon(stepTemplateFile.uploadedFile == null || isNullOrEmpty(stepTemplateFile.uploadedFile.uploadedFileName) ? Icons.add_circle_outline_outlined : Icons.remove_circle_outline_outlined, color: Colors.grey,),
                      onTap: () {
                        onUploadOrDeleteFile(stepTemplateFile);
                      },
                    ),
                    Expanded(child: Text((isNotNullOrEmpty(stepTemplateFile.uploadedFile.uploadedFileName) ? stepTemplateFile.uploadedFile.uploadedFileName : ""), style: TextStyle(color: Colors.blue),))
                  ],
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              onDownloadFile(stepTemplateFile);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(child: Icon(Icons.download_rounded, color: Colors.grey, size: 14,)),
                        Text(" Tải mẫu", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
