import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/delivery_details_screen/delivery_detail_screen.dart';
import 'package:workflow_manager/shopping_management/response/delivery_list_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';

import 'delivery_list_repository.dart';

class DeliveryListScreen extends StatefulWidget {
  @override
  _DeliveryListScreenState createState() => _DeliveryListScreenState();
}

class _DeliveryListScreenState extends State<DeliveryListScreen> {
  List<ContentShoppingModel> items = [];
  List<ContentShoppingModel> filterList = [];
  DeliveryListRepository _deliveryListRepository = DeliveryListRepository();
  RefreshController _refreshController = RefreshController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deliveryListRepository.refreshController = _refreshController;
    _deliveryListRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _deliveryListRepository,
        child: Consumer(
          builder:
              (context, DeliveryListRepository deliveryListRepository, child) {
            return Scaffold(
              appBar: AppBar(
                title: deliveryListRepository.isSearching
                    ? TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            hintText: "Tìm kiếm",
                            hintStyle: TextStyle(color: Colors.white)),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        onChanged: _deliveryListRepository.search,
                      )
                    : Text("Hàng về bàn giao"),
                actions: [
                  Visibility(
                    visible: !deliveryListRepository.isSearching,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _deliveryListRepository.toggleSearch();
                      },
                    ),
                  )
                ],
              ),
              body: WillPopScope(
                  onWillPop: () {
                    if (deliveryListRepository.isSearching) {
                      _textEditingController.text = "";
                      _deliveryListRepository.toggleSearch();
                      return Future.value(false);
                    }
                    return Future.value(true);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(
                              complete: Container(),
                            ),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                } else if (mode == LoadStatus.loading) {
                                  body = CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                } else if (mode == LoadStatus.canLoading) {
                                } else {}
                                return Container(
                                  height: 55.0,
                                  child: Center(
                                    child: body,
                                  ),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _deliveryListRepository.refreshData,
                            onLoading: _deliveryListRepository.loadMore,
                            child: isNullOrEmpty(_deliveryListRepository
                                    ?.deliveryListModel?.contracts)
                                ? Center(
                                    child: Text("Không có dữ liệu"),
                                  )
                                : ListView.separated(
                                    itemCount: _deliveryListRepository
                                            ?.deliveryListModel
                                            ?.contracts
                                            ?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      Contracts contracts =
                                          _deliveryListRepository
                                              ?.deliveryListModel?.contracts
                                              ?.elementAt(index);
                                      return InkWell(
                                        onTap: () async {
                                          bool isSuccess = await pushPage(
                                              context,
                                              DeliveryDetailScreen(
                                                  contracts.isUpdate,
                                                  contracts.iD));
                                          if (isSuccess == true) {
                                            _deliveryListRepository
                                                .refreshData();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/icon_manage_contract.webp",
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            contracts
                                                                    ?.project ??
                                                                "",
                                                            style: TextStyle(
                                                                color: getColor(
                                                                    "#6BA3DB"),
                                                                fontSize: 16),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Trạng thái: "),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            100)),
                                                                    color: getColor(contracts
                                                                            ?.deliveryStatus
                                                                            ?.bgColor ??
                                                                        "")),
                                                                child: Text(
                                                                  contracts
                                                                          ?.deliveryStatus
                                                                          ?.name ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RightArrowIcons()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      thickness: 1,
                                      height: 1,
                                    ),
                                  )),
                      ),
                      SortFilterBaseWidget(
                        onSortType: _deliveryListRepository.sort,
                        onFilter: filter,
                        sortType: _deliveryListRepository.sortType,
                      )
                    ],
                  )),
            );
          },
        ));
  }

  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model = ContentShoppingModel(
          title: "Dự án",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _deliveryListRepository.deliveryListModel.searchParam.projects,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PR",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _deliveryListRepository
              .deliveryListModel.searchParam.requisitions,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PO",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _deliveryListRepository.deliveryListModel.searchParam.contracts,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Trạng thái",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _deliveryListRepository
              .deliveryListModel.searchParam.deliveryStatus,
          getTitle: (status) => status.name);
      filterList.add(model);
    }
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: filterList,
          screenTitle: "Lọc nâng cao",
          isCanClear: true,
          onValueChanged: (model) async {
            if (model == null) {
              filterList[1].clearSelected();
              filterList[2].clearSelected();
              filterList[1].dropDownData = _deliveryListRepository.requisitions;
              filterList[2].dropDownData = _deliveryListRepository.contracts;
            } else if (model == filterList[0]) {
              await _deliveryListRepository.getPRByProject(
                  isNotNullOrEmpty(model?.selected)
                      ? model.selected[0].iD
                      : null);
              filterList[1].clearSelected();
              filterList[2].clearSelected();
              filterList[1].dropDownData = _deliveryListRepository
                  .deliveryListModel.searchParam.requisitions;
              filterList[2].dropDownData = _deliveryListRepository.contracts;
            } else if (model == filterList[1]) {
              await _deliveryListRepository.getByPR(
                  isNotNullOrEmpty(model.selected)
                      ? model.selected[0].iD
                      : null);
              filterList[2].clearSelected();
              filterList[2].dropDownData = _deliveryListRepository
                  .deliveryListModel.searchParam.contracts;
            }
          },
        ));

    if (isNotNullOrEmpty(result)) {
      _deliveryListRepository.params.projectID =
          getFirstOrNull(filterList[0]?.selected);
      _deliveryListRepository.params.requisitionNumber =
          getFirstOrNull(filterList[1]?.selected, isGetName: true);
      _deliveryListRepository.params.pONumber =
          getFirstOrNull(filterList[2]?.selected);
      _deliveryListRepository.params.status =
          getFirstOrNull(filterList[3]?.selected);
      _deliveryListRepository.refreshData();
    }
  }

  dynamic getFirstOrNull(List list, {bool isGetName = false}) {
    if (isNullOrEmpty(list)) return null;
    return isGetName ? list.first.name : list.first.iD;
  }
}
