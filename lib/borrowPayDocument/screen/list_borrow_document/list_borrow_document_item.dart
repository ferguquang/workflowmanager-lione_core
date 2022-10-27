import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/detail_borrow_document/detail_borrow_document_screen.dart';
import 'package:workflow_manager/borrowPayDocument/widgets/bottomsheet_option_screen.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

class ListBorrowDocumentItem extends StatelessWidget {
  StgDocBorrows item;
  BuildContext _context;

  ListBorrowDocumentItem(this.item, this._context);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _eventClickOpenFile();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        ImageUtils.instance.getImageType(item?.extension),
                        width: 32,
                        height: 32,
                      ),
                      Expanded(
                        child: Text(
                          item?.name ?? '',
                          style: TextStyle(
                              decoration: isNotNullOrEmpty(item.path)
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationColor: Colors.blue,
                              color: isNotNullOrEmpty(item.path)
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: getColor('${item?.statusColor}')),
                  child: Text(
                    item?.statusName,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                Visibility(
                  child: _rowIconAndTextReject(
                      Icons.error_outline, item?.reasonRD),
                  visible: item?.statusID == 3 ? true : false,
                ),
                _rowIconAndText(Icons.error_outline,
                    'Mục đích mượn: ${_getConvertListToString()}'),
                _rowIconAndText(Icons.access_time_rounded,
                    'Thời gian mượn: ${convertTimeStampToHumanDate(item?.startDate, Constant.ddMMyyyy)} - ${convertTimeStampToHumanDate(item?.endDate, Constant.ddMMyyyy)} '),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Text(
                        ' Người mượn ',
                        style: TextStyle(fontSize: 13),
                      ),
                      CircleNetworkImage(
                        url: '$_getRoot',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (!item.isSelected) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) {
                          return Wrap(
                            children: [
                              BottomSheetOptionScreen(item, context),
                            ],
                          );
                        });
                  }
                },
              ),
              Visibility(
                visible: item?.isSelected,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Image.asset(
                    'assets/images/selected.png',
                    width: 28,
                    height: 28,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rowIconAndText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 15,
          ),
          Expanded(
            child: Text(
              ' $text',
              style: TextStyle(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  Widget _rowIconAndTextReject(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.red,
            size: 15,
          ),
          Expanded(
            child: Text(
              ' Lý do: $text',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  // link root
  Future<String> _getRoot() async {
    String root = await SharedPreferencesClass.getRoot();
    return /*item.borrower.avatar =*/ root + item.borrower.avatar;
  }

  _getConvertListToString() {
    String borrow = item.purposes.map((e) => e).toList().toString();
    borrow = borrow.replaceAll('[', '').replaceAll(']', '');
    return borrow;
  }

  _eventClickOpenFile() {
    if (isNotNullOrEmpty(item.path))
      FileUtils.instance.downloadFileAndOpen(item.name, item.path, _context);
    else
      pushPage(_context, DetailBorrowDocumentScreen(item?.iD));
  }
}
