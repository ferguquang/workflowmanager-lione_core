import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/manufacture_management/manufacture_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/manufacture_management/manufacture_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/manufacture_request.dart';
import 'package:workflow_manager/shopping_management/response/manufacture_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ManufactureManagementScreen extends StatefulWidget {
  @override
  _ManufactureManagementScreenState createState() => _ManufactureManagementScreenState();
}

class _ManufactureManagementScreenState extends State<ManufactureManagementScreen> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ManufactureRepository _repository = ManufactureRepository();

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
        builder: (BuildContext context, ManufactureRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Quản lý hãng"),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Divider(color: Colors.grey, height: 8,),
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
                      child: _listWidget(repository.dataManufacturIndex),
                    ),
                  ),
                  SortFilterBaseWidget(
                    sortType: sort_type,
                    onSortType: (type) {
                      sort_type = type;
                      repository.dataManufacturIndex.manufacturs.sort(
                              (a, b) =>
                          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
                              a.name
                                  .toLowerCase()
                                  .compareTo(b.name.toLowerCase()));
                      _repository.notifyListeners();
                    },
                    onFilter: () => _filter(_repository.request),
                  ),
                ],
              ),
            ),
            floatingActionButton: Visibility(
              visible: repository.dataManufacturIndex.isCreate == null ? false : repository.dataManufacturIndex.isCreate,
              child: FloatingButtonWidget(
                onSelectedButton: () {
                  _createUpdateItem(
                    isUpdate: false
                  );
                },
              ),
            )
          );
        },
      ),
    );
  }

  Widget _listWidget(DataManufacturIndex dataManufacturIndex) {
    if (dataManufacturIndex.manufacturs == null) {
      return Container();
    }
    return ListView.separated(
      itemCount: dataManufacturIndex.manufacturs?.length,
      itemBuilder: (BuildContext context, int index) {
        return ManufactureItem(
          model: dataManufacturIndex.manufacturs[index],
          onClickItem: (itemClick) async {
            List<ContentShoppingModel> list = _repository.renderDetail(itemClick);;

            pushPage(context, ListWithArrowScreen(
                data: list,
                isShowSaveButton: false,
                screenTitle: "Chi tiết hãng",
              )
            );
          },
          onEdit: (itemUpdate) async {
            _createUpdateItem(
              isUpdate: true,
              id: itemUpdate.iD
            );
          },
          onDelete: (itemDelete) {
            ConfirmDialogFunction(
                context: context,
                content: "Bạn có muốn xóa hãng này không?",
                onAccept: () {
                  _repository.removeItem(itemDelete);
                }).showConfirmDialog();
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
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
    _repository.getManufactureIndex();
  }

  Future<void> _filter(ManufactureIndexRequest request) async {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(
        key: "Code",
        title: "Mã hãng",
        value: request != null ? request.code : ""));
    list.add(ContentShoppingModel(
        key: "Name",
        title: "Tên hãng",
        value: request != null ? request.name : ""));

    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          saveTitle: "LỌC",
          screenTitle: "Lọc nâng cao",
        ));

    _repository.request.code = result[0].value;
    _repository.request.name = result[1].value;
    _repository.pullToRefreshData();
    _repository.getManufactureIndex();
  }

  void _createUpdateItem({bool isUpdate, int id}) async {
    DataManufactureRender dataManufactureRender = await _repository.renderForm(isUpdate: isUpdate, id: id);
    if (dataManufactureRender != null) {
      List<ContentShoppingModel> list = _repository.addList(
          isUpdate: isUpdate,
          model: dataManufactureRender.manufactur != null
              ? dataManufactureRender.manufactur
              : null,
          categories: dataManufactureRender.categories);

      List<ContentShoppingModel> result = await pushPage(
          context,
          ListWithArrowScreen(
            data: list,
            saveTitle: "XONG",
            screenTitle: "Tạo mới hãng",
          ));

      int status =
          await _repository.createUpdateManufacture(isUpdate, result, id: id);
      if (status == 1) {
        _repository.pullToRefreshData();
        _getListData();
      }
    }
  }
}
