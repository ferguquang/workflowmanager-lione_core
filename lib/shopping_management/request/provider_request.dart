import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class ProviderIndexRequest {
  dynamic skip, take, codeName, abbreviation, region, idCategorys, nation;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Skip"] = skip;
    params["Take"] = take;
    if (codeName != null) {
      params["CodeName"] = codeName;
    }
    if (abbreviation != null) {
      params["Abbreviation"] = abbreviation;
    }
    if (region != null) {
      params["Region"] = region.replaceAll("[", "").replaceAll("]", "");
    }
    if (idCategorys != null) {
      params["IDCategorys"] =
          idCategorys.replaceAll("[", "").replaceAll("]", "");
    }
    params["IDNation"] = nation;

    params.removeWhere((key, value) => isNullOrEmpty(value) || value == "");
    return params;
  }
}

class ProviderDetailRequest {
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    return params;
  }
}

class ProviderCreateRequest {
  List<ContentShoppingModel> list;
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();

    list.forEach((element) {
      params[element.key] = element.isDropDown
          ? "${element.idValue}".replaceAll("[", "").replaceAll("]", "")
          : element.value;
    });
    // params["Code"] = list[0].value;
    // params["Name"] = list[1].value;
    // params["Abbreviation"] = list[2].value;
    // params["Region"] = list[3].idValue.replaceAll("[", "").replaceAll("]", "");
    // params["IDNation"] = list[4].idValue.toString().replaceAll("[", "").replaceAll("]", "");
    // params["Address"] = list[5].value;
    // params["PersonContact"] = list[6].value;
    // params["PhoneContact"] = list[7].value;
    // params["Email"] = list[8].value;
    // params["TaxCode"] = list[9].value;
    // params["IDCategorys"] = list[10].idValue;
    if (id != null) {
      params["ID"] = id;
    }
    return params;
  }
}

class ProviderChangeDebtLogRequest {
  List<ContentShoppingModel> list;
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    list.forEach((element) {
      params[element.key] =
          element.isDropDown ? element.idValue : element.value;
    });
    // params["DebtAmount"] = list[0].value;
    // params["PaidAmount"] = list[1].value;
    // params["RemainAmount"] = list[2].value;
    params["IDProvider"] = id;
    return params;
  }
}
