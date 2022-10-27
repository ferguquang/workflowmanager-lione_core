import 'package:workflow_manager/base/models/base_response.dart';

class ExchangeRateResponse extends BaseResponse {
  int status;
  Data data;

  ExchangeRateResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<ExchangeRateModel> tyGia;

  Data({this.tyGia});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['TyGia'] != null) {
      tyGia = new List<ExchangeRateModel>();
      json['TyGia'].forEach((v) {
        tyGia.add(new ExchangeRateModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tyGia != null) {
      data['TyGia'] = this.tyGia.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExchangeRateModel {
  String currencyCode;
  String currencyName;
  String buy;
  String transfer;
  String sell;

  ExchangeRateModel(
      {this.currencyCode,
      this.currencyName,
      this.buy,
      this.transfer,
      this.sell});

  ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    currencyCode = json['CurrencyCode'];
    currencyName = json['CurrencyName'];
    buy = json['Buy'];
    transfer = json['Transfer'];
    sell = json['Sell'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CurrencyCode'] = this.currencyCode;
    data['CurrencyName'] = this.currencyName;
    data['Buy'] = this.buy;
    data['Transfer'] = this.transfer;
    data['Sell'] = this.sell;
    return data;
  }
}
