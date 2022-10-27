import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/serial_detail_model.dart';

class SerialDetailUpdateResponse extends BaseResponse {
  int status;
  SerialDetailUpdateModel data;

  SerialDetailUpdateResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new SerialDetailUpdateModel.fromJson(json['Data'])
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

class SerialDetailUpdateModel {
  Serial serial;
  int totalRecord;
  List<SerialDetails> serialDetails;
  List<Requisitions> requisitions;
  List<Commodities> commodities;

  SerialDetailUpdateModel(
      {this.serial,
      this.totalRecord,
      this.serialDetails,
      this.requisitions,
      this.commodities});

  SerialDetailUpdateModel.fromJson(Map<String, dynamic> json) {
    serial =
        json['Serial'] != null ? new Serial.fromJson(json['Serial']) : null;
    totalRecord = json['TotalRecord'];
    if (json['SerialDetails'] != null) {
      serialDetails = new List<SerialDetails>();
      json['SerialDetails'].forEach((v) {
        serialDetails.add(new SerialDetails.fromJson(v));
      });
    }
    if (json['Requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
    if (json['Commodities'] != null) {
      commodities = new List<Commodities>();
      json['Commodities'].forEach((v) {
        commodities.add(new Commodities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serial != null) {
      data['Serial'] = this.serial.toJson();
    }
    data['TotalRecord'] = this.totalRecord;
    if (this.serialDetails != null) {
      data['SerialDetails'] =
          this.serialDetails.map((v) => v.toJson()).toList();
    }
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.commodities != null) {
      data['Commodities'] = this.commodities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requisitions {
  int iD;
  String name;
  String key;
  bool isEnable;

  Requisitions({this.iD, this.name, this.key, this.isEnable});

  Requisitions.fromJson(Map<String, dynamic> json) {
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

class Commodities {
  int iD;
  String name;
  String fullName;
  String key;
  bool isEnable;

  Commodities({this.iD, this.name, this.fullName, this.key, this.isEnable});

  Commodities.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    fullName = json['FullName'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['FullName'] = this.fullName;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
