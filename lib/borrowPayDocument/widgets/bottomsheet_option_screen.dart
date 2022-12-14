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
                _rowIconAndText(Icons.check_circle_outline, 'Duy???t',
                    widget.item?.isApproved, 1),
                _rowIconAndText(
                    Icons.cancel, 'T??? ch???i', widget.item?.isRejected, 2),
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
                _rowIconAndText(Icons.cancel, 'M?????n tr??? v??n th??',
                    widget.item?.isBorrowed, 4),
                _rowIconAndText(
                    Icons.cancel, 'Thu h???i', widget.item?.isDisabled, 5),
                _rowIconAndText(Icons.access_time, '????ng h??? s?? (Tr??? l???i)',
                    widget.item?.isClosed, 6),
                _rowIconAndText(Icons.delete, 'X??a phi???u m?????n',
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
              widget._context, 'B???n c?? mu???n x??a phi???u ????ng k?? n??y kh??ng?',
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
                    // status - duy???t: 1, t??? ch???i: 2, chuy???n ti???p: 3, m?????n tr???: 4, thu h???i: 5, ????ng h??? s??: 6
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
