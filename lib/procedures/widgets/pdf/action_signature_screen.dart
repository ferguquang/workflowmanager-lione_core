import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/condition.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_bottom_sheet.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_item.dart';

class ActionSignatureScreen extends StatefulWidget {
  List<Conditions> actions;
  int idServiceRecord;
  String title;
  void Function() onDismiss;

  ActionSignatureScreen(this.actions, this.idServiceRecord, this.title, {this.onDismiss});

  @override
  _ActionSignatureDialogState createState() => _ActionSignatureDialogState();
}

class _ActionSignatureDialogState extends State<ActionSignatureScreen> {
  List<Conditions> actions;

  @override
  void initState() {
    super.initState();
    actions = widget.actions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Center(child: Text("Xác nhận chuyển hồ sơ", style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: actions.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: ActionItem(
                    model: actions[index],
                  ),
                  onTap: () async {
                    await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          actions[index].titleHoSo = widget.title;
                          return ActionBottomSheet(
                            conditions: actions[index],
                            idServiceRecord: widget.idServiceRecord,
                          );
                        });

                    widget.onDismiss();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
