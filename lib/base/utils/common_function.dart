import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:local_auth/local_auth.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/workflow/models/directory_path.dart';

import '../../main.dart';

Color getColor(String hex, {int alpha}) {
  return hex.toColor();
}

String convertDoubleToInt(String text) {
  if (isNullOrEmpty(text)) return text;
  if (text.contains(".")) return text.substring(0, text.indexOf("."));
  return text;
}

bool isNullOrEmpty(dynamic object) {
  if (object == null) return true;
  if (object == "null") return true;
  if (object is String) {
    return object.isEmpty;
  }
  if (object is List) {
    return object.length == 0;
  }
  if (object is Map) {
    return object.length == 0;
  }
  if (object is Set) {
    return object.length == 0;
  }
  return false;
}

bool isNotNullOrEmpty(dynamic object) {
  return !isNullOrEmpty(object);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }

  return double.parse(s, (e) => null) != null ||
      int.parse(s, onError: (e) => null) != null;
}

String getFullDateTime(String date) {
  return date.toFullDateTimeFormat();
}

String getDateTime(String date) {
  return date.toDateTimeFormat();
}

String getTime(String date) {
  return date.toTimeFormat();
}

String getDate(String date) {
  return date.toDateFormat();
}

int getCurrentYear() {
  var now = new DateTime.now();
  return now.year;
}

String getCurrentMonth() {
  var now = new DateTime.now();
  if (now.month < 10) {
    return "0${now.month}";
  }
  return "${now.month}";
}

DateTime getDateTimeObject(String date, {String format}) {
  if (isNullOrEmpty(date)) {
    return DateTime(0);
  }
  if (format.isNullOrEmpty) {
    String format = Constant.ddMMyyyyHHmm;
    int count = date.length - date.replaceAll(":", "").length;
    if (date.contains("T")) {
      return DateTime.parse(date);
    } else if (count == 0)
      format = Constant.ddMMyyyy;
    else if (count == 2) {
      format = Constant.ddMMyyyyHHmmss;
    }
    return DateFormat(format).parse(date);
  }
  return DateFormat(format).parse(date);
}

String convertTimeStampToHumanDate(int timeStamp, String format) {
  if (timeStamp == null || timeStamp == 0) return "";
  var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return DateFormat(format).format(dateToTimeStamp);
}

int compareDate(String date1, String date2) {
  return getDateTimeObject(date1).compareTo(getDateTimeObject(date2));
}

String getCurrentDate(String format) {
  return DateFormat(format).format(DateTime.now());
}

int getLastOfMonth() {
  DateTime now = new DateTime.now();
  DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
  return lastDayOfMonth.day;
}

int getLastOfMonthWithMonth(int month) {
  DateTime now = new DateTime.now();
  DateTime lastDayOfMonth = new DateTime(now.year, month + 1, 0);
  return lastDayOfMonth.day;
}

Future<T> pushPage<T>(BuildContext context, Widget page) {
  if (isNullOrEmpty(screenStacks)) {
    screenStacks = [];
  }
  screenStacks.add(page.toStringShort());
  return Navigator.of(context).push<T>(MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(arguments: page.toStringShort())));
}

Future<T> pushPageNamed<T>(BuildContext context, String name, dynamic params) {
  return Navigator.of(context).pushNamed<T>(name, arguments: params);
}

void removeScreenName(Widget screen) {
  if (isNullOrEmpty(screenStacks)) return;
  screenStacks.remove(screen.toString());
}

bool hasScreen(String pageName) {
  if (isNullOrEmpty(pageName) || isNullOrEmpty(screenStacks)) {
    return false;
  }
  return screenStacks.last == pageName;
}

Future<DirectoryPath> getDirectory() async {
  final String method = "getDirectory";
  String response = "";
  try {
    final String result = await platform.invokeMethod(method);
    DirectoryPath path = DirectoryPath();
    path.RootSdcard = result;
    return path;
  } on PlatformException catch (e) {
    response = "Failed to Invoke: '${e.message}'.";
  }
  return null;
}

String getCurrencyFormat(String text, {bool isAllowDot = false}) {
  if (isNullOrEmpty(text)) return "";
  text = text.replaceAll(Constant.SEPARATOR_THOUSAND, "");
  if (num.tryParse(text) == null) return "";
  // var format = new NumberFormat(
  //     "#${Constant.SEPARATOR_THOUSAND}##0${numberAfterdot == 0 ? "" : ".".padRight(numberAfterdot + 1, "0")}",
  //     "en_US");
  // return format.format(num.tryParse(text));
  if (!isAllowDot) {
    if (text.contains(".")) text = text.split("\.")[0];
    return NumberFormat.decimalPattern("en").format(int.parse(text));
  } else {
    List<String> split = text.split("\.");
    String first = split[0];
    int count = 0;
    String result = '';
    for (int i = first.length - 1; i > -1; i--) {
      count++;
      result = first[i] + result;
      if (count % 3 == 0) {
        result = Constant.SEPARATOR_THOUSAND + result;
      }
    }
    first = result;
    if (first.startsWith(Constant.SEPARATOR_THOUSAND)) {
      first = first.substring(1);
    }
    String second = "";
    if (split.length > 1) {
      second = ".${split[1]}";
    }
    return first + second;
  }
}

