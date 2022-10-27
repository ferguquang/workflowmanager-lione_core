import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';

class AddContractFileRepository extends ChangeNotifier {
  List<ContractFiles> files = [];

  addFile(ContractFiles file) {
    files.add(file);
    notifyListeners();
  }

  removeFile(ContractFiles file) {
    files.remove(file);
    notifyListeners();
  }
}
