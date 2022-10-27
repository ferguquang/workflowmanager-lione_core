import 'package:workflow_manager/base/models/base_response.dart';

class CheckSlipDetailResponse extends BaseResponse {
  int status;
  CheckSlipDetailModel data;

  CheckSlipDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new CheckSlipDetailModel.fromJson(json['Data'])
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

class CheckSlipDetailModel {
  DeliveriesProgressLog deliveriesProgressLog;
  List<DeliveriesProgressLogDetails> deliveriesProgressLogDetails;

  CheckSlipDetailModel(
      {this.deliveriesProgressLog, this.deliveriesProgressLogDetails});

  CheckSlipDetailModel.fromJson(Map<String, dynamic> json) {
    deliveriesProgressLog = json['DeliveriesProgressLog'] != null
        ? new DeliveriesProgressLog.fromJson(json['DeliveriesProgressLog'])
        : null;
    if (json['DeliveriesProgressLogDetails'] != null) {
      deliveriesProgressLogDetails = new List<DeliveriesProgressLogDetails>();
      json['DeliveriesProgressLogDetails'].forEach((v) {
        deliveriesProgressLogDetails
            .add(new DeliveriesProgressLogDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveriesProgressLog != null) {
      data['DeliveriesProgressLog'] = this.deliveriesProgressLog.toJson();
    }
    if (this.deliveriesProgressLogDetails != null) {
      data['DeliveriesProgressLogDetails'] =
          this.deliveriesProgressLogDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveriesProgressLog {
  int iD;
  String sentCheckDate;
  String actDeliveryDate;
  String assigneeChecker;
  String deptChecker;
  String uRLWorkflowRecord;
  int iDServiceRecord;

  DeliveriesProgressLog(
      {this.iD,
      this.sentCheckDate,
      this.actDeliveryDate,
      this.assigneeChecker,
      this.deptChecker,
      this.uRLWorkflowRecord,
      this.iDServiceRecord});

  DeliveriesProgressLog.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    sentCheckDate = json['SentCheckDate'];
    actDeliveryDate = json['ActDeliveryDate'];
    assigneeChecker = json['AssigneeChecker'];
    deptChecker = json['DeptChecker'];
    uRLWorkflowRecord = json['URLWorkflowRecord'];
    iDServiceRecord = json['IDServiceRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['SentCheckDate'] = this.sentCheckDate;
    data['ActDeliveryDate'] = this.actDeliveryDate;
    data['AssigneeChecker'] = this.assigneeChecker;
    data['DeptChecker'] = this.deptChecker;
    data['URLWorkflowRecord'] = this.uRLWorkflowRecord;
    data['IDServiceRecord'] = this.iDServiceRecord;
    return data;
  }
}

class DeliveriesProgressLogDetails {
  int iD;
  String commodityName;
  String description;
  String unit;
  String origin;
  double deliverQTY;
  String serials;
  double okQTY;
  double notOkQTY;
  String checkNote;

  DeliveriesProgressLogDetails(
      {this.iD,
      this.commodityName,
      this.description,
      this.unit,
      this.origin,
      this.deliverQTY,
      this.serials,
      this.okQTY,
      this.notOkQTY,
      this.checkNote});

  DeliveriesProgressLogDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    commodityName = json['CommodityName'];
    description = json['Description'];
    unit = json['Unit'];
    origin = json['Origin'];
    deliverQTY = json['DeliverQTY'];
    serials = json['Serials'];
    okQTY = json['OkQTY'];
    notOkQTY = json['NotOkQTY'];
    checkNote = json['CheckNote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CommodityName'] = this.commodityName;
    data['Description'] = this.description;
    data['Unit'] = this.unit;
    data['Origin'] = this.origin;
    data['DeliverQTY'] = this.deliverQTY;
    data['Serials'] = this.serials;
    data['OkQTY'] = this.okQTY;
    data['NotOkQTY'] = this.notOkQTY;
    data['CheckNote'] = this.checkNote;
    return data;
  }
}
