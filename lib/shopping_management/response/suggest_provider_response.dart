import 'package:workflow_manager/base/models/base_response.dart';

class SuggestProviderResponse extends BaseResponse {
  int status;
  List<SuggestProviderModel> data;

  SuggestProviderResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<SuggestProviderModel>();
      json['Data'].forEach((v) {
        data.add(new SuggestProviderModel.fromJson(v));
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

class SuggestProviderModel {
  Suggest suggest;

  SuggestProviderModel({this.suggest});

  SuggestProviderModel.fromJson(Map<String, dynamic> json) {
    suggest =
        json['Suggest'] != null ? new Suggest.fromJson(json['Suggest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suggest != null) {
      data['Suggest'] = this.suggest.toJson();
    }
    return data;
  }
}

class Suggest {
  Provider provider;
  ProviderVote providerVote;

  Suggest({this.provider, this.providerVote});

  Suggest.fromJson(Map<String, dynamic> json) {
    provider = json['Provider'] != null
        ? new Provider.fromJson(json['Provider'])
        : null;
    providerVote = json['ProviderVote'] != null
        ? new ProviderVote.fromJson(json['ProviderVote'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.provider != null) {
      data['Provider'] = this.provider.toJson();
    }
    if (this.providerVote != null) {
      data['ProviderVote'] = this.providerVote.toJson();
    }
    return data;
  }
}

class Provider {
  int iD;
  String name;
  String code;

  Provider({this.iD, this.name, this.code});

  Provider.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Code'] = this.code;
    return data;
  }
}

class ProviderVote {
  int pricePoint;
  int paymentPoint;
  int deliveryPoint;
  int qualityPoint;
  int coordinatePoint;
  int totalPoint;

  ProviderVote(
      {this.pricePoint,
      this.paymentPoint,
      this.deliveryPoint,
      this.qualityPoint,
      this.coordinatePoint,
      this.totalPoint});

  ProviderVote.fromJson(Map<String, dynamic> json) {
    pricePoint = json['PricePoint'];
    paymentPoint = json['PaymentPoint'];
    deliveryPoint = json['DeliveryPoint'];
    qualityPoint = json['QualityPoint'];
    coordinatePoint = json['CoordinatePoint'];
    totalPoint = json['TotalPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PricePoint'] = this.pricePoint;
    data['PaymentPoint'] = this.paymentPoint;
    data['DeliveryPoint'] = this.deliveryPoint;
    data['QualityPoint'] = this.qualityPoint;
    data['CoordinatePoint'] = this.coordinatePoint;
    data['TotalPoint'] = this.totalPoint;
    return data;
  }
}
