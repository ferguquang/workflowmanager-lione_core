import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class ProjectPlanIndexResponse extends BaseResponse {
  DataProjectPlanIndex data;

  ProjectPlanIndexResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataProjectPlanIndex.fromJson(json['Data'])
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

class DataProjectPlanIndex {
  List<ProjectPlanItem> projectPlans;
  int totalPlan;
  int totalCustomer;
  String totalMoney;
  int totalMoneyOriginal;
  bool isCreate;
  SearchParamListManage searchParam;

  DataProjectPlanIndex(
      {this.projectPlans,
      this.totalPlan,
      this.totalCustomer,
      this.totalMoney,
      this.totalMoneyOriginal,
      this.isCreate,
      this.searchParam});

  DataProjectPlanIndex.fromJson(Map<String, dynamic> json) {
    if (json['ProjectPlans'] != null) {
      projectPlans = new List<ProjectPlanItem>();
      json['ProjectPlans'].forEach((v) {
        projectPlans.add(new ProjectPlanItem.fromJson(v));
      });
    }
    totalPlan = json['TotalPlan'];
    totalCustomer = json['TotalCustomer'];
    totalMoney = json['TotalMoney'];
    totalMoneyOriginal = json['TotalMoneyOriginal'];
    isCreate = json['IsCreate'];
    searchParam = json['SearchParam'] != null
        ? new SearchParamListManage.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projectPlans != null) {
      data['ProjectPlans'] = this.projectPlans.map((v) => v.toJson()).toList();
    }
    data['TotalPlan'] = this.totalPlan;
    data['TotalCustomer'] = this.totalCustomer;
    data['TotalMoney'] = this.totalMoney;
    data['TotalMoneyOriginal'] = this.totalMoneyOriginal;
    data['IsCreate'] = this.isCreate;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class ProjectPlanItem {
  int iD;
  String code;
  String name;
  StatusPlan status;
  String totalMoney;
  Customer customer;
  int updated;
  int startDate;
  int quater;
  String investors;
  int executeDuration;
  int tendererDate;
  int demoDate;
  int deployDate;
  String detailAmount;
  String profileType;
  String advanceTerms;
  String paymentTerms;
  Seller seller;
  List<StatusAndPhaseTarget> statusTargets;
  List<StatusAndPhaseTarget> phaseTargets;
  StatusAndPhaseTarget phase;
  bool isApprove;
  bool isReject;
  bool isUpdate;
  bool isTrash;
  bool isDelete;
  bool isView;
  bool isCopy;
  bool isRestore;
  bool isChangeStatus;
  bool isChangePhase;
  bool isDeleted;
  bool isExpired;
  bool isTemp;
  bool isApproveEdit;
  bool isRejectEdit;

  ProjectPlanItem(
      {this.iD,
      this.code,
      this.name,
      this.status,
      this.totalMoney,
      this.customer,
      this.updated,
      this.startDate,
      this.quater,
      this.investors,
      this.executeDuration,
      this.phase,
      this.tendererDate,
      this.demoDate,
      this.deployDate,
      this.detailAmount,
      this.profileType,
      this.advanceTerms,
      this.paymentTerms,
      this.seller,
      this.statusTargets,
      this.phaseTargets,
      this.isApprove,
      this.isReject,
      this.isUpdate,
      this.isTrash,
      this.isDelete,
      this.isView,
      this.isCopy,
      this.isRestore,
      this.isChangeStatus,
      this.isChangePhase,
      this.isDeleted,
      this.isExpired,
      this.isTemp,
      this.isApproveEdit,
      this.isRejectEdit});

  ProjectPlanItem.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    status =
        json['Status'] != null ? new StatusPlan.fromJson(json['Status']) : null;
    totalMoney = json['TotalMoney'];
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
    updated = json['Updated'];
    startDate = json['StartDate'];
    quater = json['Quater'];
    investors = json['Investors'];
    executeDuration = json['ExecuteDuration'];
    tendererDate = json['TendererDate'];
    demoDate = json['DemoDate'];
    deployDate = json['DeployDate'];
    detailAmount = json['DetailAmount'];
    profileType = json['ProfileType'];
    advanceTerms = json['AdvanceTerms'];
    paymentTerms = json['PaymentTerms'];
    seller =
        json['Seller'] != null ? new Seller.fromJson(json['Seller']) : null;
    if (json['StatusTargets'] != null) {
      statusTargets = new List<StatusAndPhaseTarget>();
      json['StatusTargets'].forEach((v) {
        statusTargets.add(new StatusAndPhaseTarget.fromJson(v));
      });
    }
    if (json['PhaseTargets'] != null) {
      phaseTargets = new List<StatusAndPhaseTarget>();
      json['PhaseTargets'].forEach((v) {
        phaseTargets.add(new StatusAndPhaseTarget.fromJson(v));
      });
    }
    if (json['Phase'] != null) {
      phase = json['Phase'] != null
          ? new StatusAndPhaseTarget.fromJson(json['Phase'])
          : null;
    }
    isApprove = json['IsApprove'];
    isReject = json['IsReject'];
    isUpdate = json['IsUpdate'];
    isTrash = json['IsTrash'];
    isDelete = json['IsDelete'];
    isView = json['IsView'];
    isCopy = json['IsCopy'];
    isRestore = json['IsRestore'];
    isChangeStatus = json['IsChangeStatus'];
    isChangePhase = json['IsChangePhase'];
    isDeleted = json['IsDeleted'];
    isExpired = json['IsExpired'];
    isTemp = json['IsTemp'];
    isApproveEdit = json['IsApproveEdit'];
    isRejectEdit = json['IsRejectEdit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Name'] = this.name;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    data['TotalMoney'] = this.totalMoney;
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    data['Updated'] = this.updated;
    data['StartDate'] = this.startDate;
    data['Quater'] = this.quater;
    data['Investors'] = this.investors;
    data['ExecuteDuration'] = this.executeDuration;
    data['TendererDate'] = this.tendererDate;
    data['DemoDate'] = this.demoDate;
    data['DeployDate'] = this.deployDate;
    data['DetailAmount'] = this.detailAmount;
    data['ProfileType'] = this.profileType;
    data['AdvanceTerms'] = this.advanceTerms;
    data['PaymentTerms'] = this.paymentTerms;
    if (this.seller != null) {
      data['Seller'] = this.seller.toJson();
    }
    if (this.statusTargets != null) {
      data['StatusTargets'] =
          this.statusTargets.map((v) => v.toJson()).toList();
    }
    if (this.phaseTargets != null) {
      data['PhaseTargets'] = this.phaseTargets.map((v) => v.toJson()).toList();
    }
    data['IsApprove'] = this.isApprove;
    data['IsReject'] = this.isReject;
    data['IsUpdate'] = this.isUpdate;
    data['IsTrash'] = this.isTrash;
    data['IsDelete'] = this.isDelete;
    data['IsView'] = this.isView;
    data['IsCopy'] = this.isCopy;
    data['IsRestore'] = this.isRestore;
    data['IsChangeStatus'] = this.isChangeStatus;
    data['IsChangePhase'] = this.isChangePhase;
    data['IsDeleted'] = this.isDeleted;
    data['IsExpired'] = this.isExpired;
    data['IsTemp'] = this.isTemp;
    data['IsApproveEdit'] = this.isApproveEdit;
    data['IsRejectEdit'] = this.isRejectEdit;
    data['Phase'] = this.phase;
    return data;
  }
}

class StatusPlan {
  int iD;
  String name;
  String color;

  StatusPlan({this.iD, this.name, this.color});

  StatusPlan.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Color'] = this.color;
    return data;
  }
}

