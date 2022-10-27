import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart'
    as refer;
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart';
import 'package:workflow_manager/shopping_management/response/suggest_provider_response.dart';
import 'package:workflow_manager/shopping_management/response/suggest_provider_selected_response.dart';

class SuggestProviderRepository extends ChangeNotifier {
  List<SuggestProviderModel> listData;
  List<refer.Provider> removeList;

  loadData(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsSuggestProvider, {"IDCategory": id});
    SuggestProviderResponse response = SuggestProviderResponse.fromJson(json);
    if (response.status == 1) {
      listData = response.data;
      listData.removeWhere((model) =>
          removeList
              ?.any((element) => model.suggest.provider.iD == element.iD) ==
          true);
      notifyListeners();
    } else {
      showErrorToast(response.messages);
    }
  }

  Future<List<refer.PriceRefers>> done(
      List<SuggestProviderModel> selected) async {
    if (isNullOrEmpty(selected)) {
      showErrorToast("Bạn chưa chọn nhà cung cấp nào");
      return null;
    }
    String ids = selected.map((e) => e.suggest.provider.iD).toList().join(", ");
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsSuggestProviderSeletected, {"IDs": ids});
    SuggestProviderSelectedResponse response =
        SuggestProviderSelectedResponse.fromJson(json);
    if (response.isSuccess()) {
      List<refer.PriceRefers> listSelected = [];
      for (SuggestProviderSelectedModel model in response.data) {
        listSelected.add(refer.PriceRefers(priceRefer: model.suggestSelected));
      }
      return listSelected;
    }
    return null;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
