import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_listview_loading_refresh_widget.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_index_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/detail_borrow_document/detail_borrow_document_screen.dart';
import 'package:workflow_manager/borrowPayDocument/screen/list_borrow_document/list_borrow_document_item.dart';
import 'package:workflow_manager/borrowPayDocument/screen/list_borrow_document/list_borrow_document_repository.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/register_borrow_document_screen.dart';
import 'package:workflow_manager/main.dart';

class ListBorrowDocumentScreen extends StatefulWidget {
  /* status của các tab
 chờ duyệt 2
 Đã duyệt 1
 từ chối 3
 quá hạn duyệt 4
 đã cho mượn 5
 quá hạn mượn 10
 thu hồi 6
 đã trả 7
 */
  // các param không được thay đổi
  static final int TOTAL_PENDING = 2;
  static final int TOTAL_APPROVED = 1;
  static final int TOTAL_REJECTED = 3;
  static final int TOTAL_APPROVED_EXPRIED = 4;
  static final int TOTAL_BORROWED = 5;
  static final int TOTAL_BORROWED_EXPRIED = 10;
  static final int TOTAL_DISABLED = 6;
  static final int TOTAL_CLOSE = 7;
  String nameTab;
  int number;
  int status;
  String numberAndName;

  final void Function(bool isCheckFunCallBack) onIsCheckFunCallBack;
  final void Function(String textSearch) onIsCheckTextSearch;

  ListBorrowDocumentScreen(this.status, this.number, this.nameTab,
      {this.onIsCheckFunCallBack, this.onIsCheckTextSearch});

  @override
  State<StatefulWidget> createState() {
    return _ListBorrowDocumentSate();
  }
}

class _ListBorrowDocumentSate extends State<ListBorrowDocumentScreen> {
  String startDate;
  String endDate;
  bool isCheckSort = false;
  bool isShowAction = true; // true show floating, false show widget delete
  int countSelectedItem = 0;

  ListBorrowDocumentRepository _repository = ListBorrowDocumentRepository();
  StreamSubscription _dataBorrowApproved;
  StreamSubscription _dataBorrowRemove;
  StreamSubscription _dataSearchAppbar;

  String textSearch;
  String numberAndName = '';

