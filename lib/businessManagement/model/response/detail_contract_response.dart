import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import 'create_management_response.dart';
import 'detail_management_response.dart';

class DetailContractResponse extends BaseResponse {
  DataDetailContract data;

  DetailContractResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataDetailContract.fromJson(json['Data'])
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

class DataDetailContract {
  ContractDetail contractDetail;

  DataDetailContract({this.contractDetail});

  DataDetailContract.fromJson(Map<String, dynamic> json) {
    contractDetail = json['ContractDetail'] != null
        ? new ContractDetail.fromJson(json['ContractDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contractDetail != null) {
      data['ContractDetail'] = this.contractDetail.toJson();
    }
    return data;
  }
}

class ContractDetail {
  int iD;
  String code;
  String number;
  String name;
  String projectType;
  int signDate;
  int startDate;
  int endDate;
  String province;
  String type;
  String totalMoney;
  int totalMoneyOrigin;
  String capital;
  int capitalOrigin;
  String grossProfit;
  int grossProfitOrigin;
  String absoluteValue;
  double absoluteValueOrigin;
  String bonus;
  String bonusTypes;
  int bonusType;
  String marketingCost;
  String deployCost;
  Phase phase;
  List<Phase> phaseTargets;
  Seller seller;
  Seller customer;
  List<Attachments> attachments;
  List<Attachments> attachmentsDeploy;
  List<Comments> comments;
  List<ContractPayments> contractPayments;
  List<TypeProjects> contractPaymentTypes;
  List<TypeProjects> contractPaymentStatus;
  TypeProjects projectPlan;
  Seller createdBy;
  bool isDelete;
  bool isUpdate;
  bool isRestore;
  bool isTrash;
  bool isUpFile;
  bool isCreatePayment;
  bool isChangePhase;

  // tài khoản khách
  String signDateString;
  String startDateString;
  String endDateString;
  String totalMoneyOriginString;
  String capitalOriginString;
  String grossProfitOriginString;
  bool isDeleted;

  bool isShowHistory;
  bool isShowComment;
  bool isShowFile;
  bool isShowPayment;

  ContractDetail(
      {this.iD,
      this.isShowHistory,
      this.isShowComment,
      this.isShowFile,
      this.isShowPayment,
      this.code,
      this.number,
      this.name,
      this.projectType,
      this.signDate,
      this.startDate,
      this.endDate,
      this.province,
      this.type,
      this.totalMoney,
      this.totalMoneyOrigin,
      this.capital,
      this.capitalOrigin,
      this.grossProfit,
      this.grossProfitOrigin,
      this.absoluteValue,
      this.absoluteValueOrigin,
      this.bonus,
      this.bonusTypes,
      this.bonusType,
      this.marketingCost,
      this.deployCost,
      this.phase,
      this.phaseTargets,
      this.seller,
      this.customer,
      this.attachments,
      this.comments,
      this.contractPayments,
      this.contractPaymentTypes,
      this.contractPaymentStatus,
      this.projectPlan,
      this.createdBy,
      this.isDelete,
      this.isUpdate,
      this.isRestore,
      this.isTrash,
      this.isUpFile,
      this.isCreatePayment,
      this.isChangePhase,
      this.signDateString,
      this.startDateString,
      this.endDateString,
      this.totalMoneyOriginString,
      this.capitalOriginString,
      this.grossProfitOriginString,
      this.isDeleted,
      this.attachmentsDeploy});

