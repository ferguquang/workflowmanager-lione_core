import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/notification_type.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/screen/list_borrow_document/list_borrow_document_screen.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/base/utils/palette.dart';
import 'package:workflow_manager/base/extension/string.dart';

class TabBorrowPayDocumentScreen extends StatefulWidget {
  int typeNotificationTab;

  TabBorrowPayDocumentScreen({this.typeNotificationTab});

  @override
  State<StatefulWidget> createState() {
    return TabBorrowPayDocumentState();
  }
}

class TabBorrowPayDocumentState extends State<TabBorrowPayDocumentScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> myTabs;
  bool isVisible = false;
  TabController _tabController;
  var searchController = TextEditingController();
  StreamSubscription _dataBorrowIndex;

  // chờ duyệt, đã duyệt, từ chối, quá hạn duyệt, đã cho mượn, quá hạn mượn, thu hồi, đã trả
  int totalPending = 0,
      totalApproved = 0,
      totalRejected = 0,
      totalApprovedExpried = 0,
      totalBorrowed = 0,
      totalBorrowedExpried = 0,
      totalDisabled = 0,
      totalClosed = 0;

  bool isCheckSearch = false; //false = text, true = textField

  Icon iconSearch = Icon(Icons.search);
  Widget customAppBar = Text('MƯỢN TRẢ TÀI LIỆU');

  _myTabList() {
    myTabs = <Tab>[
      _buildTab('Chờ duyệt', totalPending),
      _buildTab('Đã duyệt', totalApproved),
      _buildTab('Từ chối', totalRejected),
      _buildTab('Quá hạn duyệt', totalApprovedExpried),
      _buildTab('Đã cho mượn', totalBorrowed),
      _buildTab('Quá hạn mượn', totalBorrowedExpried),
      _buildTab('Thu hồi', totalDisabled),
      _buildTab('Đã trả', totalClosed),
    ];
  }

  Widget _buildTab(String nameTab, int number) {
    return Tab(
      child: Row(
        children: [
          Text(nameTab),
          number != 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.orange),
                  child: Text(
                    number.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              : Container()
        ],
      ),
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
            // truyền sang class  list_borrow_document_screen.dart
            eventBus.fire(GetDataBorrowSearchEvent(searchController.text));
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
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white60,
              )),
        );
        iconSearch = Icon(Icons.cancel);
      } else {
        iconSearch = Icon(Icons.search);
        customAppBar = Text('MƯỢN TRẢ TÀI LIỆU');
        searchController = TextEditingController();
        eventBus.fire(GetDataBorrowSearchEvent(null));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _myTabList();
    eventBus.on<NotiData>().listen((event) {
      if (isVisible) {
        Navigator.pop(context);
      }
      pushPage(
          context,
          TabBorrowPayDocumentScreen(
            typeNotificationTab: event.typeInt,
          ));
    });
    _tabController = new TabController(vsync: this, length: myTabs.length);

    // khi call api danh sách thành công thì sẽ vào đây
    if (isNotNullOrEmpty(_dataBorrowIndex)) _dataBorrowIndex.cancel();
    _dataBorrowIndex = eventBus.on<GetDataBorrowIndexEvent>().listen((event) {
      setState(() {
        // chờ duyệt, đã duyệt, từ chối, quá hạn duyệt, đã cho mượn, quá hạn mượn, thu hồi, đã trả
        // totalPending, totalApproved, totalRejected, totalApprovedExpried, totalBorrowed, totalBorrowedExpried, totalDisabled, totalClosed;
        // đoạn này fix cứng(các tab từ trái qua phải)
        totalPending = event.listCount[0];
        totalApproved = event.listCount[1];
        totalRejected = event.listCount[2];
        totalApprovedExpried = event.listCount[3];
        totalBorrowed = event.listCount[4];
        totalBorrowedExpried = event.listCount[5];
        totalDisabled = event.listCount[6];
        totalClosed = event.listCount[7];

        myTabs.clear();
        _myTabList();
      });
    });

    if (isNotNullOrEmpty(widget.typeNotificationTab)) {
      if (isNotNullOrEmpty(widget.typeNotificationTab)) {
        int indexTab = 0;
        if (NotificationType.instance
            .isBorrowPending(widget.typeNotificationTab))
          indexTab = 0;
        else if (NotificationType.instance
            .isBorrowApproved(widget.typeNotificationTab))
          indexTab = 1;
        else if (NotificationType.instance
            .isBorrowRejected(widget.typeNotificationTab))
          indexTab = 2;
        else if (NotificationType.instance
            .isBorrowDisabled(widget.typeNotificationTab))
          indexTab = 6;
        else if (NotificationType.instance
            .isBorrowClosed(widget.typeNotificationTab)) indexTab = 7;

        _tabController.animateTo(indexTab);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    removeScreenName(widget);
    super.dispose();

    if (isNotNullOrEmpty(_dataBorrowIndex)) _dataBorrowIndex.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("tabborrow"),
      onVisibilityChanged: (info) {
        isVisible = info.visibleFraction == 1;
      },
      child: Scaffold(
        appBar: AppBar(
          title: customAppBar,
          actions: [
            IconButton(
              icon: iconSearch,
              onPressed: () {
                _eventClickIconAppBar();
              },
            ),
          ],
        ),
        body: SafeArea(child: _mainScreen()),
      ),
    );
  }

  Widget _mainScreen() {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(child: Container()),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black87,
                    tabs: myTabs,
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // các status fix cứng
            //chờ duyệt
            _getListScreen(ListBorrowDocumentScreen.TOTAL_PENDING, totalPending,
                ' đăng ký chờ duyệt'),
            //đã duyệt
            _getListScreen(ListBorrowDocumentScreen.TOTAL_APPROVED,
                totalApproved, ' đăng ký đã duyệt',
                isCheckCallback: true),
            //từ chối
            _getListScreen(ListBorrowDocumentScreen.TOTAL_REJECTED,
                totalRejected, ' đăng ký từ chối',
                isCheckCallback: true),
            //quá hạn duyệt
            _getListScreen(ListBorrowDocumentScreen.TOTAL_APPROVED_EXPRIED,
                totalApprovedExpried, ' đăng ký đã quá hạn duyệt',
                isCheckCallback: true),
            //đã cho mượn
            _getListScreen(ListBorrowDocumentScreen.TOTAL_BORROWED,
                totalBorrowed, ' đăng ký đã cho mượn',
                isCheckCallback: true),
            //quá hạn mượn
            _getListScreen(ListBorrowDocumentScreen.TOTAL_BORROWED_EXPRIED,
                totalBorrowedExpried, ' đăng ký đã quá hạn mượn',
                isCheckCallback: true),
            //thu hồi
            _getListScreen(ListBorrowDocumentScreen.TOTAL_DISABLED,
                totalDisabled, ' đăng ký đã thu hồi',
                isCheckCallback: true),
            //đã trả
            _getListScreen(ListBorrowDocumentScreen.TOTAL_CLOSE, totalClosed,
                ' đăng ký đã trả',
                isCheckCallback: true),
          ],
        ),
      ),
    );
  }

  Widget _getListScreen(int status, int number, String text,
      {bool isCheckCallback}) {
    return ListBorrowDocumentScreen(
      status,
      number,
      text,
      onIsCheckFunCallBack: isNotNullOrEmpty(isCheckCallback)
          ? (isCheckFunCallBack) {
              if (isCheckFunCallBack) {
                setState(() {
                  totalPending++;
                  myTabs.removeAt(0);
                  myTabs.insert(
                    0,
                    Tab(
                      child: _buildTab('Chờ duyệt', totalPending),
                    ),
                  );
                });
              }
            }
          : null,
      onIsCheckTextSearch: (textSearch) {
        setState(() {
          searchController.text = '';
        });
      },
    );
  }
}
