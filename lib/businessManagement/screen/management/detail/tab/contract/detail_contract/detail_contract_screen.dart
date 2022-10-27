import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/detail/tab/comments/comments_opportunity_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/detail/tab/history/history_opportunity_screen.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';

import '../../../../../../../main.dart';
import 'detail_contract_repository.dart';
import 'file/file_contract_screen.dart';
import 'infor/information_contract_screen.dart';
import 'stage_payment/stage_payment_contract_screen.dart';

class DetailContractScreen extends StatefulWidget {
  bool isOnlyView;

  // idOpportunity của cơ hội (CHỈ DÀNH CHO CHỈNH SỬA CƠ HỘI CÒN LẠI KHÔNG DÙNG ĐẾN ID NÀY)
  int idOpportunity;
  int idContract; // id của hợp đồng

  DetailContractScreen({this.isOnlyView, this.idOpportunity, this.idContract});

  @override
  _DetailContractScreenState createState() => _DetailContractScreenState();
}

class _DetailContractScreenState extends State<DetailContractScreen>
    with SingleTickerProviderStateMixin {
  DetailContractRepository _repository = DetailContractRepository();
  ContractDetail contractDetail = ContractDetail();
  bool isChangePhase = false;

  TabController _tabController;
  List<Tab> myTabs = [];

  StreamSubscription _dataContracts;
  String root;
  User user;

  bool isFileTab = false;
  bool isPhaseTab = false;
  bool isCommentTab = false;
  bool isHistoryTab = false;
  List<Widget> listTab = [];
  bool isFirst = false;

  @override
  void initState() {
    super.initState();
    // _getTab();
    // _tabController = new TabController(vsync: this, length: myTabs?.length);
    _getContractDetail();

    _dataContracts = eventBus.on<GetDataContractEventBus>().listen((event) {
      setState(() {
        if (!event.isCreate) // chính sửa
          _getContractDetail();
      });
    });
  }

  Widget _itemTab(IconData icon, String text) {
    return Tab(
      iconMargin: EdgeInsets.only(bottom: 0),
      icon: Icon(
        icon,
        size: 20,
      ),
      text: text ?? '',
    );
  }

  void _getTab() {
    myTabs = <Tab>[]; // thêm quyền ẩn hiện
    listTab = <Widget>[];

    myTabs.add(_itemTab(Icons.error_outline, 'Thông tin'));
    listTab.add(InformationContractScreen(
      contractDetail: contractDetail,
      isOnlyView: widget.isOnlyView,
      idOpportunity: widget.idContract,
      // idOpportunity: widget.idOpportunity,
    ));

    // if (!widget.isOnlyView) {
    // admin
    if (isFileTab) {
      myTabs.add(_itemTab(Icons.attach_file_outlined, 'File đính kèm'));
      listTab.add(FileContractScreen(
        isOnlyView: widget.isOnlyView,
        attachments: contractDetail?.attachments,
        attachmentsDeploy: contractDetail?.attachmentsDeploy,
        // isAddFile: contractDetail?.isDelete,
        // iDTarget: contractDetail?.iD,
      ));
    }

    if (isPhaseTab) {
      myTabs.add(_itemTab(Icons.waves_outlined, 'Giai đoạn'));
      listTab
          .add(StagePaymentContractScreen(contractDetail, widget.isOnlyView));
    }

    if (isCommentTab) {
      myTabs.add(_itemTab(Icons.comment, 'Hoạt động'));
      listTab.add(CommentsOpportunityScreen(
        contractDetail?.comments,
        widget.isOnlyView,
        widget.idContract,
        false,
        true,
        avatar: user?.avatar ?? "",
        root: root,
      ));
    }

    if (isHistoryTab) {
      myTabs.add(_itemTab(Icons.history, 'Lịch sử'));
      listTab.add(HistoryOpportunityScreen(widget.idContract, false));
    }
    _tabController = null;
    _tabController = new TabController(vsync: this, length: myTabs?.length);
    // }
  }

  _getContractDetail() async {
    await _repository.getContractDetail(widget.idContract, widget.isOnlyView);
    if (root == null) root = await SharedPreferencesClass.getRoot();
    if (user == null) user = await SharedPreferencesClass.getUser();
    contractDetail = _repository.contractDetail;
    isChangePhase = contractDetail?.isChangePhase;
    contractDetail.comments.forEach((element) {
      element.user?.avatar = root + element.user?.avatar;
    });
    if (!isFirst) {
      // chỉ lần đầu tiên
      if (widget.isOnlyView) {
        // khachs
        isFileTab = contractDetail.isShowFile;
        isPhaseTab = contractDetail.isShowPayment;
        isCommentTab = contractDetail.isShowComment;
        isHistoryTab = contractDetail.isShowHistory;
      } else {
        isFileTab = true;
        isPhaseTab = true;
        isCommentTab = true;
        isHistoryTab = true;
      }
      setState(() {
        _getTab();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataContracts)) _dataContracts.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, DetailContractRepository __repository1, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Chi tiết hợp đồng',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: DefaultTabController(
                  length: myTabs?.length ?? 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: Image.asset(
                              'assets/images/ic-finance.png',
                              width: 46,
                              height: 53,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contractDetail?.name ?? '',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Mã hợp đồng: ${contractDetail?.code ?? ''}',
                                ),
                                UnconstrainedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: getColor(
                                                '${contractDetail?.phase?.color}') ??
                                            Colors.white),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          contractDetail?.phase?.name ?? '',
                                          style: TextStyle(
                                              color:
                                                  /*getColor(
                                                '${contractDetail?.phase?.color}') ??*/
                                                  Colors.white),
                                        ),
                                        Visibility(
                                          visible: !widget.isOnlyView &&
                                              isChangePhase,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      TabBar(
                        indicatorColor: Colors.blue,
                        controller: _tabController,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        labelPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        isScrollable: true,
                        tabs: myTabs,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: listTab,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
