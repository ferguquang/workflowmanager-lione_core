import 'package:workflow_manager/base/models/base_response.dart';

class ChooseProviderResponse extends BaseResponse {
  int status;
  ChooseProvider data;

  ChooseProviderResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data =
        json['Data'] != null ? new ChooseProvider.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class ChooseProvider {
  List<Requisitions> requisitions;
  int totalRecord;
  SearchParam searchParam;

  ChooseProvider({this.requisitions, this.totalRecord, this.searchParam});

  ChooseProvider.fromJson(Map<String, dynamic> json) {
    if (json['Requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    data['TotalRecord'] = this.totalRecord;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class Requisitions {
  int iD;
  String requisitionNumber;
  String project;
  String investor;
  String suggestionType;
  String shoppingType;
  String dept;
  String requestBy;
  double totalAmount;
  String currency;
  Status status;

  Requisitions(
      {this.iD,
      this.requisitionNumber,
      this.project,
      this.investor,
      this.suggestionType,
      this.shoppingType,
      this.dept,
      this.requestBy,
      this.totalAmount,
      this.currency,
      this.status});

  Requisitions.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    requisitionNumber = json['RequisitionNumber'];
    project = json['Project'];
    investor = json['Investor'];
    suggestionType = json['SuggestionType'];
    shoppingType = json['ShoppingType'];
    dept = json['Dept'];
    requestBy = json['RequestBy'];
    totalAmount = json['TotalAmount'];
    currency = json['Currency'];
    status = json['Status'] != null ? new Status.fromJson(json['Status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['Project'] = this.project;
    data['Investor'] = this.investor;
    data['SuggestionType'] = this.suggestionType;
    data['ShoppingType'] = this.shoppingType;
    data['Dept'] = this.dept;
    data['RequestBy'] = this.requestBy;
    data['TotalAmount'] = this.totalAmount;
    data['Currency'] = this.currency;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    return data;
  }
}

class Status {
  int iD;
  String name;
  String bgColor;

  Status({this.iD, this.name, this.bgColor});

  Status.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    bgColor = json['BgColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['BgColor'] = this.bgColor;
    return data;
  }
}

class SearchParam {
  List<SearchRequisitions> requisitions;
  List<Status> status;

  SearchParam({this.requisitions, this.status});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Requisitions'] != null) {
      requisitions = new List<SearchRequisitions>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new SearchRequisitions.fromJson(v));
      });
    }
    if (json['Status'] != null) {
      status = new List<Status>();
      json['Status'].forEach((v) {
        status.add(new Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['Status'] = this.status.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchRequisitions {
  int iD;
  String name;
  String key;
  bool isEnable;

  SearchRequisitions({this.iD, this.name, this.key, this.isEnable});

  SearchRequisitions.fromJson(Map<String, dynamic> json) {
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
