import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_model.dart';

class AddFileProcedureItem extends StatelessWidget {
  AddFileProcedureModel model;
  bool isEnableAttachSignFile;
  void Function(AddFileProcedureModel) onUpdateItem;

  AddFileProcedureItem({this.model, this.isEnableAttachSignFile, this.onUpdateItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.fileName, style: TextStyle(color: Colors.blue),),
          InkWell(
            onTap: () {
              onUpdateItem(model);
            },
            child: Visibility(
              visible: isEnableAttachSignFile,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  model.isCheck ? Icon(Icons.check_box_outlined, color: Colors.blue,) : Icon(Icons.check_box_outline_blank, color: Colors.grey,),
                  Padding(padding: EdgeInsets.only(right: 4)),
                  Expanded(child: Text("Trình ký"))
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
