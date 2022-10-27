import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/report/import_report/import_report_item.dart';
import 'package:workflow_manager/shopping_management/management/report/import_report/import_report_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ImportReportScreen extends StatefulWidget {
  @override
  _ImportReportScreenState createState() => _ImportReportScreenState();
}

class _ImportReportScreenState extends State<ImportReportScreen> {
  ImportReportRepository _repository = ImportReportRepository();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _sortType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.pullToRefreshData();
    _repository.getImportReport();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, ImportReportRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Báo cáo nhập hàng mua sắm"),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(
                        complete: Container(),
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus mode) {
                          return Container(
                            height: 55.0,
                            child: Center(),
                          );
                        },
                      ),
                      onRefresh: () {
                        _onRefresh();
                      },
                      onLoading: () {
                        _onLoadMore();
                      },
                      child: isNullOrEmpty(_repository.data.report)
                          ? EmptyScreen()
                          : ListView.builder(
                              itemCount: _repository.data.report.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ImportReportItem(
                                  model: _repository.data.report[index],
                                  onClickItem: (itemClick) {
                                    pushPage(
                                        context,
                                        ListWithArrowScreen(
                                          data: _repository
                                              .getListDetail(itemClick),
                                          screenTitle:
                                              "Chi tiết báo cáo nhập hàng phân phối",
                                          isShowSaveButton: false,
                                        ));
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                  SortFilterBaseWidget(
                    sortType: _sortType,
                    onSortType: (type) {
                      _sortType = type;
                      repository.data.report.sort((a,
                          b) =>
                      (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
                          a.nameCommodity
                              .toLowerCase()
                              .compareTo(b.nameCommodity.toLowerCase()));
                      _repository.notifyListeners();
                    },
                    onFilter: _filter,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onRefresh() async {
    _sortType = 0;
    _refreshController.refreshCompleted();
    _repository.pullToRefreshData();
    _getListData();
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListData();
  }

  void _getListData() {
    _repository.getImportReport();
  }

  Future<void> _filter() async {
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: _repository.getListFilter(),
          screenTitle: "Lọc nâng cao",
          isCanClear: true,
        ));

    _repository.request.nameProvider = result[0].value;
    _repository.request.nameCommodity = result[1].value;
    _repository.request.startDate = result[2].value;
    _repository.request.endDate = result[3].value;
    _repository.pullToRefreshData();
    _getListData();
  }
}
