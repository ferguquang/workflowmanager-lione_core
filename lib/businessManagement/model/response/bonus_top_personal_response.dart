import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';
import 'statistic_seller_response.dart';

class BonusTopPersonalResponse extends BaseResponse {
  DataTopPersonal data;

  BonusTopPersonalResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataTopPersonal.fromJson(json['Data'])
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

class DataTopPersonal {
  List<SellerInfos> bonusCNBarChartInfos;
  SearchParam searchParam;

  DataTopPersonal({this.bonusCNBarChartInfos, this.searchParam});

  DataTopPersonal.fromJson(Map<String, dynamic> json) {
    if (json['BonusTopSeller'] != null) {
      bonusCNBarChartInfos = new List<SellerInfos>();
      json['BonusTopSeller'].forEach((v) {
        bonusCNBarChartInfos.add(new SellerInfos.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bonusCNBarChartInfos != null) {
      data['BonusTopSeller'] =
          this.bonusCNBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}
