import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class CommodityRequest {
  dynamic code, name, idCategory, idManufacturs, take, skip;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (isNotNullOrEmpty(code)) {
      params["Code"] = code;
    }
    if (isNotNullOrEmpty(name)) {
      params["Name"] = name;
    }
    if (isNotNullOrEmpty(idCategory)) {
      params["IDCategory"] =
          "$idCategory".replaceAll("[", "").replaceAll("]", "");
    }
    if (isNotNullOrEmpty(idManufacturs)) {
      params["IDManufacturs"] =
          "$idManufacturs".replaceAll("[", "").replaceAll("]", "");
    }
    params["Take"] = take;
    params["Skip"] = skip;

    params.removeWhere((key, value) => isNullOrEmpty(value));
    return params;
  }
}

class CommoditySaveRequest {
  int id;
  List<ContentShoppingModel> list;
  List<ImageCommodity> imageList;

  Map<String, dynamic> getParams() {
    for (int i = 0; i < list.length; i++) {
      if (list[i].isRequire && isNullOrEmpty(list[i].value)) {
        ToastMessage.show("Trường ${list[i].title} cần bắt buộc", ToastStyle.error);
        return null;
      }
    }

    Map<String, dynamic> params = Map();
    list.forEach((element) {
      if (element.key != "HA") {
        params[element.key] = element.isDropDown ? element.idValue : element.value;
      }
    });

    if (isNotNullOrEmpty(imageList)) {
      String fileNames = imageList
          .map((e) => "'${e.fileName}'")
          .toList()
          .toString();
      String filePaths = imageList
          .map((e) => "'${e.filePath}'")
          .toList()
          .toString();
      params["FileNames"] = fileNames;
      params["FilePaths"] = filePaths;
    }

    if (id != null) {
      params["ID"] = id;
    }
    return params;
  }
}

class GetCodeByCategoryRequest {
  dynamic id, idCategory;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDCategory"] = idCategory;
    params["ID"] = id == null ? 0 : id;
    return params;
  }
}