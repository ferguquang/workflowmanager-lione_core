import 'package:workflow_manager/base/models/base_response.dart';

class CommodityIndexResponse extends BaseResponse {
  DataCommodityIndex data;

  CommodityIndexResponse.fromJson(Map<String, dynamic> json)  : super.fromJson(json) {
    data = json['Data'] != null ? new DataCommodityIndex.fromJson(json['Data']) : null;
  }
}

class DataCommodityIndex {
  List<Commodities> commodities;
  int totalRecord;
  bool isCreate;
  SearchParamCommodity searchParam;

  DataCommodityIndex({this.commodities, this.totalRecord, this.isCreate, this.searchParam});

  DataCommodityIndex.fromJson(Map<String, dynamic> json) {
    if (json['Commodities'] != null) {
      commodities = new List<Commodities>();
      json['Commodities'].forEach((v) {
        commodities.add(new Commodities.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    isCreate = json['IsCreate'];
    searchParam = json['SearchParam'] != null
        ? new SearchParamCommodity.fromJson(json['SearchParam'])
        : null;
  }
}

class Commodities {
  int iD;
  String code;
  String name;
  String category;
  String description;
  bool isView;
  bool isUpdate;
  bool isDelete;
  String manufactur;

  Commodities(
      {this.iD,
        this.code,
        this.name,
        this.category,
        this.description,
        this.isView,
        this.isUpdate,
        this.isDelete,
        this.manufactur});

  Commodities.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    category = json['Category'];
    description = json['Description'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
    manufactur = json['Manufactur'];
  }
}

class SearchParamCommodity {
  List<CategorySearchParams> categories;
  List<CategorySearchParams> manufacturs;

  SearchParamCommodity({this.categories, this.manufacturs});

  SearchParamCommodity.fromJson(Map<String, dynamic> json) {
    if (json['Categories'] != null) {
      categories = new List<CategorySearchParams>();
      json['Categories'].forEach((v) {
        categories.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Manufacturs'] != null) {
      manufacturs = new List<CategorySearchParams>();
      json['Manufacturs'].forEach((v) {
        manufacturs.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}

class CategorySearchParams {
  int iD;
  String name;
  String key;
  bool isEnable;

  CategorySearchParams({this.iD, this.name, this.key, this.isEnable});

  CategorySearchParams.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }
}

// render thêm mới:
class CommodityCreateUpdateResponse extends BaseResponse {
  DataCommodityCreateUpdate data;

  CommodityCreateUpdateResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataCommodityCreateUpdate.fromJson(json['Data']) : null;
  }
}

class DataCommodityCreateUpdate {
  CommodityCreateUpdate commodity;
  List<CategorySearchParams> categories;
  List<CategorySearchParams> types;
  List<CategorySearchParams> manufacturs;

  DataCommodityCreateUpdate({this.commodity, this.categories, this.types, this.manufacturs});

  DataCommodityCreateUpdate.fromJson(Map<String, dynamic> json) {
    commodity = json['Commodity'] != null ? new CommodityCreateUpdate.fromJson(json['Commodity']) : null;
    if (json['Categories'] != null) {
      categories = new List<CategorySearchParams>();
      json['Categories'].forEach((v) { categories.add(new CategorySearchParams.fromJson(v)); });
    }
    if (json['Types'] != null) {
      types = new List<CategorySearchParams>();
      json['Types'].forEach((v) { types.add(new CategorySearchParams.fromJson(v)); });
    }
    if (json['Manufacturs'] != null) {
      manufacturs = new List<CategorySearchParams>();
      json['Manufacturs'].forEach((v) { manufacturs.add(new CategorySearchParams.fromJson(v)); });
    }
  }
}

class CommodityCreateUpdate {
  int iD;
  String code;
  String name;
  String strType;
  int type;
  int iDCategory;
  String category;
  String manufactur;
  String unit;
  String unitTransfer;
  String description;
  String origin;
  String warranty;
  String receipt;
  String note;
  List<ImageCommodity> images;
  int iDManufactur;

  CommodityCreateUpdate(
      {this.iD,
        this.code,
        this.name,
        this.strType,
        this.type,
        this.iDCategory,
        this.category,
        this.manufactur,
        this.unit,
        this.unitTransfer,
        this.description,
        this.origin,
        this.warranty,
        this.receipt,
        this.note,
        this.images,
        this.iDManufactur});

  CommodityCreateUpdate.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    strType = json['StrType'];
    type = json['Type'];
    iDCategory = json['IDCategory'];
    category = json['Category'];
    manufactur = json['Manufactur'];
    unit = json['Unit'];
    unitTransfer = json['UnitTransfer'];
    description = json['Description'];
    origin = json['Origin'];
    warranty = json['Warranty'];
    receipt = json['Receipt'];
    note = json['Note'];
    if (json['Images'] != null) {
      images = new List<ImageCommodity>();
      json['Images'].forEach((v) { images.add(new ImageCommodity.fromJson(v)); });
    }
    iDManufactur = json['IDManufactur'];
  }
}

class ImageCommodity {
  int id;
  String fileName, filePath;
  bool isDelete;

  ImageCommodity({this.id = 0, this.fileName, this.filePath, this.isDelete = true});

  ImageCommodity.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    isDelete = json['IsDelete'];
  }
}

// lưu tạo mới
class CommoditySaveResponse extends BaseResponse {
  DataCommoditySave data;

  CommoditySaveResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataCommoditySave.fromJson(json['Data']) : null;
  }
}

class DataCommoditySave {
  Commodities commodity;

  DataCommoditySave({this.commodity});

  DataCommoditySave.fromJson(Map<String, dynamic> json) {
    commodity = json['Commodity'] != null
        ? new Commodities.fromJson(json['Commodity'])
        : null;
  }
}

