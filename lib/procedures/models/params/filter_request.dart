import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/select_model.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/extension/date.dart';

class FilterRequest {
  int pageIndex;
  int pageSize;
  String term;
  String startDate;
  String endDate;
  FilterYear filterYear = FilterYear();
  String fromExpectedDate;
  String toExpectedDate;
  TypeResolve typeResolve = TypeResolve();
  FilterStates filterState = FilterStates();
  Services service = Services();
  FilterPriorities filterPriority = FilterPriorities();
  FilterStatusRecords filterStatusRecord = FilterStatusRecords();
  UserRegister filterUserRegister = UserRegister();
  FilterDept filterDept = FilterDept();

  FilterRequest();

  FilterRequest.fromJson(Map<String, dynamic> json) {
    if(isNotNullOrEmpty(pageIndex)) {
      pageIndex = json['PageIndex'];
    }
    if(isNotNullOrEmpty(pageSize)) {
      pageSize = json['PageSize'];
    }
    if(isNotNullOrEmpty(json["Term"])) {
      term = json["Term"];
    }
    if(isNotNullOrEmpty(json["StartDate"])) {
      startDate = json["StartDate"];
    }
    if(isNotNullOrEmpty(json["EndDate"])) {
      endDate = json["EndDate"];
    }
    if (isNotNullOrEmpty(json["Year"])) {
      filterYear = FilterYear.fromJson(json["Year"]);
    }
    if (isNotNullOrEmpty(json["TypeResolve"])) {
      typeResolve = TypeResolve.fromJson(json["TypeResolve"]);
    }
    if (isNotNullOrEmpty(json["FilterStates"])) {
      filterState = FilterStates.fromJson(json["FilterStates"]);
    }
    if (isNotNullOrEmpty(json["Services"])) {
      service = Services.fromJson(json["Services"]);
    }
    if (isNotNullOrEmpty(json["FilterPriorities"])) {
      filterPriority = FilterPriorities.fromJson(json["FilterPriorities"]);
    }
    if (isNotNullOrEmpty(json["FilterStatusRecords"])) {
      filterStatusRecord = FilterStatusRecords.fromJson(json["FilterStatusRecords"]);
    }
    if(isNotNullOrEmpty(json["UserRegister"])) {
      filterUserRegister = UserRegister.fromJson(json["UserRegister"]);
    }
    if(isNotNullOrEmpty(json["FilterDept"])) {
      filterDept = FilterDept.fromJson(json["FilterDept"]);
    }
    if(isNotNullOrEmpty(json["FromExpectedDate"])) {
      fromExpectedDate = json["FromExpectedDate"];
    }
    if(isNotNullOrEmpty(json["ToExpectedDate"])) {
      toExpectedDate = json["ToExpectedDate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageIndex'] = this.pageIndex;
    data['PageSize'] = this.pageSize;
    data["Term"] = this.term;
    data["StartDate"] = this.startDate;
    data["EndDate"] = this.endDate;
    data["Year"] = this.filterYear?.toJson();
    data["TypeResolve"] = this.typeResolve?.toJson();
    data["FilterStates"] = this.filterState?.toJson();
    data["Services"] = this.service?.toJson();
    data["FilterPriorities"] = this.filterPriority?.toJson();
    data["FilterStatusRecords"] = this.filterStatusRecord?.toJson();
    data["UserRegister"] = this.filterUserRegister?.toJson();
    data["FilterDept"] = this.filterDept?.toJson();
    data["FromExpectedDate"] = this.fromExpectedDate;
    data["ToExpectedDate"] = this.toExpectedDate;
    return data;
  }

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(pageIndex)) {
      params["PageIndex"] = pageIndex;
    }
    if(isNotNullOrEmpty(pageSize)) {
      params["PageSize"] = pageSize;
    }
    if (isNotNullOrEmpty(term)) {
      params["Term"] = term;
    }
    if (isNotNullOrEmpty(startDate)) {
      params["StartDate"] = startDate.replaceAll("/", "-");
    }
    if (isNotNullOrEmpty(endDate)) {
      params["EndDate"] = endDate.replaceAll("/", "-");
    }
    if (isNotNullOrEmpty(filterState.state)) {
      params["State"] = filterState.state;
    }
    if (isNotNullOrEmpty(typeResolve.iD)) {
      params["IDType"] = typeResolve.iD;
    }
    if (isNotNullOrEmpty(service.iD)) {
      params["IDService"] = service.iD;
    }
    if (isNotNullOrEmpty(filterPriority.priority)) {
      params["Priority"] = filterPriority.priority;
    }
    if (isNotNullOrEmpty(filterStatusRecord.statusRecord)) {
      params["StatusRecord"] = filterStatusRecord.statusRecord;
    }
    if (isNotNullOrEmpty(filterUserRegister.iD)) {
      params["IDUser"] = filterUserRegister.iD;
    }
    if (isNotNullOrEmpty(filterDept.iD)) {
      params["IDDept"] = filterDept.iD;
    }
    if(isNotNullOrEmpty(fromExpectedDate)) {
      params["FromExpected"] = fromExpectedDate.replaceAll("/", "-");
    }
    if(isNotNullOrEmpty(toExpectedDate)) {
      params["ToExpected"] = toExpectedDate.replaceAll("/", "-");
    }
    return params;
  }

}
