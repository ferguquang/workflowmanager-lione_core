import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class ProviderIndexResponse extends BaseResponse {
  DataProviderIndex data;

  ProviderIndexResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataProviderIndex.fromJson(json['Data']) : null;
  }
}

class DataProviderIndex {
  List<ProvidersIndex> providers;
  bool isCreate;
  int totalRecord;
  SearchParamProvider searchParam;

  DataProviderIndex({this.providers, this.isCreate, this.totalRecord, this.searchParam});

  DataProviderIndex.fromJson(Map<String, dynamic> json) {
    if (json['Providers'] != null) {
      providers = new List<ProvidersIndex>();
      json['Providers'].forEach((v) {
        providers.add(new ProvidersIndex.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParamProvider.fromJson(json['SearchParam'])
        : null;
  }
}

class ProvidersIndex {
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

  ProvidersIndex.fromJson(Map<String, dynamic> json) {
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
}

class SearchParamProvider {
  List<CategorySearchParams> regions;
  List<CategorySearchParams> categorys;
  List<CategorySearchParams> nations;

  SearchParamProvider.fromJson(Map<String, dynamic> json) {
    if (json['Regions'] != null) {
      regions = new List<CategorySearchParams>();
      json['Regions'].forEach((v) {
        regions.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Categorys'] != null) {
      categorys = new List<CategorySearchParams>();
      json['Categorys'].forEach((v) {
        categorys.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Nations'] != null) {
      nations = new List<CategorySearchParams>();
      json['Nations'].forEach((v) {
        nations.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}

class ProviderDetailResponse extends BaseResponse {
  DataProviderDetail data;

  ProviderDetailResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json)  {
    data = json['Data'] != null ? new DataProviderDetail.fromJson(json['Data']) : null;
  }
}

class DataProviderDetail {
  ProviderDetail provider;

  DataProviderDetail({this.provider});

  DataProviderDetail.fromJson(Map<String, dynamic> json) {
    provider = json['Provider'] != null
        ? new ProviderDetail.fromJson(json['Provider'])
        : null;
  }
}

class ProviderDetail {
  int iD;
  String code;
  String name;
  List<CategoryItem> region;
  CategoryItem nation;
  String address;
  String personContact;
  String phoneContact;
  String taxCode;
  String abbreviation;
  String email;
  String commodityCategorys;

  ProviderDetail(
      {this.iD,
        this.code,
        this.name,
        this.region,
        this.address,
        this.personContact,
        this.phoneContact,
        this.taxCode,
        this.abbreviation,
        this.email,
        this.nation,
        this.commodityCategorys});

  ProviderDetail.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    if (json['Region'] != null) {
      region = new List<CategoryItem>();
      json['Region'].forEach((v) {
        region.add(new CategoryItem.fromJson(v));
      });
    }
    nation = json['Nation'] != null
        ? new CategoryItem.fromJson(json['Nation'])
        : null;
    address = json['Address'];
    personContact = json['PersonContact'];
    phoneContact = json['PhoneContact'];
    taxCode = json['TaxCode'];
    abbreviation = json['Abbreviation'];
    email = json['Email'];
    commodityCategorys = json['CommodityCategorys'];
  }
}

class CategoryItem {
  int iD;
  String name;

  CategoryItem({this.iD, this.name});

  CategoryItem.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }
}

class ProviderDetailDebtLogResponse extends BaseResponse {
  DataProviderDetailDebtLog data;

  ProviderDetailDebtLogResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataProviderDetailDebtLog.fromJson(json['Data']) : null;
  }
}

class DataProviderDetailDebtLog {
  List<ProviderImportLogs> providerImportLogs;
  int totalRecord;

  DataProviderDetailDebtLog({this.providerImportLogs, this.totalRecord});

  DataProviderDetailDebtLog.fromJson(Map<String, dynamic> json) {
    if (json['ProviderImportLogs'] != null) {
      providerImportLogs = new List<ProviderImportLogs>();
      json['ProviderImportLogs'].forEach((v) {
        providerImportLogs.add(new ProviderImportLogs.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
  }
}

class ProviderImportLogs {
  int iD;
  String code;
  String name;
  String pONumber;
  String updated;
  String totalAmount;
  String paidAmount;
  String status;

  ProviderImportLogs(
      {this.iD,
        this.code,
        this.name,
        this.pONumber,
        this.updated,
        this.totalAmount,
        this.paidAmount,
        this.status});

  ProviderImportLogs.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    pONumber = json['PONumber'];
    updated = json['Updated'];
    totalAmount = json['TotalAmount'];
    paidAmount = json['PaidAmount'];
    status = json['Status'];
  }
}

// lịch sử điều chỉnh nợ
class ProviderViewDebtLogResponse extends BaseResponse {
  DataProviderViewDebtLog data;

  ProviderViewDebtLogResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json)  {
    status = json['Status'];
    data = json['Data'] != null ? new DataProviderViewDebtLog.fromJson(json['Data']) : null;
  }
}

class DataProviderViewDebtLog {
  List<ProviderDebtLogs> providerDebtLogs;
  int totalRecord;

  DataProviderViewDebtLog({this.providerDebtLogs, this.totalRecord});

  DataProviderViewDebtLog.fromJson(Map<String, dynamic> json) {
    if (json['ProviderDebtLogs'] != null) {
      providerDebtLogs = new List<ProviderDebtLogs>();
      json['ProviderDebtLogs'].forEach((v) {
        providerDebtLogs.add(new ProviderDebtLogs.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
  }
}

class ProviderDebtLogs {
  int iD;
  String debtAmount;
  String paidAmount;
  String remainAmount;
  String created;

  ProviderDebtLogs(
      {this.iD,
        this.debtAmount,
        this.paidAmount,
        this.remainAmount,
        this.created});

  ProviderDebtLogs.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    debtAmount = json['DebtAmount'];
    paidAmount = json['PaidAmount'];
    remainAmount = json['RemainAmount'];
    created = json['Created'];
  }
}

// nợ cần trả nhà cung cấp:
class ProviderDetailDebtResponse extends BaseResponse {
  DataProviderDetailDebt data;

  ProviderDetailDebtResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataProviderDetailDebt.fromJson(json['Data']) : null;
  }
}

class DataProviderDetailDebt {
  List<ProviderDebts> providerDebts;
  int totalRecord;

  DataProviderDetailDebt({this.providerDebts, this.totalRecord});

  DataProviderDetailDebt.fromJson(Map<String, dynamic> json) {
    if (json['ProviderDebts'] != null) {
      providerDebts = new List<ProviderDebts>();
      json['ProviderDebts'].forEach((v) {
        providerDebts.add(new ProviderDebts.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
  }
}

class ProviderDebts {
  int iD;
  String code;
  String name;
  String pONumber;
  String updated;
  String totalAmount;
  String debtAmount;
  String remainAmount;

  ProviderDebts(
      {this.iD,
        this.code,
        this.name,
        this.pONumber,
        this.updated,
        this.totalAmount,
        this.debtAmount,
        this.remainAmount});

  ProviderDebts.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    pONumber = json['PONumber'];
    updated = json['Updated'];
    totalAmount = json['TotalAmount'];
    debtAmount = json['DebtAmount'];
    remainAmount = json['RemainAmount'];
  }
}

// điều chỉnh:
class ProviderUpdateDebtLogResponse extends BaseResponse {
  DataProviderUpdateDebtLog data;

  ProviderUpdateDebtLogResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataProviderUpdateDebtLog.fromJson(json['Data']) : null;
  }
}

class DataProviderUpdateDebtLog {
  int iDProvider;
  double debtAmount;

  DataProviderUpdateDebtLog({this.iDProvider, this.debtAmount});

  DataProviderUpdateDebtLog.fromJson(Map<String, dynamic> json) {
    iDProvider = json['IDProvider'];
    debtAmount = json['DebtAmount'];
  }
}

class ProviderChangeDebtLogResponse extends BaseResponse {
  DataProviderChangeDebtLog data;

  ProviderChangeDebtLogResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataProviderChangeDebtLog.fromJson(json['Data']) : null;
  }
}

class DataProviderChangeDebtLog {
  List<ProviderDebts> providerDebts;
  int totalRecord;

  DataProviderChangeDebtLog({this.providerDebts, this.totalRecord});

  DataProviderChangeDebtLog.fromJson(Map<String, dynamic> json) {
    if (json['ProviderDebts'] != null) {
      providerDebts = new List<ProviderDebts>();
      json['ProviderDebts'].forEach((v) {
        providerDebts.add(new ProviderDebts.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
  }
}

// render create provider:
class CommodityCreateResponse extends BaseResponse {
  DataCommodityCreate data;

  CommodityCreateResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataCommodityCreate.fromJson(json['Data'])
        : null;
  }
}

class DataCommodityCreate {
  String code;
  int iDNation;
  List<CategorySearchParams> categorys;
  List<CategorySearchParams> regions;
  List<CategorySearchParams> nations;

  DataCommodityCreate(
      {this.code, this.iDNation, this.categorys, this.regions, this.nations});

  DataCommodityCreate.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    iDNation = json['IDNation'];
    if (json['Categorys'] != null) {
      categorys = new List<CategorySearchParams>();
      json['Categorys'].forEach((v) {
        categorys.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Regions'] != null) {
      regions = new List<CategorySearchParams>();
      json['Regions'].forEach((v) {
        regions.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Nations'] != null) {
      nations = new List<CategorySearchParams>();
      json['Nations'].forEach((v) {
        nations.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}
