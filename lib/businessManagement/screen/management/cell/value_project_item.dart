import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';

class ValueProjectItem extends StatelessWidget {
  TypeProjectMoney item;
  int index;
  final void Function() onTypeProjects;

  ValueProjectItem(this.item, this.index, {this.onTypeProjects});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Giá trị dự án: $index',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                _buildRowText(
                    'Loại dự án (Sản phẩm): ', item?.nameTypeProject ?? ""),
                _buildRowText('Giá trị: ', item?.moneyTotalMoney),
                _buildRowText('Giá vốn: ', item?.moneyCapital),
                _buildRowText('Lãi gộp: ', item?.grossProfit),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              onTypeProjects();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowText(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
          Expanded(
              child: Text(
            value,
            style: TextStyle(color: Colors.grey),
          )),
        ],
      ),
    );
  }
}
