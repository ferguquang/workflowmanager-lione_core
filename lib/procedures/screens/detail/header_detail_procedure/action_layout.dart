import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/event_show_action.dart';

import 'action/action_bottom_sheet.dart';
import 'action/action_item.dart';
import 'add_action/add_action_bottom_sheet.dart';

class ActionLayout extends StatefulWidget {
  List<Conditions> conditions;
  DataProcedureDetail dataProcedureDetail;
  bool isReject;

  ActionLayout({Key key, this.conditions, this.dataProcedureDetail, this.isReject}) : super(key: key);

  @override
  State<ActionLayout> createState() => _ActionLayoutState();
}

class _ActionLayoutState extends State<ActionLayout> {
  List<Conditions> conditions;
  DataProcedureDetail dataProcedureDetail;
  bool isReject;

  @override
  void initState() {
    super.initState();

    eventBus.on<EventShowAction>().listen((event) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            conditions[index].titleHoSo = dataProcedureDetail.title;
            return ActionBottomSheet(
              conditions: conditions[index],
              idServiceRecord:
              dataProcedureDetail.iDServiceRecord,
              isReject: isReject,
              isFinish: true,
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    conditions = widget.conditions;
    dataProcedureDetail = widget.dataProcedureDetail;
    isReject = widget.isReject;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Xử lý hồ sơ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  // Icon(Icons.arrow_circle_down, color: Colors.grey)
                ],
              ),
            ),
            decoration: BoxDecoration(color: Colors.grey[200]),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: dataProcedureDetail.addAction == null /*&& dataProcedureDetail.addAction.name.isNotEmpty */? conditions.length : conditions.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == conditions.length) {
                  return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (_) {
                              return Wrap(
                                children: [
                                  AddActionBottomSheet(
                                    idServiceRecord: dataProcedureDetail.iDServiceRecord,
                                    addAction: dataProcedureDetail.addAction,
                                  )
                                ],
                              );
                            }
                        );
                      },
                      child: dataProcedureDetail.addAction.name != null ? _addActionWidget(dataProcedureDetail.addAction) : Container()
                  );
                }
                return InkWell(
                  child: ActionItem(
                    model: conditions[index],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          conditions[index].titleHoSo = dataProcedureDetail.title;
                          return ActionBottomSheet(
                            conditions: conditions[index],
                            idServiceRecord:
                            dataProcedureDetail.iDServiceRecord,
                            isReject: isReject,
                            isFinish: true,
                          );
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _addActionWidget(AddAction addAction) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(addAction.action, style: TextStyle(fontSize: 14),),
          Card(
              color: getColor(addAction.color),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(addAction.name, style: TextStyle(color: Colors.white, fontSize: 12),),
              )
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[200])
      ),
    );
  }
}
