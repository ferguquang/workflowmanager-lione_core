import 'package:workflow_manager/base/models/base_response.dart';

import 'create_management_response.dart';
import 'over_view_response.dart';

class DetailManagementResponse extends BaseResponse {
  DataDetailManagement data;

  DetailManagementResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataDetailManagement.fromJson(json['Data'])
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

class DataDetailManagement {
  ProjectDetailModel projectDetailModel;

  DataDetailManagement({this.projectDetailModel});

  DataDetailManagement.fromJson(Map<String, dynamic> json) {
    projectDetailModel = json['ProjectDetailModel'] != null
        ? new ProjectDetailModel.fromJson(json['ProjectDetailModel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projectDetailModel != null) {
      data['ProjectDetailModel'] = this.projectDetailModel.toJson();
    }
    return data;
  }
}

class ProjectDetailModel {
  List<DataFields> dataFields;
  Status status;
  List<TypeProjectMonies> typeProjectMonies;
  Status phase;
  Seller seller;
  Customer customer;
  List<Seller> sellerTargets;
  List<Status> statusTargets;
  List<Status> phaseTargets;
  List<Contracts> contracts;
  List<Attachments> attachments;
  List<Comments> comments;
  bool isDeleted;
  bool isUpdate;
  bool isDelete;
  bool isRestore;
  bool isTrash;
  bool isChangeStatus;
  bool isChangePhase;
  bool isChangeSeller;
  bool isComment;
  bool isAddFile;
  bool isCreateContract;
  bool isTemp;
  bool isApproveEdit;
  bool isRejectEdit;

  // dành cho khách
  String executeDurationString;
  String tendererDateString;
  String demoDateString;
  String deployDateString;
  String investors;
  String detailAmount;
  String profileType;
  String advanceTerms;
  String paymentTerms;
  bool isShowContract;
  bool isShowFile;
  bool isShowComment;
  bool isShowHistory;

  ProjectDetailModel(
      {this.dataFields,
      this.isShowContract,
      this.isShowFile,
      this.isShowComment,
      this.isShowHistory,
      this.status,
      this.typeProjectMonies,
      this.phase,
      this.seller,
      this.customer,
      this.sellerTargets,
      this.statusTargets,
      this.phaseTargets,
      this.contracts,
      this.attachments,
      this.comments,
      this.isDeleted,
      this.isUpdate,
      this.isDelete,
      this.isRestore,
      this.isTrash,
      this.isChangeStatus,
      this.isChangePhase,
      this.isChangeSeller,
      this.isComment,
      this.isAddFile,
      this.isCreateContract,
      this.isTemp,
      this.isApproveEdit,
      this.isRejectEdit,
      this.executeDurationString,
      this.tendererDateString,
      this.demoDateString,
      this.deployDateString,
      this.investors,
      this.detailAmount,
      this.profileType,
      this.advanceTerms,
      this.paymentTerms});

  ProjectDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['DataFields'] != null) {
      dataFields = new List<DataFields>();
      json['DataFields'].forEach((v) {
        dataFields.add(new DataFields.fromJson(v));
      });
    }
    status =
        json['Status'] != null ? new Status.fromJson(json['Status']) : null;
    if (json['TypeProjectMonies'] != null) {
      typeProjectMonies = new List<TypeProjectMonies>();
      json['TypeProjectMonies'].forEach((v) {
        typeProjectMonies.add(new TypeProjectMonies.fromJson(v));
      });
    }
    phase = json['Phase'] != null ? new Status.fromJson(json['Phase']) : null;
    seller =
        json['Seller'] != null ? new Seller.fromJson(json['Seller']) : null;
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
    if (json['SellerTargets'] != null) {
      sellerTargets = new List<Seller>();
      json['SellerTargets'].forEach((v) {
        sellerTargets.add(new Seller.fromJson(v));
      });
    }
    if (json['StatusTargets'] != null) {
      statusTargets = new List<Status>();
      json['StatusTargets'].forEach((v) {
        statusTargets.add(new Status.fromJson(v));
      });
    }
    if (json['PhaseTargets'] != null) {
      phaseTargets = new List<Status>();
      json['PhaseTargets'].forEach((v) {
        phaseTargets.add(new Status.fromJson(v));
      });
    }
    if (json['Contracts'] != null) {
      contracts = new List<Contracts>();
      json['Contracts'].forEach((v) {
        contracts.add(new Contracts.fromJson(v));
      });
    }
    if (json['Attachments'] != null) {
      attachments = new List<Attachments>();
      json['Attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    if (json['Comments'] != null) {
      comments = new List<Comments>();
      json['Comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    isShowContract = json['IsShowContract'];
    isShowFile = json['IsShowFile'];
    isShowComment = json['IsShowComment'];
    isShowHistory = json['IsShowHistory'];
    isDeleted = json['IsDeleted'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
    isRestore = json['IsRestore'];
    isTrash = json['IsTrash'];
    isChangeStatus = json['IsChangeStatus'];
    isChangePhase = json['IsChangePhase'];
    isChangeSeller = json['IsChangeSeller'];
    isComment = json['IsComment'];
    isAddFile = json['IsAddFile'];
    isCreateContract = json['IsCreateContract'];
    isTemp = json['IsTemp'];
    isApproveEdit = json['IsApproveEdit'];
    isRejectEdit = json['IsRejectEdit'];

    executeDurationString = json['ExecuteDurationString'];
    tendererDateString = json['TendererDateString'];
    demoDateString = json['DemoDateString'];
    deployDateString = json['DeployDateString'];
    investors = json['Investors'];
    detailAmount = json['DetailAmount'];
    profileType = json['ProfileType'];
    advanceTerms = json['AdvanceTerms'];
    paymentTerms = json['PaymentTerms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataFields != null) {
      data['DataFields'] = this.dataFields.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    if (this.typeProjectMonies != null) {
      data['TypeProjectMonies'] =
          this.typeProjectMonies.map((v) => v.toJson()).toList();
    }
    if (this.phase != null) {
      data['Phase'] = this.phase.toJson();
    }
    if (this.seller != null) {
      data['Seller'] = this.seller.toJson();
    }
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    if (this.sellerTargets != null) {
      data['SellerTargets'] =
          this.sellerTargets.map((v) => v.toJson()).toList();
    }
    if (this.statusTargets != null) {
      data['StatusTargets'] =
          this.statusTargets.map((v) => v.toJson()).toList();
    }
    if (this.phaseTargets != null) {
      data['PhaseTargets'] = this.phaseTargets.map((v) => v.toJson()).toList();
    }
    if (this.contracts != null) {
      data['Contracts'] = this.contracts.map((v) => v.toJson()).toList();
    }
    if (this.attachments != null) {
      data['Attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['Comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['IsShowContract'] = this.isShowContract;
    data['IsShowFile'] = this.isShowFile;
    data['IsShowComment'] = this.isShowComment;
    data['IsShowHistory'] = this.isShowHistory;
    data['IsDeleted'] = this.isDeleted;
    data['IsUpdate'] = this.isUpdate;
    data['IsDelete'] = this.isDelete;
    data['IsRestore'] = this.isRestore;
    data['IsTrash'] = this.isTrash;
    data['IsChangeStatus'] = this.isChangeStatus;
    data['IsChangePhase'] = this.isChangePhase;
    data['IsChangeSeller'] = this.isChangeSeller;
    data['IsComment'] = this.isComment;
    data['IsAddFile'] = this.isAddFile;
    data['IsCreateContract'] = this.isCreateContract;
    data['IsTemp'] = this.isTemp;
    data['IsApproveEdit'] = this.isApproveEdit;
    data['IsRejectEdit'] = this.isRejectEdit;

    data['ExecuteDurationString'] = this.executeDurationString;
    data['TendererDateString'] = this.tendererDateString;
    data['DemoDateString'] = this.demoDateString;
    data['DeployDateString'] = this.deployDateString;
    data['Investors'] = this.investors;
    data['DetailAmount'] = this.detailAmount;
    data['ProfileType'] = this.profileType;
    data['AdvanceTerms'] = this.advanceTerms;
    data['PaymentTerms'] = this.paymentTerms;
    return data;
  }
}

class Status {
  int iD;
  String name;
  String color;
  bool isTemp = false;

  Status({this.iD, this.name, this.color, this.isTemp});

  Status.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    color = json['Color'];
    isTemp = json['IsTemp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Color'] = this.color;
    data['IsTemp'] = this.isTemp;
    return data;
  }
}

class TypeProjectMonies {
  int iD;
  TypeProjects typeProject;
  String totalMoney;
  String capital;
  String grossProfit;
  bool isDelete;
  bool isTotalMoneyTemp;
  bool isCapitalTemp;
  bool isGrossProfitTemp;

  TypeProjectMonies(
      {this.iD,
      this.typeProject,
      this.totalMoney,
      this.capital,
      this.grossProfit,
      this.isDelete,
      this.isTotalMoneyTemp,
      this.isCapitalTemp,
      this.isGrossProfitTemp});

  TypeProjectMonies.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    typeProject = json['TypeProject'] != null
        ? new TypeProjects.fromJson(json['TypeProject'])
        : null;
    totalMoney = json['TotalMoney'];
    capital = json['Capital'];
    grossProfit = json['GrossProfit'];
    isDelete = json['IsDelete'];
    isTotalMoneyTemp = json['IsTotalMoneyTemp'];
    isCapitalTemp = json['IsCapitalTemp'];
    isGrossProfitTemp = json['IsGrossProfitTemp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    if (this.typeProject != null) {
      data['TypeProject'] = this.typeProject.toJson();
    }
    data['TotalMoney'] = this.totalMoney;
    data['Capital'] = this.capital;
    data['GrossProfit'] = this.grossProfit;
    data['IsDelete'] = this.isDelete;
    data['IsTotalMoneyTemp'] = this.isTotalMoneyTemp;
    data['IsCapitalTemp'] = this.isCapitalTemp;
    data['IsGrossProfitTemp'] = this.isGrossProfitTemp;
    return data;
  }
}

class Phase {
  int iD;
  String name;
  String color;
  bool isTemp;

  Phase({this.iD, this.name, this.color, this.isTemp});

  Phase.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    color = json['Color'];
    isTemp = json['IsTemp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Color'] = this.color;
    data['IsTemp'] = this.isTemp;
    return data;
  }
}

class Customer {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  String group;
  String contactName;
  String contactAddress;

  Customer(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.group,
      this.contactName,
      this.contactAddress});

  Customer.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    group = json['Group'];
    contactName = json['ContactName'];
    contactAddress = json['ContactAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['Group'] = this.group;
    data['ContactName'] = this.contactName;
    data['ContactAddress'] = this.contactAddress;
    return data;
  }
}

class Comments {
  int iD;
  String body;
  int created;
  Seller user;
  bool isDelete;

  Comments({this.iD, this.body, this.created, this.user, this.isDelete});

  Comments.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    body = json['Body'];
    created = json['Created'];
    user = json['User'] != null ? new Seller.fromJson(json['User']) : null;
    isDelete = json['IsDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Body'] = this.body;
    data['Created'] = this.created;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['IsDelete'] = this.isDelete;
    return data;
  }
}

class Contracts {
  int iD;
  String code;
  String name;
  int signDate;
  String signDateString;
  int startDate;
  String startDateString;
  int endDate;
  String endDateString;
  String totalMoney;
  bool isDeleted;
  bool isView;
  bool isUpdate;
  bool isDelete;
  bool isRestore;
  bool isTrash;

