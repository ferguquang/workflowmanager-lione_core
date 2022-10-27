import 'package:workflow_manager/procedures/models/params/filter_request.dart';

class ListReportStatusRequest extends FilterRequest {

  ListReportStatusRequest();

  ListReportStatusRequest.from(FilterRequest request) {
    this.pageIndex = request.pageIndex;
    this.pageSize = request.pageSize;
    this.term = request.term;
    this.startDate = request.startDate;
    this.endDate = request.endDate;
    this.filterUserRegister = request.filterUserRegister;
    this.filterState = request.filterState;
    this.typeResolve = request.typeResolve;
    this.service = request.service;
    this.filterDept = request.filterDept;
    this.fromExpectedDate = request.fromExpectedDate;
    this.toExpectedDate = request.toExpectedDate;
  }

}