import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/select_model.dart';

class ListRegisterResponse extends BaseResponse {
  DataListRegister data;

  ListRegisterResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataListRegister.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataListRegister {
  List<TypeResolve> typeResolves;
  List<Services> services;
  List<FilterStates> filterStates;
  List<FilterPriorities> filterPriorities;
  List<FilterStatusRecords> filterStatusRecords;
  List<ServiceRecords> serviceRecords;
  int recordTotalPending;
  int recordTotalProcessing;
  int recordTotalProcessed;
  int recordTotalRejected;
  int recordTotalResented;
  int recordTotalCancel;
  int recordTotalStar;
  int recordTotal;
  int pageSize;
  int pageIndex;
  int pageTotal;
  int recordNumber;

  DataListRegister(
      {this.typeResolves,
      this.services,
      this.filterStates,
      this.filterPriorities,
      this.filterStatusRecords,
      this.serviceRecords,
      this.recordTotalPending,
      this.recordTotalProcessing,
      this.recordTotalProcessed,
      this.recordTotalRejected,
      this.recordTotalResented,
      this.recordTotalCancel,
      this.recordTotalStar,
      this.recordTotal,
      this.pageSize,
      this.pageIndex,
      this.pageTotal,
      this.recordNumber});

  DataListRegister.fromJson(Map<String, dynamic> json) {
    if (json['Types'] != null) {
      typeResolves = new List<TypeResolve>();
      json['Types'].forEach((v) {
        typeResolves.add(new TypeResolve.fromJson(v));
      });
    }
    if (json['Services'] != null) {
      services = new List<Services>();
      json['Services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    if (json['FilterConditions'] != null) {
      filterStates = new List<FilterStates>();
      json['FilterConditions'].forEach((v) {
        filterStates.add(new FilterStates.fromJson(v));
      });
    }
    if (json['FilterPriorities'] != null) {
      filterPriorities = new List<FilterPriorities>();
      json['FilterPriorities'].forEach((v) {
        filterPriorities.add(new FilterPriorities.fromJson(v));
      });
    }
    if (json['FilterStatusRecords'] != null) {
      filterStatusRecords = new List<FilterStatusRecords>();
      json['FilterStatusRecords'].forEach((v) {
        filterStatusRecords.add(new FilterStatusRecords.fromJson(v));
      });
    }
    if (json['ServiceRecords'] != null) {
      serviceRecords = new List<ServiceRecords>();
      json['ServiceRecords'].forEach((v) {
        serviceRecords.add(new ServiceRecords.fromJson(v));
      });
    }
    recordTotalPending = json['RecordTotalPending'];
    print("XsizeValue = ${json['RecordTotalPending']}");
    recordTotalProcessing = json['RecordTotalProcessing'];
    recordTotalProcessed = json['RecordTotalProcessed'];
    recordTotalRejected = json['RecordTotalRejected'];
    recordTotalResented = json['RecordTotalResented'];
    recordTotalCancel = json['RecordTotalCancel'];
    recordTotalStar = json['RecordTotalStar'];
    recordTotal = json['RecordTotal'];
    pageSize = json['PageSize'];
    pageIndex = json['PageIndex'];
    pageTotal = json['PageTotal'];
    recordNumber = json['RecordNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.typeResolves != null) {
      data['Types'] = this.typeResolves.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['Services'] = this.services.map((v) => v.toJson()).toList();
    }
    if (this.filterStates != null) {
      data['FilterConditions'] =
          this.filterStates.map((v) => v.toJson()).toList();
    }
    if (this.filterPriorities != null) {
      data['FilterPriorities'] =
          this.filterPriorities.map((v) => v.toJson()).toList();
    }
    if (this.filterStatusRecords != null) {
      data['FilterStatusRecords'] =
          this.filterStatusRecords.map((v) => v.toJson()).toList();
    }
    if (this.serviceRecords != null) {
      data['ServiceRecords'] =
          this.serviceRecords.map((v) => v.toJson()).toList();
    }
    data['RecordTotalPending'] = this.recordTotalPending;
    data['RecordTotalProcessing'] = this.recordTotalProcessing;
    data['RecordTotalProcessed'] = this.recordTotalProcessed;
    data['RecordTotalRejected'] = this.recordTotalRejected;
    data['RecordTotalResented'] = this.recordTotalResented;
    data['RecordTotalCancel'] = this.recordTotalCancel;
    data['RecordTotalStar'] = this.recordTotalStar;
    data['RecordTotal'] = this.recordTotal;
    data['PageSize'] = this.pageSize;
    data['PageIndex'] = this.pageIndex;
    data['PageTotal'] = this.pageTotal;
    data['RecordNumber'] = this.recordNumber;
    return data;
  }
}

class FilterYear extends SelectModel {
  FilterYear() {
    this.name = name;
  }

  FilterYear.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    return data;
  }
}

class TypeResolve extends SelectModel {
  int iD;
  String describe;
  String icon;

