import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/custom_listview_loading_refresh_widget.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/palette.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_search_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_search_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/detai_register_borrow_document/detail_register_borrow_document_screen.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/register_borrow_document_item.dart';

import 'register_borrow_document_repository.dart';

class RegisterBorrowDocumentScreen extends StatefulWidget {
  bool isCheckTab =
      false; // false = từ danh sách chuyển qua, true từ thống kê chuyển qua
  RegisterBorrowDocumentScreen(this.isCheckTab);

  @override
  State<StatefulWidget> createState() {
    return _RegisterBorrowDocumentSate();
  }
}

class _RegisterBorrowDocumentSate extends State<RegisterBorrowDocumentScreen> {
  var timeController =
      TextEditingController(text: 'Chọn thời gian từ ngày - đến ngày  ');
  String startDate;
  String endDate;
  bool isCheckSort = false;

  RegisterBorrowDocumentRepository _repository =
      RegisterBorrowDocumentRepository();
  BorrowSearchRequest request = BorrowSearchRequest();

  var searchController = TextEditingController();

  Icon iconSearch = Icon(Icons.search);
  Widget customAppBar = Text('Đăng ký mượn hồ sơ, tài liệu');
  bool isCheckSearch = false; //false = text, true = textField

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBorrowSearch();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
          builder: (context, RegisterBorrowDocumentRepository _repository, _) {
        return Scaffold(
          appBar: AppBar(
            leading: BackIconButton(),
            title: customAppBar,
            actions: [
              widget.isCheckTab
                  ? IconButton(
                      icon: iconSearch,
                      onPressed: () {
                        _eventClickIconAppBar();
                      },
                    )
                  : Text(''),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _eventClickDateTime();
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Text(timeController.text),
                            Icon(
                              Icons.date_range,
                              color: Colors.grey.withAlpha(150),
                            )
                          ],
                        ),
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
                Container(
                  height: 0.2,
                  color: Colors.grey,
                ),
                Expanded(
                    child: CustomListViewWidget(
                  onLoading: _onLoading,
                  onRefresh: _onRefresh,
                  lengthList: this._repository.stgDocs?.length,
                  textEmpty: 'Không có dữ liệu hiển thị',
                  listViewWidget: ListView.separated(
                    shrinkWrap: true,
                    itemCount: this._repository.stgDocs?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      StgDocs item = this._repository.stgDocs[index];
                      return InkWell(
                          onTap: () {
                            _eventClickItemListView(item);
                          },
                          child: RegisterBorrowDocumentItem(item));
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ))
              ],
            ),
          ),
        );
      }),
    );
  }

  // event click vào icon search
  _eventClickIconAppBar() {
    setState(() {
      isCheckSearch = !isCheckSearch;

      if (isCheckSearch) {
        customAppBar = TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
            _repository.pullToRefreshData();
            _getBorrowSearch();
          },
          controller: searchController,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm',
            hintStyle: TextStyle(color: Colors.white60),
            enabledBorder: new UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Palette.borderEditText.toColor())),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        );
        iconSearch = Icon(Icons.cancel);
      } else {
        _getTextAppbar();
        _getBorrowSearch();
      }
    });
  }

  _eventClickItemListView(StgDocs item) async {
    bool isStatus = await pushPage(
        context,
        DetailRegisterBorrowDocumentScreen(
            this._repository.dataBorrowSearch, item));
    if (isStatus && widget.isCheckTab == false)
      Navigator.of(context).pop(isStatus);
  }

  // click chọn từ ngày đến ngày
  _eventClickDateTime() {
    DateTimePickerWidget(
            context: context,
            onDateTimeSelected: (valueDate) {
              String sStartDate = valueDate;

              DateTimePickerWidget(
                      context: context,
                      onDateTimeSelected: (valueDate) {
                        startDate = sStartDate;
                        endDate = valueDate;
                        setState(() {
                          timeController.text =
                              startDate + ' - ' + endDate + ' ';
                        });
                        _repository.pullToRefreshData();
                        _getBorrowSearch();
                      },
                      format: Constant.ddMMyyyy)
                  .showOnlyDatePicker();
            },
            format: Constant.ddMMyyyy)
        .showOnlyDatePicker();
  }

  _getBorrowSearch() {
    request.term = searchController.text;
    if (isNotNullOrEmpty(request.startDate))
      request.startDate = startDate.replaceAll('/', '-');
    if (isNotNullOrEmpty(request.endDate))
      request.endDate = endDate.replaceAll('/', '-');
    _repository.getBorrowSearch(request);
  }

  _eventClickSortName() {
    setState(() {
      isCheckSort = !isCheckSort;
      request.sortname = 'Name';
      request.sortType = isCheckSort ? 1 : 0;
      _repository.pullToRefreshData();
      _getBorrowSearch();
    });
  }

  _getTextAppbar() {
    iconSearch = Icon(Icons.search);
    customAppBar = Text('Đăng ký mượn hồ sơ, tài liệu');
    searchController = TextEditingController();
  }

  void _onLoading() async {
    _getBorrowSearch();
  }

  void _onRefresh() async {
    _getTextAppbar();
    request.sortType = 0;
    request.sortname = 'Created';
    _repository.pullToRefreshData();
    _getBorrowSearch();
  }
}
