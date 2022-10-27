import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/plan_shopping/detail/plan_shopping_detail_screen.dart';
import 'package:workflow_manager/shopping_management/management/plan_shopping/plan_shopping_item.dart';
import 'package:workflow_manager/shopping_management/management/plan_shopping/plan_shopping_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class PlanShoppingScreen extends StatefulWidget {
  @override
  _PlanShoppingScreenState createState() => _PlanShoppingScreenState();
}

class _PlanShoppingScreenState extends State<PlanShoppingScreen> {
  PlanShoppingRepository _repository = PlanShoppingRepository();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _sortType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.pullToRefreshData();
    _repository.getPlanIndex();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, PlanShoppingRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Kế hoạch mua sắm"),
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
                      child: isNullOrEmpty(_repository.data.plannings)
                          ? EmptyScreen()
                          : ListView.builder(
                              itemCount: _repository.data.plannings.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PlanShoppingItem(
                                  model: _repository.data.plannings[index],
                                  onClickItem: (itemClick) {
                                    pushPage(
                                        context,
                                        PlanShoppingDetailScreen(
                                          id: itemClick.iD,
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
                      repository.data.plannings.sort((a,
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
    _repository.getPlanIndex();
  }

  _filter() async {
    List<ContentShoppingModel> list = _repository.addFilter();
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          screenTitle: "Lọc nâng cao",
          saveTitle: "Lọc",
          isCanClear: true,
        ));

    _repository.request.idDept = result[0].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.year = result[1].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.quarter = result[2].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.suggestionType = result[3].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.shoppingType = result[4].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.pullToRefreshData();
    _repository.getPlanIndex();
  }
}
