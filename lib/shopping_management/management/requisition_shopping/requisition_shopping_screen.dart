import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/requisition_shopping/requisition_shopping_item.dart';
import 'package:workflow_manager/shopping_management/management/requisition_shopping/requisition_shopping_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

import 'detail/requisition_detail_screen.dart';

class RequisitionShoppingScreen extends StatefulWidget {
  @override
  _RequisitionShoppingScreenState createState() => _RequisitionShoppingScreenState();
}

class _RequisitionShoppingScreenState extends State<RequisitionShoppingScreen> {
  RequisitionShoppingRepository _repository = RequisitionShoppingRepository();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _sortType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.pullToRefreshData();
    _repository.getRequisitionIndex();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, RequisitionShoppingRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Yêu cầu mua sắm"),
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
                      child: isNullOrEmpty(_repository.data.requisitions)
                          ? EmptyScreen()
                          : ListView.builder(
                              itemCount: _repository.data.requisitions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RequisitionShoppingItem(
                                  model: _repository.data.requisitions[index],
                                  onClickItem: (itemClick) async {
                                    await pushPage(
                                        context,
                                        RequisitionDetailScreen(
                                          model: itemClick,
                                        ));

                                    _repository.pullToRefreshData();
                                    _repository.getRequisitionIndex();
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
                      repository.data.requisitions.sort((a,
                          b) =>
                      (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
                          a.shoppingType
                              .toLowerCase()
                              .compareTo(b.shoppingType.toLowerCase()));
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
    _repository.getRequisitionIndex();
  }

  Future<void> _filter() async {
    List<ContentShoppingModel> list = _repository.addFilter();
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          screenTitle: "Lọc nâng cao",
          saveTitle: "Lọc",
          isCanClear: true,
        ));

    _repository.request.requisitionNumber = result[0]?.value;
    _repository.request.requestBy = result[1]?.value;
    _repository.request.idDept =
        result[2].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.statuisProcess =
        result[3].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.pullToRefreshData();
    _repository.getRequisitionIndex();
  }
}
