import 'package:workflow_manager/base/models/base_response.dart';

class DeliveryProgressDetailResponse extends BaseResponse {
  int status;
  DeliveryProgressDetailModel data;

  DeliveryProgressDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DeliveryProgressDetailModel.fromJson(json['Data'])
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

class DeliveryProgressDetailModel {
  DeliveryProgressLog deliveryProgressLog;
  List<DetailDeliveries> detailDeliveries;
  bool isSend;
  bool isSendKtbh;
  bool isSave;
  List<Status> status;
  bool isUpdate;
  Receiver receiver;

  DeliveryProgressDetailModel(
      {this.deliveryProgressLog,
      this.detailDeliveries,
      this.isSend,
      this.isSendKtbh,
      this.isSave,
      this.status,
      this.isUpdate,
      this.receiver});

  DeliveryProgressDetailModel.fromJson(Map<String, dynamic> json) {
    deliveryProgressLog = json['DeliveryProgressLog'] != null
        ? new DeliveryProgressLog.fromJson(json['DeliveryProgressLog'])
        : null;
    if (json['DetailDeliveries'] != null) {
      detailDeliveries = new List<DetailDeliveries>();
      json['DetailDeliveries'].forEach((v) {
        detailDeliveries.add(new DetailDeliveries.fromJson(v));
      });
    }
    isSend = json['IsSend'];
    isSendKtbh = json['IsSendKtbh'];
    isSave = json['IsSave'];
    if (json['Status'] != null) {
      status = new List<Status>();
      json['Status'].forEach((v) {
        status.add(new Status.fromJson(v));
      });
    }
    isUpdate = json['IsUpdate'];
    receiver = json['Receiver'] != null
        ? new Receiver.fromJson(json['Receiver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryProgressLog != null) {
      data['DeliveryProgressLog'] = this.deliveryProgressLog.toJson();
    }
    if (this.detailDeliveries != null) {
      data['DetailDeliveries'] =
          this.detailDeliveries.map((v) => v.toJson()).toList();
    }
    data['IsSend'] = this.isSend;
    data['IsSendKtbh'] = this.isSendKtbh;
    data['IsSave'] = this.isSave;
    if (this.status != null) {
      data['Status'] = this.status.map((v) => v.toJson()).toList();
    }
    data['IsUpdate'] = this.isUpdate;
    if (this.receiver != null) {
      data['Receiver'] = this.receiver.toJson();
    }
    return data;
  }
}

class DeliveryProgressLog {
  int iD;
  Deliver deliver;
  Deliver receiver;
  Deliver actDeliveryDate;
  DeliveryStatus status;

  DeliveryProgressLog(
      {this.iD,
      this.deliver,
      this.receiver,
      this.actDeliveryDate,
      this.status});

  DeliveryProgressLog.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    deliver =
        json['Deliver'] != null ? new Deliver.fromJson(json['Deliver']) : null;
    receiver = json['Receiver'] != null
        ? new Deliver.fromJson(json['Receiver'])
        : null;
    actDeliveryDate = json['ActDeliveryDate'] != null
        ? new Deliver.fromJson(json['ActDeliveryDate'])
        : null;
    status = json['Status'] != null
        ? new DeliveryStatus.fromJson(json['Status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    if (this.deliver != null) {
      data['Deliver'] = this.deliver.toJson();
    }
    if (this.receiver != null) {
      data['Receiver'] = this.receiver.toJson();
    }
    if (this.actDeliveryDate != null) {
      data['ActDeliveryDate'] = this.actDeliveryDate.toJson();
    }
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    return data;
  }
}

class Deliver {
  String value;
  bool isReadOnly;

  Deliver({this.value, this.isReadOnly});

