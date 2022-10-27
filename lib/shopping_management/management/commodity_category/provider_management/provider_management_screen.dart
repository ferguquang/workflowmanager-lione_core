import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/detail_provider_main_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/provider_info_screen/provider_info_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/provider_management_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/provider_management_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ProviderManagementScreen extends StatefulWidget {
  @override
  _ProviderManagementScreenState createState() => _ProviderManagementScreenState();
}

class _ProviderManagementScreenState extends State<ProviderManagementScreen> {
  ProviderManagementRepository _repository = ProviderManagementRepository();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _sortType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.pullToRefreshData();
    _getListData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, ProviderManagementRepository repository, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Quản lý nhà cung cấp"),
            ),
            body: repository.dataProviderIndex == null ? Container() : SafeArea(
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
                      child: _listWidget(repository.dataProviderIndex),
                    ),
                  ),
                  SortFilterBaseWidget(
                    sortType: _sortType,
                    onSortType: (type) {
                      repository.dataProviderIndex.providers.sort((a, b) =>
                          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
                              a.name
                                  .toLowerCase()
                                  .compareTo(b.name.toLowerCase()));
                      _repository.notifyListeners();
                    },
                    onFilter: _filter,
                  ),
                ],
              ),
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 32),
              child: Visibility(
                visible: repository.dataProviderIndex.isCreate == null ? false : repository.dataProviderIndex.isCreate,
                child: FloatingButtonWidget(
                  onSelectedButton: () async {
                    DataCommodityCreate dataCommodityCreate = await _repository.renderCreateProvider();
                    _createUpdateItem(repository.dataProviderIndex.searchParam, null, dataCommodityCreate);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _listWidget(DataProviderIndex dataProviderIndex) {
    if (isNullOrEmpty(dataProviderIndex.providers)) {
      return EmptyScreen();
    }
    return ListView.separated(
      itemCount: dataProviderIndex.providers?.length,
      itemBuilder: (BuildContext context, int index) {
        return ProviderManagementItem(
          model: dataProviderIndex.providers[index],
          onClickItem: (itemClick) {
            pushPage(context, DetailProviderMainScreen(
              model: dataProviderIndex.providers[index],
            ));
          },
          onEdit: (itemUpdate) async {
            ProviderDetail providerDetail = await _repository.getProviderUpdate(itemUpdate);
            if (providerDetail != null) {
              _createUpdateItem(dataProviderIndex.searchParam, providerDetail, null);
            }
          },
          onDelete: (itemDelete) {
            ConfirmDialogFunction(
                context: context,
                content: "Bạn có muốn xóa nhà cung cấp này không?",
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
    _repository.getProviderIndex();
  }

  Future<void> _createUpdateItem(SearchParamProvider searchParam, ProviderDetail model, DataCommodityCreate dataCommodityCreate) async {
    List<ContentShoppingModel> list = [];

    list.add(ContentShoppingModel(
        key: "Code",
        title: "Mã nhà cung cấp",
        isRequire: true,
        value: model != null ? model.code : dataCommodityCreate.code));
    list.add(ContentShoppingModel(
        key: "Name",
        title: "Tên nhà cung cấp",
        isRequire: true,
        value: model != null ? model.name : ""));
    list.add(ContentShoppingModel(
        key: "Abbreviation",
        title: "Tên viết tắt",
        isRequire: true,
        value: model != null ? model.abbreviation : ""));

    String region = "";
    String idValue = "";
    CategorySearchParams regionSelected;
    if (model != null && model.region != null) {
      region = model.region
          .map((e) => "${e.name}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");

      idValue = model.region
          .map((e) => "${e.iD}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");

      searchParam.regions.forEach((element) {
        if (idValue == "${element.iD}") {
          regionSelected = element;
        }
      });
    }

    list.add(ContentShoppingModel(
      key: "Region",
      title: "Vùng miền",
      isRequire: true,
      isDropDown: true,
      idValue: idValue,
      dropDownData: searchParam.regions,
      selected: regionSelected != null ? [regionSelected] : [],
      getTitle: (status) => status.name,
      value: model != null ? region : "",
      isSingleChoice: true,
    ));

    String nationString = "";
    CategorySearchParams nationSelected;
    String idValueNation = "";
    if (model != null) {
      nationString = model.nation.name;
      searchParam.nations.forEach((element) {
        if (element.iD == model.nation.iD) {
          nationSelected = element;
        }
      });

      idValueNation = "${nationSelected.iD}";
    } else {
      dataCommodityCreate.nations.forEach((element) {
        if (element.iD == dataCommodityCreate.iDNation) {
          nationString = element.name;
          return;
        }
      });

      searchParam.nations.forEach((element) {
        if (element.iD == dataCommodityCreate.iDNation) {
          nationSelected = element;
        }
      });

      idValueNation = "${nationSelected.iD}";
    }

    list.add(ContentShoppingModel(
      key: "IDNation",
      title: "Quốc gia",
      isDropDown: true,
      value: nationString,
      idValue: idValueNation,
      dropDownData: searchParam.nations,
      selected: nationSelected != null ? [nationSelected] : [],
      getTitle: (data) => data.name,
    ));
    list.add(ContentShoppingModel(key: "Address", title: "Địa chỉ", value: model != null ? model.address : ""));
    list.add(ContentShoppingModel(key: "PersonContact", title: "Người liên hệ", value: model != null ? model.personContact : ""));
    list.add(ContentShoppingModel(key: "PhoneContact", title: "Số điện thoại người liên hệ", isNumeric: true, value: model != null ? model.phoneContact : ""));
    list.add(ContentShoppingModel(key: "Email", title: "Email", value: model != null ? model.email : ""));
    list.add(ContentShoppingModel(key: "TaxCode", title: "Mã số thuế", value: model != null ? model.taxCode : ""));

    String categoryString = "";
    List<dynamic> categorySelected = [];
    if (model != null) {
      List<String> result = model.commodityCategorys.split(',');
      categoryString = result.toString().replaceAll("[", "").replaceAll("]", "");
    }
    list.add(ContentShoppingModel(
      key: "IDCategorys",
      title: "Danh mục hàng hóa",
      isDropDown: true,
      isRequire: true,
      isSingleChoice: false,
      value: categoryString,
      selected: categorySelected,
      dropDownData: searchParam.categorys,
      getTitle: (item) {
        return item.name;
      })
    );

    // update:
    if (model != null) {
      // quốc gia
      // list[4].idValue = model.nation.iD;
      // List<dynamic> selectedNation = [];
      // selectedNation.add(model.nation);
      // list[4].selected = selectedNation;

      // danh mục
      List<dynamic> selected = [];
      List<String> idCategoryList = [];
      List<String> result = model.commodityCategorys.split(',');
      result.forEach((itemSelected) {
        searchParam.categorys.forEach((itemCategory) {
          if (itemSelected == itemCategory.name) {
            idCategoryList.add("${itemCategory.iD}");
            selected.add(itemCategory);
          }
        });
      });
      list[10].idValue = idCategoryList
          .map((e) => "$e")
          .toList()
          .toString();
      list[10].selected = selected;
    }

    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          saveTitle: "XONG",
          screenTitle: model == null ? "Tạo mới nhà cung cấp" : "Cập nhật nhà cung cấp",
        )
    );

    int status = await _repository.createUpdateProvider(result, model);
    if (status == 1) {
      _repository.pullToRefreshData();
      _getListData();
    }
  }

  Future<void> _filter() async {
    List<ContentShoppingModel> list = _repository.addFilter();
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          screenTitle: "Lọc nâng cao",
          isCanClear: true,
        ));

    _repository.request.codeName = result[0].value;
    _repository.request.abbreviation = result[1].value;
    _repository.request.region =
        result[2].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.nation =
        result[3].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.idCategorys =
        result[4].idValue.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.pullToRefreshData();
    _getListData();
  }
}
