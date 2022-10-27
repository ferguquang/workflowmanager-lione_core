import 'package:workflow_manager/base/models/base_response.dart';

class ProviderDetailResponse extends BaseResponse {
  int status;
  ProviderDetail data;

  ProviderDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data =
        json['Data'] != null ? new ProviderDetail.fromJson(json['Data']) : null;
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

class ProviderDetail {
  Requisition requisition;

  ProviderDetail({this.requisition});

  ProviderDetail.fromJson(Map<String, dynamic> json) {
    requisition = json['Requisition'] != null
        ? new Requisition.fromJson(json['Requisition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requisition != null) {
      data['Requisition'] = this.requisition.toJson();
    }
    return data;
  }
}

class Requisition {
  int iD;
  String requisitionNumber;
  String shoppingType;
  String suggestionType;
  String purpose;
  String requestBy;
  Dept dept;
  int requestDate;
  String project;
  String investor;
  String currencyCode;
  double currencyRate;
  int receptionDate;
  String status;
  String reason;
  int processingDay;
  double totalAmount;
  bool isSave;
  bool isSend;
  bool isReject;
  bool isApprove;
  int changeProviderDate;
  List<LineChooseProviderDetail> lines;
  DisableFiels disableFiels;

  Requisition(
      {this.iD,
      this.requisitionNumber,
      this.shoppingType,
      this.suggestionType,
      this.purpose,
      this.requestBy,
      this.dept,
      this.requestDate,
      this.project,
      this.investor,
      this.currencyCode,
      this.currencyRate,
      this.receptionDate,
      this.status,
      this.reason,
      this.processingDay,
      this.totalAmount,
      this.isSave,
      this.isSend,
      this.lines,
      this.changeProviderDate,
      this.disableFiels});