class Customer {
  int iD;
  String avatar;
  String name;
  String email;
  String phone;
  String address;

  Customer(
      {this.iD, this.avatar, this.name, this.email, this.phone, this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    avatar = json['Avatar'];
    name = json['Name'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Avatar'] = this.avatar;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    return data;
  }
}

class SearchParamListManage {
  List<Sellers> sellers;
  List<TypeProjects> centers;
  List<TypeProjects> typeProjects;
  List<TypeProjects> typeBusiness;
  List<TypeProjects> statuss;
  List<TypeProjects> quarters;
  List<TypeProjects> sources;
  List<TypeProjects> provinces;
  List<TypeProjects> potentialTypes;
  List<TypeProjects> campaignTypes;

  SearchParamListManage(
      {this.sellers,
      this.centers,
      this.typeProjects,
      this.typeBusiness,
      this.statuss,
      this.quarters,
      this.sources,
      this.provinces,
      this.potentialTypes,
      this.campaignTypes});

  SearchParamListManage.fromJson(Map<String, dynamic> json) {
    if (json['Sellers'] != null) {
      sellers = new List<Sellers>();
      json['Sellers'].forEach((v) {
        sellers.add(new Sellers.fromJson(v));
      });
    }
    if (json['Centers'] != null) {
      centers = new List<TypeProjects>();
      json['Centers'].forEach((v) {
        centers.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['TypeProjects'] != null) {
      typeProjects = new List<TypeProjects>();
      json['TypeProjects'].forEach((v) {
        typeProjects.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['TypeBusiness'] != null) {
      typeBusiness = new List<TypeProjects>();
      json['TypeBusiness'].forEach((v) {
        typeBusiness.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Statuss'] != null) {
      statuss = new List<TypeProjects>();
      json['Statuss'].forEach((v) {
        statuss.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Quarters'] != null) {
      quarters = new List<TypeProjects>();
      json['Quarters'].forEach((v) {
        quarters.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Sources'] != null) {
      sources = new List<TypeProjects>();
      json['Sources'].forEach((v) {
        sources.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Provinces'] != null) {
      provinces = new List<TypeProjects>();
      json['Provinces'].forEach((v) {
        provinces.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['PotentialTypes'] != null) {
      potentialTypes = new List<TypeProjects>();
      json['PotentialTypes'].forEach((v) {
        potentialTypes.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['CampaignTypes'] != null) {
      campaignTypes = new List<TypeProjects>();
      json['CampaignTypes'].forEach((v) {
        campaignTypes.add(new TypeProjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellers != null) {
      data['Sellers'] = this.sellers.map((v) => v.toJson()).toList();
    }
    if (this.centers != null) {
      data['Centers'] = this.centers.map((v) => v.toJson()).toList();
    }
    if (this.typeProjects != null) {
      data['TypeProjects'] = this.typeProjects.map((v) => v.toJson()).toList();
    }
    if (this.typeBusiness != null) {
      data['TypeBusiness'] = this.typeBusiness.map((v) => v.toJson()).toList();
    }
    if (this.statuss != null) {
      data['Statuss'] = this.statuss.map((v) => v.toJson()).toList();
    }
    if (this.quarters != null) {
      data['Quarters'] = this.quarters.map((v) => v.toJson()).toList();
    }
    if (this.sources != null) {
      data['Sources'] = this.sources.map((v) => v.toJson()).toList();
    }
    if (this.provinces != null) {
      data['Provinces'] = this.provinces.map((v) => v.toJson()).toList();
    }
    if (this.potentialTypes != null) {
      data['PotentialTypes'] =
          this.potentialTypes.map((v) => v.toJson()).toList();
    }
    if (this.campaignTypes != null) {
      data['CampaignTypes'] =
          this.campaignTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Centers {
  String name;
  String key;
  int iD;
  bool isEnable;

  Centers({this.name, this.key, this.iD, this.isEnable});

  Centers.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    key = json['Key'];
    iD = json['ID'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['ID'] = this.iD;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class TypeProjects {
  String name;
  String key;
  int iD;
  bool isEnable;
  List<TypeBusiness> target;
  bool isSelected = false;

  TypeProjects({this.name, this.key, this.iD, this.target});

  TypeProjects.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    key = json['Key'];
    iD = json['ID'];
    isEnable = json['IsEnable'];
    isSelected = json['IsSelected'];
    if (json['Target'] != null) {
      target = new List<TypeBusiness>();
      json['Target'].forEach((v) {
        target.add(new TypeBusiness.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['ID'] = this.iD;
    data['IsEnable'] = this.isEnable;
    data['IsSelected'] = this.isSelected;
    if (this.target != null) {
      data['Target'] = this.target.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusAndPhaseTarget {
  int iD;
  String name;
  String color;

  StatusAndPhaseTarget({this.iD, this.name, this.color});

  StatusAndPhaseTarget.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Color'] = this.color;
    data['ID'] = this.iD;
    return data;
  }
}

class TypeBusiness {
  String name;
  String key;
  int iD;

  TypeBusiness({this.name, this.key, this.iD});

  TypeBusiness.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    key = json['Key'];
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['ID'] = this.iD;
    return data;
  }
}

class Sellers {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;

  Sellers(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept});

  Sellers.fromJson(Map<String, dynamic> json) {
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
