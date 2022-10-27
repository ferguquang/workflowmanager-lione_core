import 'package:workflow_manager/base/models/base_response.dart';

class DeliveryProgressListResponse extends BaseResponse {
  int status;
  DeliveryProgressListModel data;

  DeliveryProgressListResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DeliveryProgressListModel.fromJson(json['Data'])
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

class DeliveryProgressListModel {
  Contract contract;
  List<Deliveries> deliveries;
  bool isCreate;

  DeliveryProgressListModel({this.contract, this.deliveries, this.isCreate});

  DeliveryProgressListModel.fromJson(Map<String, dynamic> json) {
    contract = json['Contract'] != null
        ? new Contract.fromJson(json['Contract'])
        : null;
    if (json['Deliveries'] != null) {
      deliveries = new List<Deliveries>();
      json['Deliveries'].forEach((v) {
        deliveries.add(new Deliveries.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contract != null) {
      data['Contract'] = this.contract.toJson();
    }
    if (this.deliveries != null) {
      data['Deliveries'] = this.deliveries.map((v) => v.toJson()).toList();
    }
    data['IsCreate'] = this.isCreate;
    return data;
  }
}

class Contract {
  int iD;

  Contract({this.iD});

  Contract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    return data;
  }
}

class Deliveries {
  int iD;
  String actDeliveryDate;
  String deliver;
  String receiver;
  String status;
  int iDStatus;
  int created;
  bool isView;
  bool isUpdate;

  Deliveries(
      {this.iD,
      this.actDeliveryDate,
      this.deliver,
      this.receiver,
      this.status,
      this.iDStatus,
      this.created,
      this.isView,
      this.isUpdate});

  Deliveries.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    actDeliveryDate = json['ActDeliveryDate'];
    deliver = json['Deliver'];
    receiver = json['Receiver'];
    status = json['Status'];
    iDStatus = json['IDStatus'];
    created = json['Created'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ActDeliveryDate'] = this.actDeliveryDate;
    data['Deliver'] = this.deliver;
    data['Receiver'] = this.receiver;
    data['Status'] = this.status;
    data['IDStatus'] = this.iDStatus;
    data['Created'] = this.created;
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    return data;
  }
}
