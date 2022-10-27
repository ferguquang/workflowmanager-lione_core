import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/network/app_url.dart';

class SendInfoDeviceRequest {

  String iDPlayer;
  String token;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (iDPlayer.isNotNullOrEmpty) {
      params["IDPlayer"] = iDPlayer;
    }
    if (token.isNotNullOrEmpty) {
      params["Token"] = token;
    }
    params["AppType"] = "2"; // 1 : App Doceye, 2 : App L-iONE
    return params;
  }
}
