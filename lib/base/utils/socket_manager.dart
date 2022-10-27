import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class SocketManager {
  static SocketManager _instance;
  static SocketManager get  instance {
    if (_instance == null) {
      _instance = SocketManager();
    }
    return _instance;
  }

  Future<void> connect() async {
    String deviceID = await SharedPreferencesClass.get(
        SharedPreferencesClass.ONESIGNAL_ID_KEY);
    print("deviceID : ${deviceID}");
    Map<String, String> query = Map();
    String token = await SharedPreferencesClass.getToken();
    query['Token'] = token;
    query['DeviceID'] = deviceID;
    // socket = IO.io(
    //     AppUrl.hostSocket,
    //     IO.OptionBuilder()
    //         .setTransports(['websocket'])
    //         .setQuery(query)
    //         .enableForceNew()
    //         .enableReconnection()
    //         .build());
    socket.onConnect((_) {
      print('socket onConnect');
    });
    socket.on('fromServer', (_) {
      print(_);
    });
    socket.onConnecting((data) {
      print('socket onConnecting');
    });
    socket.onDisconnect((_) {
      print('socket onDisconnect');
    });
    socket.onError((data) {
      print('socket onError');
    });
    if (socket.disconnected && isNotNullOrEmpty(token)) {
      socket.connect();
    }
  }

  logoutSocket() async {
    OneSignal.shared.setSubscription(false);

    User user = await SharedPreferencesClass.getUser();
    String deviceID = await SharedPreferencesClass.get(SharedPreferencesClass.ONESIGNAL_ID_KEY);
    EmitLogout emitLogout = EmitLogout(user?.iDUserDocPro ?? 0, deviceID ?? "");
    socket?.emit('onLogout', emitLogout.toJson());
    socket?.disconnect();
    socket?.close();

    SharedPreferencesClass.removeUser();
    // SharedPreferencesClass.clearData();
  }
}

class EmitLogout {
  int idUserDocpro;
  String deviceID;

  EmitLogout(this.idUserDocpro, this.deviceID);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDUser'] = this.idUserDocpro;
    data['deviceID'] = this.deviceID;
    return data;
  }
}
