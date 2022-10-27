import 'package:workflow_manager/base/models/base_response.dart';

class DeliveryDetailResponse extends BaseResponse {
  int status;
  DeliveryDetailModel data;

  DeliveryDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DeliveryDetailModel.fromJson(json['Data'])
        : null;
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

class DeliveryDetailModel {
  Contract contract;
  List<Lines> lines;

  DeliveryDetailModel({this.contract, this.lines});

  DeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    contract = json['Contract'] != null
        ? new Contract.fromJson(json['Contract'])
        : null;
    if (json['Lines'] != null) {
      lines = new List<Lines>();
      json['Lines'].forEach((v) {
        lines.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contract != null) {
      data['Contract'] = this.contract.toJson();
    }
    if (this.lines != null) {
      data['Lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contract {
  int iD;
  String requisitionNumber;
  String suggestionType;
  String shoppingType;
  int iDShoppingType;
  String project;
  String pONumber;
  String currencyCode;
  double currencyRate;
  String provider;
  String signDate;
  String signBy;
  String jobPosition;
  String totalAmount;
  bool isSave;
  bool isComplete;
  bool isUpdate;

  Contract(
      {this.iD,
      this.requisitionNumber,
      this.suggestionType,
      this.shoppingType,
      this.iDShoppingType,
      this.project,
      this.pONumber,
      this.currencyCode,
      this.currencyRate,
      this.provider,
      this.signDate,
      this.signBy,
      this.jobPosition,
      this.totalAmount,
      this.isSave,
      this.isComplete,
      this.isUpdate});

  Contract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    requisitionNumber = json['RequisitionNumber'];
    suggestionType = json['SuggestionType'];
    shoppingType = json['ShoppingType'];
    iDShoppingType = json['IDShoppingType'];
    project = json['Project'];
    pONumber = json['PONumber'];
    currencyCode = json['CurrencyCode'];
    currencyRate = json['CurrencyRate'];
    provider = json['Provider'];
    signDate = json['SignDate'];
    signBy = json['SignBy'];
    jobPosition = json['JobPosition'];
    totalAmount = json['TotalAmount'];
    isSave = json['IsSave'];
    isComplete = json['IsComplete'];
    isUpdate = json['IsUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['SuggestionType'] = this.suggestionType;
    data['ShoppingType'] = this.shoppingType;
    data['IDShoppingType'] = this.iDShoppingType;
    data['Project'] = this.project;
    data['PONumber'] = this.pONumber;
    data['CurrencyCode'] = this.currencyCode;
    data['CurrencyRate'] = this.currencyRate;
    data['Provider'] = this.provider;
    data['SignDate'] = this.signDate;
    data['SignBy'] = this.signBy;
    data['JobPosition'] = this.jobPosition;
    data['TotalAmount'] = this.totalAmount;
    data['IsSave'] = this.isSave;
    data['IsComplete'] = this.isComplete;
    data['IsUpdate'] = this.isUpdate;
    return data;
  }
}

class Lines {
  int iD;
  String commodityName;
  String manufactur;
  String description;
  String qTY;
  String commodityUnit;
  String totalQTY;
  String remainQTY;
  ImportDate importDate;
  ImportDate actImportDate;
  ImportDate deliver;
  ImportDate address;
  ImportDate actAddress;
  String checker;
  String checkDate;
  String checkResult;
  CO cO;
  CO actCO;
  CO cQ;
  CO actCQ;
  ImportDate otherNote;
  CO other;
  CO actOther;
  ImportDate docHandover;
  ImportDate actDocHandover;
  ImportDate receiver;
  ImportDate note;

  ImportDate deliveryDate;
  ImportDate actDeliveryDate;
  ImportDate portDate;
  ImportDate actPortDate;

  Lines(
      {this.iD,
      this.commodityName,
      this.manufactur,
      this.description,
      this.qTY,
      this.commodityUnit,
      this.totalQTY,
      this.remainQTY,
      this.importDate,
      this.actImportDate,
      this.deliver,
      this.address,
      this.actAddress,
      this.checker,
      this.checkDate,
      this.checkResult,
      this.cO,
      this.actCO,
      this.cQ,
      this.actCQ,
      this.otherNote,
      this.other,
      this.actOther,
      this.docHandover,
      this.actDocHandover,
      this.receiver,
      this.note,
      this.deliveryDate,
      this.actDeliveryDate,
      this.portDate,
      this.actPortDate});

  Lines.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    commodityName = json['CommodityName'];
    manufactur = json['Manufactur'];
    description = json['Description'];
    qTY = json['QTY'];
    commodityUnit = json['CommodityUnit'];
    totalQTY = json['TotalQTY'];
    remainQTY = json['RemainQTY'];
    importDate = json['ImportDate'] != null
        ? new ImportDate.fromJson(json['ImportDate'])
        : null;
    actImportDate = json['ActImportDate'] != null
        ? new ImportDate.fromJson(json['ActImportDate'])
        : null;
    deliver = json['Deliver'] != null
        ? new ImportDate.fromJson(json['Deliver'])
        : null;
    address = json['Address'] != null
        ? new ImportDate.fromJson(json['Address'])
        : null;
    actAddress = json['ActAddress'] != null
        ? new ImportDate.fromJson(json['ActAddress'])
        : null;
    deliveryDate = json['DeliveryDate'] != null
        ? new ImportDate.fromJson(json['DeliveryDate'])
        : null;
    actDeliveryDate = json['ActDeliveryDate'] != null
        ? new ImportDate.fromJson(json['ActDeliveryDate'])
        : null;
    portDate = json['PortDate'] != null
        ? new ImportDate.fromJson(json['PortDate'])
        : null;
    actPortDate = json['ActPortDate'] != null
        ? new ImportDate.fromJson(json['ActPortDate'])
        : null;
    checker = json['Checker'];
    checkDate = json['CheckDate'];
    checkResult = json['CheckResult'];
    cO = json['CO'] != null ? new CO.fromJson(json['CO']) : null;
    actCO = json['ActCO'] != null ? new CO.fromJson(json['ActCO']) : null;
    cQ = json['CQ'] != null ? new CO.fromJson(json['CQ']) : null;
    actCQ = json['ActCQ'] != null ? new CO.fromJson(json['ActCQ']) : null;
    otherNote = json['OtherNote'] != null
        ? new ImportDate.fromJson(json['OtherNote'])
        : null;
    other = json['Other'] != null ? new CO.fromJson(json['Other']) : null;
    actOther =
        json['ActOther'] != null ? new CO.fromJson(json['ActOther']) : null;
    docHandover = json['DocHandover'] != null
        ? new ImportDate.fromJson(json['DocHandover'])
        : null;
    actDocHandover = json['ActDocHandover'] != null
        ? new ImportDate.fromJson(json['ActDocHandover'])
        : null;
    receiver = json['Receiver'] != null
        ? new ImportDate.fromJson(json['Receiver'])
        : null;
    note = json['Note'] != null ? new ImportDate.fromJson(json['Note']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CommodityName'] = this.commodityName;
    data['Manufactur'] = this.manufactur;
    data['Description'] = this.description;
    data['QTY'] = this.qTY;
    data['CommodityUnit'] = this.commodityUnit;
    data['TotalQTY'] = this.totalQTY;
    data['RemainQTY'] = this.remainQTY;
    if (this.importDate != null) {
      data['ImportDate'] = this.importDate.toJson();
    }
    if (this.actImportDate != null) {
      data['ActImportDate'] = this.actImportDate.toJson();
    }
    if (this.deliver != null) {
      data['Deliver'] = this.deliver.toJson();
    }
    if (this.address != null) {
      data['Address'] = this.address.toJson();
    }
    if (this.actAddress != null) {
      data['ActAddress'] = this.actAddress.toJson();
    }
    data['Checker'] = this.checker;
    data['CheckDate'] = this.checkDate;
    data['CheckResult'] = this.checkResult;
    if (this.cO != null) {
      data['CO'] = this.cO.toJson();
    }
    if (this.actCO != null) {
      data['ActCO'] = this.actCO.toJson();
    }
    if (this.cQ != null) {
      data['CQ'] = this.cQ.toJson();
    }
    if (this.actCQ != null) {
      data['ActCQ'] = this.actCQ.toJson();
    }
    if (this.otherNote != null) {
      data['OtherNote'] = this.otherNote.toJson();
    }
    if (this.other != null) {
      data['Other'] = this.other.toJson();
    }
    if (this.actOther != null) {
      data['ActOther'] = this.actOther.toJson();
    }
    if (this.docHandover != null) {
      data['DocHandover'] = this.docHandover.toJson();
    }
    if (this.actDocHandover != null) {
      data['ActDocHandover'] = this.actDocHandover.toJson();
    }
    if (this.receiver != null) {
      data['Receiver'] = this.receiver.toJson();
    }
    if (this.note != null) {
      data['Note'] = this.note.toJson();
    }
    return data;
  }
}

class ImportDate {
  String value;
  bool isReadOnly;

  ImportDate({this.value, this.isReadOnly});

  ImportDate.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    isReadOnly = json['IsReadOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['IsReadOnly'] = this.isReadOnly;
    return data;
  }
}

class CO {
  bool value;
  bool isReadOnly;

  CO({this.value, this.isReadOnly});

  CO.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    isReadOnly = json['IsReadOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['IsReadOnly'] = this.isReadOnly;
    return data;
  }
}
