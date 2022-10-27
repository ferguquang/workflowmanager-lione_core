import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';

class InforValueDetailDialog extends StatefulWidget {
  List<TypeProjectMonies> typeProjectMonies;
  DataFields totalMoneyModel = DataFields();
  DataFields capitalModel = DataFields();
  DataFields grossProfitModel = DataFields();

  InforValueDetailDialog(
      {this.typeProjectMonies,
      this.totalMoneyModel,
      this.capitalModel,
      this.grossProfitModel});

  @override
  _InforValueDetailDialogState createState() => _InforValueDetailDialogState();
}

class _InforValueDetailDialogState extends State<InforValueDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              color: Colors.blue,
            ),
            alignment: Alignment.center,
            child: Text(
              'Giá trị dự án',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng giá trị dự án',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Giá trị: ${widget.totalMoneyModel?.value ?? ''}',
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.totalMoneyModel?.isTemp ?? false
                          ? Colors.red
                          : null),
                ),
                Text(
                  'Giá vốn: ${widget.capitalModel?.value ?? ''}',
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.capitalModel?.isTemp ?? false
                          ? Colors.red
                          : null),
                ),
                Text(
                  'Lãi gộp: ${widget.grossProfitModel?.value ?? ''}',
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.grossProfitModel?.isTemp ?? false
                          ? Colors.red
                          : null),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: widget.typeProjectMonies?.length ?? 0,
            itemBuilder: (context, index) {
              TypeProjectMonies item = widget.typeProjectMonies[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Giá trị dự án (Sản phẩm): ${item?.typeProject?.name}'),
                    Text(
                      'Giá trị: ${item?.totalMoney}',
                      style: TextStyle(
                          fontSize: 14,
                          color: widget.totalMoneyModel?.isTemp ?? false
                              ? Colors.red
                              : null),
                    ),
                    Text(
                      'Giá vốn: ${item?.capital}',
                      style: TextStyle(
                          fontSize: 14,
                          color: widget.capitalModel?.isTemp ?? false
                              ? Colors.red
                              : null),
                    ),
                    Text(
                      'Lãi gộp: ${item?.grossProfit}',
                      style: TextStyle(
                          fontSize: 14,
                          color: widget.grossProfitModel?.isTemp ?? false
                              ? Colors.red
                              : null),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(4),
          )
        ],
      ),
    );
  }
}
