import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class ManufacturIndexResponse extends BaseResponse {
  DataManufacturIndex data;

  ManufacturIndexResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataManufacturIndex.fromJson(json['Data']) : null;
  }
}

class DataManufacturIndex {
  List<Manufacturs> manufacturs;
  bool isCreate;
  int totalRecord;

  DataManufacturIndex({this.manufacturs, this.isCreate, this.totalRecord});

  DataManufacturIndex.fromJson(Map<String, dynamic> json) {
    if (json['Manufacturs'] != null) {
      manufacturs = new List<Manufacturs>();
      json['Manufacturs'].forEach((v) {
        manufacturs.add(new Manufacturs.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
    totalRecord = json['TotalRecord'];
  }
}

class Manufacturs {
  int iD;
  String code;
  String name;
  String categorys;
  String place;
  String contact;
  String phone;
  String email;
  bool isView;
  bool isUpdate;
  bool isDelete;

  Manufacturs(
      {this.iD,
        this.code,
        this.name,
        this.categorys,
        this.place,
        this.contact,
        this.phone,
        this.email,
        this.isView,
        this.isUpdate,
        this.isDelete});

  Manufacturs.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    categorys = json['Categorys'];
    place = json['Place'];
    contact = json['Contact'];
    phone = json['Phone'];
    email = json['Email'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
  }
}

// render:
class ManufacturRenderResponse extends BaseResponse {
  DataManufactureRender data;

  ManufacturRenderResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataManufactureRender.fromJson(json['Data']) : null;
  }
}

class DataManufactureRender {
  ManufacturRender manufactur;
  List<CategorySearchParams> categories;

  DataManufactureRender({this.manufactur, this.categories});

  DataManufactureRender.fromJson(Map<String, dynamic> json) {
    manufactur = json['Manufactur'] != null
        ? new ManufacturRender.fromJson(json['Manufactur'])
        : null;
    if (json['Categories'] != null) {
      categories = new List<CategorySearchParams>();
      json['Categories'].forEach((v) {
        categories.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}

class ManufacturRender {
  int iD;
  List<Categories> categories;
  String code;
  String name;
  String place;
  String contact;
  String phone;
  String email;

  ManufacturRender(
      {this.iD,
        this.categories,
        this.code,
        this.name,
        this.place,
        this.contact,
        this.phone,
        this.email});

  ManufacturRender.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    if (json['Categories'] != null) {
      categories = new List<Categories>();
      json['Categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    code = json['Code'];
    name = json['Name'];
    place = json['Place'];
    contact = json['Contact'];
    phone = json['Phone'];
    email = json['Email'];
  }
}

class Categories {
  int iD;
  String name;

  Categories({this.iD, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}