  void _listenerEventBus() {
    if (isNotNullOrEmpty(_dataBorrowApproved)) _dataBorrowApproved.cancel();
    _dataBorrowApproved =
        eventBus.on<GetDataBorrowApprovedEvent>().listen((event) {
      // truyên từ các action của class bottomsheet_option_repository.dart
      setState(() {
        _repository.pullToRefreshData();
        _hideWidgetDelete();
        _getBorrowIndex();
      });
    });

    if (isNotNullOrEmpty(_dataBorrowRemove)) _dataBorrowRemove.cancel();
    _dataBorrowRemove = eventBus.on<GetDataBorrowDeleteEvent>().listen((event) {
      // truyền từ detail_borrow_document_repository.dart qua
      setState(() {
        _repository.pullToRefreshData();
        _hideWidgetDelete();
        _getBorrowIndex();
      });
    });

    if (isNotNullOrEmpty(_dataSearchAppbar)) _dataSearchAppbar.cancel();
    _dataSearchAppbar = eventBus.on<GetDataBorrowSearchEvent>().listen((event) {
      // truyền từ tab_borrow_pay_document_screen.dart qua
      setState(() async {
        textSearch = event.textSearch;
        await _repository.getSearchIndex(textSearch);
        if (isNotNullOrEmpty(textSearch))
          numberAndName = '${_repository.searchedData.length}${widget.nameTab}';
        else
          _getCountHeader();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCountHeader();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getBorrowIndex();
      _listenerEventBus();
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (isNotNullOrEmpty(_dataBorrowApproved)) _dataBorrowApproved.cancel();
    if (isNotNullOrEmpty(_dataBorrowRemove)) _dataBorrowRemove.cancel();
    if (isNotNullOrEmpty(_dataSearchAppbar)) _dataSearchAppbar.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
        builder: (context, ListBorrowDocumentRepository _repository, child) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                isNullOrEmpty(textSearch)
                                    ? '${widget.number}${widget.nameTab}'
                                    : numberAndName,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _eventClickSortName();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Tên ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      isCheckSort
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: CustomListViewWidget(
                            lengthList: _repository.searchedData?.length,
                            onLoading: this._onLoading,
                            onRefresh: this._onRefresh,
                            listViewWidget: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _repository.searchedData?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                StgDocBorrows item =
                                    _repository.searchedData[index];
                                return InkWell(
                                  child: ListBorrowDocumentItem(item, context),
                                  onTap: () {
                                    pushPage(context,
                                        DetailBorrowDocumentScreen(item?.iD));
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      item?.isSelected = !item.isSelected;
                                      item.isSelected
                                          ? countSelectedItem++
                                          : countSelectedItem--;
                                      countSelectedItem > 0
                                          ? isShowAction = false
                                          : isShowAction = true;
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _folderActionWidget()
                ],
              ),
            ),
            floatingActionButton: Visibility(
              visible: isShowAction && _repository.isShowButtonBorrow,
              child: FloatingButtonWidget(
                onSelectedButton: () {
                  _eventClickFloatingButton();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // click FLOATINGBUTTON
  _eventClickFloatingButton() async {
    bool isStatus =
        await pushPage(context, RegisterBorrowDocumentScreen(false));
    if (isStatus) {
      if (widget.status == ListBorrowDocumentScreen.TOTAL_PENDING) {
        // tab chờ duyệt
        _repository.pullToRefreshData();
        _getBorrowIndex();
      } else {
        // các tab khác chờ duyệt
        if (isNotNullOrEmpty(widget.onIsCheckFunCallBack))
          widget.onIsCheckFunCallBack(isStatus);
      }
    }
  }

  // WIDGET XÓA NHIỀU
  Widget _folderActionWidget() {
    return Visibility(
      visible: !isShowAction,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(left: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey)),
        child: Row(
          children: [
            Expanded(
              child: Text('$countSelectedItem mục'),
            ),
            IconButton(
              onPressed: () {
                showConfirmDialog(
                    context, 'Bạn có muốn xóa những phiếu đăng ký này không?',
                    () {
                  setState(() {
                    _eventClickRemoves();
                  });
                });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                showConfirmDialog(context, 'Bạn có muốn hủy chọn?', () {
                  setState(() {
                    _hideWidgetDelete();
                    _repository.getCheckFalseListOriginal();
                  });
                });
              },
              icon: Icon(
                Icons.cancel_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _eventClickRemoves() async {
    bool isStatus = await _repository.getBorrowRemoves();
    if (isStatus) {
      countSelectedItem = 0;
      isShowAction = true;
      _repository.pullToRefreshData();
      _getBorrowIndex();
    }
  }

  _eventClickSortName() {
    setState(() {
      isCheckSort = !isCheckSort;
      if (isCheckSort)
        _repository.searchedData.sort((a, b) => a.name.compareTo(b.name));
      else
        _repository.searchedData.sort((a, b) => b.name.compareTo(a.name));
    });
  }

  _getBorrowIndex() async {
    BorrowIndexRequest request = BorrowIndexRequest();
    request.status = widget.status;
    await _repository.getBorrowIndex(request);
    _getCountHeader();
  }

  _getCountHeader() {
    setState(() {
      widget.status == ListBorrowDocumentScreen.TOTAL_PENDING
          ? numberAndName =
              '${_repository.listCount.length > 0 ? _repository.listCount[0] : "0"}${widget.nameTab}'
          : numberAndName = '${widget.number}${widget.nameTab}';
    });
  }

  _hideWidgetDelete() {
    isShowAction = true;
    countSelectedItem = 0;
  }

  void _onLoading() async {
    _getBorrowIndex();
  }

  void _onRefresh() async {
    _hideWidgetDelete();
    _repository.pullToRefreshData();
    if (isNotNullOrEmpty(textSearch) &&
        isNotNullOrEmpty(widget.onIsCheckTextSearch))
      widget.onIsCheckTextSearch(null);
    _getBorrowIndex();
  }
}
