import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';

import 'create_management_response.dart';
import 'over_view_response.dart';

class CreateContractResponse extends BaseResponse {
  DataCreateContract data;

  CreateContractResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataCreateContract.fromJson(json['Data'])
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

class DataCreateContract {
  Contract contract;
  List<Seller> customers;
  List<TypeProjects> projectTypes;
  List<TypeProjects> centers;
  List<Seller> sellers;
  List<TypeProjects> projectPlans;
  List<TypeProjects> provinces;
  List<TypeProjects> paymentTypes;
  List<TypeProjects> bonusTypes;
  List<TypeProjects> types;
  List<TypeProjects> statuses;
  bool isSelectPlan;
  bool isSelectCustomer;
  bool isSelectSeller;

  DataCreateContract(
      {this.contract,
      this.customers,
      this.projectTypes,
      this.centers,
      this.sellers,
      this.projectPlans,
      this.provinces,
      this.paymentTypes,
      this.bonusTypes,
      this.types,
      this.statuses,
      this.isSelectPlan,
      this.isSelectCustomer,
      this.isSelectSeller});

  DataCreateContract.fromJson(Map<String, dynamic> json) {
    contract = json['Contract'] != null
        ? new Contract.fromJson(json['Contract'])
        : null;
    if (json['Customers'] != null) {
      customers = new List<Seller>();
      json['Customers'].forEach((v) {
        customers.add(new Seller.fromJson(v));
      });
    }
    if (json['ProjectTypes'] != null) {
      projectTypes = new List<TypeProjects>();
      json['ProjectTypes'].forEach((v) {
        projectTypes.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Centers'] != null) {
      centers = new List<TypeProjects>();
      json['Centers'].forEach((v) {
        centers.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Sellers'] != null) {
      sellers = new List<Seller>();
      json['Sellers'].forEach((v) {
        sellers.add(new Seller.fromJson(v));
      });
    }
    if (json['ProjectPlans'] != null) {
      projectPlans = new List<TypeProjects>();
      json['ProjectPlans'].forEach((v) {
        projectPlans.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Provinces'] != null) {
      provinces = new List<TypeProjects>();
      json['Provinces'].forEach((v) {
        provinces.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['PaymentTypes'] != null) {
      paymentTypes = new List<TypeProjects>();
      json['PaymentTypes'].forEach((v) {
        paymentTypes.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['BonusTypes'] != null) {
      bonusTypes = new List<TypeProjects>();
      json['BonusTypes'].forEach((v) {
        bonusTypes.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Types'] != null) {
      types = new List<TypeProjects>();
      json['Types'].forEach((v) {
        types.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Statuses'] != null) {
      statuses = new List<TypeProjects>();
      json['Statuses'].forEach((v) {
        statuses.add(new TypeProjects.fromJson(v));
      });
    }
    isSelectPlan = json['IsSelectPlan'];
    isSelectCustomer = json['IsSelectCustomer'];
    isSelectSeller = json['IsSelectSeller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contract != null) {
      data['Contract'] = this.contract.toJson();
    }
    if (this.customers != null) {
      data['Customers'] = this.customers.map((v) => v.toJson()).toList();
    }
    if (this.projectTypes != null) {
      data['ProjectTypes'] = this.projectTypes.map((v) => v.toJson()).toList();
    }
    if (this.centers != null) {
      data['Centers'] = this.centers.map((v) => v.toJson()).toList();
    }
    if (this.sellers != null) {
      data['Sellers'] = this.sellers.map((v) => v.toJson()).toList();
    }
    if (this.projectPlans != null) {
      data['ProjectPlans'] = this.projectPlans.map((v) => v.toJson()).toList();
    }
    if (this.provinces != null) {
      data['Provinces'] = this.provinces.map((v) => v.toJson()).toList();
    }
    if (this.paymentTypes != null) {
      data['PaymentTypes'] = this.paymentTypes.map((v) => v.toJson()).toList();
    }
    if (this.bonusTypes != null) {
      data['BonusTypes'] = this.bonusTypes.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['Types'] = this.types.map((v) => v.toJson()).toList();
    }
    if (this.statuses != null) {
      data['Statuses'] = this.statuses.map((v) => v.toJson()).toList();
    }
    data['IsSelectPlan'] = this.isSelectPlan;
    data['IsSelectCustomer'] = this.isSelectCustomer;
    data['IsSelectSeller'] = this.isSelectSeller;
    return data;
  }
}

class Contract {
  int iD;
  int iDCustomer;
  int iDProjectPlan;
  String codePrefix;
  String code;
  String number;
  String name;
  int iDTypeProject;
  int signDate;
  int startDate;
  int endDate;
  int iDProvince;
  int status;
  int iDSeller;
  int iDCenter;
  int totalMoney;
  int capital;
  int grossProfit;
  double marketingCost;
  int deployCost;
  int bonusType;
  double bonus;
  List<Attachments> attachments;
  List<Attachments> attachmentsDeploy;
  List<Payments> payments;
  int type;
  int invoiceMoney;
  double absoluteValue;

  Contract(
      {this.iD,
      this.iDCustomer,
      this.iDProjectPlan,
      this.codePrefix,
      this.code,
      this.number,
      this.name,
      this.iDTypeProject,
      this.signDate,
      this.startDate,
      this.endDate,
      this.iDProvince,
      this.status,
      this.iDSeller,
      this.iDCenter,
      this.totalMoney,
      this.capital,
      this.grossProfit,
      this.marketingCost,
      this.deployCost,
      this.bonusType,
      this.bonus,
      this.attachments,
      this.payments,
      this.type,
      this.invoiceMoney,
      this.absoluteValue,
      this.attachmentsDeploy});

  Contract.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    invoiceMoney = json['InvoiceMoney'];
    iDCustomer = json['IDCustomer'];
    iDProjectPlan = json['IDProjectPlan'];
    codePrefix = json['CodePrefix'];
    code = json['Code'];
    number = json['Number'];
    name = json['Name'];
    iDTypeProject = json['IDTypeProject'];
    signDate = json['SignDate'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    iDProvince = json['IDProvince'];
    status = json['Status'];
    iDSeller = json['IDSeller'];
    iDCenter = json['IDCenter'];
    totalMoney = json['TotalMoney'];
    capital = json['Capital'];
    grossProfit = json['GrossProfit'];
    marketingCost = json['MarketingCost'];
    deployCost = json['DeployCost'];
    bonusType = json['BonusType'];
    bonus = json['Bonus'];
    if (json['Attachments'] != null) {
      attachments = new List<Attachments>();
      json['Attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    if (json['AttachmentsDeploy'] != null) {
      attachmentsDeploy = new List<Attachments>();
      json['AttachmentsDeploy'].forEach((v) {
        attachmentsDeploy.add(new Attachments.fromJson(v));
      });
    }
    if (json['Payments'] != null) {
      payments = new List<Payments>();
      json['Payments'].forEach((v) {
        payments.add(new Payments.fromJson(v));
      });
    }
    type = json['Type'];
    absoluteValue = json['AbsoluteValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['InvoiceMoney'] = this.invoiceMoney;
    data['IDCustomer'] = this.iDCustomer;
    data['IDProjectPlan'] = this.iDProjectPlan;
    data['CodePrefix'] = this.codePrefix;
    data['Code'] = this.code;
    data['Number'] = this.number;
    data['Name'] = this.name;
    data['IDTypeProject'] = this.iDTypeProject;
    data['SignDate'] = this.signDate;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['IDProvince'] = this.iDProvince;
    data['Status'] = this.status;
    data['IDSeller'] = this.iDSeller;
    data['IDCenter'] = this.iDCenter;
    data['TotalMoney'] = this.totalMoney;
    data['Capital'] = this.capital;
    data['GrossProfit'] = this.grossProfit;
    data['MarketingCost'] = this.marketingCost;
    data['DeployCost'] = this.deployCost;
    data['BonusType'] = this.bonusType;
    data['Bonus'] = this.bonus;
    if (this.attachments != null) {
      data['Attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.attachmentsDeploy != null) {
      data['AttachmentsDeploy'] =
          this.attachmentsDeploy.map((v) => v.toJson()).toList();
    }
    if (this.payments != null) {
      data['Payments'] = this.payments.map((v) => v.toJson()).toList();
    }
    data['Type'] = this.type;
    data['AbsoluteValue'] = this.absoluteValue;
    return data;
  }
}

class Payments {
  int iD;
  String name;
  int type;
  String typeName;
  double ratio;
  String rules;
  int paymentDate;
  int remindDay;
  Status status;
  List<Status> statusTargets;
  bool isChangeStatus;
  bool isUpdate;
  bool isDelete;
  bool isView;

  Payments(
      {this.iD,
      this.name,
      this.type,
      this.typeName,
      this.ratio,
      this.rules,
      this.paymentDate,
      this.remindDay,
      this.status,
      this.statusTargets,
      this.isChangeStatus,
      this.isUpdate,
      this.isDelete,
      this.isView});

  Payments.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    type = json['Type'];
    typeName = json['TypeName'];
    ratio = json['Ratio'];
    rules = json['Rules'];
    paymentDate = json['PaymentDate'];
    remindDay = json['RemindDay'];
    status =
        json['Status'] != null ? new Status.fromJson(json['Status']) : null;
    if (json['StatusTargets'] != null) {
      statusTargets = new List<Status>();
      json['StatusTargets'].forEach((v) {
        statusTargets.add(new Status.fromJson(v));
      });
    }
    isChangeStatus = json['IsChangeStatus'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
    isView = json['IsView'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['TypeName'] = this.typeName;
    data['Ratio'] = this.ratio;
    data['Rules'] = this.rules;
    data['PaymentDate'] = this.paymentDate;
    data['RemindDay'] = this.remindDay;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    if (this.statusTargets != null) {
      data['StatusTargets'] =
          this.statusTargets.map((v) => v.toJson()).toList();
    }
    data['IsChangeStatus'] = this.isChangeStatus;
    data['IsUpdate'] = this.isUpdate;
    data['IsDelete'] = this.isDelete;
    data['IsView'] = this.isView;
    return data;
  }
}
