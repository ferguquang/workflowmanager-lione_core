// model phần giải quyết:
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';

class ResolveResponse extends BaseResponse {
  DataResolve data;

  ResolveResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataResolve.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataResolve {
  List<FilterStates> listStates;
  List<FilterPriorities> listPriorities;
  List<FilterStatusRecords> listStatusRecords;
  List<UserRegister> listUserRegister;
  List<FilterDept> listDepts;
  List<Services> listServices;
  List<TypeResolve> listTypeResolves;
  List<ServiceRecords> listServiceRecords;
  int recordTotalPending;
  int recordTotalProcessed;
  int recordTotalResented;
  int recordTotalStar;
  int pageSize;
  int pageIndex;
  int pageTotal;
  int recordNumber;

  DataResolve(
      {this.listStates,
        this.listPriorities,
        this.listStatusRecords,
        this.listUserRegister,
        this.listDepts,
        this.listServices,
        this.listTypeResolves,
        this.listServiceRecords,
        this.recordTotalPending,
        this.recordTotalProcessed,
        this.recordTotalResented,
        this.recordTotalStar,
        this.pageSize,
        this.pageIndex,
        this.pageTotal,
        this.recordNumber});

  DataResolve.fromJson(Map<String, dynamic> json) {
    if (json['FilterConditions'] != null) {
      listStates = new List<FilterStates>();
      json['FilterConditions'].forEach((v) {
        listStates.add(new FilterStates.fromJson(v));
      });
    }
    if (json['FilterPriorities'] != null) {
      listPriorities = new List<FilterPriorities>();
      json['FilterPriorities'].forEach((v) {
        listPriorities.add(new FilterPriorities.fromJson(v));
      });
    }
    if (json['FilterStatusRecords'] != null) {
      listStatusRecords = new List<FilterStatusRecords>();
      json['FilterStatusRecords'].forEach((v) {
        listStatusRecords.add(new FilterStatusRecords.fromJson(v));
      });
    }
    if (json['User'] != null) {
      listUserRegister = new List<UserRegister>();
      json['User'].forEach((v) {
        listUserRegister.add(new UserRegister.fromJson(v));
      });
    }
    if (json['Dept'] != null) {
      listDepts = new List<FilterDept>();
      json['Dept'].forEach((v) {
        listDepts.add(new FilterDept.fromJson(v));
      });
    }
    if (json['Services'] != null) {
      listServices = new List<Services>();
      json['Services'].forEach((v) {
        listServices.add(new Services.fromJson(v));
      });
    }
    if (json['Types'] != null) {
      listTypeResolves = new List<TypeResolve>();
      json['Types'].forEach((v) {
        listTypeResolves.add(new TypeResolve.fromJson(v));
      });
    }
    if (json['ServiceRecords'] != null) {
      listServiceRecords = new List<ServiceRecords>();
      json['ServiceRecords'].forEach((v) {
        listServiceRecords.add(new ServiceRecords.fromJson(v));
      });
    }
    recordTotalPending = json['RecordTotalPending'];
    recordTotalProcessed = json['RecordTotalProcessed'];
    recordTotalResented = json['RecordTotalResented'];
    recordTotalStar = json['RecordTotalStar'];
    pageSize = json['PageSize'];
    pageIndex = json['PageIndex'];
    pageTotal = json['PageTotal'];
    recordNumber = json['RecordNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listStates != null) {
      data['FilterConditions'] =
          this.listStates.map((v) => v.toJson()).toList();
    }
    if (this.listPriorities != null) {
      data['FilterPriorities'] =
          this.listPriorities.map((v) => v.toJson()).toList();
    }
    if (this.listStatusRecords != null) {
      data['FilterStatusRecords'] =
          this.listStatusRecords.map((v) => v.toJson()).toList();
    }
    if (this.listUserRegister != null) {
      data['User'] = this.listUserRegister.map((v) => v.toJson()).toList();
    }
    if (this.listDepts != null) {
      data['Dept'] = this.listDepts.map((v) => v.toJson()).toList();
    }
    if (this.listServices != null) {
      data['Services'] = this.listServices.map((v) => v.toJson()).toList();
    }
    if (this.listTypeResolves != null) {
      data['Types'] = this.listTypeResolves.map((v) => v.toJson()).toList();
    }
    if (this.listServiceRecords != null) {
      data['ServiceRecords'] =
          this.listServiceRecords.map((v) => v.toJson()).toList();
    }
    data['RecordTotalPending'] = this.recordTotalPending;
    data['RecordTotalProcessed'] = this.recordTotalProcessed;
    data['RecordTotalResented'] = this.recordTotalResented;
    data['RecordTotalStar'] = this.recordTotalStar;
    data['PageSize'] = this.pageSize;
    data['PageIndex'] = this.pageIndex;
    data['PageTotal'] = this.pageTotal;
    data['RecordNumber'] = this.recordNumber;
    return data;
  }
}
