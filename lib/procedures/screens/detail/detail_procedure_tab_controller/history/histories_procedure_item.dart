import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class HistoriesProcedureItem extends StatelessWidget {
  Histories model;
  int position;

  HistoriesProcedureItem({this.model, this.position});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: CircleNetworkImage(
                  url: model.createdBy.avatar,
                ),
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bước: ${model.name ?? ""}", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),),
                  Row(
                    children: [
                      Icon(Icons.access_time_outlined, size: 12,),
                      Text(" ${convertTimeStampToHumanDate(model.created, "dd/MM/yyyy HH:mm")}")
                    ],
                  ),
                  Text("Ghi chú: ${model.describe}", style: TextStyle(color: position == 0 ? Colors.red : Colors.black),),
                  Text("Đơn vị phụ trách: ${model.executorName ?? ""}"),
                  Text("Trạng thái xử lý: ${model.statusProcess ?? ""}"),
                  Text("Tiến độ xử lý: ${model.progressTime ?? ""}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
