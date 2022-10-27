import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';

class PickSignalRepository extends ChangeNotifier {
  DataSignatureList dataSignatureList;

  PickSignalRepository(this.dataSignatureList);

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
