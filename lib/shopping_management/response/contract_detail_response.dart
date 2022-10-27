import 'package:workflow_manager/base/models/base_response.dart';

class ContractDetailResponse extends BaseResponse {
  int status;
  ContractDetailModel data;

  ContractDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ContractDetailModel.fromJson(json['Data'])
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

class ContractDetailModel {
  Contract contract;

  ContractDetailModel({this.contract});

  ContractDetailModel.fromJson(Map<String, dynamic> json) {
    contract = json['contract'] != null
        ? new Contract.fromJson(json['contract'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contract != null) {
      data['contract'] = this.contract.toJson();
    }
    return data;
  }
}

class Contract {
  int iD;
  String requisitionNumber;
  String shoppingType;
  int iDShoppingType;
  String suggestionType;
  int iDSuggestionType;
  String project;
  String pONumber;
  String currency;
  double rate;
  String provider;
  String signDate;
  String singBy;
  String jobPosition;
  String paymentMethod;
  String note;
  List<ContractFiles> contractFiles;
  double totalAmount;
  String status;
  int iDStatus;
  bool isUpdate;
  bool isSave;
  bool isSendSign;
  bool isFinish;
  bool isOutOfStock;
  List<Lines> lines;

  Contract(
      {this.iD,
      this.requisitionNumber,
      this.shoppingType,
      this.iDShoppingType,
      this.suggestionType,
      this.iDSuggestionType,
      this.project,
      this.pONumber,
      this.currency,
      this.rate,
      this.provider,
      this.signDate,
      this.singBy,
      this.jobPosition,
      this.paymentMethod,
      this.note,
      this.contractFiles,
      this.totalAmount,
      this.status,
      this.iDStatus,
      this.isUpdate,
      this.isSave,
      this.isSendSign,
      this.isFinish,
      this.isOutOfStock,
      this.lines});

