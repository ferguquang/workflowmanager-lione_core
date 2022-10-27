import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/delivery_details_screen/delivery_detail_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/payment/payment_progress_details_screen/payment_progress_details_screen.dart';
import 'package:workflow_manager/shopping_management/response/payment_progress_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';

import 'payment_progress_list_repository.dart';

class PaymentProgressListScreen extends StatefulWidget {
  @override
  _PaymentProgressListScreenState createState() =>
      _PaymentProgressListScreenState();
}

class _PaymentProgressListScreenState extends State<PaymentProgressListScreen> {
  List<ContentShoppingModel> items = [];
  List<ContentShoppingModel> filterList = [];
  PaymentProgressListRepository _paymentProgressListRepository =
      PaymentProgressListRepository();

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _paymentProgressListRepository.refreshController = _refreshController;
    _paymentProgressListRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tiến độ thanh toán"),
        ),
        body: ChangeNotifierProvider.value(
          value: _paymentProgressListRepository,
          child: Consumer(
            builder: (context,
                PaymentProgressListRepository paymentProgressListRepository,
                child) {
              return Column(
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
                        onRefresh: _paymentProgressListRepository.refreshData,
                        onLoading: _paymentProgressListRepository.loadMore,
                        child: isNullOrEmpty(_paymentProgressListRepository
                                ?.paymentProgressModel?.contracts)
                            ? Center(
                                child: Text("Không có dữ liệu"),
                              )
                            : ListView.separated(
                                itemCount: _paymentProgressListRepository
                                        ?.paymentProgressModel
                                        ?.contracts
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  Contracts contracts =
                                      _paymentProgressListRepository
                                          ?.paymentProgressModel?.contracts
                                          ?.elementAt(index);
                                  if (contracts.isView != true)
                                    print("uay uay ${contracts.project}");
                                  return InkWell(
                                    onTap: () async {
                                      if (contracts.isView != true) {
                                        showErrorToast(
                                            "Bạn không được quyền xem mục này");
                                        return;
                                      }
                                      bool isSuccess = await pushPage(
                                          context,
                                          PaymentProgressDetailScreen(
                                              contracts.isUpdate,
                                              contracts.iD));
                                      if (isSuccess == true) {
                                        _paymentProgressListRepository
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
                                                  "assets/images/icon_statistic.webp",
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        contracts?.project ??
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
                                                          Text("Mã PR: "),
                                                          Expanded(
                                                              child: Text(contracts
                                                                      ?.requisitionNumber ??
                                                                  ""))
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Trạng thái: "),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            100)),
                                                                color: getColor(
                                                                    contracts
                                                                            ?.status
                                                                            ?.bgColor ??
                                                                        "")),
                                                            child: Text(
                                                              contracts?.status
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
                    onSortType: _paymentProgressListRepository.sort,
                    onFilter: filter,
                    sortType: _paymentProgressListRepository.sortType,
                  )
                ],
              );
            },
          ),
        ));
  }

  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model = ContentShoppingModel(
          title: "Dự án",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _paymentProgressListRepository
              .paymentProgressModel.searchParam.projects,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PR",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _paymentProgressListRepository
              .paymentProgressModel.searchParam.pRCodes,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PO",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _paymentProgressListRepository
              .paymentProgressModel.searchParam.pOCodes,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Mã hoặc tên NCC", getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Trạng thái",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _paymentProgressListRepository
              .paymentProgressModel.searchParam.statuses,
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
              filterList[1].dropDownData =
                  _paymentProgressListRepository.pRCodes;
              filterList[2].dropDownData =
                  _paymentProgressListRepository.pOCodes;
            } else if (model == filterList[0]) {
              await _paymentProgressListRepository.getPRByProject(
                  isNotNullOrEmpty(model?.selected)
                      ? model.selected[0].iD
                      : null);
              filterList[1].dropDownData = _paymentProgressListRepository
                  .paymentProgressModel.searchParam.pRCodes;
              filterList[1].clearSelected();
              filterList[2].clearSelected();
              filterList[2].dropDownData =
                  _paymentProgressListRepository.pOCodes;
            } else if (model == filterList[1]) {
              await _paymentProgressListRepository.getByPR(
                  isNotNullOrEmpty(model.selected)
                      ? model.selected[0].iD
                      : null);
              filterList[2].dropDownData = _paymentProgressListRepository
                  .paymentProgressModel.searchParam.pOCodes;
              filterList[2].clearSelected();
            }
          },
        ));

    if (isNotNullOrEmpty(result)) {
      _paymentProgressListRepository.params.project =
          getFirstOrNull(filterList[0]?.selected);
      _paymentProgressListRepository.params.prCodes =
          getFirstOrNull(filterList[1]?.selected, isGetName: true);
      _paymentProgressListRepository.params.pOCodes =
          getFirstOrNull(filterList[2]?.selected);
      _paymentProgressListRepository.params.providerTerm = filterList[3].value;
      _paymentProgressListRepository.params.status =
          getFirstOrNull(filterList[4]?.selected);
      _paymentProgressListRepository.refreshData();
    }
  }

  dynamic getFirstOrNull(List list, {bool isGetName = false}) {
    if (isNullOrEmpty(list)) return null;
    return isGetName ? list.first.name : list.first.iD;
  }
}
