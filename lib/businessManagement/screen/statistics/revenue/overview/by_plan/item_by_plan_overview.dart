import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

// thực tế chia cho kế hoạch
class ItemByPlanOverView extends StatelessWidget {
  ProjectQuaterChartInfos item;

  ItemByPlanOverView(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              item.lable,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            // thực tế chia cho kế hoạch
            child: Text(
              "${item.actual}/${item.committed}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Expanded(
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: 16,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[350],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          getColor("${item?.actualColor}")),
                      value: item?.percent / 100,
                    )),
              ),
              Text(
                "${item.percent != 0.0 ? item.percent : 0}%",
                style: TextStyle(color: Colors.white),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