  Contract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    requisitionNumber = json['RequisitionNumber'];
    shoppingType = json['ShoppingType'];
    iDShoppingType = json['IDShoppingType'];
    suggestionType = json['SuggestionType'];
    iDSuggestionType = json['IDSuggestionType'];
    project = json['Project'];
    pONumber = json['PONumber'];
    currency = json['Currency'];
    rate = json['Rate'];
    provider = json['Provider'];
    signDate = json['SignDate'];
    singBy = json['SingBy'];
    jobPosition = json['JobPosition'];
    paymentMethod = json['PaymentMethod'];
    note = json['Note'];
    if (json['ContractFiles'] != null) {
      contractFiles = new List<ContractFiles>();
      json['ContractFiles'].forEach((v) {
        contractFiles.add(ContractFiles.fromJson(v));
      });
    }
    totalAmount = json['TotalAmount'];
    status = json['Status'];
    iDStatus = json['IDStatus'];
    isUpdate = json['IsUpdate'];
    isSave = json['IsSave'];
    isSendSign = json['IsSendSign'];
    isFinish = json['IsFinish'];
    isOutOfStock = json['IsOutOfStock'];
    if (json['Lines'] != null) {
      lines = new List<Lines>();
      json['Lines'].forEach((v) {
        lines.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['ShoppingType'] = this.shoppingType;
    data['IDShoppingType'] = this.iDShoppingType;
    data['SuggestionType'] = this.suggestionType;
    data['IDSuggestionType'] = this.iDSuggestionType;
    data['Project'] = this.project;
    data['PONumber'] = this.pONumber;
    data['Currency'] = this.currency;
    data['Rate'] = this.rate;
    data['Provider'] = this.provider;
    data['SignDate'] = this.signDate;
    data['SingBy'] = this.singBy;
    data['JobPosition'] = this.jobPosition;
    data['PaymentMethod'] = this.paymentMethod;
    data['Note'] = this.note;
    if (this.contractFiles != null) {
      data['ContractFiles'] =
          this.contractFiles.map((v) => v.toJson()).toList();
    }
    data['TotalAmount'] = this.totalAmount;
    data['Status'] = this.status;
    data['IDStatus'] = this.iDStatus;
    data['IsUpdate'] = this.isUpdate;
    data['IsSave'] = this.isSave;
    data['IsSendSign'] = this.isSendSign;
    data['IsFinish'] = this.isFinish;
    data['IsOutOfStock'] = this.isOutOfStock;
    if (this.lines != null) {
      data['Lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lines {
  int iD;
  String product;
  String manufactur;
  String description;
  double qTY;
  String unit;
  double price;
  double amount;
  double rentalTime;
  String rentType;
  int iDRentType;
  String origin;
  String warranty;
  bool cO;
  bool cQ;
  bool other;
  String note;
  int payPercent1;
  String payDate1;
  double payAmount1;
  int payPercent2;
  String payDate2;
  double payAmount2;
  int payPercent3;
  String payDate3;
  double payAmount3;

  Lines(
      {this.iD,
      this.product,
      this.manufactur,
      this.description,
      this.qTY,
      this.unit,
      this.price,
      this.amount,
      this.rentalTime,
      this.rentType,
      this.iDRentType,
      this.origin,
      this.warranty,
      this.cO,
      this.cQ,
      this.other,
      this.note,
      this.payPercent1,
      this.payDate1,
      this.payAmount1,
      this.payPercent2,
      this.payDate2,
      this.payAmount2,
      this.payPercent3,
      this.payDate3,
      this.payAmount3});

  Lines.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    product = json['Product'];
    manufactur = json['Manufactur'];
    description = json['Description'];
    qTY = json['QTY'];
    unit = json['Unit'];
    price = json['Price'];
    amount = json['Amount'];
    rentalTime = json['RentalTime'];
    rentType = json['RentType'];
    iDRentType = json['IDRentType'];
    origin = json['Origin'];
    warranty = json['Warranty'];
    cO = json['CO'];
    cQ = json['CQ'];
    other = json['Other'];
    note = json['Note'];
    payPercent1 = json['PayPercent1']?.toInt() ?? 0;
    payDate1 = json['PayDate1'];
    payAmount1 = json['PayAmount1'];
    payPercent2 = json['PayPercent2']?.toInt() ?? 0;
    payDate2 = json['PayDate2'];
    payAmount2 = json['PayAmount2'];
    payPercent3 = json['PayPercent3']?.toInt() ?? 0;
    payDate3 = json['PayDate3'];
    payAmount3 = json['PayAmount3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Product'] = this.product;
    data['Manufactur'] = this.manufactur;
    data['Description'] = this.description;
    data['QTY'] = this.qTY;
    data['Unit'] = this.unit;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['RentalTime'] = this.rentalTime;
    data['RentType'] = this.rentType;
    data['IDRentType'] = this.iDRentType;
    data['Origin'] = this.origin;
    data['Warranty'] = this.warranty;
    data['CO'] = this.cO;
    data['CQ'] = this.cQ;
    data['Other'] = this.other;
    data['Note'] = this.note;
    data['PayPercent1'] = this.payPercent1;
    data['PayDate1'] = this.payDate1;
    data['PayAmount1'] = this.payAmount1;
    data['PayPercent2'] = this.payPercent2;
    data['PayDate2'] = this.payDate2;
    data['PayAmount2'] = this.payAmount2;
    data['PayPercent3'] = this.payPercent3;
    data['PayDate3'] = this.payDate3;
    data['PayAmount3'] = this.payAmount3;
    return data;
  }
}

class ContractFiles {
  String fileName;
  String filePath;

  ContractFiles(this.fileName, this.filePath);

  ContractFiles.fromJson(Map<String, dynamic> json) {
    fileName = json["FileName"];
    filePath = json["FilePath"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json["FileName"] = fileName;
    json["FilePath"] = filePath;
    return json;
  }
}
