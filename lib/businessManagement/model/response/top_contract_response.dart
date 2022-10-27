import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class TopContractResponse extends BaseResponse {
  DataTopContract data;

  TopContractResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataTopContract.fromJson(json['Data'])
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

class DataTopContract {
  List<ContractInfos> contractInfos;
  SearchParam searchParam;
  int pageSize;
  int pageIndex;

  DataTopContract(
      {this.contractInfos, this.searchParam, this.pageSize, this.pageIndex});

  DataTopContract.fromJson(Map<String, dynamic> json) {
    pageSize = json['PageSize'];
    pageIndex = json['PageIndex'];
    if (json['ContractInfos'] != null) {
      contractInfos = new List<ContractInfos>();
      json['ContractInfos'].forEach((v) {
        contractInfos.add(new ContractInfos.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageSize'] = this.pageSize;
    data['PageIndex'] = this.pageIndex;
    if (this.contractInfos != null) {
      data['ContractInfos'] =
          this.contractInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class ContractInfos {
  int iDContract;
  String name;
  ProjectPlan projectPlan;
  String projectType;
  String businessType;
  int signDate;
  String sellerAvatar;
  String sellerName;
  String deptName;
  String position;

  ContractInfos(
      {this.iDContract,
      this.name,
      this.projectPlan,
      this.projectType,
      this.businessType,
      this.signDate,
      this.sellerAvatar,
      this.sellerName,
      this.deptName,
      this.position});

  ContractInfos.fromJson(Map<String, dynamic> json) {
    iDContract = json['IDContract'];
    name = json['Name'];
    projectPlan = json['ProjectPlan'] != null
        ? new ProjectPlan.fromJson(json['ProjectPlan'])
        : null;
    projectType = json['ProjectType'];
    businessType = json['BusinessType'];
    signDate = json['SignDate'];
    sellerAvatar = json['SellerAvatar'];
    sellerName = json['SellerName'];
    deptName = json['DeptName'];
    position = json['Position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDContract'] = this.iDContract;
    data['Name'] = this.name;
    if (this.projectPlan != null) {
      data['ProjectPlan'] = this.projectPlan.toJson();
    }
    data['ProjectType'] = this.projectType;
    data['BusinessType'] = this.businessType;
    data['SignDate'] = this.signDate;
    data['SellerAvatar'] = this.sellerAvatar;
    data['SellerName'] = this.sellerName;
    data['DeptName'] = this.deptName;
    data['Position'] = this.position;
    return data;
  }
}

class ProjectPlan {
  int iD;
  String name;

  ProjectPlan({this.iD, this.name});

  ProjectPlan.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}
