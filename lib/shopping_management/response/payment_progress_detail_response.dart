import 'package:workflow_manager/base/models/base_response.dart';

class PaymentProgressDetailResponse extends BaseResponse {
  int status;
  PaymentProgressDetailModel data;

  PaymentProgressDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new PaymentProgressDetailModel.fromJson(json['Data'])
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

class PaymentProgressDetailModel {
  Contract contract;
  List<ContractDetails> contractDetails;
  bool isSave;
  bool isComplete;

  PaymentProgressDetailModel(
      {this.contract, this.contractDetails, this.isSave, this.isComplete});

  PaymentProgressDetailModel.fromJson(Map<String, dynamic> json) {
    contract = json['Contract'] != null
        ? new Contract.fromJson(json['Contract'])
        : null;
    if (json['ContractDetails'] != null) {
      contractDetails = new List<ContractDetails>();
      json['ContractDetails'].forEach((v) {
        contractDetails.add(new ContractDetails.fromJson(v));
      });
    }
    isSave = json['IsSave'];
    isComplete = json['IsComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contract != null) {
      data['Contract'] = this.contract.toJson();
    }
    if (this.contractDetails != null) {
      data['ContractDetails'] =
          this.contractDetails.map((v) => v.toJson()).toList();
    }
    data['IsSave'] = this.isSave;
    data['IsComplete'] = this.isComplete;
    return data;
  }
}

class Contract {
  int iD;
  String requisitionNumber;
  String suggestionType;
  String shoppingType;
  String project;
  String pONumber;
  String currency;
  double rate;
  String provider;
  int signDate;
  String signBy;
  String jobPosition;
  String totalAmount;
  String payAmount1;
  String payAmount2;
  String payAmount3;
  String totalDebt;

  Contract(
      {this.iD,
      this.requisitionNumber,
      this.suggestionType,
      this.shoppingType,
      this.project,
      this.pONumber,
      this.currency,
      this.rate,
      this.provider,
      this.signDate,
      this.signBy,
      this.jobPosition,
      this.totalAmount,
      this.payAmount1,
      this.payAmount2,
      this.payAmount3,
      this.totalDebt});

  Contract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    requisitionNumber = json['RequisitionNumber'];
    suggestionType = json['SuggestionType'];
    shoppingType = json['ShoppingType'];
    project = json['Project'];
    pONumber = json['PONumber'];
    currency = json['Currency'];
    rate = json['Rate'];
    provider = json['Provider'];
    signDate = json['SignDate'];
    signBy = json['SignBy'];
    jobPosition = json['JobPosition'];
    totalAmount = json['TotalAmount'];
    payAmount1 = json['PayAmount1'];
    payAmount2 = json['PayAmount2'];
    payAmount3 = json['PayAmount3'];
    totalDebt = json['TotalDebt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['SuggestionType'] = this.suggestionType;
    data['ShoppingType'] = this.shoppingType;
    data['Project'] = this.project;
    data['PONumber'] = this.pONumber;
    data['Currency'] = this.currency;
    data['Rate'] = this.rate;
    data['Provider'] = this.provider;
    data['SignDate'] = this.signDate;
    data['SignBy'] = this.signBy;
    data['JobPosition'] = this.jobPosition;
    data['TotalAmount'] = this.totalAmount;
    data['PayAmount1'] = this.payAmount1;
    data['PayAmount2'] = this.payAmount2;
    data['PayAmount3'] = this.payAmount3;
    data['TotalDebt'] = this.totalDebt;
    return data;
  }
}

class ContractDetails {
  int iD;
  String commodity;
  double amount;
  int payPercent1;
  String payAmount1;
  double payActAmount1;
  int payActDate1;
  int payDate1;
  int payPercent2;
  String payAmount2;
  double payActAmount2;
  int payActDate2;
  int payDate2;
  int payPercent3;
  String payAmount3;
  double payActAmount3;
  int payActDate3;
  int payDate3;
  double totalActAmount;
  String totalDebt;
  String amountString;
  bool isRequiredPay1;
  bool isRequiredPay2;
  bool isRequiredPay3;
  String manufactur;

