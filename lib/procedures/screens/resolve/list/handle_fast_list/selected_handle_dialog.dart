import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/procedures/models/response/record_is_resolve_list_response.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/selected_handle_item.dart';

class SelectedHandleDialog extends StatefulWidget {
  List<ActionsResolve> actions;
  void Function(ActionsResolve) onSelected;

  SelectedHandleDialog({this.actions, this.onSelected});

  @override
  _SelectedHandleDialogState createState() => _SelectedHandleDialogState();
}

class _SelectedHandleDialogState extends State<SelectedHandleDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: (widget.actions.length * 50).toDouble() + 150,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Chọn cách xử lý".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.actions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      int idSelected = widget.actions[index].iDSchemaCondition;
                      for (int i = 0; i < widget.actions.length; i++) {
                        if (widget.actions[i].iDSchemaCondition == idSelected) {
                          if (widget.actions[i].isSelected) {
                            widget.actions[i].isSelected = false;
                          } else {
                            widget.actions[i].isSelected = true;
                          }
                        } else {
                          widget.actions[i].isSelected = false;
                        }
                      }
                    });
                  },
                  child: SelectedHandleItem(
                    action: widget.actions[index],
                  ),
                );
              },
            ),
          ),
          SaveButton(
            margin: EdgeInsets.all(8),
            title: "Xác nhận".toUpperCase(),
            onTap: () {
              ActionsResolve actionSelected;
              for (int i = 0; i < widget.actions.length; i ++) {
                if (widget.actions[i].isSelected) {
                  actionSelected = widget.actions[i];
                }
              }

              if (actionSelected != null) {
                widget.onSelected(actionSelected);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
