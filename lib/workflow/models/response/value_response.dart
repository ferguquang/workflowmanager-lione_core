import 'dart:collection';

import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/models/base_response.dart';

class ValueResponse<T> extends BaseResponse {
  T data;

  ValueResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] is T) data = json['Data'] as T;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Data'] = this.data;
    data['Messages'] = this.messages;
    return data;
  }
}