  TypeResolve();

  TypeResolve.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    icon = json['Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Icon'] = this.icon;
    return data;
  }
}

class Services extends SelectModel {
  int iD;
  String describe;
  String code;
  int iDType;
  int created;
  bool isFeatured;

  Services();

  Services.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    code = json['Code'];
    iDType = json['IDType'];
    subName = "Loại thủ tục : ${json['TypeName'] ?? ""}";
    created = json['Created'];
    isFeatured = json['IsFeatured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Code'] = this.code;
    data['IDType'] = this.iDType;
    data['TypeName'] = this.subName;
    data['Created'] = this.created;
    data['IsFeatured'] = this.isFeatured;
    return data;
  }
}

class FilterStates extends SelectModel {
  int state;

  FilterStates();

  FilterStates.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Name'] = this.name;
    return data;
  }
}

class FilterPriorities extends SelectModel {
  int priority;

  FilterPriorities();

  FilterPriorities.fromJson(Map<String, dynamic> json) {
    priority = json['Priority'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Priority'] = this.priority;
    data['Name'] = this.name;
    return data;
  }
}

class FilterStatusRecords extends SelectModel {
  int statusRecord;

  FilterStatusRecords();

  FilterStatusRecords.fromJson(Map<String, dynamic> json) {
    statusRecord = json['StatusRecord'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusRecord'] = this.statusRecord;
    data['Name'] = this.name;
    return data;
  }
}

class ServiceInfoFile {
  String path;
  String name;
  String extension;

  ServiceInfoFile({this.path, this.name, this.extension});

  ServiceInfoFile.fromJson(Map<String, dynamic> json) {
    path = json['Path'];
    name = json['Name'];
    extension = json['Extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Path'] = this.path;
    data['Name'] = this.name;
    data['Extension'] = this.extension;

    return data;
  }
}

class ServiceRecords {
  int iD;
  String title;
  int iDService;
  String describe;
  int priority;
  StatusRecord statusRecord;
  StatusRecord processRecord;
  bool isDone;
  Favourite favourite;
  bool isRejected;
  String serviceName;
  String serviceCode;
  String status;
  String colorStatus;
  int iDType;
  String typeName;
  int registeredAt;
  int responseAt;
  CreatedBy createdBy;
  bool removable;
  bool editable;
  StarDetail star;

  // giải quyết:
  String remainTime;
  int isResolve;

  bool isSelected = false;

  ServiceRecords(
      {this.iD,
      this.title,
      this.iDService,
      this.describe,
      this.priority,
      this.statusRecord,
      this.isDone,
      this.favourite,
      this.isRejected,
      this.serviceName,
      this.serviceCode,
      this.status,
      this.colorStatus,
      this.iDType,
      this.typeName,
      this.registeredAt,
      this.responseAt,
      this.createdBy,
      this.removable,
      this.editable,
      this.star,
      this.remainTime,
      this.isResolve,
      this.isSelected});

