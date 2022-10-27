import 'package:workflow_manager/base/utils/common_function.dart';

class LogicColumnUpdate {
  String origin;
  List<String> targets = null;
  String refValue;
  List<String> params = null;
  String scope;
  String link;

  LogicColumnUpdate.fromJson(Map<String, dynamic> json) {
    origin = json['Origin'];
    if (isNotNullOrEmpty(json['Targets']))
      targets =
          (json['Targets'] as List<dynamic>).map((e) => e.toString()).toList();
    if (isNotNullOrEmpty(json['Params']))
      params =
          (json['Params'] as List<dynamic>).map((e) => e.toString()).toList();
    refValue = json['RefValue'];
    scope = json['Scope'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Origin'] = origin;
    json['Targets'] = targets;
    json['RefValue'] = refValue;
    json['Params'] = params;
    json['Scope'] = scope;
    json['Link'] = link;
    return json;
  }
}
