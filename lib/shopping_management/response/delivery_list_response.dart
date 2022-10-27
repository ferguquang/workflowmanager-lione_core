import 'package:workflow_manager/base/models/base_response.dart';

class DeliveryListResponse extends BaseResponse {
  int status;
  DeliveryListModel data;

  DeliveryListResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DeliveryListModel.fromJson(json['Data'])
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

class DeliveryListModel {
  List<Contracts> contracts;
  bool isCreate;
  int totalRecord;
  SearchParam searchParam;

  DeliveryListModel(
      {this.contracts, this.isCreate, this.totalRecord, this.searchParam});

  DeliveryListModel.fromJson(Map<String, dynamic> json) {
    if (json['Contracts'] != null) {
      contracts = new List<Contracts>();
      json['Contracts'].forEach((v) {
        contracts.add(new Contracts.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contracts != null) {
      data['Contracts'] = this.contracts.map((v) => v.toJson()).toList();
    }
    data['IsCreate'] = this.isCreate;
    data['TotalRecord'] = this.totalRecord;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class Contracts {
  int iD;
  String project;
  String requisition;
  String pONumber;
  String signDate;
  String totalAmount;
  String currencyCode;
  DeliveryStatus deliveryStatus;
  bool isView;
  bool isUpdate;

  Contracts(
      {this.iD,
      this.project,
      this.requisition,
      this.pONumber,
      this.signDate,
      this.totalAmount,
      this.currencyCode,
      this.deliveryStatus,
      this.isView,
      this.isUpdate});

  Contracts.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    project = json['Project'];
    requisition = json['Requisition'];
    pONumber = json['PONumber'];
    signDate = json['SignDate'];
    totalAmount = json['TotalAmount'];
    currencyCode = json['CurrencyCode'];
    deliveryStatus = json['DeliveryStatus'] != null
        ? new DeliveryStatus.fromJson(json['DeliveryStatus'])
        : null;
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Project'] = this.project;
    data['Requisition'] = this.requisition;
    data['PONumber'] = this.pONumber;
    data['SignDate'] = this.signDate;
    data['TotalAmount'] = this.totalAmount;
    data['CurrencyCode'] = this.currencyCode;
    if (this.deliveryStatus != null) {
      data['DeliveryStatus'] = this.deliveryStatus.toJson();
    }
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    return data;
  }
}

class DeliveryStatus {
  int iD;
  String name;
  String bgColor;

  DeliveryStatus({this.iD, this.name, this.bgColor});

  DeliveryStatus.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    bgColor = json['BgColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['BgColor'] = this.bgColor;
    return data;
  }
}

class SearchParam {
  List<Projects> projects;
  List<Requisitions> requisitions;
  List<SearchContract> contracts;
  List<DeliveryStatus> deliveryStatus;

  SearchParam(
      {this.projects, this.requisitions, this.contracts, this.deliveryStatus});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Projects'] != null) {
      projects = new List<Projects>();
      json['Projects'].forEach((v) {
        projects.add(new Projects.fromJson(v));
      });
    }
    if (json['Requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
    if (json['Contracts'] != null) {
      contracts = new List<SearchContract>();
      json['Contracts'].forEach((v) {
        contracts.add(new SearchContract.fromJson(v));
      });
    }
    if (json['DeliveryStatus'] != null) {
      deliveryStatus = new List<DeliveryStatus>();
      json['DeliveryStatus'].forEach((v) {
        deliveryStatus.add(new DeliveryStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['Projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.contracts != null) {
      data['Contracts'] = this.contracts.map((v) => v.toJson()).toList();
    }
    if (this.deliveryStatus != null) {
      data['DeliveryStatus'] =
          this.deliveryStatus.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Projects {
  int iD;
  String name;
  String key;
  bool isEnable;

  Projects({this.iD, this.name, this.key, this.isEnable});

  Projects.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class Requisitions {
  String iD;
  String name;
  String key;
  bool isEnable;

  Requisitions({this.iD, this.name, this.key, this.isEnable});

  Requisitions.fromJson(Map<String, dynamic> json) {
    iD = json['ID']?.toString();
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class SearchContract {
  int iD;
  String name;
  String key;
  bool isEnable;

  SearchContract({this.iD, this.name, this.key, this.isEnable});

  SearchContract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
