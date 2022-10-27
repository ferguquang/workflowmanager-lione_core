import 'package:workflow_manager/base/models/base_response.dart';

class BorrowSearchResponse extends BaseResponse {
  DataBorrowSearch data;

  BorrowSearchResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataBorrowSearch.fromJson(json['Data'])
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

class DataBorrowSearch {
  List<StgDocs> stgDocs;
  bool isLD;
  bool isVT;
  int iDModuleLD;
  int iDModuleVT;
  String positionCode;
  bool isBorrowMutil;
  bool isBorrowFollow;
  // List<int> idModuleFollow;

  DataBorrowSearch({
    this.stgDocs,
    this.isLD,
    this.isVT,
    this.iDModuleLD,
    this.iDModuleVT,
    this.positionCode,
    this.isBorrowMutil,
    this.isBorrowFollow,
    /*this.idModuleFollow*/
  });

  DataBorrowSearch.fromJson(Map<String, dynamic> json) {
    if (json['StgDocs'] != null) {
      stgDocs = new List<StgDocs>();
      json['StgDocs'].forEach((v) {
        stgDocs.add(new StgDocs.fromJson(v));
      });
    }
    isLD = json['isLD'];
    isVT = json['isVT'];
    iDModuleLD = json['IDModuleLD'];
    iDModuleVT = json['IDModuleVT'];
    positionCode = json['PositionCode'];
    isBorrowMutil = json['IsBorrowMutil'];
    isBorrowFollow = json['IsBorrowFollow'];
    // idModuleFollow = json['IdModuleFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stgDocs != null) {
      data['StgDocs'] = this.stgDocs.map((v) => v.toJson()).toList();
    }
    data['isLD'] = this.isLD;
    data['isVT'] = this.isVT;
    data['IDModuleLD'] = this.iDModuleLD;
    data['IDModuleVT'] = this.iDModuleVT;
    data['PositionCode'] = this.positionCode;
    data['IsBorrowMutil'] = this.isBorrowMutil;
    data['IsBorrowFollow'] = this.isBorrowFollow;
    // data['IdModuleFollow'] = this.idModuleFollow;
    return data;
  }
}

class StgDocs {
  int iDDoc;
  String name;
  int date;
  String statusName;
  String statusColor;
  String symbolNo;
  String describe;
  String extension;

  StgDocs(
      {this.iDDoc,
      this.name,
      this.date,
      this.statusName,
      this.statusColor,
      this.symbolNo,
      this.describe,
      this.extension});

  StgDocs.fromJson(Map<String, dynamic> json) {
    iDDoc = json['IDDoc'];
    name = json['Name'];
    date = json['Date'];
    statusName = json['StatusName'];
    statusColor = json['StatusColor'];
    symbolNo = json['SymbolNo'];
    describe = json['Describe'];
    extension = json['Extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDDoc'] = this.iDDoc;
    data['Name'] = this.name;
    data['Date'] = this.date;
    data['StatusName'] = this.statusName;
    data['StatusColor'] = this.statusColor;
    data['SymbolNo'] = this.symbolNo;
    data['Describe'] = this.describe;
    data['Extension'] = this.extension;
    return data;
  }
}
