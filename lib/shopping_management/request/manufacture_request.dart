import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class ManufactureIndexRequest {
  dynamic skip, take, code = "", name = "";

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Skip"] = skip;
    params["Take"] = take;
    if (isNotNullOrEmpty(code)) {
      params["Code"] = code;
    }
    if (isNotNullOrEmpty(name)) {
      params["Name"] = name;
    }
    return params;
  }
}

class CreateUpdateManufactureRequest {
  List<ContentShoppingModel> list = [];
  int id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    list.forEach((element) {
      params[element.key] = element.isDropDown ? element.idValue : element.value;
    });

    if (id != null) {
      params["ID"] = id;
    }

    return params;
  }
}