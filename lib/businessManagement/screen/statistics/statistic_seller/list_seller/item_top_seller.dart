import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/statistic_seller_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_icon_text_widget.dart';

class ItemTopSeller extends StatelessWidget {
  SellerInfos item;
  int index;

  ItemTopSeller(this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleNetworkImage(
              url: item?.sellerAvatar,
              height: 50,
              width: 50,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item?.sellerName,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                RowAndTextWidget(
                  icon: Icons.work_outline,
                  text: item?.deptName,
                ),
                RowAndTextWidget(
                  icon: Icons.person,
                  text: item?.position,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              item?.value,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: index == null
                      ? Colors.blue
                      : index == 0
                          ? Colors.orange
                          : index == 1
                              ? Colors.green[800]
                              : index == 2
                                  ? Colors.amberAccent
                                  : getColor('#444444'),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
