import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/commodity_category_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/create/create_commodity_category_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/filter/filter_commodity_category.dart';
import 'package:workflow_manager/shopping_management/response/commodity_category_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class CommodityCategoryChildScreen extends StatefulWidget {
  @override
  _CommodityCategoryChildScreenState createState() => _CommodityCategoryChildScreenState();
}

class _CommodityCategoryChildScreenState extends State<CommodityCategoryChildScreen> {
  CommodityCategoryRepository _repository = CommodityCategoryRepository();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int sort_type = 0;

  @override
  void initState() {
    super.initState();
    _repository.pullToRefreshData();
    _getListData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, CommodityCategoryRepository repository, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Quản lý danh mục hàng hóa"),
            ),
            body: repository.dataCommodityCategory == null ? Container() : SafeArea(
              child: Column(
                children: [
                        Divider(
                          height: 8,
                          color: Colors.grey,
                        ),
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
                            child: _listWidget(repository),
                          ),
                        ),
                        SortFilterBaseWidget(
                          onFilter: () {
                            pushPage(
                                context,
                                FilterCommodityCategory(
                                  valueCode: _repository.request.code,
                                  valueName: _repository.request.term,
                                  onFilter: (code, name) {
                                    _repository.request.code = code;
                                    _repository.request.term = name;
                                    _repository.pullToRefreshData();
                                    _getListData();
                                  },
                                ));
                          },
                          onSort: () {
                            showModalBottomSheet(
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      SortNameBottomSheet(
                                        onUpdateType: (type) {
                                          setState(() {
                                            sort_type = type;
                                          });
                                          _sortList(type, _repository);
                                        },
                                        type: sort_type,
                                      )
                                    ],
                                  );
                                },
                                context: context);
                          },
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: Visibility(
              visible: repository.dataCommodityCategory.isCreate,
              child: FloatingButtonWidget(
                onSelectedButton: () {
                  pushPage(
                      context,
                      CreateCommodityCategoryScreen(
                        isUpdate: false,
                        onCreateItem: (itemAdd) {
                          _repository.addItemCommodity(itemAdd);
                        },
                      ));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _onRefresh() async {
    sort_type = 0;
    _refreshController.refreshCompleted();
    _repository.pullToRefreshData();
    _getListData();
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListData();
  }

  Widget _listWidget(CommodityCategoryRepository repository) {
    // _sortList(sort_type, repository);
    if (repository.dataCommodityCategory?.categories?.isEmpty) {
      return EmptyScreen();
    }
    return ListView.separated(
      itemCount: repository.dataCommodityCategory.categories?.length,
      itemBuilder: (BuildContext context, int index) {
        return CommodityCategoryItem(
          model: repository.dataCommodityCategory.categories[index],
          onEdit: (itemUpdate) {
            pushPage(context, CreateCommodityCategoryScreen(
              isUpdate: true,
              model: itemUpdate,
              onUpdateItem: (item) {
                _repository.updateItem(item);
              },
            ));
          },
          onDelete: (itemDelete) {
            ConfirmDialogFunction(context: context,
              content: "Bạn có muốn xóa danh mục hàng hóa này không?",
              onAccept: () {
                _repository.deleteCommodityCategory(itemDelete);
              }
            ).showConfirmDialog();
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
         return Divider();
      },
    );
  }

  void _sortList(int type, CommodityCategoryRepository repository, ) {
    if (type == SortNameBottomSheet.SORT_A_Z) {
      repository.dataCommodityCategory.categories.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (type == SortNameBottomSheet.SORT_Z_A) {
      repository.dataCommodityCategory.categories.sort((a, b) {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });
    }

    _repository.updateList(repository.dataCommodityCategory.categories);
  }

  void _getListData() {
    _repository.getCommodityCategoryIndex();
  }
}
