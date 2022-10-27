// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:device_info/device_info.dart';
// import 'package:flutter/foundation.dart';
// import 'package:package_info/package_info.dart';
// import 'package:synchronized/synchronized.dart';
//
// import 'base_sharepreference.dart';
// import 'common_function.dart';
//
// class FirestoreHelper {
//   int maxLogs;
//   bool isOnlySendWhenRelease;
//
//   FirestoreHelper({this.maxLogs = 6000, this.isOnlySendWhenRelease: true});
//
//   final _lock = new Lock();
//
//   void sendLogToFirebase(
//       {String apiLink,
//       Map<String, dynamic> params,
//       int httpCode,
//       String response}) async {
//     if (kDebugMode && isOnlySendWhenRelease) return;
//     await _lock.synchronized(() async {
//       var db = FirebaseFirestore.instance;
//       String lastID = "LastID";
//       String configs = "Configs";
//       String index = "Index";
//       String logApiError = "LogApiError";
//
//       Map<String, dynamic> sendParams = Map();
//       var deviceInfo = DeviceInfoPlugin();
//       String deviceName;
//       String osVersion;
//       var manufacturer = "Apple";
//       if (Platform.isAndroid) {
//         var info = await deviceInfo.androidInfo;
//         osVersion = info.version.release;
//         manufacturer = info.manufacturer;
//         deviceName = "${info.model}";
//       } else {
//         var info = await deviceInfo.iosInfo;
//         osVersion = info.systemVersion;
//         deviceName = "${info.name}";
//       }
//       String token = params["Token"];
//       params.remove("Token");
//       sendParams["DeviceName"] = deviceName;
//       sendParams["OsVersion"] = osVersion;
//       sendParams["Manufacturer"] = manufacturer;
//       sendParams["IsAndroid"] = Platform.isAndroid;
//       sendParams["AppVer"] = await _getVersion();
//       sendParams["ApiParams"] = jsonEncode(params);
//       sendParams["ApiResponse"] = response;
//       sendParams["ApiLink"] = apiLink;
//       sendParams["HttpCode"] = httpCode;
//       sendParams["Date"] = getCurrentDate("yyyy/MM/dd HH:mm");
//       sendParams["UserName"] = await SharedPreferencesClass.getValue(
//           SharedPreferencesClass.USER_NAME);
//       int id = 1;
//       params["Token"] = token;
//       var config = await db.collection(configs).get();
//       if (config.docs.length == 0) {
//         await db.collection(configs).add({lastID: id});
//       } else {
//         await config.docs.first.reference
//             .update({lastID: FieldValue.increment(1)});
//         id = config.docs.first.data()[lastID] + 1;
//       }
//       sendParams[index] = id;
//       await db.collection(logApiError).add(sendParams);
//       db
//           .collection(logApiError)
//           .where(index, isLessThan: id - maxLogs)
//           .get()
//           .then((value) {
//         value.docs.forEach((element) {
//           element.reference.delete();
//         });
//       });
//     });
//   }
//
//   Future<String> _getVersion() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     return packageInfo.version;
//   }
// }
