import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class ProviderVoteIndexResponse extends BaseResponse {
  DataProviderVotes data;

  ProviderVoteIndexResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataProviderVotes.fromJson(json['Data'])
        : null;
  }
}

class DataProviderVotes {
  List<ProviderVotes> providerVotes;
  bool isCreate;
  int totalRecord;
  SearchParamProviderVote searchParam;

  DataProviderVotes(
      {this.providerVotes, this.isCreate, this.totalRecord, this.searchParam});

  DataProviderVotes.fromJson(Map<String, dynamic> json) {
    if (json['ProviderVotes'] != null) {
      providerVotes = new List<ProviderVotes>();
      json['ProviderVotes'].forEach((v) {
        providerVotes.add(new ProviderVotes.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParamProviderVote.fromJson(json['SearchParam'])
        : null;
  }
}

class ProviderVotes {
  int iD;
  String code;
  String name;
  String project;
  String created;
  int totalPoint;
  bool isView;
  bool isUpdate;
  bool isDelete;

  ProviderVotes(
      {this.iD,
      this.code,
      this.name,
      this.project,
      this.created,
      this.totalPoint,
      this.isView,
      this.isUpdate,
      this.isDelete});

  ProviderVotes.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    project = json['Project'];
    created = json['Created'];
    totalPoint = json['TotalPoint'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
  }
}

class SearchParamProviderVote {
  List<CategorySearchParams> categorys;

  SearchParamProviderVote({this.categorys});

  SearchParamProviderVote.fromJson(Map<String, dynamic> json) {
    if (json['Categorys'] != null) {
      categorys = new List<CategorySearchParams>();
      json['Categorys'].forEach((v) {
        categorys.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}

// render provider vote:
class RenderCreateUpdateProviderVoteResponse extends BaseResponse {
  DataRenderCreateUpdateProviderVote data;

  RenderCreateUpdateProviderVoteResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataRenderCreateUpdateProviderVote.fromJson(json['Data']) : null;
  }
}

class DataRenderCreateUpdateProviderVote {
  RenderProviderVote providerVote;
  List<CategorySearchParams> projects;
  List<CategorySearchParams> providers;

  DataRenderCreateUpdateProviderVote({this.providerVote, this.projects, this.providers});

  DataRenderCreateUpdateProviderVote.fromJson(Map<String, dynamic> json) {
    providerVote = json['ProviderVote'] != null
        ? new RenderProviderVote.fromJson(json['ProviderVote'])
        : null;
    if (json['Projects'] != null) {
      projects = new List<CategorySearchParams>();
      json['Projects'].forEach((v) {
        projects.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Providers'] != null) {
      providers = new List<CategorySearchParams>();
      json['Providers'].forEach((v) {
        providers.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}

class RenderProviderVote {
  int iD;
  List<Project> project;
  Code code;
  String name;
  int pricePoint;
  int paymentPoint;
  int deliveryPoint;
  int qualityPoint;
  int coordinatePoint;
  int totalPoint;
  String buyer;
  String created;
  String note;

  RenderProviderVote(
      {this.iD,
        this.project,
        this.code,
        this.name,
        this.pricePoint,
        this.paymentPoint,
        this.deliveryPoint,
        this.qualityPoint,
        this.coordinatePoint,
        this.totalPoint,
        this.buyer,
        this.created,
        this.note});

  RenderProviderVote.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    if (json['Project'] != null) {
      project = new List<Project>();
      json['Project'].forEach((v) {
        project.add(new Project.fromJson(v));
      });
    }
    code = json['Code'] != null ? new Code.fromJson(json['Code']) : null;
    name = json['Name'];
    pricePoint = json['PricePoint'];
    paymentPoint = json['PaymentPoint'];
    deliveryPoint = json['DeliveryPoint'];
    qualityPoint = json['QualityPoint'];
    coordinatePoint = json['CoordinatePoint'];
    totalPoint = json['TotalPoint'];
    buyer = json['Buyer'];
    created = json['Created'];
    note = json['Note'];
  }
}

class Project {
  int iD;
  String name;

  Project({this.iD, this.name});

  Project.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }
}

class Code {
  int iDProvider;
  String code;

  Code({this.iDProvider, this.code});

  Code.fromJson(Map<String, dynamic> json) {
    iDProvider = json['IDProvider'];
    code = json['Code'];
  }
}

class GetNameByProviderResponse extends BaseResponse {
  DataGetNameByProvider data;

  GetNameByProviderResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataGetNameByProvider.fromJson(json['Data']) : null;
  }
}

class DataGetNameByProvider {
  String name;

  DataGetNameByProvider({this.name});

  DataGetNameByProvider.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
  }
}

