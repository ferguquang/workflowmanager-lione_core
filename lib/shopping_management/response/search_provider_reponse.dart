import 'package:workflow_manager/base/models/base_response.dart';

class SearchProviderResponse extends BaseResponse {
  int status;
  SearchProviderModel data;

  SearchProviderResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new SearchProviderModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class SearchProviderModel {
  List<Providers> providers;
  bool isCreate;
  int totalRecord;
  SearchParam searchParam;

  SearchProviderModel(
      {this.providers, this.isCreate, this.totalRecord, this.searchParam});

  SearchProviderModel.fromJson(Map<String, dynamic> json) {
    if (json['Providers'] != null) {
      providers = new List<Providers>();
      json['Providers'].forEach((v) {
        providers.add(new Providers.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.providers != null) {
      data['Providers'] = this.providers.map((v) => v.toJson()).toList();
    }
    data['IsCreate'] = this.isCreate;
    data['TotalRecord'] = this.totalRecord;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class Providers {
  int iD;
  String code;
  String name;
  String region;
  String commodityCategory;
  String personContact;
  String phoneContact;
  double totalAmount;
  double remainAmount;
  bool isView;
  bool isUpdate;
  bool isDelete;

  Providers(
      {this.iD,
      this.code,
      this.name,
      this.region,
      this.commodityCategory,
      this.personContact,
      this.phoneContact,
      this.totalAmount,
      this.remainAmount,
      this.isView,
      this.isUpdate,
      this.isDelete});

  Providers.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    region = json['Region'];
    commodityCategory = json['CommodityCategory'];
    personContact = json['PersonContact'];
    phoneContact = json['PhoneContact'];
    totalAmount = json['TotalAmount'];
    remainAmount = json['RemainAmount'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Region'] = this.region;
    data['CommodityCategory'] = this.commodityCategory;
    data['PersonContact'] = this.personContact;
    data['PhoneContact'] = this.phoneContact;
    data['TotalAmount'] = this.totalAmount;
    data['RemainAmount'] = this.remainAmount;
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    data['IsDelete'] = this.isDelete;
    return data;
  }
}

class SearchParam {
  List<Regions> regions;
  List<Categorys> categorys;
  List<Nations> nations;

  SearchParam({this.regions, this.categorys});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Regions'] != null) {
      regions = new List<Regions>();
      json['Regions'].forEach((v) {
        regions.add(new Regions.fromJson(v));
      });
    }
    if (json['Categorys'] != null) {
      categorys = new List<Categorys>();
      json['Categorys'].forEach((v) {
        categorys.add(new Categorys.fromJson(v));
      });
    }
    if (json['Nations'] != null) {
      nations = new List<Nations>();
      json['Nations'].forEach((v) {
        nations.add(new Nations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.regions != null) {
      data['Regions'] = this.regions.map((v) => v.toJson()).toList();
    }
    if (this.categorys != null) {
      data['Categorys'] = this.categorys.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nations {
  int iD;
  String name;
  String key;
  bool isEnable;

  Nations({this.iD, this.name, this.key, this.isEnable});

  Nations.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class Regions {
  int iD;
  String name;
  String key;
  bool isEnable;

  Regions({this.iD, this.name, this.key, this.isEnable});

  Regions.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class Categorys {
  int iD;
  String name;
  String key;
  bool isEnable;

  Categorys({this.iD, this.name, this.key, this.isEnable});

  Categorys.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
