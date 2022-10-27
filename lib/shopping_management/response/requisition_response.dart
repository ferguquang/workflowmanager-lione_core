import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class RequisitionIndexResponse extends BaseResponse {
  DataRequisitionIndex data;

  RequisitionIndexResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataRequisitionIndex.fromJson(json['Data']) : null;
  }
}

class DataRequisitionIndex {
  List<Requisitions> requisitions;
  int totalRecord;
  SearchParam searchParam;

  DataRequisitionIndex({this.requisitions, this.totalRecord, this.searchParam});

  DataRequisitionIndex.fromJson(Map<String, dynamic> json) {
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
}

class Requisitions {
  int iD;
  String requisitionNumber;
  String shoppingType;
  String suggestionType;
  String dept;
  String requestBy;
  Status status;
  bool isView;

  Requisitions(
      {this.iD,
        this.requisitionNumber,
        this.shoppingType,
        this.suggestionType,
        this.dept,
        this.requestBy,
        this.status,
        this.isView});

  Requisitions.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    requisitionNumber = json['RequisitionNumber'];
    shoppingType = json['ShoppingType'];
    suggestionType = json['SuggestionType'];
    dept = json['Dept'];
    requestBy = json['RequestBy'];
    status =
    json['Status'] != null ? new Status.fromJson(json['Status']) : null;
    isView = json['IsView'];
  }
}

class Status {
  String name;
  String bgColor;

  Status({this.name, this.bgColor});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    bgColor = json['BgColor'];
  }

}

class SearchParam {
  List<CategorySearchParams> requisitionStatus;
  List<CategorySearchParams> depts;

  SearchParam({this.requisitionStatus, this.depts});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['RequisitionStatus'] != null) {
      requisitionStatus = new List<CategorySearchParams>();
      json['RequisitionStatus'].forEach((v) {
        requisitionStatus.add(new CategorySearchParams.fromJson(v));
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

// chi tiets:
class RequisitionDetailResponse extends BaseResponse {
  DataRequisitionDetail data;

  RequisitionDetailResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataRequisitionDetail.fromJson(json['Data']) : null;
  }
}

class DataRequisitionDetail {
  Requisition requisition;
  List<RequisitionDetails> requisitionDetails;

  DataRequisitionDetail({this.requisition, this.requisitionDetails});

  DataRequisitionDetail.fromJson(Map<String, dynamic> json) {
    requisition = json['Requisition'] != null
        ? new Requisition.fromJson(json['Requisition'])
        : null;
    if (json['RequisitionDetails'] != null) {
      requisitionDetails = new List<RequisitionDetails>();
      json['RequisitionDetails'].forEach((v) {
        requisitionDetails.add(new RequisitionDetails.fromJson(v));
      });
    }
  }
}

class Requisition {
  int iD;
  String requisitionNumber;
  String suggestionType;
  int iDSuggestionType;
  String shoppingType;
  int iDShoppingType;
  String purpose;
  String requestBy;
  Dept dept;
  int requestDate;
  String project;
  String investor;
  String status;
  String reason;
  int iDServiceRecord;
  String totalAmount;
  bool isReject;
  bool isApprove;
  bool isRent;
  bool isNote;

  Requisition(
      {this.iD,
        this.requisitionNumber,
        this.suggestionType,
        this.iDSuggestionType,
        this.shoppingType,
        this.iDShoppingType,
        this.purpose,
        this.requestBy,
        this.dept,
        this.requestDate,
        this.project,
        this.investor,
        this.status,
        this.reason,
        this.iDServiceRecord,
        this.totalAmount,
        this.isReject,
        this.isApprove,
        this.isRent,
        this.isNote});

  Requisition.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    requisitionNumber = json['RequisitionNumber'];
    suggestionType = json['SuggestionType'];
    iDSuggestionType = json['IDSuggestionType'];
    shoppingType = json['ShoppingType'];
    iDShoppingType = json['IDShoppingType'];
    purpose = json['Purpose'];
    requestBy = json['RequestBy'];
    dept = json['Dept'] != null ? new Dept.fromJson(json['Dept']) : null;
    requestDate = json['RequestDate'];
    project = json['Project'];
    investor = json['Investor'];
    status = json['Status'];
    reason = json['Reason'];
    iDServiceRecord = json['IDServiceRecord'];
    totalAmount = json['TotalAmount'];
    isReject = json['IsReject'];
    isApprove = json['IsApprove'];
    isRent = json['IsRent'];
    isNote = json['IsNote'];
  }
}

class Dept {
  int iD;
  String name;

  Dept(
      {this.iD,
        this.name,});

  Dept.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }
}

class RequisitionDetails {
  int iD;
  String commodity;
  String commodityCategory;
  String manufactur;
  String description;
  double qTY;
  double inventoryQTY;
  double approvedQTY;
  String unit;
  String origin;
  String warranty;
  String price;
  String totalAmount;
  bool cO;
  bool cQ;
  bool otherDoc;
  int deliveryDate;
  String deliveryDestination;
  double nbRent;
  String rentType;
  String note;

  RequisitionDetails(
      {this.iD,
        this.commodity,
        this.commodityCategory,
        this.manufactur,
        this.description,
        this.qTY,
        this.inventoryQTY,
        this.approvedQTY,
        this.unit,
        this.origin,
        this.warranty,
        this.price,
        this.totalAmount,
        this.cO,
        this.cQ,
        this.otherDoc,
        this.deliveryDate,
        this.deliveryDestination,
        this.nbRent,
        this.rentType,
        this.note});

  RequisitionDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    commodity = json['Commodity'];
    commodityCategory = json['CommodityCategory'];
    manufactur = json['Manufactur'];
    description = json['Description'];
    qTY = json['QTY'];
    inventoryQTY = json['InventoryQTY'];
    approvedQTY = json['ApprovedQTY'];
    unit = json['Unit'];
    origin = json['Origin'];
    warranty = json['Warranty'];
    price = json['Price'];
    totalAmount = json['TotalAmount'];
    cO = json['CO'];
    cQ = json['CQ'];
    otherDoc = json['OtherDoc'];
    deliveryDate = json['DeliveryDate'];
    deliveryDestination = json['DeliveryDestination'];
    nbRent = json['NbRent'];
    rentType = json['RentType'];
    note = json['Note'];
  }
}

