import 'dart:convert';
import 'dart:core';

import 'category.dart';
import 'package:workflow_manager/base/models/base_response.dart';

class DataListDynamicllyResponse extends BaseResponse {
  int status;
  DataListDynamiclly data;

  DataListDynamicllyResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DataListDynamiclly.fromJson(json['Data'])
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

class DataListDynamiclly {
  List<Category> categories;

  DataListDynamiclly.fromJson(Map<String, dynamic> json) {
    if (json['Categories'] != null) {
      categories = [];
      json['Categories'].forEach((v) {
        categories.add( Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();

    return json;
  }
}

