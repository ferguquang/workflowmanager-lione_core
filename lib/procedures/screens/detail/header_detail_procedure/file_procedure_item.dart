import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class FileProcedureItem extends StatelessWidget {

  RegisterAttachedFiles registerAttachedFiles;

  FileProcedureItem({this.registerAttachedFiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.arrow_circle_down,
            color: Colors.blue,
          ),
          Expanded(
            child: Text(
              registerAttachedFiles.name,
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