  ServiceRecords.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['Title'];
    iDService = json['IDService'];
    describe = json['Describe'];
    priority = json['Priority'];

    statusRecord = json['StatusRecord'] != null
        ? new StatusRecord.fromJson(json['StatusRecord'])
        : null;
    processRecord = json['ProcessRecord'] != null
        ? new StatusRecord.fromJson(json['ProcessRecord'])
        : null;
    isDone = json['IsDone'];
    favourite = json['Favourite'] != null
        ? new Favourite.fromJson(json['Favourite'])
        : null;
    isRejected = json['IsRejected'];
    serviceName = json['ServiceName'];
    serviceCode = json['ServiceCode'];
    status = json['Status'];
    colorStatus = json['ColorStatus'];
    iDType = json['IDType'];
    typeName = json['TypeName'];
    registeredAt = json['RegisteredAt'];
    responseAt = json['ResponseAt'];
    createdBy = json['CreatedBy'] != null
        ? new CreatedBy.fromJson(json['CreatedBy'])
        : null;
    removable = json['Removable'];
    editable = json['Editable'];
    star = json['Star'] != null ? new StarDetail.fromJson(json['Star']) : null;

    remainTime = json['RemainTime'];
    isResolve = json['IsResolve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['IDService'] = this.iDService;
    data['Describe'] = this.describe;
    data['Priority'] = this.priority;
    if (this.statusRecord != null) {
      data['StatusRecord'] = this.statusRecord.toJson();
    }
    if (this.processRecord != null) {
      data['ProcessRecord'] = this.processRecord.toJson();
    }
    data['IsDone'] = this.isDone;
    if (this.favourite != null) {
      data['Favourite'] = this.favourite.toJson();
    }
    data['IsRejected'] = this.isRejected;
    data['ServiceName'] = this.serviceName;
    data['ServiceCode'] = this.serviceCode;
    data['Status'] = this.status;
    data['IDType'] = this.iDType;
    data['TypeName'] = this.typeName;
    data['RegisteredAt'] = this.registeredAt;
    data['ResponseAt'] = this.responseAt;
    if (this.createdBy != null) {
      data['CreatedBy'] = this.createdBy.toJson();
    }
    data['Removable'] = this.removable;
    data['Editable'] = this.editable;
    if (this.star != null) {
      data['Star'] = this.star.toJson();
    }

    data['RemainTime'] = this.remainTime;
    data['IsResolve'] = this.isResolve;

    return data;
  }
}

class StatusRecord {
  String name;
  String color;

  StatusRecord({this.name, this.color});

  StatusRecord.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Color'] = this.color;
    return data;
  }
}

class Favourite {
  bool isFavourite;
  String icon;

  Favourite({this.isFavourite, this.icon});

  Favourite.fromJson(Map<String, dynamic> json) {
    isFavourite = json['IsFavourite'];
    icon = json['Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsFavourite'] = this.isFavourite;
    data['Icon'] = this.icon;
    return data;
  }
}

class CreatedBy {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;

  CreatedBy(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['IDDept'] = this.iDDept;
    return data;
  }
}

class StarDetail {
  double star;
  String title;

  int iDServiceRecord;
  int iDService;
  int isRegisterView;

  StarDetail({this.star, this.title});

  StarDetail.fromJson(Map<String, dynamic> json) {
    star = json['Star'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Star'] = this.star;
    data['Title'] = this.title;
    return data;
  }
}

class UserRegister extends SelectModel {
  int iD;
  String email;
  String phone;
  String address;
  int iDDept;

  UserRegister({this.iD, this.email, this.phone, this.address, this.iDDept});

  UserRegister.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['IDDept'] = this.iDDept;
    return data;
  }
}

class FilterDept extends SelectModel {
  int iD;
  String describe;

  FilterDept({this.iD, this.describe});

  FilterDept.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    return data;
  }
}
