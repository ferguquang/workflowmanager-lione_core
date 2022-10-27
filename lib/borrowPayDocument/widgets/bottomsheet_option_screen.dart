import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/detail_borrow_document/detail_borrow_document_repository.dart';
import 'package:workflow_manager/borrowPayDocument/widgets/bottomsheet_approved/bottomsheet_approved_screen.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

class BottomSheetOptionScreen extends StatefulWidget {
  StgDocBorrows item;
  BuildContext _context;

  BottomSheetOptionScreen(this.item, this._context);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetOptionState();
  }
}

class _BottomSheetOptionState extends State<BottomSheetOptionScreen> {
  DetailBorrowDocumentRepository _repository = DetailBorrowDocumentRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
        builder: (context, DetailBorrowDocumentRepository _repository, child) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 16, right: 16, bottom: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        ImageUtils.instance
                            .getImageType(widget.item?.extension ?? ''),
                        width: 40,
                        height: 40,
                      ),
                      Expanded(
                        child: Text(
                          '  ${widget.item?.name ?? ''}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                _rowIconAndText(Icons.check_circle_outline, 'Duyệt',
                    widget.item?.isApproved, 1),
                _rowIconAndText(
                    Icons.cancel, 'Từ chối', widget.item?.isRejected, 2),
                _rowIconAndText(
                    Icons.folder,
                    widget.item.isForwardVT
                        ? widget.item?.titleForwardVT
                        : widget.item.isForwardLD
                            ? widget.item?.titleForwardLD
                            : '',
                    widget.item.isForwardVT
                        ? true
                        : widget.item.isForwardLD
                            ? true
                            : false,
                    3),
                _rowIconAndText(Icons.cancel, 'Mượn trả văn thư',
                    widget.item?.isBorrowed, 4),
                _rowIconAndText(
                    Icons.cancel, 'Thu hồi', widget.item?.isDisabled, 5),
                _rowIconAndText(Icons.access_time, 'Đóng hồ sơ (Trả lại)',
                    widget.item?.isClosed, 6),
                _rowIconAndText(Icons.delete, 'Xóa phiếu mượn',
                    widget.item?.isBorrowDelete, 7),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _rowIconAndText(IconData icon, String text, bool isShow, int status) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        if (status == 7) {
          showConfirmDialog(
              widget._context, 'Bạn có muốn xóa phiếu đăng ký này không?',
              () async {
            await _repository.getBorrowOptionDelete(widget.item.iD);
            // Navigator.of(widget._context).pop();
          });
        } else {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) {
                return Wrap(
                  children: [
                    // status - duyệt: 1, từ chối: 2, chuyển tiếp: 3, mượn trả: 4, thu hồi: 5, đóng hồ sơ: 6
                    BottomSheetApprovedScreen(status, widget.item),
                  ],
                );
              });
        }
      },
      child: Visibility(
        visible: isShow,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey,
                size: 24,
              ),
              Expanded(
                child: Text(
                  '   $text',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
