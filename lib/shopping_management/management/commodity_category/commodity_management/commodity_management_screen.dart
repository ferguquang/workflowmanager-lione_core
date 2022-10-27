import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/commodity_management_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/commodity_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/create_update/create_commodity_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/filter/filter_commodity_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/commodity_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class CommodityManagementScreen extends StatefulWidget {
  @override
  _CommodityManagementScreenState createState() => _CommodityManagementScreenState();
}

class _CommodityManagementScreenState extends State<CommodityManagementScreen> {
  CommodityRepository _repository = CommodityRepository();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int sort_type = 0;

  List<CategorySearchParams> _manufactursSelected;
  List<CategorySearchParams> _categorySelected;

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
        builder: (context, CommodityRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Quản lý hàng hóa"),
            ),
            body: repository.dataCommodityIndex == null ? Container() :  SafeArea(
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
                      child: _listWidget(repository.dataCommodityIndex),
                    ),
                  ),
                  SortFilterBaseWidget(
                          onFilter: () async {
                            List<ContentShoppingModel> list =
                                _repository.addFilter();
                            List<ContentShoppingModel> result = await pushPage(
                                context,
                                ListWithArrowScreen(
                                  data: list,
                                  screenTitle: "Lọc nâng cao",
                                  saveTitle: "Lọc",
                                  isCanClear: true,
                                ));

                            _repository.request.idCategory = result[0]
                                ?.idValue
                                .toString()
                                .replaceAll("]", "")
                                .replaceAll("[", "");
                            _repository.request.idManufacturs = result[1]
                                ?.idValue
                                .toString()
                                .replaceAll("]", "")
                                .replaceAll("[", "");
                            _repository.request.code = result[2].value;
                            _repository.request.name = result[3].value;
                            _repository.pullToRefreshData();
                            _repository.getCommodityIndex();

                            // pushPage(context, FilterCommodityScreen(
                            //             searchParamCommodity: _repository.dataCommodityIndex.searchParam,
                            //             request: _repository.request,
                            //             // categorySelected: _categorySelected,
                            //             // manufactursSelected: _manufactursSelected,
                            //             onFilter: (CommodityRequest request
                            //                 /*, categoriesSelected, manufactureSelected*/) {
                            //               // _manufactursSelected = manufactureSelected;
                            //               // _categorySelected = categoriesSelected;
                            //
                            //               _repository.request = request;
                            //               _repository.pullToRefreshData();
                            //               _getListData();
                            //             },
                            //           ));
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
                                          _sortList(sort_type, repository);
                                        },
                                        type: sort_type,
                                      )
                                    ],
                                  );
                                },
                                context: context);
                          },
                        )
                      ],
                    ),
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 32),
              child: Visibility(
                visible: repository.dataCommodityIndex.isCreate == null ? false : repository.dataCommodityIndex.isCreate,
                child: FloatingButtonWidget(
                  onSelectedButton: () {
                    pushPage(context, CreateCommodityScreen(
                      isUpdate: false,
                      onCreateItem: (itemAdd) {
                        _repository.addItemCommodity(itemAdd);
                      },
                    ));
                  },
                ),
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

  void _getListData() {
    _repository.getCommodityIndex();
  }

  Widget _listWidget(DataCommodityIndex dataCommodityIndex) {
    if (dataCommodityIndex.commodities == null) {
      return Container();
    }
    if (dataCommodityIndex.commodities.length == 0) {
      return EmptyScreen();
    }
    // _sortList(sort_type, _repository);
    return ListView.separated(
      itemCount: dataCommodityIndex.commodities?.length,
      itemBuilder: (BuildContext context, int index) {
        return CommodityManagementItem(
          model: dataCommodityIndex.commodities[index],
          onClickItem: (itemClick) async {
            int status = await pushPage(context, CreateCommodityScreen(
              isUpdate: null,
                  id: itemClick.iD,
                  modelIndex: itemClick,
                  onUpdateItem: (itemUpdate) {
                    _repository.updateItem(itemUpdate);
                  },
                  onRemoveItem: (idItem) {
                    ConfirmDialogFunction(
                        context: context,
                        content: "Bạn có muốn xóa hàng hóa này không?",
                        onAccept: () {
                          Commodities commodities = Commodities();
                          commodities.iD = idItem;
                          _repository.removeItem(commodities);
                        }
                ).showConfirmDialog();
              },
            ));
            if (status == 1) {
              _repository.removeLocal(itemClick);
            }
          },
          onEdit: (itemUpdate) {
            pushPage(context, CreateCommodityScreen(
              isUpdate: true,
              id: dataCommodityIndex.commodities[index].iD,
              onUpdateItem: (itemUpdate) {
                _repository.updateItem(itemUpdate);
              },
            ));
          },
          onDelete: (itemDelete) {
            ConfirmDialogFunction(context: context,
                content: "Bạn có muốn xóa danh mục hàng hóa này không?",
                onAccept: () {
                  _repository.removeItem(itemDelete);
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

  void _sortList(type, CommodityRepository repository) {
    if (type == SortNameBottomSheet.SORT_A_Z) {
      repository.dataCommodityIndex.commodities.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else {
      repository.dataCommodityIndex.commodities.sort((a, b) {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });
    }

    _repository.updateList(repository.dataCommodityIndex.commodities);
  }
}
