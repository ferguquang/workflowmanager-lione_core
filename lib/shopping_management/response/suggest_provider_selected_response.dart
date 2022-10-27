import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart';

class SuggestProviderSelectedResponse extends BaseResponse {
  int status;
  List<SuggestProviderSelectedModel> data;

  SuggestProviderSelectedResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<SuggestProviderSelectedModel>();
      json['Data'].forEach((v) {
        data.add(new SuggestProviderSelectedModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuggestProviderSelectedModel {
  PriceRefer suggestSelected;

  SuggestProviderSelectedModel({this.suggestSelected});

  SuggestProviderSelectedModel.fromJson(Map<String, dynamic> json) {
    suggestSelected = json['SuggestSelected'] != null
        ? new PriceRefer.fromJson(json['SuggestSelected'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suggestSelected != null) {
      data['SuggestSelected'] = this.suggestSelected.toJson();
    }
    return data;
  }
}
