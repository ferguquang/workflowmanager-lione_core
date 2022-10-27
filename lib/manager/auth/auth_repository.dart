import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/base/utils/socket_manager.dart';
import 'package:workflow_manager/manager/models/params/change_pass_request.dart';
import 'package:workflow_manager/manager/models/params/get_info_notify_request.dart';
import 'package:workflow_manager/manager/models/params/login_request.dart';
import 'package:workflow_manager/manager/models/params/update_profile_request.dart';
import 'package:workflow_manager/manager/models/response/get_data_app.dart';
import 'package:workflow_manager/manager/models/response/update_profile_response.dart';
import 'package:workflow_manager/workflow/models/notification_model.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';

import '../../base/network/api_caller.dart';
import '../../main.dart';

enum CurrentStatus {
  Uninitialized,
  Unauthenticated,
  Authenticating,
  Authenticated
}

class AuthRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  CurrentStatus loggedInStatus = CurrentStatus.Uninitialized;

  List<DocTypes> docTypes;

  String message;

  static final _localAuth = LocalAuthentication();

  Future<void> validateToken() async {
    String token = await SharedPreferencesClass.getToken();
    if (token.isNotNullOrEmpty) {
      loggedInStatus = CurrentStatus.Authenticated;
      notifyListeners();
    } else {
      loggedInStatus = CurrentStatus.Unauthenticated;
      notifyListeners();
    }
  }

  Future<void> autoNextToLoginScreen() async {
    var duration = new Duration(seconds: 0);
    Future.delayed(duration, () {
      loggedInStatus = CurrentStatus.Unauthenticated;
      AppStore.isLogoutState = false;
      notifyListeners();
    });
  }

  // Đăng nhập
  Future<Map<String, dynamic>> login(
      BuildContext context, String userName, String password) async {
    AuthRepository.unregitryOldPlayerID();
    SharedPreferencesClass.removeRemoteUrl();
    var result;
    LoginRequest loginRequest = LoginRequest();
    loginRequest.userName = userName;
    loginRequest.password = password;
    loginRequest.isCloudApi =
        await SharedPreferencesClass.get(SharedPreferencesClass.IS_CLOUD_API) ??
            false;
    loggedInStatus = CurrentStatus.Authenticating;
    notifyListeners();
    final response =
        await apiCaller.postFormData(AppUrl.login, loginRequest.getParams());
    final LoginResponse authResponse = LoginResponse.fromJson(response);
    if (authResponse.isSuccess()) {
      // userName và passWord dùng ch≈≈o module 'kho dữ liệu' không đươc xóa
      await SharedPreferencesClass.saveValue(
          SharedPreferencesClass.USER_NAME, userName);
      await SharedPreferencesClass.saveValue(
          SharedPreferencesClass.PASS_WORD, password);

      await SharedPreferencesClass.saveToken(authResponse.data.token);
      await SharedPreferencesClass.saveUser(authResponse.data.user);
      await SharedPreferencesClass.save(
          SharedPreferencesClass.ROOT_KEY, authResponse.data.configDocPro.root);
      _saveLoginData(userName, password);
      loggedInStatus = CurrentStatus.Authenticated;
      AppStore.isLogoutState = false;
      if (isNotNullOrEmpty(authResponse.data.linkApi)) {
        String remoteBaseUrl = "${authResponse.data.linkApi}/api/";
        SharedPreferencesClass.save(
            SharedPreferencesClass.BASE_URL_REMOTE, remoteBaseUrl);
      }
      checkApplink(context);
      notifyListeners();
    } else {
      loggedInStatus = CurrentStatus.Unauthenticated;
      notifyListeners();
    }
    return result;
  }

  // Thay đổi mật khẩu
  Future<bool> changePassword(ChangePasswordRequest request) async {
    if (isNullOrEmpty(request.currentPass)) {
      message = "Vui lòng nhập mật khẩu hiện tại";
      return false;
    }
    if (isNullOrEmpty(request.newPass)) {
      message = "Vui lòng nhập mật khẩu mới";
      return false;
    }
    if (isNullOrEmpty(request.newPassConfirm)) {
      message = "Vui lòng nhập mật khẩu xác nhận";
      return false;
    }
    if (request.newPass != request.newPassConfirm) {
      message = "Mật khẩu và xác nhận mật khẩu không so khớp";
      return false;
    }
    final response = await apiCaller.postFormData(
        AppUrl.changePassword, request.getParams());
    final BaseResponse changePassResponse = BaseResponse.fromJson(response);
    if (changePassResponse.status == 1) {
      message = "Thay đổi mật khẩu thành công";
      return true;
    } else {
      message = changePassResponse.messages;
      return false;
    }
  }

  // update profile
  Future<bool> updateProfile(UpdateProfileRequest request) async {
    if (isNullOrEmpty(request.userName)) {
      message = "Tên không được để trống!";
      return false;
    }
    if (isNullOrEmpty(request.email)) {
      message = "Thư điện tử không được bỏ trống!";
      return false;
    }
    if (isNullOrEmpty(request.address)) {
      message = "Địa chỉ không được để trống!";
      return false;
    }
    if (isNullOrEmpty(request.email)) {
      message = "Hòm thư điện tử không được để trống!";
      return false;
    }
    if (!request.email.isEmail()) {
      message = "Hòm thư điện tử không đúng định dạng!";
      return false;
    }
    if (isNullOrEmpty(request.numberPhone)) {
      message = "Số điện thoại không được để trống!";
      return false;
    }
    if (isNullOrEmpty(request.numberPhone)) {
      message = "Số điện thoại không được để trống!";
      return false;
    }
    if (!request.numberPhone.isPhone()) {
      message = "Số điện thoại không hợp lệ!";
      return false;
    }
    final response =
        await apiCaller.postFormData(AppUrl.updateProfile, request.getParams());
    final BaseResponse changePassResponse = BaseResponse.fromJson(response);
    if (changePassResponse.status == 1) {
      message = "Thay đổi thông tin cá nhân thành công";
      return true;
    } else {
      message = changePassResponse.messages;
      return false;
    }
  }

  // check lắng nghe từ applink
  Future<void> checkApplink(BuildContext context,
      {bool isNavigation = false}) async {
    var token = await SharedPreferencesClass.getToken();
    if (isNullOrEmpty(token)) return;
    var result = await platform.invokeMethod(Constant.APP_LINK_KEY);
    if (isNullOrEmpty(result)) return;
    if (isNullOrEmpty(result["iDNotify"])) {
      return;
    }
    try {
      var idNotify = int.parse(result["iDNotify"]);
      if (idNotify == 0) return;
      AppStore.idNotify = idNotify;
      if (isNavigation) {
        listenerNavigationAppLink(context);
      }
    } on Exception catch (e) {
      print("${e.toString()}");
    }
  }

  Future<void> listenerNavigationAppLink(BuildContext context) async {
    int idNotify = AppStore.idNotify;
    print("XidNotify 2 = ${idNotify}");
    GetInfoNotifyRequest request = GetInfoNotifyRequest();
    request.idNotify = idNotify;
    NotificationResponse notificationResponse =
        await getInfoNotification(request);
    if (notificationResponse.isSuccess(isDontShowErrorMessage: true) &&
        notificationResponse.data.notificationInfos.length > 0) {
      OneSignalManager.instance.navigationTargetScreen(
          context, notificationResponse.data.notificationInfos[0]);
    }
    AppStore.idNotify = 0;
  }

  // Lấy thông tin một item của notification
  Future<NotificationResponse> getInfoNotification(
      GetInfoNotifyRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getInfoNotifyById, request.getParams());
    return NotificationResponse.fromJson(response);
  }

  Future<void> loginFromDoceye(String tokenDoceye) async {
    await SharedPreferencesClass.saveToken(tokenDoceye);
    loggedInStatus = CurrentStatus.Authenticated;
    notifyListeners();
  }

  static Future<void> saveOldPlayerID() async {
    String playerId = await SharedPreferencesClass.getValue(
        SharedPreferencesClass.ONESIGNAL_ID_KEY);
    String token = await SharedPreferencesClass.getToken();
    String baseUrl = await SharedPreferencesClass.get(
        SharedPreferencesClass.BASE_URL_REMOTE);
    if (playerId != null && token != null)
      await SharedPreferencesClass.save(
          SharedPreferencesClass.SAVE_PLAYER_ID_TO_UNREGISTER,
          "$baseUrl\n$playerId\n$token");
  }

  static Future<void> unregitryOldPlayerID() async {
    String value = await SharedPreferencesClass.getValue(
        SharedPreferencesClass.SAVE_PLAYER_ID_TO_UNREGISTER);
    if (isNotNullOrEmpty(value)) {
      List<String> list = value.split("\n");
      var result = await OneSignalManager.instance
          .removeInfoDevice(list[1], oldToken: list[2],baseUrl: list[0]);
      if (result == true)
        await SharedPreferencesClass.save(
            SharedPreferencesClass.SAVE_PLAYER_ID_TO_UNREGISTER, null);
    }
  }

  // Đăng xuất
  static Future<void> logout({bool isTokenExpired: false}) async {
    if (!isTokenExpired) {
      var result = await _removeInfoDevice();
      if (result != true) {
        await saveOldPlayerID();
      }
    }
    SocketManager().logoutSocket();
    await FlutterLocalNotificationsPlugin().cancelAll();
    FlutterAppBadger.removeBadge();
    await SharedPreferencesClass.save(
        SharedPreferencesClass.UNREADNOTIFICATION, 0);
    AppStore.isLogoutState = true;
    platform.invokeMethod(Constant.LOGOUT_EVENT_KEY);
    // ngắt kết nối socket
    SharedPreferencesClass.saveValue(
        SharedPreferencesClass.PASSWORD_SIGNAL, "");
    loadingDialog.clear();
    Navigator.pushNamedAndRemoveUntil(
        mainGlobalKey.currentContext, '/', (_) => false,
        arguments: CurrentStatus.Unauthenticated);
  }

  static Future<bool> _removeInfoDevice() async {
    String playerId = await SharedPreferencesClass.getValue(
        SharedPreferencesClass.ONESIGNAL_ID_KEY);
    if (playerId == null) return true;
    return await OneSignalManager.instance.removeInfoDevice(playerId);
  }

  // gửi event để lưu trong Provider và Keychain
  _saveLoginData(String userName, String password) async {
    User user = await SharedPreferencesClass.getUser();
    var params = Map<String, dynamic>();
    params["userId"] = user.iDUserDocPro;
    params["name"] = userName;
    params["password"] = password;
    String message;
    try {
      message = await platform.invokeMethod(Constant.SAVE_USER_KEY, params);
    } on Exception catch (e) {
      message = "Failed to get data from native : '${e}'.";
    }
    print("send user info success" + message);
  }

  // get config app
  Future<void> getConfigApp() async {
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getConfigApp, Map<String, dynamic>());

    DataAppResponse dataAppResponse = DataAppResponse.fromJson(response);
    if (dataAppResponse.isSuccess()) {
      String copyRight = dataAppResponse.data;
      AppStore.copyRight = copyRight;
      notifyListeners();
    } else {
      message = dataAppResponse.messages;
      notifyListeners();
    }
  }

  Future<ProfileDetailModel> getProfile() async {
    var response = await ApiCaller.instance
        .postFormData(AppUrl.profileDetail, Map<String, dynamic>());
    ProfileDetailResponse profileDetailsResponse =
        ProfileDetailResponse.fromJson(response);
    if (profileDetailsResponse.isSuccess()) {
      return profileDetailsResponse.data;
    }
    return null;
  }

  // login by face id, touch id
  Future<bool> hasBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) {
      ToastMessage.show(
          "Chưa bật xác thực. Sau khi đăng nhập, bạn vui lòng vào phần cài đặt để bật xác thực bằng vân tay hoặc FaceId",
          ToastStyle.error);
      return false;
    }
    try {
      return await _localAuth.authenticateWithBiometrics(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print("PlatformException message => ${e.message}");
      return false;
    }
  }
}
