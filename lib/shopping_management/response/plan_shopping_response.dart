import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class PlanIndexResponse extends BaseResponse {
  DataPlanIndex data;

  PlanIndexResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataPlanIndex.fromJson(json['Data']) : null;
  }
}

class DataPlanIndex {
  List<Plannings> plannings;
  int totalRecord;
  SearchParam searchParam;

  DataPlanIndex({this.plannings, this.totalRecord, this.searchParam});

  DataPlanIndex.fromJson(Map<String, dynamic> json) {
    if (json['Plannings'] != null) {
      plannings = new List<Plannings>();
      json['Plannings'].forEach((v) {
        plannings.add(new Plannings.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }
}

class Plannings {
  int iD;
  String shoppingType;
  String suggestionType;
  String report;
  String dept;
  String totalAmount;
  String creator;
  bool isView;

  Plannings(
      {this.iD,
        this.shoppingType,
        this.suggestionType,
        this.report,
        this.dept,
        this.totalAmount,
        this.creator,
        this.isView});

  Plannings.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    shoppingType = json['ShoppingType'];
    suggestionType = json['SuggestionType'];
    report = json['Report'];
    dept = json['Dept'];
    totalAmount = json['TotalAmount'];
    creator = json['Creator'];
    isView = json['IsView'];
  }
}

class SearchParam {
  List<CategorySearchParams> years;
  List<CategorySearchParams> quarters;
  List<CategorySearchParams> suggestionTypes;
  List<CategorySearchParams> shoppingTypes;
  List<CategorySearchParams> depts;

  SearchParam(
      {this.years,
        this.quarters,
        this.suggestionTypes,
        this.shoppingTypes,
        this.depts});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Years'] != null) {
      years = new List<CategorySearchParams>();
      json['Years'].forEach((v) {
        years.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Quarters'] != null) {
      quarters = new List<CategorySearchParams>();
      json['Quarters'].forEach((v) {
        quarters.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['SuggestionTypes'] != null) {
      suggestionTypes = new List<CategorySearchParams>();
      json['SuggestionTypes'].forEach((v) {
        suggestionTypes.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['ShoppingTypes'] != null) {
      shoppingTypes = new List<CategorySearchParams>();
      json['ShoppingTypes'].forEach((v) {
        shoppingTypes.add(new CategorySearchParams.fromJson(v));
      });
    }
    if (json['Depts'] != null) {
      depts = new List<CategorySearchParams>();
      json['Depts'].forEach((v) {
        depts.add(new CategorySearchParams.fromJson(v));
      });
    }
  }
}

// detail:
class PlanningDetailResponse extends BaseResponse {
  DataPlanningDetail data;

  PlanningDetailResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataPlanningDetail.fromJson(json['Data']) : null;
  }
}

class DataPlanningDetail {
  Planning planning;
  PlanningDetailHeader planningDetailHeader;
  List<PlanningDetails> planningDetails;

  DataPlanningDetail({this.planning, this.planningDetailHeader, this.planningDetails});

  DataPlanningDetail.fromJson(Map<String, dynamic> json) {
    planning = json['Planning'] != null
        ? new Planning.fromJson(json['Planning'])
        : null;
    planningDetailHeader = json['PlanningDetailHeader'] != null
        ? new PlanningDetailHeader.fromJson(json['PlanningDetailHeader'])
        : null;
    if (json['PlanningDetails'] != null) {
      planningDetails = new List<PlanningDetails>();
      json['PlanningDetails'].forEach((v) {
        planningDetails.add(new PlanningDetails.fromJson(v));
      });
    }
  }
}

class Planning {
  int iD;
  String year;
  String quarter;
  String shoppingType;
  int iDShoppingType;
  String suggestionType;
  int iDSuggestionType;
  String dept;
  String totalAmount;
  String creator;

  Planning(
      {this.iD,
        this.year,
        this.quarter,
        this.shoppingType,
        this.iDShoppingType,
        this.suggestionType,
        this.iDSuggestionType,
        this.dept,
        this.totalAmount,
        this.creator});

  Planning.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    year = json['Year'];
    quarter = json['Quarter'];
    shoppingType = json['ShoppingType'];
    iDShoppingType = json['IDShoppingType'];
    suggestionType = json['SuggestionType'];
    iDSuggestionType = json['IDSuggestionType'];
    dept = json['Dept'];
    totalAmount = json['TotalAmount'];
    creator = json['Creator'];
  }
}

class PlanningDetailHeader {
  List<String> titles;
  List<String> codes;

  PlanningDetailHeader({this.titles, this.codes});

  PlanningDetailHeader.fromJson(Map<String, dynamic> json) {
    titles = json['Titles'].cast<String>();
    codes = json['Codes'].cast<String>();
  }
}

class PlanningDetails {
  int iD;
  String deliveryCategory;
  String amount;
  double nbRent;
  String shoppingType;
  String rentType;
  String projectCode;
  String projectName;
  int contractExpectDate;
  int deployExpectDate;
  String deployDate;
  int qTY;
  String deployAddress;
  String description;
  String unit;
  int requestDate;

  PlanningDetails(
      {this.iD,
        this.deliveryCategory,
        this.amount,
        this.nbRent,
        this.shoppingType,
        this.rentType,
        this.projectCode,
        this.projectName,
        this.contractExpectDate,
        this.deployExpectDate,
        this.deployDate,
        this.qTY,
        this.deployAddress,
        this.description,
        this.unit,
        this.requestDate});

  PlanningDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    deliveryCategory = json['DeliveryCategory'];
    amount = json['Amount'];
    nbRent = json['NbRent'];
    shoppingType = json['ShoppingType'];
    rentType = json['RentType'];
    projectCode = json['ProjectCode'];
    projectName = json['ProjectName'];
    contractExpectDate = json['ContractExpectDate'];
    deployExpectDate = json['DeployExpectDate'];
    deployDate = json['DeployDate'];
    qTY = json['QTY'];
    deployAddress = json['DeployAddress'];
    description = json['Description'];
    unit = json['Unit'];
    requestDate = json['RequestDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['DeliveryCategory'] = this.deliveryCategory;
    data['Amount'] = this.amount;
    data['NbRent'] = this.nbRent;
    data['ShoppingType'] = this.shoppingType;
    data['RentType'] = this.rentType;
    data['ProjectCode'] = this.projectCode;
    data['ProjectName'] = this.projectName;
    data['ContractExpectDate'] = this.contractExpectDate;
    data['DeployExpectDate'] = this.deployExpectDate;
    data['DeployDate'] = this.deployDate;
    data['QTY'] = this.qTY;
    data['DeployAddress'] = this.deployAddress;
    data['Description'] = this.description;
    data['Unit'] = this.unit;
    data['RequestDate'] = this.requestDate;
    return data;
  }
}

