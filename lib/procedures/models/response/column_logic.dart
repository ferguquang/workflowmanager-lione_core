import 'package:workflow_manager/base/utils/common_function.dart';

class ColumnLogic {
  String origin;
  List<String> targets = null;
  String refValue;

  ColumnLogic.fromJson(Map<String, dynamic> json) {
    origin = json['Origin'];
    if (isNotNullOrEmpty(json['Targets']))
      targets =
          (json['Targets'] as List<dynamic>).map((e) => e.toString()).toList();
    refValue = json['RefValue'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Origin'] = origin;
    json['Targets'] = targets;
    json['RefValue'] = refValue;
    return json;
  }
}
