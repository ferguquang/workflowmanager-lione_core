import 'package:workflow_manager/base/models/base_response.dart';

class CommodityCategoryIndexResponse extends BaseResponse {
  DataCommodityCategory data;

  CommodityCategoryIndexResponse.fromJson(Map<String, dynamic> json)  : super.fromJson(json) {
    data = json['Data'] != null ? new DataCommodityCategory.fromJson(json['Data']) : null;
  }
}

class DataCommodityCategory {
  List<Categories> categories;
  int totalRecord;
  bool isCreate;

  DataCommodityCategory({this.categories, this.totalRecord, this.isCreate});

  DataCommodityCategory.fromJson(Map<String, dynamic> json) {
    if (json['Categories'] != null) {
      categories = new List<Categories>();
      json['Categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    isCreate = json['IsCreate'];
  }
}

class Categories {
  int iD;
  String code;
  String name;
  bool isUpdate;
  bool isDelete;

  Categories({this.iD, this.code, this.name, this.isUpdate = true, this.isDelete = true});

  Categories.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
  }
}

class CommodityCategorySaveResponse extends BaseResponse {
  DataCommodityCategorySave data;

  CommodityCategorySaveResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json)  {
    data = json['Data'] != null ? new DataCommodityCategorySave.fromJson(json['Data']) : null;
  }
}

class DataCommodityCategorySave {
  Categories category;

  DataCommodityCategorySave({this.category});

  DataCommodityCategorySave.fromJson(Map<String, dynamic> json) {
    category = json['Category'] != null
        ? new Categories.fromJson(json['Category'])
        : null;
  }
}
