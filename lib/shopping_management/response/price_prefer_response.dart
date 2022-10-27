import 'dart:math';

import 'package:math_expressions/math_expressions.dart';
import 'package:workflow_manager/base/models/base_response.dart';

class PricePreferResponse extends BaseResponse {
  int status;
  PricePreferModel data;

  PricePreferResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = PricePreferModel.fromJson(json["Data"]);
    }
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['Status'] = this.status;
//   if (this.data != null) {
//     data['Data'] = this.data.map((v) => v.toJson()).toList();
//   }
//   return data;
// }
}

class PricePreferModel {
  List<PriceRefers> priceRefers;
  bool isHidden;

  PricePreferModel({this.priceRefers, this.isHidden});

  PricePreferModel.fromJson(Map<String, dynamic> json) {
    if (json['PriceRefers'] != null) {
      priceRefers = new List<PriceRefers>();
      json['PriceRefers'].forEach((v) {
        priceRefers.add(new PriceRefers.fromJson(v));
      });
    }
    isHidden = json['IsHidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceRefers != null) {
      data['PriceRefers'] = this.priceRefers.map((v) => v.toJson()).toList();
    }
    data['IsHidden'] = this.isHidden;
    return data;
  }
}

class PriceRefers {
  Commodity commodity;
  PriceRefer priceRefer;

  PriceRefers({this.commodity, this.priceRefer}) {
    if (this.commodity == null) commodity = Commodity();
    if (this.priceRefer == null) priceRefer = PriceRefer();
  }

  PriceRefers.fromJson(Map<String, dynamic> json) {
    commodity = json['Commodity'] != null
        ? new Commodity.fromJson(json['Commodity'])
        : null;
    priceRefer = json['PriceRefer'] != null
        ? new PriceRefer.fromJson(json['PriceRefer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commodity != null) {
      data['Commodity'] = this.commodity.toJson();
    }
    if (this.priceRefer != null) {
      data['PriceRefer'] = this.priceRefer.toJson();
    }
    return data;
  }
}

class Commodity {
  int iD;
  int categoryID;

  Commodity({this.iD, this.categoryID});

  Commodity.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    categoryID = json['CategoryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CategoryID'] = this.categoryID;
    return data;
  }
}

class PriceRefer {
  Provider provider = Provider();
  CostLog costLog = CostLog();

  PriceRefer({this.provider, this.costLog}) {
    if (provider == null) provider = Provider();
    if (costLog == null) costLog = CostLog();
  }

  PriceRefer.fromJson(Map<String, dynamic> json) {
    provider = json['Provider'] != null
        ? new Provider.fromJson(json['Provider'])
        : null;
    costLog =
    json['CostLog'] != null ? new CostLog.fromJson(json['CostLog']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.provider != null) {
      data['Provider'] = this.provider.toJson();
    }
    if (this.costLog != null) {
      data['CostLog'] = this.costLog.toJson();
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

class CostLog {
  double price;
  String paymentTerm;
  String deliveryTime;
  String quality;
  String warranty;
  int point;

  CostLog({this.price,
    this.paymentTerm,
    this.deliveryTime,
    this.quality,
    this.warranty,
    this.point});

  CostLog.fromJson(Map<String, dynamic> json) {
    price = json['Price'];
    paymentTerm = json['PaymentTerm'];
    deliveryTime = json['DeliveryTime'];
    quality = json['Quality'];
    warranty = json['Warranty'];
    point = json['Point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Price'] = this.price;
    data['PaymentTerm'] = this.paymentTerm;
    data['DeliveryTime'] = this.deliveryTime;
    data['Quality'] = this.quality;
    data['Warranty'] = this.warranty;
    data['Point'] = this.point;
    return data;
  }
}
