import 'package:workflow_manager/base/utils/common_function.dart';

import 'filter_request.dart';

class ListResolveRequest extends FilterRequest {

  ListResolveRequest();

  ListResolveRequest.from(FilterRequest request) {
    this.pageIndex = request.pageIndex;
    this.pageSize = request.pageSize;
    this.term = request.term;
    this.startDate = request.startDate;
    this.endDate = request.endDate;
    this.filterState = request.filterState;
    this.typeResolve = request.typeResolve;
    this.service = request.service;
    this.filterPriority = request.filterPriority;
    this.filterStatusRecord = request.filterStatusRecord;
    this.filterUserRegister = request.filterUserRegister;
    this.filterDept = request.filterDept;
    this.fromExpectedDate = request.fromExpectedDate;
    this.toExpectedDate = request.toExpectedDate;
  }

}

class RecordIsResolveListRequest {
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["ID"] = this.id;
    return params;
  }
}

class RecordResolveListRequest {
  dynamic id, idStep, idSchemaCondition, describe, pass;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["ID"] = this.id;
    params["IDStep"] = this.idStep;
    params["IDSchemaCondition"] = this.idSchemaCondition;
    params["Describe"] = this.describe;
    params["Pass"] = this.pass;
    return params;
  }
}