String calcString(String text) {
  try {
    text = text.replaceAll(",", "");
    if (isNullOrEmpty(text)) return "";
    Parser p = new Parser();
    Expression exp = p.parse(text);
    String result = exp.evaluate(EvaluationType.REAL, null).toString();
    return result;
  } catch (ex) {
    return "";
  }
}

double getDouble(dynamic value, {double orElse: 0}) {
  if (isNullOrEmpty(value)) return orElse;
  String text = value.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
  return double.parse(text);
}

int getInt(dynamic value, {int orElse: 0}) {
  if (isNullOrEmpty(value)) return orElse;
  String text = value.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
  return int.parse(text);
}

TextEditingController getDataPercentController(
    TextEditingController textController) {
  textController.text = textController.text.replaceAll('..', '.');
  // '.'
  if (textController.text[0].toString() == '.')
    textController.text = textController.text.replaceAll('.', '');
  //'01 || 02 | 03 | 04 | 05 ...'
  if (textController.text.length == 2 &&
      textController.text[0].toString() == '0' &&
      textController.text[1].toString() != '.')
    textController.text = textController.text.substring(1);
  // '100.'
  if (textController.text.length == 4 &&
      textController.text[3].toString() == '.')
    textController.text = textController.text.substring(0, 3);

  if (double.parse(textController.text) > 100) textController.text = '100';

  textController.text = textController.text.replaceAll(',', '.');
  // dòng này để cusor hiển thị của cuối cùng
  textController.selection =
      TextSelection.collapsed(offset: textController.text.length);
  return textController;
}

replaceDateToMobileFormat(String date) {
  if (isNullOrEmpty(date)) return "";
  return date.replaceAll("-", "/");
}

Future<bool> hasFaceId() async {
  final _localAuth = LocalAuthentication();
  try {
    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.face);
  } on PlatformException catch (e) {
    print(e.message);
    return false;
  }
}

Future<bool> isHasLessOneBiometric() async {
  final _localAuth = LocalAuthentication();
  try {
    return await _localAuth.canCheckBiometrics;
  } on PlatformException catch (e) {
    print(e.message);
  }
  return false;
}

Future<bool> hasTouchId() async {
  final _localAuth = LocalAuthentication();
  try {
    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint);
  } on PlatformException catch (e) {
    print(e.message);
    return false;
  }
}

Future<bool> checkAppAvailable(String androidId, String iosScheme) async {
  if (Platform.isAndroid) {
    var params = Map<String, String>();
    params[Constant.PACKAGE_NAME] = androidId;
    var message;
    try {
      message =
          await platform.invokeMethod(Constant.CHECK_APP_AVAILABLE, params);
      return message == true;
    } on PlatformException catch (e) {}
    return false;
  } else if (Platform.isIOS) {
    return await canLaunch("${iosScheme}://");
  }
}

Future<bool> openApp(String androidId, String iosId, String iosScheme,
    String appName, BuildContext context) async {
  if (Platform.isAndroid) {
    var params = Map<String, String>();
    params[Constant.PACKAGE_NAME] = androidId;
    try {
      var isAvailable = await checkAppAvailable(androidId, iosScheme);
      if (isAvailable == true) {
        await platform.invokeMethod(Constant.OPEN_OTHER_APP, params);
      } else {
        ConfirmDialogFunction(
          context: context,
          content:
              "Bạn cần cài đặt ứng dụng ${appName} để thực hiện chức năng này.",
          onAccept: () {
            platform.invokeMethod(Constant.OPEN_OTHER_APP, params);
          },
        ).showConfirmDialog();
      }
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  } else if (Platform.isIOS) {
    if (await canLaunch("${iosScheme}://")) {
      await launch("${iosScheme}://");
      return true;
    } else {
      ConfirmDialogFunction(
        context: context,
        content:
            "Bạn cần cài đặt ứng dụng ${appName} để thực hiện chức năng này.",
        onAccept: () {
          StoreRedirect.redirect(
              androidAppId: androidId, iOSAppId: iosId); //iOSAppId của Doceye
        },
      ).showConfirmDialog();
    }
  }
}

int compareVersion(String version1, String version2) {
  if (version1 == version2) return 0;
  List<int> list1 = version1.split(".").map((e) => int.parse(e)).toList();
  List<int> list2 = version2.split(".").map((e) => int.parse(e)).toList();
  int minLength = min(list1.length, list2.length);
  for (int i = 0; i < minLength; i++) {
    if (list1[i].compareTo(list2[i]) == 0) {
      continue;
    } else {
      return list1[i].compareTo(list2[i]);
    }
  }
  return list1.length.compareTo(list2.length);
}
