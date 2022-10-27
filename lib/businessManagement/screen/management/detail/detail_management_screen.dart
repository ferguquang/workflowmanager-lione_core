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
  bool isApproveEdit = false; // duyệt chỉnh sửa
  bool isRejectEdit = false; // từ chối chỉnh sửa

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
    // các chỉnh sửa trong chi tiết qua
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
      child: Text("Sửa cơ hội"),
    ));
    if (isApproveEdit)
      listPopupMenu.add(PopupMenuItem(
        value: 1,
        child: Text("Duyệt chỉnh sửa"),
      ));
    if (isRejectEdit)
      listPopupMenu.add(PopupMenuItem(
        value: 2,
        child: Text("Từ chối duyệt chỉnh sửa"),
      ));
  }

  void _getTab() {
    myTabs = <Tab>[]; // thêm quyền ẩn hiện
    listTab = [];
    if (isContractTab) {
      myTabs.add(_itemTab(Icons.error_outline, 'Hợp đồng'));
      listTab.add(ContractOpportunityScreen(contracts, widget.isOnlyView,
          isCreateContract, widget.idOpportunity));
    }
    if (isFileTab) {
      myTabs.add(_itemTab(Icons.attach_file_outlined, 'File đính kèm'));
      listTab.add(FileOpportunityScreen(attachments, widget.isOnlyView,
          isAddFile, listPhaseFile, widget.idOpportunity));
    }

    if (isCommentTab) {
      myTabs.add(_itemTab(Icons.comment, 'Hoạt động'));
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
      myTabs.add(_itemTab(Icons.history, 'Lịch sử'));
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
    // thông tin cơ bản
    dataFields = _repository.projectDetailModel?.dataFields;
    // trạng thái
    status = _repository.projectDetailModel?.status;
    isChangeStatus = _repository.projectDetailModel?.isChangeStatus;
    // giai đoạn
    phase = _repository.projectDetailModel?.phase;
    isChangePhase = _repository.projectDetailModel?.isChangePhase;
    // khách hàng
    customer = _repository.projectDetailModel?.customer;
    //seller
    seller = _repository.projectDetailModel?.seller;
    isChangeSeller = _repository.projectDetailModel?.isChangeSeller;
    // cơ hội
    contracts = _repository.projectDetailModel?.contracts;
    isCreateContract = _repository.projectDetailModel?.isCreateContract;
    //file
    attachments = _repository.projectDetailModel?.attachments;
    isAddFile = _repository.projectDetailModel?.isAddFile;
    // hoạt động
    comments = _repository.projectDetailModel?.comments;
    if (isNotNullOrEmpty(comments))
      comments?.forEach((element) {
        element.user?.avatar = root + element.user?.avatar;
      });
    // danh sách giai đoạn
    listPhase = _repository.projectDetailModel?.phaseTargets ?? [];
    isApproveEdit = _repository.projectDetailModel?.isApproveEdit ?? false;
    isRejectEdit = _repository.projectDetailModel?.isRejectEdit ?? false;

    if (isNotNullOrEmpty(dataFields)) {
      dataFields?.forEach((element) {
        switch (element.name) {
          case "Name": // tên cơ hội
            nameModel = element;
            break;
          case "Code": // Mã cơ hội
            codeModel = element;
            break;
          case "StartDate": // ngày dự kiến ký hợp đồng
            dateSignContractModel = element;
            break;
          case "TotalMoney": // Giá trị dự kiến
            totalMoneyModel = element;
            break;
          case "Capital": // Giá vốn
            capitalModel = element;
            break;
          case "MarketingCost": // Chi phí maketing
            costMarketingModel = element;
            break;
          case "TypeProject": // Loại dự án (sản phẩm)
            typeProjectModel = element;
            break;
          case "DeployDate": // Địa điểm triển khai
            deployDateModel = element;
            break;
          case "CampaignType": // Chiến dịch Marketing
            campaignTypesModel = element;
            break;
          case "PotentialType": //Mức độ đánh giá cơ hội
            potentialTypeModel = element;
            break;
          case "Quarter": //Quý
            quarterModel = element;
            break;
          case "GrossProfit": //Lãi gộp
            grossProfitModel = element;
            break;
        }
      });
    }

    // 2 dòng này dùng cho danh sách file khi thêm - sửa file đính kèm
    listPhaseFile = [];
    if (isNotNullOrEmpty(listPhase)) {
      listPhaseFile.add(phase);
      listPhaseFile.addAll(listPhase);
    }

    if (!isFirst) {
      isFirst = true;
      // chỉ lần đầu tiên
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
              'Chi tiết cơ hội',
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
                                'Giá trị hợp đồng dự kiến',
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
                      'Xem thêm thông tin',
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
          // trạng thái cơ hội
          RowAndTextWidget(
            padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            icon: Icons.border_color,
            text: 'Trạng thái cơ hội',
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
          // giai đoạn
          RowAndTextWidget(
            padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            icon: Icons.border_color,
            text: 'Giai đoạn cơ hội',
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
                            'KHÁCH HÀNG ',
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
                        'Nhóm khách hàng: ${customer?.group ?? ''}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('Người liên hệ: ${customer?.contactName ?? ''}',
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
                          'Phòng ban: ${seller?.deptName ?? ''}',
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

  // xem thêm thông tin
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

  // xem giá trị dự án
  _getViewInforValueProject() {
    if (isNullOrEmpty(_repository.projectDetailModel?.typeProjectMonies)) {
      ToastMessage.show('Giá trị hợp đồng không có dữ liệu', ToastStyle.error);
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

  // trạng thái cơ hội
  _getStatusOpportunity() {
    ChoiceDialog choiceDialog = ChoiceDialog<Status>(
      context,
      _repository.projectDetailModel?.statusTargets,
      title: 'Thay đổi trạng thái',
      isSingleChoice: true,
      getTitle: (data) => data?.name,
      onAccept: (List<Status> selected) {
        if (isNotNullOrEmpty(selected)) _eventClickStatus(selected[0]?.iD);
      },
      choiceButtonText: 'Chọn trạng thái',
    );
    choiceDialog.showChoiceDialog();
  }

  _eventClickStatus(int id) async {
    bool status =
        await _repository.getDetailChangeStatus(id, widget.idOpportunity);
    if (status) _getDetailManagement();
  }

  // giai đoạn cơ hội
  _getPhaseOpportunity() {
    ChoiceDialog choiceDialog = ChoiceDialog<Status>(
      context,
      listPhase,
      title: 'Thay đổi giai đoạn',
      isSingleChoice: true,
      getTitle: (data) => data?.name,
      onAccept: (List<Status> selected) {
        if (isNotNullOrEmpty(selected)) _eventClickPhase(selected[0]?.iD);
      },
      choiceButtonText: 'Chọn giai đoạn',
    );
    choiceDialog.showChoiceDialog();
  }

  _eventClickPhase(int id) async {
    bool status =
        await _repository.getDetailChangePhase(id, widget.idOpportunity);
    if (status) _getDetailManagement();
  }

  // khách hàng, seller
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
            context, 'Bạn có muốn duyệt chỉnh sửa cơ hội này không?', () async {
          bool status =
              await _repository.getProjectPlanApproveEdit(widget.idOpportunity);
          if (status) _getDetailManagement();
        });
        break;

      case 2:
        showConfirmDialog(
            context, 'Bạn có muốn từ chối duyệt chỉnh sửa cơ hội này không?',
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