  Requisition.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    changeProviderDate = json['ChangeProviderDate'];
    requisitionNumber = json['RequisitionNumber'];
    shoppingType = json['ShoppingType'];
    suggestionType = json['SuggestionType'];
    purpose = json['Purpose'];
    requestBy = json['RequestBy'];
    dept = json['Dept'] != null ? new Dept.fromJson(json['Dept']) : null;
    requestDate = json['RequestDate']?.toInt() ?? 0;
    project = json['Project'];
    investor = json['Investor'];
    currencyCode = json['CurrencyCode'];
    currencyRate = json['CurrencyRate'];
    receptionDate = json['ReceptionDate']?.toInt() ?? 0;
    status = json['Status'];
    reason = json['Reason'];
    processingDay = json['ProcessingDay'];
    totalAmount = json['TotalAmount'];
    isSave = json['IsSave'];
    isSend = json['IsSend'];
    isReject = json['IsReject'];
    isApprove = json['IsApprove'];
    if (json['Lines'] != null) {
      lines = new List<LineChooseProviderDetail>();
      json['Lines'].forEach((v) {
        lines.add(new LineChooseProviderDetail.fromJson(v));
      });
    }
    disableFiels = json['DisableFiels'] != null
        ? new DisableFiels.fromJson(json['DisableFiels'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['ShoppingType'] = this.shoppingType;
    data['SuggestionType'] = this.suggestionType;
    data['Purpose'] = this.purpose;
    data['RequestBy'] = this.requestBy;
    if (this.dept != null) {
      data['Dept'] = this.dept.toJson();
    }
    data['RequestDate'] = this.requestDate;
    data['Project'] = this.project;
    data['Investor'] = this.investor;
    data['CurrencyCode'] = this.currencyCode;
    data['CurrencyRate'] = this.currencyRate;
    data['ReceptionDate'] = this.receptionDate;
    data['Status'] = this.status;
    data['Reason'] = this.reason;
    data['ProcessingDay'] = this.processingDay;
    data['TotalAmount'] = this.totalAmount;
    data['IsSave'] = this.isSave;
    data['IsSend'] = this.isSend;
    data['IsApprove'] = this.isApprove;
    data['ChangeProviderDate'] = changeProviderDate;
    data['IsReject'] = this.isReject;
    if (this.lines != null) {
      data['Lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dept {
  int iD;
  int iDChannel;
  String name;
  String code;
  String describe;
  int parent;
  Null parents;
  String created;
  int userCount;
  Null searchMeta;
  bool keepConnectionAlive;
  Null connection;
  Null lastSQL;
  Null lastArgs;
  String lastCommand;
  bool enableAutoSelect;
  bool enableNamedParams;
  int commandTimeout;
  int oneTimeCommandTimeout;

  Dept(
      {this.iD,
      this.iDChannel,
      this.name,
      this.code,
      this.describe,
      this.parent,
      this.parents,
      this.created,
      this.userCount,
      this.searchMeta,
      this.keepConnectionAlive,
      this.connection,
      this.lastSQL,
      this.lastArgs,
      this.lastCommand,
      this.enableAutoSelect,
      this.enableNamedParams,
      this.commandTimeout,
      this.oneTimeCommandTimeout});

  Dept.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    name = json['Name'];
    code = json['Code'];
    describe = json['Describe'];
    parent = json['Parent'];
    parents = json['Parents'];
    created = json['Created'];
    userCount = json['UserCount'];
    searchMeta = json['SearchMeta'];
    keepConnectionAlive = json['KeepConnectionAlive'];
    connection = json['Connection'];
    lastSQL = json['LastSQL'];
    lastArgs = json['LastArgs'];
    lastCommand = json['LastCommand'];
    enableAutoSelect = json['EnableAutoSelect'];
    enableNamedParams = json['EnableNamedParams'];
    commandTimeout = json['CommandTimeout'];
    oneTimeCommandTimeout = json['OneTimeCommandTimeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['Name'] = this.name;
    data['Code'] = this.code;
    data['Describe'] = this.describe;
    data['Parent'] = this.parent;
    data['Parents'] = this.parents;
    data['Created'] = this.created;
    data['UserCount'] = this.userCount;
    data['SearchMeta'] = this.searchMeta;
    data['KeepConnectionAlive'] = this.keepConnectionAlive;
    data['Connection'] = this.connection;
    data['LastSQL'] = this.lastSQL;
    data['LastArgs'] = this.lastArgs;
    data['LastCommand'] = this.lastCommand;
    data['EnableAutoSelect'] = this.enableAutoSelect;
    data['EnableNamedParams'] = this.enableNamedParams;
    data['CommandTimeout'] = this.commandTimeout;
    data['OneTimeCommandTimeout'] = this.oneTimeCommandTimeout;
    return data;
  }
}

class LineChooseProviderDetail {
  int iD;
  int iDCategory;
  String product;
  String description;
  double qTY;
  String unit;
  String origin;
  double price;
  double amount;
  int deliveryDate;
  String deliveryDestination;
  double nbRent;
  String rentType;
  String provider;
  int providerID;
  double priceByProvider;
  String total;
  String manufactur;
  bool isHidden;

  LineChooseProviderDetail(
      {this.iD,
      this.product,
      this.description,
      this.qTY,
      this.unit,
      this.origin,
      this.price,
      this.amount,
      this.deliveryDate,
      this.deliveryDestination,
      this.nbRent,
      this.rentType,
      this.provider,
      this.providerID,
      this.priceByProvider,
      this.manufactur,
      this.iDCategory});

  LineChooseProviderDetail.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDCategory = json['IDCategory'];
    product = json['Product'];
    description = json['Description'];
    qTY = json['QTY'];
    unit = json['Unit'];
    origin = json['Origin'];
    price = json['Price'];
    amount = json['Amount'];
    deliveryDate = json['DeliveryDate'];
    deliveryDestination = json['DeliveryDestination'];
    nbRent = json['NbRent'];
    rentType = json['RentType'];
    provider = json['Provider'];
    providerID = json['ProviderID'];
    priceByProvider = json['PriceByProvider'];
    manufactur = json['Manufactur'];
    isHidden = json['IsHidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDCategory'] = this.iDCategory;
    data['Product'] = this.product;
    data['Description'] = this.description;
    data['QTY'] = this.qTY;
    data['Unit'] = this.unit;
    data['Origin'] = this.origin;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['DeliveryDate'] = this.deliveryDate;
    data['DeliveryDestination'] = this.deliveryDestination;
    data['NbRent'] = this.nbRent;
    data['RentType'] = this.rentType;
    data['Provider'] = this.provider;
    data['ProviderID'] = this.providerID;
    data['PriceByProvider'] = this.priceByProvider;
    data['Manufactur'] = this.manufactur;
    return data;
  }
}

class DisableFiels {
  bool currencyRate;
  bool currencyCode;
  bool processingDay;

  DisableFiels({this.currencyRate, this.currencyCode, this.processingDay});

  DisableFiels.fromJson(Map<String, dynamic> json) {
    currencyRate = json['CurrencyRate'];
    currencyCode = json['CurrencyCode'];
    processingDay = json['ProcessingDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CurrencyRate'] = this.currencyRate;
    data['CurrencyCode'] = this.currencyCode;
    data['ProcessingDay'] = this.processingDay;
    return data;
  }
}