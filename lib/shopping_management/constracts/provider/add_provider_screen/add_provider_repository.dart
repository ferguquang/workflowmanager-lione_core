import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_model.dart';
import 'package:workflow_manager/shopping_management/request/add_provider_params.dart';
import 'package:workflow_manager/shopping_management/response/search_provider_reponse.dart';

class AddProviderRepository extends ChangeNotifier {
  AddProviderParams params = AddProviderParams();
  int take = 20;
  int pageIndex = 1;
  SearchProviderModel searchProviderModel;
  List<SearchProviderModel> checkedList = [];
  RefreshController refreshController;
  List<int> selectedIds = [];

  _loadData() async {
    params.pageIndex = pageIndex;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsProviderIndex, params.getParams(),
        isLoading: pageIndex == 1);
    SearchProviderResponse searchProvideResponse =
        SearchProviderResponse.fromJson(response);
    if (searchProvideResponse.status == 1) {
      if (pageIndex == 1) {
        searchProviderModel = searchProvideResponse.data;
        checkedList = [];
      } else {
        searchProviderModel.providers
            .addAll(searchProvideResponse.data.providers);
        searchProviderModel.totalRecord =
            searchProvideResponse.data.totalRecord;
        searchProviderModel.searchParam =
            searchProvideResponse.data.searchParam;
      }
      if (isNotNullOrEmpty(selectedIds))
        searchProviderModel.providers
            .removeWhere((element) => selectedIds.contains(element.iD));
      notifyListeners();
      pageIndex++;
    } else {
      showErrorToast(searchProvideResponse.messages);
    }
    if (refreshController.isRefresh)
      refreshController.refreshCompleted();
    else if (refreshController.isLoading) {
      refreshController.loadComplete();
    }
  }

  refreshData() {
    pageIndex = 1;
    _loadData();
  }

  loadMore({int pageIndex}) {
    if (searchProviderModel != null) {
      if (searchProviderModel.totalRecord < take) {
        refreshController.loadComplete();
        return;
      }
    }
    if (pageIndex != null) {
      this.pageIndex = pageIndex;
    }
    _loadData();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
