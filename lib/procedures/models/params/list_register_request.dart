import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/params/filter_request.dart';

class ListRegisterRequest extends FilterRequest {

  ListRegisterRequest();

  ListRegisterRequest.from(FilterRequest request) {
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
  }
}

class RegisterRatingRequest {
  int idServiceRecord;

  RegisterRatingRequest({this.idServiceRecord});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IDServiceRecord"] = idServiceRecord;
    return params;
  }
}

class RegisterRemoveRequest {
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["ID"] = id;
    return params;
  }
}