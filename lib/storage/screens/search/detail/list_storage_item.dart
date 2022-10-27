import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/storage_index_response.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action.dart';

class ListStorageItem extends StatelessWidget {
  DocChildItem item;
  int idParen;
  ListStorageItem(this.item, this.idParen);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Image.asset(
            !item.isCheck
                ? ImageUtils.instance.checkImageFileWith(item?.typeExtension)
                : 'assets/images/selected.png',
            width: 32,
            height: 32,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      item?.name ?? "",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: item?.isPassword ?? false,
                      child: Icon(
                        Icons.lock,
                        size: 12,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Flexible(
                        child: Text(
                      '${convertTimeStampToHumanDate(item?.created, "dd/MM/yyyy")} bởi ${item?.createBy}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              BottomSheetAction(context, item, idParen).showBottomSheetDialog();
            },
            icon: Icon(
              Icons.more_vert_sharp,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
