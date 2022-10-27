import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class StatisticSellerResponse extends BaseResponse {
  DataStatisticSeller data;

  StatisticSellerResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataStatisticSeller.fromJson(json['Data'])
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

class DataStatisticSeller {
  List<SellerInfos> sellerInfos;
  SearchParam searchParam;

  DataStatisticSeller({this.sellerInfos, this.searchParam});

  DataStatisticSeller.fromJson(Map<String, dynamic> json) {
    if (json['SellerInfos'] != null) {
      sellerInfos = new List<SellerInfos>();
      json['SellerInfos'].forEach((v) {
        sellerInfos.add(new SellerInfos.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellerInfos != null) {
      data['SellerInfos'] = this.sellerInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class SellerInfos {
  String sellerAvatar;
  String sellerName;
  String deptName;
  String position;
  double percent;
  String color;
  String value;

  SellerInfos(
      {this.sellerAvatar,
      this.sellerName,
      this.deptName,
      this.position,
      this.percent,
      this.color,
      this.value});

  SellerInfos.fromJson(Map<String, dynamic> json) {
    sellerAvatar = json['SellerAvatar'];
    sellerName = json['SellerName'];
    deptName = json['DeptName'];
    position = json['Position'];
    percent = json['Percent'];
    color = json['Color'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SellerAvatar'] = this.sellerAvatar;
    data['SellerName'] = this.sellerName;
    data['DeptName'] = this.deptName;
    data['Position'] = this.position;
    data['Percent'] = this.percent;
    data['Color'] = this.color;
    data['Value'] = this.value;
    return data;
  }
}
