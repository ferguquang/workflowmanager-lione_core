import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class CheckVersionApp {
  Future<void> checkVersion(BuildContext context) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String isUpdateAndroidKey = "isUpdateAndroid";
    String isUpdateIosKey = "isUpdateIos";
    String verUpdateAndroidKey = "version_android";
    String verUpdateIosKey = "version_ios";
    if (kDebugMode) {
      verUpdateAndroidKey = "version_android_debug";
      verUpdateIosKey = "version_ios_debug";
      isUpdateAndroidKey = "isUpdateAndroidDebug";
      isUpdateIosKey = "isUpdateIosDebug";
    }
    if (Platform.isAndroid) {
      var snapshot = await databaseReference.child(isUpdateAndroidKey).once();
      if (snapshot.value == true) {
        databaseReference
            .child(verUpdateAndroidKey)
            .once()
            .then((DataSnapshot snapshot) {
          if (compareVersion(version, snapshot.value) == -1) {
            checkVersionUpdate(context);
          }
        });
      }
    }
    if (Platform.isIOS) {
      var snapshot = await databaseReference.child(isUpdateIosKey).once();
      if (snapshot.value == true) {
        databaseReference
            .child(verUpdateIosKey)
            .once()
            .then((DataSnapshot snapshot) {
          if (compareVersion(version, snapshot.value) == -1) {
            checkVersionUpdate(context);
          }
        });
      }
    }
  }

  static void checkVersionUpdate(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;

    ConfirmDialogFunction dialogFunction = ConfirmDialogFunction(
        context: context,
        content:
            "Bạn phải cập nhật lên phiên bản mới nhất để sử dụng ứng dụng.",
        onAccept: () async {
          StoreRedirect.redirect(
              androidAppId: packageName, iOSAppId: AppStore.AppleID);
        },
        onCancel: () {
          exit(0);
        },
        acceptTitle: "Cập nhật");
    dialogFunction.showConfirmDialog();
  }
}
