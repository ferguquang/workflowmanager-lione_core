import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_search_response.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

class RegisterBorrowDocumentItem extends StatelessWidget {
  StgDocs model;

  RegisterBorrowDocumentItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                ImageUtils.instance
                    .getImageType(model?.extension ?? ''),
                width: 32,
                height: 32,
              ),
              Expanded(
                child: Text(
                  model?.name ?? 0,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Visibility(
            visible: isNotNullOrEmpty(model?.statusName) ? true : false,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: getColor("${model?.statusColor ?? ''}")),
              child: Text(
                isNotNullOrEmpty(model?.statusName) ? model?.statusName : '',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          _rowIconAndText(
              Icon(
                Icons.format_list_numbered_rtl_outlined,
                color: Colors.grey,
                size: 15,
              ),
              'Số ký hiệu: ${model?.symbolNo}'),
          _rowIconAndText(
              Icon(
                Icons.access_time_rounded,
                color: Colors.grey,
                size: 15,
              ),
              'Thời gian tạo tài liệu: ${convertTimeStampToHumanDate(model?.date, Constant.ddMMyyyy)}'),
          _rowIconAndText(
              Icon(
                Icons.error,
                color: Colors.grey,
                size: 15,
              ),
              'Mô tả: ${model?.describe}')
        ],
      ),
    );
  }

  Widget _rowIconAndText(Icon icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          icon,
          Expanded(
            child: Text(
              '  ' + text,
              style: TextStyle(/*color: Colors.grey,*/ fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
