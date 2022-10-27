import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/general_report_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';

import '../../../base/utils/common_function.dart';
import 'general_report_repository.dart';

class GeneralReportScreen extends StatefulWidget {
  bool isGeneral;

  GeneralReportScreen(this.isGeneral);

  @override
  _GeneralReportScreenState createState() => _GeneralReportScreenState();
}

class _GeneralReportScreenState extends State<GeneralReportScreen> {
  List<ContentShoppingModel> filterList = [];
  GeneralReportRepository _generalReportRepository = GeneralReportRepository();
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _generalReportRepository.isGeneral = widget.isGeneral;
    _generalReportRepository.refreshController = _refreshController;
    _generalReportRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _generalReportRepository,
        child: Consumer(
          builder:
              (context, GeneralReportRepository deliveryListRepository, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.isGeneral
                    ? "Báo cáo tổng hợp mua sắm"
                    : "Báo cáo chi tiết mua sắm"),
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
                        onRefresh: _generalReportRepository.refreshData,
                        onLoading: _generalReportRepository.loadMore,
                        child: isNullOrEmpty(_generalReportRepository
                                ?.generalReportModel?.report)
                            ? Center(
                                child: Text("Không có dữ liệu"),
                              )
                            : ListView.separated(
                                itemCount: _generalReportRepository
                                        ?.generalReportModel?.report?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  Report report = _generalReportRepository
                                      ?.generalReportModel?.report
                                      ?.elementAt(index);
                                  return Container(
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      report?.projectName ?? "",
                                                      style: TextStyle(
                                                          color: getColor(
                                                              "#6BA3DB"),
                                                          fontSize: 16),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Text(
                                                        "Mã dự án: ${report?.projectCode ?? ""}"),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Text(
                                                        "Chủ đầu tư: ${report?.investor ?? ""}"),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          !widget.isGeneral,
                                                      child: Text(
                                                          "Danh mục hàng hóa: ${report?.category ?? ""}"),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Text(
                                                        "Tổng tiền: ${getCurrencyFormat(report?.totalAmount?.toString())}"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                    onSortType: _generalReportRepository.sort,
                    onFilter: filter,
                    sortType: _generalReportRepository.sortType,
                  )
                ],
              ),
            );
          },
        ));
  }

  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model = ContentShoppingModel(
          title: "Chọn phòng ban",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _generalReportRepository.generalReportModel.searchParam.dept,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Mã hoặc tên dự án",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _generalReportRepository.generalReportModel.searchParam.projects,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Năm",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _generalReportRepository.generalReportModel.searchParam.years,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Quý",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _generalReportRepository.generalReportModel.searchParam.quarter,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Loại đề nghị",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _generalReportRepository
              .generalReportModel.searchParam.suggestTypes,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Hình thức mua sắm",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _generalReportRepository
              .generalReportModel.searchParam.shoppingTypes,
          getTitle: (status) => status.name);
      filterList.add(model);
      if (!widget.isGeneral) {
        model = ContentShoppingModel(
            title: "Danh mục hàng hóa",
            isDropDown: true,
            isSingleChoice: false,
            dropDownData: _generalReportRepository
                .generalReportModel.searchParam.categories,
            getTitle: (status) => status.name);
        filterList.add(model);
      }
    }
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: filterList,
          screenTitle: "Lọc",
          isCanClear: true,
          saveTitle: "Áp dụng",
        ));

    if (isNotNullOrEmpty(result)) {
      _generalReportRepository.params.deptID =
          getFirstOrNull(filterList[0]?.selected);
      _generalReportRepository.params.projectID =
          getFirstOrNull(filterList[1]?.selected);
      _generalReportRepository.params.year =
          getFirstOrNull(filterList[2]?.selected);
      _generalReportRepository.params.quarter =
          getFirstOrNull(filterList[3]?.selected);
      _generalReportRepository.params.suggestType =
          getFirstOrNull(filterList[4]?.selected);
      _generalReportRepository.params.shoppingType =
          getFirstOrNull(filterList[5]?.selected);
      if (!widget.isGeneral) {
        _generalReportRepository.params.cateIds =
            isNullOrEmpty(filterList[6].selected)?null:filterList[6].selected.map((e) => e.iD).toList().cast<int>();
      }
      _generalReportRepository.refreshData();
    }
  }

  int getFirstOrNull(List list) {
    if (isNullOrEmpty(list)) return null;
    return list.first.iD;
  }
}
