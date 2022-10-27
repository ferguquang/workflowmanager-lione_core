import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class ProviderVoteIndexRequest {
  dynamic take, skip, provider, contract, idCategorys;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Skip"] = skip;
    params["Take"] = take;
    if (isNotNullOrEmpty(provider)) {
      params["Provider"] = provider;
    }
    if (isNotNullOrEmpty(contract)) {
      params["Contract"] = contract;
    }
    if (isNotNullOrEmpty(idCategorys) && idCategorys != "null") {
      params["IDCategorys"] = idCategorys;
    }

    return params;
  }
}


class ProviderVoteSaveRequest {
  List<ContentShoppingModel> list;
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    list.forEach((element) {
      if (isNotNullOrEmpty(element.key)) {
        params[element.key] = element.isDropDown ? element.idValue : element.value;
      }
    });
    if (id != null) {
      params["ID"] = id;
    }
    return params;
  }
}