  Deliver.fromJson(Map<String, dynamic> json) {
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

class DeliveryStatus {
  int iD;
  String name;
  bool isReadOnly;

  DeliveryStatus({this.iD, this.name, this.isReadOnly});

  DeliveryStatus.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    isReadOnly = json['IsReadOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['IsReadOnly'] = this.isReadOnly;
    return data;
  }
}

class DetailDeliveries {
  bool isCheck;
  bool isChecked;
  int iDDeliveriesProgressLogDetail;
  int iDContractDetailDelivery;
  int iDCommodity;
  String nameCommodity;
  double qTY;
  DeliveryQTY deliveryQTY;
  DeliveryQTY returnQTY;
  double totalQTY;
  double remainQTY;
  DeliveryQTY okQTY;
  DeliveryQTY notOkQTY;
  Deliver note;
  StatusDetail statusDetail;
  int iDStatus;
  int soLuongQTY = 0;
  int conLaiQTY = 0;
  int soLanVao = 0;
  bool isCheckList = false;

  DetailDeliveries(
      {this.isCheck,
      this.isChecked,
      this.iDDeliveriesProgressLogDetail,
      this.iDContractDetailDelivery,
      this.iDCommodity,
      this.nameCommodity,
      this.qTY,
      this.deliveryQTY,
      this.returnQTY,
      this.totalQTY,
      this.remainQTY,
      this.okQTY,
      this.notOkQTY,
      this.note,
      this.statusDetail,
      this.iDStatus,
      this.soLuongQTY = 0,
      this.conLaiQTY = 0,
      this.soLanVao = 0});

  DetailDeliveries.fromJson(Map<String, dynamic> json) {
    isCheck = json['IsCheck'];
    isChecked = json['IsChecked'];
    iDDeliveriesProgressLogDetail = json['IDDeliveriesProgressLogDetail'];
    iDContractDetailDelivery = json['IDContractDetailDelivery'];
    iDCommodity = json['IDCommodity'];
    nameCommodity = json['NameCommodity'];
    qTY = json['QTY'];
    deliveryQTY = json['DeliveryQTY'] != null
        ? new DeliveryQTY.fromJson(json['DeliveryQTY'])
        : null;
    returnQTY = json['ReturnQTY'] != null
        ? new DeliveryQTY.fromJson(json['ReturnQTY'])
        : null;
    totalQTY = json['TotalQTY'];
    remainQTY = json['RemainQTY'];
    okQTY =
        json['OkQTY'] != null ? new DeliveryQTY.fromJson(json['OkQTY']) : null;
    notOkQTY = json['NotOkQTY'] != null
        ? new DeliveryQTY.fromJson(json['NotOkQTY'])
        : null;
    note = json['Note'] != null ? new Deliver.fromJson(json['Note']) : null;
    statusDetail = json['StatusDetail'] != null
        ? new StatusDetail.fromJson(json['StatusDetail'])
        : null;
    iDStatus = json['IDStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsCheck'] = this.isCheck;
    data['IsChecked'] = this.isChecked;
    data['IDDeliveriesProgressLogDetail'] = this.iDDeliveriesProgressLogDetail;
    data['IDContractDetailDelivery'] = this.iDContractDetailDelivery;
    data['IDCommodity'] = this.iDCommodity;
    data['NameCommodity'] = this.nameCommodity;
    data['QTY'] = this.qTY;
    if (this.deliveryQTY != null) {
      data['DeliveryQTY'] = this.deliveryQTY.toJson();
    }
    if (this.returnQTY != null) {
      data['ReturnQTY'] = this.returnQTY.toJson();
    }
    data['TotalQTY'] = this.totalQTY;
    data['RemainQTY'] = this.remainQTY;
    if (this.okQTY != null) {
      data['OkQTY'] = this.okQTY.toJson();
    }
    if (this.notOkQTY != null) {
      data['NotOkQTY'] = this.notOkQTY.toJson();
    }
    if (this.note != null) {
      data['Note'] = this.note.toJson();
    }
    if (this.statusDetail != null) {
      data['StatusDetail'] = this.statusDetail.toJson();
    }
    data['IDStatus'] = this.iDStatus;
    return data;
  }
}

class DeliveryQTY {
  double value;
  bool isReadOnly;

  DeliveryQTY({this.value, this.isReadOnly});

  DeliveryQTY.fromJson(Map<String, dynamic> json) {
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

class StatusDetail {
  String name;
  String bgColor;

  StatusDetail({this.name, this.bgColor});

  StatusDetail.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    bgColor = json['BgColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['BgColor'] = this.bgColor;
    return data;
  }
}

class Status {
  int iD;
  String name;
  bool isEnable;

  Status({this.iD, this.name, this.isEnable});

  Status.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class Receiver {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;
  String deptName;

  Receiver(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept,
      this.deptName});

  Receiver.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
    deptName = json['DeptName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['IDDept'] = this.iDDept;
    data['DeptName'] = this.deptName;
    return data;
  }
}
