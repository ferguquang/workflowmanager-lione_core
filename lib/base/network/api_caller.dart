import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/FirestoreHelper.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/manager/auth/auth_repository.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import '../../main.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

typedef ProgressListener = void Function(int total, int progress, int percent);

class ApiCaller {
  static ApiCaller _instance;
  String directory = "";
  static const int timeout_code = 900;
  static const int dio_error_default = 901;
  static const int dio_error_response = 902;
  static const int dio_error_no_reason = 903;
  // FirestoreHelper firestore = FirestoreHelper();

  static ApiCaller get instance {
    if (_instance == null) {
      _instance = ApiCaller();
    }
    return _instance;
  }

  Dio _dio;
  static String _baseUrl;

  static init() async {
    if (_baseUrl == null) {
      _baseUrl = await SharedPreferencesClass.get(
          SharedPreferencesClass.BASE_URL_REMOTE);
    }
  }

  ApiCaller() {
    FileUtils.instance.getSaveDirectory().then((value) => directory = value);
    _dio = Dio();
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      String token = await SharedPreferencesClass.getToken();
      var customHeaders = {
        'content-type': 'application/json',
        'Authorization': token
      };
      String baseUrl = await SharedPreferencesClass.get(
          SharedPreferencesClass.BASE_URL_REMOTE);
      print("XbaseUrl = ${baseUrl}");
      if (isNotNullOrEmpty(baseUrl)) {
        options.baseUrl = baseUrl;
      } else {
        options.baseUrl = AppUrl.baseURL;
      }
      options.responseType = ResponseType.plain;
      options.connectTimeout = 30000;
      options.receiveTimeout = 30000;
      options.sendTimeout = 30000;
      options.headers.addAll(customHeaders);
      return options;
    }));
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    getApplicationDocumentsDirectory().then((appDocDir) {
      String appDocPath = appDocDir.path;

      var cj = PersistCookieJar(
          ignoreExpires: false, dir: (appDocPath + "/.cookies/"));
      var cookieJar = PersistCookieJar();
      _dio.interceptors.add(CookieManager(cookieJar));
    });
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic> params, bool isLoading = true}) async {
    params["Token"] = await SharedPreferencesClass.getToken();
    printParams(params, path);
    if (isLoading) {
      showLoading();
    }
    var responseJson;
    try {
      Response response = await _dio.get(path, queryParameters: params);
      responseJson = _response(response, params);
    } on DioError catch (ex) {
      return _errorException(dioError: ex);
    } on Exception {
      return _errorException();
    } finally {
      if (isLoading) {
        hideLoading();
      }
    }
    return responseJson;
  }

  printParams(Map<String, dynamic> params, String path) {
    if (isNullOrEmpty(params)) {
      print("param for $path:   $params");
      return;
    }
    StringBuffer sb = StringBuffer();
    for (String key in params.keys) {
      sb.write("$key:${params[key]},");
    }
    String result = sb.toString();

    int count = (result.length / 900).ceil();
    int end = 0;
    for (int i = 0; i < count; i++) {
      end = (i + 1) * 900;
      if (end > result.length) {
        end = result.length;
      }
      print("param for $path[$i]:  ${result.substring(i * 900, end)}");
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> params,
      {bool isLoading = true}) async {
    String token = await SharedPreferencesClass.getToken();
    params["Token"] = token;
    printParams(params, path);

    if (isLoading) {
      showLoading();
    }
    var responseJson;
    try {
      Response response = await _dio.post(path, data: params);
      responseJson = _response(response, params);
    } on DioError catch (ex) {
      return _errorException(dioError: ex);
    } on Exception {
      return _errorException();
    } finally {
      if (isLoading) {
        hideLoading();
      }
    }
    return responseJson;
  }

  Future<dynamic> delete(String path, Map<String, dynamic> params,
      {bool isLoading: true}) async {
    showLoading();
    var responseJson;
    params["Token"] = await SharedPreferencesClass.getToken();
    printParams(params, path);
    try {
      Response response = await _dio.delete(path, queryParameters: params);
      responseJson = _response(response, params);
    } on DioError catch (ex) {
      return _errorException(dioError: ex);
    } on Exception {
      return _errorException();
    } finally {
      if (isLoading) hideLoading();
    }
    return responseJson;
  }

  Future<dynamic> postFormData(String path, Map<String, dynamic> params,
      {bool isLoading = true, bool isNeedAddToken = true}) async {
    // if (path.contains("report/wf")) {
    // params["Token"] = "tGYk62qV86UJC15j8uvJe0oljziEgNbm/WvDu4E9hSUB\$a\$n\$G";
    // } else {
    if (isNeedAddToken)
      params["Token"] = await SharedPreferencesClass.getToken();
    // }
    try {
      printParams(params, path);
    } catch (e) {

    }
    if (isLoading) {
      showLoading();
    }
    var responseJson;
    try {
      FormData formData = new FormData.fromMap(params);
      Response response = await _dio.post(path, data: formData);
      responseJson = _response(response, params);
    } on DioError catch (ex) {
      return _errorException(dioError: ex);
    } on Exception {
      return _errorException();
    } finally {
      if (isLoading) {
        hideLoading();
      }
    }
    return responseJson;
  }

  Future<dynamic> uploadFile(String path, Map<String, dynamic> params,
      {ProgressListener sendListener, bool isLoading = true}) async {
    params["Token"] = await SharedPreferencesClass.getToken();
    printParams(params, path);
    loadingDialog.show(isShowImmediate: true);
    var responseJson;
    try {
      var formData = FormData.fromMap(params);
      Response response = await _dio.post(path, data: formData,
          onSendProgress: (int count, int total) {
        print("$count $total");
        if (sendListener != null) {
          sendListener(total, count, 100.0 * count ~/ total);
        }
      });
      responseJson = _response(response, params);
    } on DioError catch (ex) {
      return _errorException(dioError: ex);
    } on Exception {
      return _errorException();
    } finally {
      if (isLoading) {
        hideLoading();
      }
    }
    return responseJson;
  }

  Future<dynamic> downloadFile(String uri, String filePath,
      {ProgressListener receiverListener,
      bool isLoading = true,
      bool isAutoDetectFileName = false}) async {
    if (isLoading) {
      showLoading();
    }
    String savePath = filePath.startsWith("/")
        ? filePath
        : await FileUtils.instance.getFilePath(filePath);
    try {
      Dio dio = Dio();
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        String token = await SharedPreferencesClass.getToken();
        var customHeaders = {
          'content-type': 'application/json',
          'Authorization': token
        };
        options.baseUrl = AppUrl.baseURL;
        options.connectTimeout = 30000;
        options.receiveTimeout = 30000;
        options.sendTimeout = 30000;
        options.headers.addAll(customHeaders);
        return options;
      }));
      Response response = await dio.download(
          uri, isAutoDetectFileName == true ? getFileName : savePath,
          onReceiveProgress: (received, total) {});
      // responseJson = _response(response);
      return response.statusCode == 200;
    } on Exception catch (ex) {} finally {
      if (isLoading) {
        hideLoading();
      }
    }
    return false;
  }

  String getFileName(Headers responseHeaders) {
    List<String> listData = responseHeaders["content-disposition"];
    if (isNullOrEmpty(listData)) return "tai ve.zip";
    String fileName = listData[0];
    fileName = directory + fileName.split("filename=")[1];
    return fileName;
  }

  dynamic _response(Response response, Map<String, dynamic> params) {
    if (response.statusCode != 200) {
      // firestore.sendLogToFirebase(
      //     apiLink: "${response.request.baseUrl}${response.request.path}",
      //     params: params,
      //     httpCode: response.statusCode,
      //     response: response.data.toString());
    }
    switch (response.statusCode) {
      case 200:
        //get body of response
        var responseJson = json.decode(response.data.toString());
        BaseResponse baseResponse = BaseResponse.fromJson(responseJson);
        if (baseResponse.messageCode == 100) {
          // Nếu error_code == 100 => xác thức không hợp lệ
          AuthRepository.logout(isTokenExpired: true);
        }
        // if (baseResponse.messageCode == 100 ||
        //     isNotNullOrEmpty(baseResponse?.messages) &&
        //         baseResponse?.messages ==
        //             "Object reference not set to an instance of an object.") {
        //   firestore.sendLogToFirebase(
        //       apiLink: "${response.request.baseUrl}${response.request.path}",
        //       params: params,
        //       httpCode: response.statusCode,
        //       response: response.data.toString());
        // }
        return responseJson;
      case 400:
        return _getErrorResponse(
            message: "Cú pháp không hợp lệ", code: response.statusCode);
      case 401:
      case 403:
        return _getErrorResponse(
            message: "Có vấn đề khi xác thực trong tài khoản của bạn",
            code: response.statusCode);
      case 404:
        return _getErrorResponse(
            message: "Không thể truy cập đến máy chủ",
            code: response.statusCode);
      case 500:
        return _getErrorResponse(
            message: "Máy chủ gặp lỗi", code: response.statusCode);
      default:
        return _getErrorResponse(
            message: "Kết nối đến máy chủ thất bại", code: response.statusCode);
    }
  }

  Future<Map<String, dynamic>> _errorException(
      {String message: "Kết nối đến máy chủ thất bại.",
      DioError dioError,
      int code: 0}) async {
    String resultCode = "";
    if (dioError != null) {
      switch (dioError.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
          {
            message = "Máy chủ không phản hồi";
            code = timeout_code;
            break;
          }
        case DioErrorType.DEFAULT:
          {
            if (dioError.error is SocketException &&
                isNotNullOrEmpty(dioError?.error?.osError?.errorCode))
              resultCode = " (${dioError?.error?.osError?.errorCode})";
            message = "Không tìm thấy máy chủ$resultCode";
            code = dio_error_default;
            return _getErrorResponse(
                message: message, code: code, isNotAddCode: true);
            break;
          }
        case DioErrorType.RESPONSE:
          {
            return _response(dioError.response, null);
          }
      }
    }
    return _getErrorResponse(message: message, code: code);
  }

  Map<String, dynamic> _getErrorResponse(
      {String message, int code, bool isNotAddCode: false}) {
    String stringCode = " ($code).";
    if (code == timeout_code) {
      stringCode = " (timeout)";
    }
    return jsonDecode("""{
  "Status": ${code ?? 0},
  "Data": null,
  "Messages": "$message${isNotAddCode ? "" : stringCode}"
}""");
  }

  Future<String> getSaveFileFolder() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  showLoading() {
    loadingDialog.show();
  }

  hideLoading() {
    loadingDialog.hide();
  }
}
