import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/progress_report_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';

import 'progress_report_repository.dart';

class ProgressReportScreen extends StatefulWidget {
  ProgressReportScreen();

  @override
  _ProgressReportScreenState createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  List<ContentShoppingModel> filterList = [];
  ProgressReportRepository _shoppingReportRepository =
      ProgressReportRepository();
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _shoppingReportRepository.refreshController = _refreshController;
    _shoppingReportRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _shoppingReportRepository,
        child: Consumer(
          builder: (context, ProgressReportRepository deliveryListRepository,
              child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Báo cáo tiến độ mua sắm"),
              ),
              body: Column(
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
                        onRefresh: _shoppingReportRepository.refreshData,
                        onLoading: _shoppingReportRepository.loadMore,
                        child: isNullOrEmpty(_shoppingReportRepository
                                ?.progressReportModel?.report)
                            ? Center(
                                child: Text("Không có dữ liệu"),
                              )
                            : ListView.separated(
                                itemCount: _shoppingReportRepository
                                        ?.progressReportModel?.report?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  Report report = _shoppingReportRepository
                                      ?.progressReportModel?.report
                                      ?.elementAt(index);
                                  return InkWell(
                                    onTap: () {
                                      showDetails(report);
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
                                                        report?.project ?? "",
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
                                                      Text(
                                                          "Mã PR: ${report?.requisition ?? ""}"),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4),
                                                      ),
                                                      Text(
                                                          "Chủ đầu tư: ${report?.investor ?? ""}"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                    onSortType: _shoppingReportRepository.sort,
                    onFilter: filter,
                    sortType: _shoppingReportRepository.sortType,
                  )
                ],
              ),
            );
          },
        ));
  }

  showDetails(Report model) {
    List<ContentShoppingModel> listData = [];
    String PROJECT = "Dự án";
    String PR = "PR";
    String PO = "PO";
    String INVESTOR = "Chủ đầu tư";
    String TONG_TIEN = "Tổng tiền (VNĐ)";
    String CHAM = "Chậm (%)";
    String HANG_DANGVE = "Hàng đang về (%)";
    String DUNG_TIENDO = "Đúng tiến độ (%)";
    String VUOT_TIENDO = "Vượt tiến độ (%)";
    listData.add(ContentShoppingModel(
        title: PROJECT, value: model.project, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: PR, value: model.requisition, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: PO, value: model.contract, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: INVESTOR, value: model.investor, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: TONG_TIEN, value: model.totalAmount, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: CHAM, value: model.cham, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: HANG_DANGVE, value: model.dangVe, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: DUNG_TIENDO, value: model.dungTienDo, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: VUOT_TIENDO, value: model.vuotTienDo, isNextPage: false));
    pushPage(
        context,
        ListWithArrowScreen(
          data: listData,
          screenTitle: "Chi tiết báo cáo tiến độ",
          isShowSaveButton: false,
        ));
  }

  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model = ContentShoppingModel(
          title: "Chọn dự án",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _shoppingReportRepository
              .progressReportModel.searchParam.projects,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PR",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _shoppingReportRepository
              .progressReportModel.searchParam.requisitions,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PO",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _shoppingReportRepository
              .progressReportModel.searchParam.contracts,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(title: "Người yêu cầu", isNextPage: true);
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
                  _shoppingReportRepository.requisitions;
              filterList[2].dropDownData = _shoppingReportRepository.contracts;
            } else if (model == filterList[0]) {
              await _shoppingReportRepository.getPRByProject(
                  isNotNullOrEmpty(model?.selected)
                      ? model.selected[0].iD
                      : null);
              filterList[1].clearSelected();
              filterList[2].clearSelected();
              filterList[1].dropDownData = _shoppingReportRepository
                  .progressReportModel.searchParam.requisitions;
              filterList[2].dropDownData = _shoppingReportRepository.contracts;
            } else if (model == filterList[1]) {
              await _shoppingReportRepository.getByPR(
                  isNotNullOrEmpty(model.selected)
                      ? model.selected[0].iD
                      : null);
              filterList[2].clearSelected();
              filterList[2].dropDownData = _shoppingReportRepository
                  .progressReportModel.searchParam.contracts;
            }
          },
        ));

    if (isNotNullOrEmpty(result)) {
      _shoppingReportRepository.params.iDProject =
          getFirstOrNull(filterList[0]?.selected);
      _shoppingReportRepository.params.iDRequisition =
          getFirstOrNull(filterList[1]?.selected);
      _shoppingReportRepository.params.iDContract =
          getFirstOrNull(filterList[2]?.selected);
      _shoppingReportRepository.params.requestBy = filterList[3]?.value;
      _shoppingReportRepository.refreshData();
    }
  }

  dynamic getFirstOrNull(List list, {bool isGetName: false}) {
    if (isNullOrEmpty(list)) return null;
    return isGetName ? list.first.name : list.first.iD;
  }
}
