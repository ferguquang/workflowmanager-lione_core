import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/measure_size.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/create/create_management_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/divider_widget.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/infor_detail_dialog.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/infor_value_detail_dialog.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_and_two_text.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_icon_text_widget.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';

import '../../../../main.dart';
import 'detail_management_repository.dart';
import 'tab/comments/comments_opportunity_screen.dart';
import 'tab/contract/contract_opportunity_screen.dart';
import 'tab/file/file_opportunity_screen.dart';
import 'tab/history/history_opportunity_screen.dart';

class DetailManagementScreen extends StatefulWidget {
  bool isOnlyView;
  int idOpportunity;

  DetailManagementScreen({this.isOnlyView, this.idOpportunity});

  @override
  _DetailManagementScreenState createState() => _DetailManagementScreenState();
}

class _DetailManagementScreenState extends State<DetailManagementScreen>
    with SingleTickerProviderStateMixin {
  DetailManagementRepository _repository = DetailManagementRepository();
  List<DataFields> dataFields = [];
  DataFields nameModel = DataFields();
  DataFields codeModel = DataFields();
  DataFields dateSignContractModel = DataFields();
  DataFields totalMoneyModel = DataFields();
  DataFields capitalModel = DataFields();
  DataFields costMarketingModel = DataFields();
  DataFields typeProjectModel = DataFields();
  DataFields deployDateModel = DataFields();
  DataFields campaignTypesModel = DataFields();
  DataFields potentialTypeModel = DataFields();
  DataFields grossProfitModel = DataFields();
  DataFields quarterModel = DataFields();

  Status status = Status();
  bool isChangeStatus = false;
  Status phase = Status();
  bool isChangePhase = false;
  Seller seller = Seller();
  bool isChangeSeller = false;
  Customer customer = Customer();

  TabController _tabController;
  List<Tab> myTabs = [];
  ScrollController _scrollController;

  String root;
  User user;

  List<Status> listPhase = [];
  List<Status> listPhaseFile = [];

  List<Contracts> contracts = [];
  bool isCreateContract = false;
  List<Attachments> attachments = [];
  bool isAddFile = false;
  List<Comments> comments;

  GlobalKey key = GlobalKey();
  double height = 0;

  List<PopupMenuItem> listPopupMenu = [];

  StreamSubscription _dataCreateOpportunity;
  bool isApproveEdit = false; // duy???t ch???nh s???a
  bool isRejectEdit = false; // t??? ch???i ch???nh s???a

  bool isContractTab = false;
  bool isCommentTab = false;
  bool isFileTab = false;
  bool isHistoryTab = false;
  List<Widget> listTab = [];
  bool isFirst = false;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _getDetailManagement();
    eventBus.on<NotiData>().listen((event) {
      if (isVisible) {
        Navigator.pop(context);
      }
      pushPage(
          context,
          DetailManagementScreen(
            isOnlyView: false,
            idOpportunity: event.id,
          ));
    });
    // c??c ch???nh s???a trong chi ti???t qua
    if (isNotNullOrEmpty(_dataCreateOpportunity))
      _dataCreateOpportunity.cancel();
    _dataCreateOpportunity = eventBus.on<GetDataSaveEventBus>().listen((event) {
      _getDetailManagement();
    });
  }
  void getListMenu() {
    listPopupMenu = [];
    listPopupMenu.add(PopupMenuItem(
      value: 0,
      child: Text("S???a c?? h???i"),
    ));
    if (isApproveEdit)
      listPopupMenu.add(PopupMenuItem(
        value: 1,
        child: Text("Duy???t ch???nh s???a"),
      ));
    if (isRejectEdit)
      listPopupMenu.add(PopupMenuItem(
        value: 2,
        child: Text("T??? ch???i duy???t ch???nh s???a"),
      ));
  }

  void _getTab() {
    myTabs = <Tab>[]; // th??m quy???n ???n hi???n
    listTab = [];
    if (isContractTab) {
      myTabs.add(_itemTab(Icons.error_outline, 'H???p ?????ng'));
      listTab.add(ContractOpportunityScreen(contracts, widget.isOnlyView,
          isCreateContract, widget.idOpportunity));
    }
    if (isFileTab) {
      myTabs.add(_itemTab(Icons.attach_file_outlined, 'File ????nh k??m'));
      listTab.add(FileOpportunityScreen(attachments, widget.isOnlyView,
          isAddFile, listPhaseFile, widget.idOpportunity));
    }

    if (isCommentTab) {
      myTabs.add(_itemTab(Icons.comment, 'Ho???t ?????ng'));
      listTab.add(CommentsOpportunityScreen(
        comments,
        widget.isOnlyView,
        widget.idOpportunity,
        true,
        _repository.projectDetailModel?.isComment,
        avatar: user?.avatar ?? '',
        root: root,
      ));
    }

    if (isHistoryTab) {
      myTabs.add(_itemTab(Icons.history, 'L???ch s???'));
      listTab.add(HistoryOpportunityScreen(widget.idOpportunity, true));
    }
    _tabController = null;
    _tabController = new TabController(vsync: this, length: myTabs?.length);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    if (isNotNullOrEmpty(_dataCreateOpportunity))
      _dataCreateOpportunity.cancel();
    removeScreenName(widget);
    super.dispose();
  }

  _getDetailManagement() async {
    if (root == null) root = await SharedPreferencesClass.getRoot();
    if (user == null) user = await SharedPreferencesClass.getUser();
    await _repository.getDetailManagement(
        widget.idOpportunity, widget.isOnlyView);
    // th??ng tin c?? b???n
    dataFields = _repository.projectDetailModel?.dataFields;
    // tr???ng th??i
    status = _repository.projectDetailModel?.status;
    isChangeStatus = _repository.projectDetailModel?.isChangeStatus;
    // giai ??o???n
    phase = _repository.projectDetailModel?.phase;
    isChangePhase = _repository.projectDetailModel?.isChangePhase;
    // kh??ch h??ng
    customer = _repository.projectDetailModel?.customer;
    //seller
    seller = _repository.projectDetailModel?.seller;
    isChangeSeller = _repository.projectDetailModel?.isChangeSeller;
    // c?? h???i
    contracts = _repository.projectDetailModel?.contracts;
    isCreateContract = _repository.projectDetailModel?.isCreateContract;
    //file
    attachments = _repository.projectDetailModel?.attachments;
    isAddFile = _repository.projectDetailModel?.isAddFile;
    // ho???t ?????ng
    comments = _repository.projectDetailModel?.comments;
    if (isNotNullOrEmpty(comments))
      comments?.forEach((element) {
        element.user?.avatar = root + element.user?.avatar;
      });
    // danh s??ch giai ??o???n
    listPhase = _repository.projectDetailModel?.phaseTargets ?? [];
    isApproveEdit = _repository.projectDetailModel?.isApproveEdit ?? false;
    isRejectEdit = _repository.projectDetailModel?.isRejectEdit ?? false;

    if (isNotNullOrEmpty(dataFields)) {
      dataFields?.forEach((element) {
        switch (element.name) {
          case "Name": // t??n c?? h???i
            nameModel = element;
            break;
          case "Code": // M?? c?? h???i
            codeModel = element;
            break;
          case "StartDate": // ng??y d??? ki???n k?? h???p ?????ng
            dateSignContractModel = element;
            break;
          case "TotalMoney": // Gi?? tr??? d??? ki???n
            totalMoneyModel = element;
            break;
          case "Capital": // Gi?? v???n
            capitalModel = element;
            break;
          case "MarketingCost": // Chi ph?? maketing
            costMarketingModel = element;
            break;
          case "TypeProject": // Lo???i d??? ??n (s???n ph???m)
            typeProjectModel = element;
            break;
          case "DeployDate": // ?????a ??i???m tri???n khai
            deployDateModel = element;
            break;
          case "CampaignType": // Chi???n d???ch Marketing
            campaignTypesModel = element;
            break;
          case "PotentialType": //M???c ????? ????nh gi?? c?? h???i
            potentialTypeModel = element;
            break;
          case "Quarter": //Qu??
            quarterModel = element;
            break;
          case "GrossProfit": //L??i g???p
            grossProfitModel = element;
            break;
        }
      });
    }

    // 2 d??ng n??y d??ng cho danh s??ch file khi th??m - s???a file ????nh k??m
    listPhaseFile = [];
    if (isNotNullOrEmpty(listPhase)) {
      listPhaseFile.add(phase);
      listPhaseFile.addAll(listPhase);
    }

    if (!isFirst) {
      isFirst = true;
      // ch??? l???n ?????u ti??n
      if (widget.isOnlyView) {
        // khacsh
        isContractTab = _repository.projectDetailModel.isShowContract;
        isFileTab = _repository.projectDetailModel.isShowFile;
        isCommentTab = _repository.projectDetailModel.isShowComment;
        isHistoryTab = _repository.projectDetailModel.isShowHistory;
      } else {
        // admin
        isContractTab = true;
        isCommentTab = true;
        isFileTab = true;
        isHistoryTab = true;
        getListMenu();
      }
      setState(() {
        _getTab();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("detailma"),
      onVisibilityChanged: (info) {
        isVisible = info.visibleFraction == 1;
      },
      child: ChangeNotifierProvider.value(
        value: _repository,
        child: Consumer(
          builder: (context, DetailManagementRepository __repository1, child) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              body: SafeArea(
                child: !isContractTab &&
                        !isCommentTab &&
                        !isFileTab &&
                        !isHistoryTab
                    ? _getHeaderInfor()
                    : NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              expandedHeight: height,
                              automaticallyImplyLeading: false,
                              flexibleSpace: FlexibleSpaceBar(
                                background: _getSizeHeightHeader(),
                              ),
                              backgroundColor: Colors.white,
                              snap: true,
                              pinned: true,
                              floating: true,
                              forceElevated: innerBoxIsScrolled,
                              bottom: PreferredSize(
                                preferredSize: Size(double.infinity, 1.0),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 8),
                                      height: kToolbarHeight,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TabBar(
                                        automaticIndicatorColorAdjustment: true,
                                        indicatorColor: Colors.blue,
                                        controller: _tabController,
                                        isScrollable: true,
                                        labelColor: Colors.blue,
                                        unselectedLabelColor: Colors.grey,
                                        tabs: myTabs,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ];
                        },
                        body: DefaultTabController(
                          length: myTabs.length,
                          child: Column(
                            children: [
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
      ),
    );
  }

  Widget _getSizeHeightHeader() {
    return MeasureSize(
      onChange: (size) {
        double contentHeight =
            (key.currentContext.findRenderObject() as RenderBox)
                // ignore: invalid_use_of_protected_member
                .computeMaxIntrinsicHeight(
                    (key.currentContext.findRenderObject() as RenderBox)
                        .size
                        .width);
        if (height != contentHeight) {
          height = contentHeight + 40.0;
          // print('gggggggggggggggggggg - $height');
          setState(() {});
        }
      },
      child: _getHeaderInfor(),
    );
  }

  Widget _getHeaderInfor() {
    return Container(
      color: Colors.white,
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text(
              'Chi ti???t c?? h???i',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Visibility(
                visible: !widget.isOnlyView,
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: PopupMenuButton(
                    child: Icon(Icons.more_vert),
                    onSelected: (value) {
                      _eventClickPopupMenu(value);
                    },
                    itemBuilder: (context) {
                      return listPopupMenu;
                    },
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Image.asset(
                    'assets/images/icon_detail_plan.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          nameModel?.value ?? '',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: nameModel.isTemp ?? false
                                  ? Colors.red
                                  : null),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(codeModel?.value ?? '',
                            style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(
            iHeight: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${dateSignContractModel?.title ?? ""}',
                              style: TextStyle(
                                  fontSize: 13, color: getColor('#3e444b')),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Text(dateSignContractModel?.value ?? '',
                                      style: TextStyle(
                                          color: dateSignContractModel.isTemp ??
                                                  false
                                              ? Colors.red
                                              : null,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text(' (${quarterModel?.value ?? ''})',
                                      style: TextStyle(
                                          color: quarterModel.isTemp ?? false
                                              ? Colors.red
                                              : null,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.attach_money_outlined,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _getViewInforValueProject(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gi?? tr??? h???p ?????ng d??? ki???n',
                                style: TextStyle(
                                    fontSize: 13, color: getColor('#3e444b')),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text('${totalMoneyModel?.value ?? ''}',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(
            iHeight: 1,
          ),
          RowAndTwoText(
            icon: Icons.account_balance,
            textTitle: '${capitalModel?.title ?? ""}',
            textValue: '${capitalModel?.value ?? ""}',
            isColors: capitalModel?.isTemp ?? false,
          ),
          RowAndTwoText(
            icon: Icons.airline_seat_individual_suite,
            textTitle: '${costMarketingModel?.title ?? ""}',
            textValue: '${costMarketingModel?.value ?? ""}',
            isColors: costMarketingModel?.isTemp ?? false,
          ),
          RowAndTwoText(
            icon: Icons.bookmark,
            textTitle: '${typeProjectModel?.title ?? ""}',
            textValue: '${typeProjectModel?.value ?? ""}',
            isColors: typeProjectModel?.isTemp ?? false,
          ),
          RowAndTwoText(
            icon: Icons.add_location_alt,
            textTitle: '${deployDateModel?.title ?? ""}',
            textValue: '${deployDateModel?.value ?? ""}',
            isColors: deployDateModel?.isTemp ?? false,
          ),
          RowAndTwoText(
            icon: Icons.compare,
            textTitle: '${campaignTypesModel?.title ?? ""}',
            textValue: '${campaignTypesModel?.value ?? ""}',
            isColors: campaignTypesModel?.isTemp ?? false,
          ),
          RowAndTwoText(
            icon: Icons.rate_review,
            textTitle: '${potentialTypeModel?.title ?? ""}',
            textValue: '${potentialTypeModel?.value ?? ""}',
            isColors: potentialTypeModel?.isTemp ?? false,
          ),
          InkWell(
            onTap: () => _getViewInforValueNew(),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: const Text(
                      'Xem th??m th??ng tin',
                      style: TextStyle(fontSize: 13, color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ),
          DividerWidget(
            iHeight: 1,
          ),
          // tr???ng th??i c?? h???i
          RowAndTextWidget(
            padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            icon: Icons.border_color,
            text: 'Tr???ng th??i c?? h???i',
          ),
          InkWell(
            onTap: () {
              if (!widget.isOnlyView && isChangeStatus) {
                _getStatusOpportunity();
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 16),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: getColor('${status?.color}'),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    status?.name ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                  Visibility(
                    visible: !widget.isOnlyView && isChangeStatus,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 10,
                    ),
                  )
                ],
              ),
            ),
          ),
          // giai ??o???n
          RowAndTextWidget(
            padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            icon: Icons.border_color,
            text: 'Giai ??o???n c?? h???i',
          ),
          InkWell(
            onTap: () {
              if (!widget.isOnlyView && isChangePhase) {
                _getPhaseOpportunity();
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 16),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: getColor('${phase?.color}'),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    phase?.name ?? '',
                    style: TextStyle(
                      color: phase?.isTemp ?? false ? Colors.red : Colors.white,
                    ),
                  ),
                  Visibility(
                    visible: !widget.isOnlyView && isChangePhase,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 10,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KH??CH H??NG ',
                            style: TextStyle(
                                color: getColor('#3e444b'), fontSize: 12),
                          ),
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                            size: 16,
                          )
                        ],
                      ),
                      _getInforSeller(customer?.avatar, customer?.name,
                          customer?.email, customer?.phone),
                      Text(
                        'Nh??m kh??ch h??ng: ${customer?.group ?? ''}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('Ng?????i li??n h???: ${customer?.contactName ?? ''}',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Visibility(
                  // visible: !widget.isOnlyView && isChangeSeller,
                  visible: !widget.isOnlyView ? true : isChangeSeller ?? false,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AM (SALE) ',
                              style: TextStyle(
                                  color: getColor('#3e444b'), fontSize: 12),
                            ),
                            Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 16,
                            )
                          ],
                        ),
                        _getInforSeller(seller?.avatar, seller?.name,
                            seller?.email, seller?.phone),
                        Text(
                          'Ph??ng ban: ${seller?.deptName ?? ''}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(
            iHeight: 10,
          ),
        ],
      ),
    );
  }

  // xem th??m th??ng tin
  _getViewInforValueNew() {
    CustomDialogWidget(
            context,
            InforDetailDialog(
              isOnlyView: widget.isOnlyView,
              projectDetailModel: _repository.projectDetailModel,
            ),
            isClickOutWidget: true)
        .show();
  }

  // xem gi?? tr??? d??? ??n
  _getViewInforValueProject() {
    if (isNullOrEmpty(_repository.projectDetailModel?.typeProjectMonies)) {
      ToastMessage.show('Gi?? tr??? h???p ?????ng kh??ng c?? d??? li???u', ToastStyle.error);
      return;
    }

    CustomDialogWidget(
        context,
            InforValueDetailDialog(
                typeProjectMonies:
                    _repository.projectDetailModel?.typeProjectMonies,
                grossProfitModel: grossProfitModel,
                totalMoneyModel: totalMoneyModel,
                capitalModel: capitalModel),
            isClickOutWidget: true)
        .show();
  }

  // tr???ng th??i c?? h???i
  _getStatusOpportunity() {
    ChoiceDialog choiceDialog = ChoiceDialog<Status>(
      context,
      _repository.projectDetailModel?.statusTargets,
      title: 'Thay ?????i tr???ng th??i',
      isSingleChoice: true,
      getTitle: (data) => data?.name,
      onAccept: (List<Status> selected) {
        if (isNotNullOrEmpty(selected)) _eventClickStatus(selected[0]?.iD);
      },
      choiceButtonText: 'Ch???n tr???ng th??i',
    );
    choiceDialog.showChoiceDialog();
  }

  _eventClickStatus(int id) async {
    bool status =
        await _repository.getDetailChangeStatus(id, widget.idOpportunity);
    if (status) _getDetailManagement();
  }

  // giai ??o???n c?? h???i
  _getPhaseOpportunity() {
    ChoiceDialog choiceDialog = ChoiceDialog<Status>(
      context,
      listPhase,
      title: 'Thay ?????i giai ??o???n',
      isSingleChoice: true,
      getTitle: (data) => data?.name,
      onAccept: (List<Status> selected) {
        if (isNotNullOrEmpty(selected)) _eventClickPhase(selected[0]?.iD);
      },
      choiceButtonText: 'Ch???n giai ??o???n',
    );
    choiceDialog.showChoiceDialog();
  }

  _eventClickPhase(int id) async {
    bool status =
        await _repository.getDetailChangePhase(id, widget.idOpportunity);
    if (status) _getDetailManagement();
  }

  // kh??ch h??ng, seller
  Widget _getInforSeller(
      String avatar, String name, String email, String phone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleNetworkImage(
              height: 32, width: 32, url: '$root$avatar' ?? ''),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? '',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              RowAndTextWidget(
                sizeText: 10,
                padding: EdgeInsets.only(top: 0),
                icon: Icons.email,
                text: email ?? '',
              ),
              RowAndTextWidget(
                sizeText: 10,
                padding: EdgeInsets.only(top: 0),
                icon: Icons.phone,
                text: phone ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  _eventClickPopupMenu(int value) {
    switch (value) {
      case 0:
        pushPage(
            context,
            CreateManagementScreen(
              idOpportunity: widget.idOpportunity ?? 0,
              typeOpportunity: CreateManagementScreen.TYPE_EDIT,
            ));
        break;

      case 1:
        showConfirmDialog(
            context, 'B???n c?? mu???n duy???t ch???nh s???a c?? h???i n??y kh??ng?', () async {
          bool status =
              await _repository.getProjectPlanApproveEdit(widget.idOpportunity);
          if (status) _getDetailManagement();
        });
        break;

      case 2:
        showConfirmDialog(
            context, 'B???n c?? mu???n t??? ch???i duy???t ch???nh s???a c?? h???i n??y kh??ng?',
            () async {
          bool status =
              await _repository.getProjectPlanRejectEdit(widget.idOpportunity);
          if (status) _getDetailManagement();
        });
        break;
    }
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
}