  ContractDetail.fromJson(Map<String, dynamic> json) {
    isShowHistory = json['IsShowHistory'];
    isShowComment = json['IsShowComment'];
    isShowFile = json['IsShowFile'];
    isShowPayment = json['IsShowPayment'];
    iD = json['ID'];
    code = json['Code'];
    number = json['Number'];
    name = json['Name'];
    projectType = json['ProjectType'];
    signDate = json['SignDate'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    province = json['Province'];
    type = json['Type'];
    totalMoney = json['TotalMoney'];
    totalMoneyOrigin = json['TotalMoneyOrigin'];
    capital = json['Capital'];
    capitalOrigin = json['CapitalOrigin'];
    grossProfit = json['GrossProfit'];
    grossProfitOrigin = json['GrossProfitOrigin'];
    absoluteValue = json['AbsoluteValue'];
    absoluteValueOrigin = json['AbsoluteValueOrigin'];
    bonus = json['Bonus'];
    bonusTypes = json['BonusTypes'];
    bonusType = json['BonusType'];
    marketingCost = json['MarketingCost'];
    deployCost = json['DeployCost'];
    phase = json['Phase'] != null ? new Phase.fromJson(json['Phase']) : null;
    if (json['PhaseTargets'] != null) {
      phaseTargets = new List<Phase>();
      json['PhaseTargets'].forEach((v) {
        phaseTargets.add(new Phase.fromJson(v));
      });
    }
    seller =
        json['Seller'] != null ? new Seller.fromJson(json['Seller']) : null;
    customer =
        json['Customer'] != null ? new Seller.fromJson(json['Customer']) : null;
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
    if (json['Comments'] != null) {
      comments = new List<Comments>();
      json['Comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    if (json['ContractPayments'] != null) {
      contractPayments = new List<ContractPayments>();
      json['ContractPayments'].forEach((v) {
        contractPayments.add(new ContractPayments.fromJson(v));
      });
    }
    if (json['ContractPaymentTypes'] != null) {
      contractPaymentTypes = new List<TypeProjects>();
      json['ContractPaymentTypes'].forEach((v) {
        contractPaymentTypes.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['ContractPaymentStatus'] != null) {
      contractPaymentStatus = new List<TypeProjects>();
      json['ContractPaymentStatus'].forEach((v) {
        contractPaymentStatus.add(new TypeProjects.fromJson(v));
      });
    }
    projectPlan = json['ProjectPlan'] != null
        ? new TypeProjects.fromJson(json['ProjectPlan'])
        : null;
    createdBy = json['CreatedBy'] != null
        ? new Seller.fromJson(json['CreatedBy'])
        : null;
    isDelete = json['IsDelete'];
    isUpdate = json['IsUpdate'];
    isRestore = json['IsRestore'];
    isTrash = json['IsTrash'];
    isUpFile = json['IsUpFile'];
    isCreatePayment = json['IsCreatePayment'];
    isChangePhase = json['IsChangePhase'];

    signDateString = json['SignDateString'];
    startDateString = json['StartDateString'];
    endDateString = json['EndDateString'];
    totalMoneyOriginString = json['TotalMoneyOriginString'];
    capitalOriginString = json['CapitalOriginString'];
    grossProfitOriginString = json['GrossProfitOriginString'];
    isDeleted = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsShowHistory'] = this.isShowHistory;
    data['IsShowComment'] = this.isShowComment;
    data['IsShowFile'] = this.isShowFile;
    data['IsShowPayment'] = this.isShowPayment;
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Number'] = this.number;
    data['Name'] = this.name;
    data['ProjectType'] = this.projectType;
    data['SignDate'] = this.signDate;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Province'] = this.province;
    data['Type'] = this.type;
    data['TotalMoney'] = this.totalMoney;
    data['TotalMoneyOrigin'] = this.totalMoneyOrigin;
    data['Capital'] = this.capital;
    data['CapitalOrigin'] = this.capitalOrigin;
    data['GrossProfit'] = this.grossProfit;
    data['GrossProfitOrigin'] = this.grossProfitOrigin;
    data['AbsoluteValue'] = this.absoluteValue;
    data['AbsoluteValueOrigin'] = this.absoluteValueOrigin;
    data['Bonus'] = this.bonus;
    data['BonusTypes'] = this.bonusTypes;
    data['BonusType'] = this.bonusType;
    data['MarketingCost'] = this.marketingCost;
    data['DeployCost'] = this.deployCost;
    if (this.phase != null) {
      data['Phase'] = this.phase.toJson();
    }
    if (this.phaseTargets != null) {
      data['PhaseTargets'] = this.phaseTargets.map((v) => v.toJson()).toList();
    }
    if (this.seller != null) {
      data['Seller'] = this.seller.toJson();
    }
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    if (this.attachments != null) {
      data['Attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.attachmentsDeploy != null) {
      data['AttachmentsDeploy'] =
          this.attachmentsDeploy.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['Comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.contractPayments != null) {
      data['ContractPayments'] =
          this.contractPayments.map((v) => v.toJson()).toList();
    }
    if (this.contractPaymentTypes != null) {
      data['ContractPaymentTypes'] =
          this.contractPaymentTypes.map((v) => v.toJson()).toList();
    }
    if (this.contractPaymentStatus != null) {
      data['ContractPaymentStatus'] =
          this.contractPaymentStatus.map((v) => v.toJson()).toList();
    }
    if (this.projectPlan != null) {
      data['ProjectPlan'] = this.projectPlan.toJson();
    }
    if (this.createdBy != null) {
      data['CreatedBy'] = this.createdBy.toJson();
    }
    data['IsDelete'] = this.isDelete;
    data['IsUpdate'] = this.isUpdate;
    data['IsRestore'] = this.isRestore;
    data['IsTrash'] = this.isTrash;
    data['IsUpFile'] = this.isUpFile;
    data['IsCreatePayment'] = this.isCreatePayment;
    data['IsChangePhase'] = this.isChangePhase;

    data['SignDateString'] = this.signDateString;
    data['StartDateString'] = this.startDateString;
    data['EndDateString'] = this.endDateString;
    data['TotalMoneyOriginString'] = this.totalMoneyOriginString;
    data['CapitalOriginString'] = this.capitalOriginString;
    data['GrossProfitOriginString'] = this.grossProfitOriginString;
    data['IsDeleted'] = this.isDeleted;
    return data;
  }
}

class ContractPayments {
  int iD;
  String name;
  int type;
  String typeName;
  double ratio;
  String rules;
  int paymentDate;
  int remindDay;
  Phase status;
  List<Phase> statusTargets;
  bool isChangeStatus;
  bool isUpdate;
  bool isDelete;
  bool isView;
  String paymentDateString;

  ContractPayments(
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
      this.isView,
      this.paymentDateString});

  ContractPayments.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    paymentDateString = json['PaymentDateString'];
    type = json['Type'];
    typeName = json['TypeName'];
    ratio = json['Ratio'];
    rules = json['Rules'];
    paymentDate = json['PaymentDate'];
    remindDay = json['RemindDay'];
    status = json['Status'] != null ? new Phase.fromJson(json['Status']) : null;
    if (json['StatusTargets'] != null) {
      statusTargets = new List<Phase>();
      json['StatusTargets'].forEach((v) {
        statusTargets.add(new Phase.fromJson(v));
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
    data['PaymentDateString'] = this.paymentDateString;
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
