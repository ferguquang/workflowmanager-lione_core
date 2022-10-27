import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';

class ListResolveItem extends StatelessWidget {
  ServiceRecords model;
  int position;
  int state;

  void Function(ServiceRecords, int) onUpdateItem;
  void Function(ServiceRecords) onRatingItem;

  ListResolveItem(
      {this.model,
      this.position,
      this.state,
      this.onUpdateItem,
      this.onRatingItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle,
                        color: model.priority == 0
                            ? Colors.grey[300]
                            : Colors.orangeAccent,
                        size: 16),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text("${model.processRecord.name}",
                        style: TextStyle(color: Colors.white)),
                  ),
                  decoration: BoxDecoration(
                      color: getColor(model.colorStatus),
                      borderRadius: BorderRadius.circular(10)),
                ),
                _buildRow(
                    Icon(Icons.flag_outlined, color: Colors.grey, size: 16),
                    "Loại thủ tục: ${model.typeName}"),
                _buildRow(
                    Icon(Icons.info_outline, color: Colors.grey, size: 16),
                    "Thủ tục: ${model.serviceName}"),
                _buildRow(
                    Icon(Icons.access_time_outlined,
                        color: Colors.grey, size: 16),
                    "Ngày đăng ký: ${convertTimeStampToHumanDate(model.registeredAt, "dd/MM/yyyy HH:mm")}"),
                _createBy("${model.createdBy.avatar}", model.createdBy.name),
                _buildRow(
                    Icon(Icons.access_time_outlined,
                        color: Colors.grey, size: 16),
                    "Thời gian còn lại: ${model.remainTime}"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.perm_contact_cal_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      Padding(padding: EdgeInsets.only(right: 4)),
                      Row(
                        children: [
                          // Icon(Icons.perm_contact_cal_outlined, color: Colors.grey, size: 16,),
                          Text("Tình trạng hồ sơ: "),
                          Text(model.statusRecord.name,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: getColor(model.statusRecord.color)))
                        ],
                      ),
                      // RichText(
                      //   text: TextSpan(
                      //       text: "Tình trạng hồ sơ: ",
                      //       style: TextStyle(color: Colors.black, fontSize: 12),
                      //       children: [
                      //         TextSpan(text: "${model.statusRecord.name}", style: TextStyle(color: getColor(model.statusRecord.color)))
                      //       ]
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: state == 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: state == 1 && model.isResolve == 1,
                child: IconButton(
                  icon: Icon(Icons.check_circle,
                      color: model.isSelected ? Colors.blue : Colors.grey),
                  onPressed: () {
                    onUpdateItem(model, position);
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  onRatingItem(model);
                },
                icon: Icon(Icons.star,
                    color: model.favourite.isFavourite
                        ? Colors.amber
                        : Colors.grey,
                    size: 28),
              )
            ],
          )
        ],
      ),
    );
    ;
  }

  Widget _createBy(String avatarUrl, String value) {
    return Row(
      children: [
        Icon(
          Icons.person_pin_outlined,
          color: Colors.grey,
          size: 16,
        ),
        Text(" Người đăng ký: "),
        CachedNetworkImage(
          imageUrl: avatarUrl,
          errorWidget: (context, url, error) => Icon(
            Icons.account_circle_sharp,
            color: Colors.grey,
            size: 16,
          ),
          imageBuilder: (context, imageProvider) {
            return Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            );
          },
        ),
        Expanded(child: Text(" $value"))
      ],
    );
  }

  Widget _buildRow(Icon icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          Padding(padding: EdgeInsets.only(right: 4)),
          Expanded(child: Text("$value", style: TextStyle(fontSize: 14)))
        ],
      ),
    );
  }
}
