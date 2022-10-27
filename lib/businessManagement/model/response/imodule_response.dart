import 'package:workflow_manager/base/models/base_response.dart';

class IModuleResponse extends BaseResponse {
  DataIModule data;

  IModuleResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataIModule.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataIModule {
  bool isThongKe;
  bool isQuanly;
  bool isKhach;

  DataIModule({this.isThongKe, this.isQuanly, this.isKhach});

  DataIModule.fromJson(Map<String, dynamic> json) {
    isThongKe = json['IsThongKe'];
    isQuanly = json['IsQuanly'];
    isKhach = json['IsKhach'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsThongKe'] = this.isThongKe;
    data['IsQuanly'] = this.isQuanly;
    data['IsKhach'] = this.isKhach;
    return data;
  }
}
