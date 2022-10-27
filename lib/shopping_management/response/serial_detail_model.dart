import 'package:workflow_manager/base/models/base_response.dart';

class SerialDetailReponse extends BaseResponse {
  int status;
  SerialDetailModel data;

  SerialDetailReponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new SerialDetailModel.fromJson(json['Data'])
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

class SerialDetailModel {
  Serial serial;
  int totalRecord;
  List<SerialDetails> serialDetails;

  SerialDetailModel({this.serial, this.totalRecord, this.serialDetails});

  SerialDetailModel.fromJson(Map<String, dynamic> json) {
    serial =
        json['Serial'] != null ? new Serial.fromJson(json['Serial']) : null;
    totalRecord = json['TotalRecord'];
    if (json['SerialDetails'] != null) {
      serialDetails = new List<SerialDetails>();
      json['SerialDetails'].forEach((v) {
        serialDetails.add(new SerialDetails.fromJson(v));
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
    return data;
  }
}

class Serial {
  int iD;
  List<Requisition> requisition;
  List<Contract> contract;
  String invoiceNumber;
  String invFilePath;
  String packingNumber;
  String packingFilePath;
  String cOName;
  String cOFilePath;
  String cQName;
  String cQFilePath;
  String otherFile;
  String otherFilePath;
  String bolNumber;
  String bolFilePath;
  String tkNumber;
  String tkFilePath;

  Serial(
      {this.iD,
      this.requisition,
      this.contract,
      this.invoiceNumber,
      this.invFilePath,
      this.packingNumber,
      this.packingFilePath,
      this.cOName,
      this.cOFilePath,
      this.cQName,
      this.cQFilePath,
      this.otherFile,
      this.otherFilePath,
      this.bolNumber,
      this.bolFilePath,
      this.tkNumber,
      this.tkFilePath});

  Serial.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    if (json['Requisition'] != null) {
      requisition = new List<Requisition>();
      json['Requisition'].forEach((v) {
        requisition.add(new Requisition.fromJson(v));
      });
    }
    if (json['Contract'] != null) {
      contract = new List<Contract>();
      json['Contract'].forEach((v) {
        contract.add(new Contract.fromJson(v));
      });
    }
    invoiceNumber = json['InvoiceNumber'];
    invFilePath = json['InvFilePath'];
    packingNumber = json['PackingNumber'];
    packingFilePath = json['PackingFilePath'];
    cOName = json['COName'];
    cOFilePath = json['COFilePath'];
    cQName = json['CQName'];
    cQFilePath = json['CQFilePath'];
    otherFile = json['OtherFile'];
    otherFilePath = json['OtherFilePath'];
    bolNumber = json['BolNumber'];
    bolFilePath = json['BolFilePath'];
    tkNumber = json['TkNumber'];
    tkFilePath = json['TkFilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    if (this.requisition != null) {
      data['Requisition'] = this.requisition.map((v) => v.toJson()).toList();
    }
    if (this.contract != null) {
      data['Contract'] = this.contract.map((v) => v.toJson()).toList();
    }
    data['InvoiceNumber'] = this.invoiceNumber;
    data['InvFilePath'] = this.invFilePath;
    data['PackingNumber'] = this.packingNumber;
    data['PackingFilePath'] = this.packingFilePath;
    data['COName'] = this.cOName;
    data['COFilePath'] = this.cOFilePath;
    data['CQName'] = this.cQName;
    data['CQFilePath'] = this.cQFilePath;
    data['OtherFile'] = this.otherFile;
    data['OtherFilePath'] = this.otherFilePath;
    data['BolNumber'] = this.bolNumber;
    data['BolFilePath'] = this.bolFilePath;
    data['TkNumber'] = this.tkNumber;
    data['TkFilePath'] = this.tkFilePath;
    return data;
  }
}

class Requisition {
  int iD;
  String name;
  String key;

  Requisition({this.iD, this.name, this.key});

  Requisition.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    return data;
  }
}

class SerialDetails {
  int iD;
  int iDSerial;
  Requisition commodity;
  String nameCommodity;
  String serialNo;

  SerialDetails(
      {this.iD,
      this.iDSerial,
      this.commodity,
      this.nameCommodity,
      this.serialNo});

  SerialDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDSerial = json['IDSerial'];
    commodity = json['Commodity'] != null
        ? new Requisition.fromJson(json['Commodity'])
        : null;
    nameCommodity = json['NameCommodity'];
    serialNo = json['SerialNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDSerial'] = this.iDSerial;
    if (this.commodity != null) {
      data['Commodity'] = this.commodity.toJson();
    }
    data['NameCommodity'] = this.nameCommodity;
    data['SerialNo'] = this.serialNo;
    return data;
  }
}

class Contract {
  int iD;
  String name;
  String key;

  Contract({this.iD, this.name, this.key});

  Contract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    return data;
  }
}
