import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/register_borrow_document_screen.dart';
import 'package:workflow_manager/borrowPayDocument/screen/statistic/amount/statistic_amount_doc_screen.dart';
import 'package:workflow_manager/borrowPayDocument/screen/statistic/purpose/statistic_purpose_doc_screen.dart';
import 'package:workflow_manager/borrowPayDocument/screen/statistic/statistic_borrow_documents_repository.dart';
import 'package:workflow_manager/main.dart';

class StatisticTabBorrowDocuments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticTabBorrowDocuments();
  }
}

class _StatisticTabBorrowDocuments extends State<StatisticTabBorrowDocuments>
    with AutomaticKeepAliveClientMixin {
  StatisticBorrowDocumentsRepository _repository =
      StatisticBorrowDocumentsRepository();
  StreamSubscription _dataBorrow;

  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Mục đích',
    ),
    Tab(
      text: 'Số lượng',
    ),
  ];

  PageController controller = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getStatisticBorrow();
    _listenerEventBus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _tabController.dispose();

    if (isNotNullOrEmpty(_dataBorrow)) _dataBorrow.cancel();
  }

  void _listenerEventBus() {
    if (isNotNullOrEmpty(_dataBorrow)) _dataBorrow.cancel();
    _dataBorrow = eventBus.on<GetDataBorrowDetailSearchEvent>().listen((event) {
      _repository.getStatisticBorrow();
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
        builder:
            (context, StatisticBorrowDocumentsRepository _repository, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Mượn trả tài liệu"),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    pushPage(context, RegisterBorrowDocumentScreen(true));
                  },
                ),
              ],
            ),
            body: DefaultTabController(
              length: tabs.length,
              child: Scaffold(
                appBar: new PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: new Container(
                    color: Colors.white,
                    child: new SafeArea(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: new Container(),
                          ),
                          TabBar(
                            isScrollable: false,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            tabs: tabs,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    StatisticPurposeDocScreen(
                      listPurposes: _repository.listPurposes,
                    ),
                    StatisticAmountDocScreen(
                      listAmounts: _repository.listAmounts,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