  Contracts(
      {this.iD,
      this.code,
      this.name,
      this.signDate,
      this.signDateString,
      this.startDate,
      this.startDateString,
      this.endDate,
      this.endDateString,
      this.totalMoney,
      this.isDeleted,
      this.isView,
      this.isUpdate,
      this.isDelete,
      this.isRestore,
      this.isTrash});

  Contracts.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    signDate = json['SignDate'];
    signDateString = json['SignDateString'];
    startDate = json['StartDate'];
    startDateString = json['StartDateString'];
    endDate = json['EndDate'];
    endDateString = json['EndDateString'];
    totalMoney = json['TotalMoney'];
    isDeleted = json['IsDeleted'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
    isRestore = json['IsRestore'];
    isTrash = json['IsTrash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['SignDate'] = this.signDate;
    data['SignDateString'] = this.signDateString;
    data['StartDate'] = this.startDate;
    data['StartDateString'] = this.startDateString;
    data['EndDate'] = this.endDate;
    data['EndDateString'] = this.endDateString;
    data['TotalMoney'] = this.totalMoney;
    data['IsDeleted'] = this.isDeleted;
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    data['IsDelete'] = this.isDelete;
    data['IsRestore'] = this.isRestore;
    data['IsTrash'] = this.isTrash;
    return data;
  }
}

class Attachments {
  int iD;
  String fileName;
  String filePath;
  String phaseName;
  int phaseID;
  bool isDelete;
  bool isView;
  bool isEdit;

  Attachments(
      {this.iD,
      this.fileName,
      this.filePath,
      this.phaseName,
      this.phaseID,
      this.isDelete,
      this.isView,
      this.isEdit});

  Attachments.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    phaseName = json['PhaseName'];
    phaseID = json['PhaseID'];
    isDelete = json['IsDelete'];
    isView = json['IsView'];
    isEdit = json['IsEdit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    data['PhaseName'] = this.phaseName;
    data['PhaseID'] = this.phaseID;
    data['IsDelete'] = this.isDelete;
    data['IsView'] = this.isView;
    data['IsEdit'] = this.isEdit;
    return data;
  }
}
