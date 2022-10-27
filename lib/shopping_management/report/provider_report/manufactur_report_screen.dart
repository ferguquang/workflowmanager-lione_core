import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/manufactur_report_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';

import 'manufactur_report_repository.dart';

class ManufacturReportScreen extends StatefulWidget {
  ManufacturReportScreen();

  @override
  _ManufacturReportScreenState createState() => _ManufacturReportScreenState();
}

class _ManufacturReportScreenState extends State<ManufacturReportScreen> {
  List<ContentShoppingModel> filterList = [];
  ManufacturReportRepository _providerReportRepository =
      ManufacturReportRepository();
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _providerReportRepository.refreshController = _refreshController;
    _providerReportRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _providerReportRepository,
        child: Consumer(
          builder: (context, ManufacturReportRepository deliveryListRepository,
              child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Báo cáo mua sắm theo hãng"),
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
                        onRefresh: _providerReportRepository.refreshData,
                        onLoading: _providerReportRepository.loadMore,
                        child: isNullOrEmpty(_providerReportRepository
                                ?.manufacturReportModel?.report)
                            ? Center(
                                child: Text("Không có dữ liệu"),
                              )
                            : ListView.separated(
                                itemCount: _providerReportRepository
                                        ?.manufacturReportModel
                                        ?.report
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  Report report = _providerReportRepository
                                      ?.manufacturReportModel?.report
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
                                                      report?.manufactur ?? "",
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
                                                        "Tổng tiền đã mua (VND): ${getCurrencyFormat(report?.total) ?? ""}"),
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
                    onSortType: _providerReportRepository.sort,
                    onFilter: filter,
                    sortType: _providerReportRepository.sortType,
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
          title: "Chọn hãng",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _providerReportRepository.manufacturReportModel.manufacturs,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Thời gian bắt đầu", isNextPage: true, isOnlyDate: true);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Thời gian kết thúc", isNextPage: true, isOnlyDate: true);
      filterList.add(model);
    }
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: filterList,
          screenTitle: "Lọc nâng cao",
          isCanClear: true,
        ));

    if (isNotNullOrEmpty(result)) {
      _providerReportRepository.params.iDManufactur =
          getFirstOrNull(filterList[0]?.selected);
      _providerReportRepository.params.startDate = filterList[1]?.value;
      _providerReportRepository.params.endDate = filterList[2]?.value;
      _providerReportRepository.refreshData();
    }
  }

  int getFirstOrNull(List list) {
    if (isNullOrEmpty(list)) return null;
    return list.first.iD;
  }
}
