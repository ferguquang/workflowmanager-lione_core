import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class HistoryOpportunityResponse extends BaseResponse {
  DataHistoryOpportunity data;

  HistoryOpportunityResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataHistoryOpportunity.fromJson(json['Data'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataHistoryOpportunity {
  List<Histories> histories;

  DataHistoryOpportunity({this.histories});

  DataHistoryOpportunity.fromJson(Map<String, dynamic> json) {
    if (json['Histories'] != null) {
      histories = new List<Histories>();
      json['Histories'].forEach((v) {
        histories.add(new Histories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.histories != null) {
      data['Histories'] = this.histories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Histories {
  int iD;
  String phaseName;
  int created;
  Seller seller;
  String body;

  Histories({this.iD, this.phaseName, this.created, this.seller, this.body});

  Histories.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    phaseName = json['PhaseName'];
    created = json['Created'];
    seller =
        json['Seller'] != null ? new Seller.fromJson(json['Seller']) : null;
    body = json['Body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['PhaseName'] = this.phaseName;
    data['Created'] = this.created;
    if (this.seller != null) {
      data['Seller'] = this.seller.toJson();
    }
    data['Body'] = this.body;
    return data;
  }
}
