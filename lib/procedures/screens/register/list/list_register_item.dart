import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/register/list/option_register_item.dart';

import 'list_register_screen.dart';

class ListRegisterItem extends StatelessWidget {
  ServiceRecords model;

  void Function(ServiceRecords) onUpdateItem;
  void Function(ServiceRecords) onDeleteItem;

  ListRegisterItem({this.model, this.onUpdateItem, this.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: model.priority == 0 ? Colors.grey[300] : Colors.orangeAccent,
                      size: 16,
                    ),
                    Padding(padding: EdgeInsets.only(right: 8)),
                    Expanded(
                        child: Text("${model.title}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text("${model.status}",
                        style: TextStyle(color: Colors.white)),
                  ),
                  decoration: BoxDecoration(
                      color: getColor(model.colorStatus),
                      borderRadius: BorderRadius.circular(10)),
                ),
                _buildRow(Icon(Icons.flag_outlined, color: Colors.grey, size: 16),
                    "Loại thủ tục: ${model.typeName}"),
                _buildRow(Icon(Icons.info_outline, color: Colors.grey, size: 16),
                    "Thủ tục: ${model.serviceName}"),
                _buildRow(Icon(Icons.access_time_outlined, color: Colors.grey, size: 16),
                    "Ngày đăng ký: ${convertTimeStampToHumanDate(model.registeredAt, "dd/MM/yyyy HH:mm")}"),
                _buildRow(Icon(Icons.access_time_outlined, color: Colors.grey, size: 16),
                    "Ngày phản hồi: ${convertTimeStampToHumanDate(model.responseAt, "dd/MM/yyyy HH:mm")}"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.perm_contact_cal_outlined, color: Colors.grey, size: 16,),
                      Padding(padding: EdgeInsets.only(right: 4)),
                      Text("Tình trạng hồ sơ: "),
                      Text(model.statusRecord.name, style: TextStyle(fontSize: 14, color: getColor(model.statusRecord.color)))
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              model.removable || model.editable
                  ? IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [OptionRegisterItem(
                                  model: model,
                                  onDeleteItem: (ServiceRecords item) {
                                    onDeleteItem(item);
                                  },
                                )],
                              );
                            });
                      },
              )
              : SizedBox(),
              IconButton(
                icon: Icon(
                  Icons.star,
                  color:
                      model.favourite.isFavourite ? Colors.amber : Colors.grey,
                  size: 28,
                ),
                onPressed: () {
                  onUpdateItem(model);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(Icon icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          icon,
          Padding(padding: EdgeInsets.only(right: 4)),
          Expanded(child: Text("$value", style: TextStyle(fontSize: 14),))
        ],
      ),
    );
  }
}