  ContractDetails(
      {this.iD,
      this.commodity,
      this.amount,
      this.payPercent1,
      this.payAmount1,
      this.payActAmount1,
      this.payActDate1,
      this.payDate1,
      this.payPercent2,
      this.payAmount2,
      this.payActAmount2,
      this.payActDate2,
      this.payDate2,
      this.payPercent3,
      this.payAmount3,
      this.payActAmount3,
      this.payActDate3,
      this.payDate3,
      this.totalActAmount,
      this.totalDebt,
      this.amountString,
      this.isRequiredPay1,
      this.isRequiredPay2,
      this.isRequiredPay3,
      this.manufactur});

  void copyTo(ContractDetails target) {
    var json = toJson();
    target.iD = json['ID'];
    target.commodity = json['Commodity'];
    target.amount = json['Amount'];
    target.payPercent1 = json['PayPercent1']?.toInt() ?? 0;
    target.payAmount1 = json['PayAmount1'];
    target.payActAmount1 = json['PayActAmount1'];
    target.payActDate1 = json['PayActDate1'];
    target.payDate1 = json['PayDate1'];
    target.payPercent2 = json['PayPercent2']?.toInt() ?? 0;
    target.payAmount2 = json['PayAmount2'];
    target.payActAmount2 = json['PayActAmount2'];
    target.payActDate2 = json['PayActDate2'];
    target.payDate2 = json['PayDate2'];
    target.payPercent3 = json['PayPercent3']?.toInt() ?? 0;
    target.payAmount3 = json['PayAmount3'];
    target.payActAmount3 = json['PayActAmount3'];
    target.payActDate3 = json['PayActDate3'];
    target.payDate3 = json['PayDate3'];
    target.totalActAmount = json['TotalActAmount'];
    target.totalDebt = json['TotalDebt'];
    target.amountString = json['AmountString'];
    target.isRequiredPay1 = json['IsRequiredPay1'];
    target.isRequiredPay2 = json['IsRequiredPay2'];
    target.isRequiredPay3 = json['IsRequiredPay3'];
    target.manufactur = json['Manufactur'];
  }

  ContractDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    commodity = json['Commodity'];
    amount = json['Amount'];
    payPercent1 = json['PayPercent1']?.toInt() ?? 0;
    payAmount1 = json['PayAmount1'];
    payActAmount1 = json['PayActAmount1'];
    payActDate1 = json['PayActDate1'];
    payDate1 = json['PayDate1'];
    payPercent2 = json['PayPercent2']?.toInt() ?? 0;
    payAmount2 = json['PayAmount2'];
    payActAmount2 = json['PayActAmount2'];
    payActDate2 = json['PayActDate2'];
    payDate2 = json['PayDate2'];
    payPercent3 = json['PayPercent3']?.toInt() ?? 0;
    payAmount3 = json['PayAmount3'];
    payActAmount3 = json['PayActAmount3'];
    payActDate3 = json['PayActDate3'];
    payDate3 = json['PayDate3'];
    totalActAmount = json['TotalActAmount'];
    totalDebt = json['TotalDebt'];
    amountString = json['AmountString'];
    isRequiredPay1 = json['IsRequiredPay1'];
    isRequiredPay2 = json['IsRequiredPay2'];
    isRequiredPay3 = json['IsRequiredPay3'];
    manufactur = json['Manufactur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Commodity'] = this.commodity;
    data['Amount'] = this.amount;
    data['PayPercent1'] = this.payPercent1;
    data['PayAmount1'] = this.payAmount1;
    data['PayActAmount1'] = this.payActAmount1;
    data['PayActDate1'] = this.payActDate1;
    data['PayDate1'] = this.payDate1;
    data['PayPercent2'] = this.payPercent2;
    data['PayAmount2'] = this.payAmount2;
    data['PayActAmount2'] = this.payActAmount2;
    data['PayActDate2'] = this.payActDate2;
    data['PayDate2'] = this.payDate2;
    data['PayPercent3'] = this.payPercent3;
    data['PayAmount3'] = this.payAmount3;
    data['PayActAmount3'] = this.payActAmount3;
    data['PayActDate3'] = this.payActDate3;
    data['PayDate3'] = this.payDate3;
    data['TotalActAmount'] = this.totalActAmount;
    data['TotalDebt'] = this.totalDebt;
    data['AmountString'] = this.amountString;
    data['IsRequiredPay1'] = this.isRequiredPay1;
    data['IsRequiredPay2'] = this.isRequiredPay2;
    data['IsRequiredPay3'] = this.isRequiredPay3;
    data['Manufactur'] = this.manufactur;
    return data;
  }
}
