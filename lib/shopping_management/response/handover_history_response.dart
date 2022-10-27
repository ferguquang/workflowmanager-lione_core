import 'package:workflow_manager/base/models/base_response.dart';

class HandoverHistoryResponse extends BaseResponse {
  int status;
  HandoverHistoryModel data;

  HandoverHistoryResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new HandoverHistoryModel.fromJson(json['Data'])
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

class HandoverHistoryModel {
  Commodity commodity;
  List<Histories> histories;

  HandoverHistoryModel({this.commodity, this.histories});

  HandoverHistoryModel.fromJson(Map<String, dynamic> json) {
    commodity = json['Commodity'] != null
        ? new Commodity.fromJson(json['Commodity'])
        : null;
    if (json['Histories'] != null) {
      histories = new List<Histories>();
      json['Histories'].forEach((v) {
        histories.add(new Histories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commodity != null) {
      data['Commodity'] = this.commodity.toJson();
    }
    if (this.histories != null) {
      data['Histories'] = this.histories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commodity {
  int iD;
  String name;
  String importDate;
  double qTY;
  String unit;

  Commodity({this.iD, this.name, this.importDate, this.qTY, this.unit});

  Commodity.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    importDate = json['ImportDate'];
    qTY = json['QTY'];
    unit = json['Unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['ImportDate'] = this.importDate;
    data['QTY'] = this.qTY;
    data['Unit'] = this.unit;
    return data;
  }
}

class Histories {
  int iD;
  String actDeliveryDate;
  double qTY;
  double deliveryQTY;
  double returnQTY;
  double totalQTY;
  double remainQTY;
  String status;
  double okQTY;
  double notOkQTY;
  String note;

  Histories(
      {this.iD,
      this.actDeliveryDate,
      this.qTY,
      this.deliveryQTY,
      this.returnQTY,
      this.totalQTY,
      this.remainQTY,
      this.status,
      this.okQTY,
      this.notOkQTY,
      this.note});

  Histories.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    actDeliveryDate = json['ActDeliveryDate'];
    qTY = json['QTY'];
    deliveryQTY = json['DeliveryQTY'];
    returnQTY = json['ReturnQTY'];
    totalQTY = json['TotalQTY'];
    remainQTY = json['RemainQTY'];
    status = json['Status'];
    okQTY = json['OkQTY'];
    notOkQTY = json['NotOkQTY'];
    note = json['Note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ActDeliveryDate'] = this.actDeliveryDate;
    data['QTY'] = this.qTY;
    data['DeliveryQTY'] = this.deliveryQTY;
    data['ReturnQTY'] = this.returnQTY;
    data['TotalQTY'] = this.totalQTY;
    data['RemainQTY'] = this.remainQTY;
    data['Status'] = this.status;
    data['OkQTY'] = this.okQTY;
    data['NotOkQTY'] = this.notOkQTY;
    data['Note'] = this.note;
    return data;
  }
}
