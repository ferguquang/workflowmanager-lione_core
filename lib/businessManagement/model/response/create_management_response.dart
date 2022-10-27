import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class CreateManagementResponse extends BaseResponse {
  DataCreateManagement data;

  CreateManagementResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataCreateManagement.fromJson(json['Data'])
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

class DataCreateManagement {
  List<Seller> customers;
  List<TypeProjects> typeBusiness;
  List<TypeProjects> contacts;
  List<TypeProjects> typeProjects;
  List<TypeProjects> provinces;
  List<TypeProjects> potentialTypes;
  List<TypeProjects> phases;
  List<TypeProjects> campaignTypes;
  List<TypeProjects> centers;
  List<Seller> sellers;
  ProjectPlan projectPlan;
  List<TypeProjectMoney> typeProjectMoney;
  bool isSelectSeller;
  bool isSelectTypeBusiness;
  bool isSelectCustomer;
  bool isSelectContact;
  bool isChangePhase;

  DataCreateManagement(
      {this.customers,
      this.typeBusiness,
      this.contacts,
      this.typeProjects,
      this.provinces,
      this.potentialTypes,
      this.phases,
      this.campaignTypes,
      this.centers,
      this.sellers,
      this.projectPlan,
      this.typeProjectMoney,
      this.isSelectSeller,
      this.isSelectTypeBusiness,
      this.isSelectCustomer,
      this.isSelectContact,
      this.isChangePhase});

  DataCreateManagement.fromJson(Map<String, dynamic> json) {
    if (json['Customers'] != null) {
      customers = new List<Seller>();
      json['Customers'].forEach((v) {
        customers.add(new Seller.fromJson(v));
      });
    }
    if (json['TypeBusiness'] != null) {
      typeBusiness = new List<TypeProjects>();
      json['TypeBusiness'].forEach((v) {
        typeBusiness.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['Contacts'] != null) {
      contacts = new List<TypeProjects>();
      json['Contacts'].forEach((v) {
        contacts.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['TypeProjects'] != null) {
      typeProjects = new List<TypeProjects>();
      json['TypeProjects'].forEach((v) {
        typeProjects.add(new TypeProjects.fromJson(v));
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
    if (json['Phases'] != null) {
      phases = new List<TypeProjects>();
      json['Phases'].forEach((v) {
        phases.add(new TypeProjects.fromJson(v));
      });
    }
    if (json['CampaignTypes'] != null) {
      campaignTypes = new List<TypeProjects>();
      json['CampaignTypes'].forEach((v) {
        campaignTypes.add(new TypeProjects.fromJson(v));
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
    projectPlan = json['ProjectPlan'] != null
        ? new ProjectPlan.fromJson(json['ProjectPlan'])
        : null;
    if (json['TypeProjectMoney'] != null) {
      typeProjectMoney = new List<TypeProjectMoney>();
      json['TypeProjectMoney'].forEach((v) {
        typeProjectMoney.add(new TypeProjectMoney.fromJson(v));
      });
    }
    isSelectSeller = json['IsSelectSeller'];
    isSelectTypeBusiness = json['IsSelectTypeBusiness'];
    isSelectCustomer = json['IsSelectCustomer'];
    isSelectContact = json['IsSelectContact'];
    isChangePhase = json['IsChangePhase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customers != null) {
      data['Customers'] = this.customers.map((v) => v.toJson()).toList();
    }
    if (this.typeBusiness != null) {
      data['TypeBusiness'] = this.typeBusiness.map((v) => v.toJson()).toList();
    }
    if (this.contacts != null) {
      data['Contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    if (this.typeProjects != null) {
      data['TypeProjects'] = this.typeProjects.map((v) => v.toJson()).toList();
    }
    if (this.provinces != null) {
      data['Provinces'] = this.provinces.map((v) => v.toJson()).toList();
    }
    if (this.potentialTypes != null) {
      data['PotentialTypes'] =
          this.potentialTypes.map((v) => v.toJson()).toList();
    }
    if (this.phases != null) {
      data['Phases'] = this.phases.map((v) => v.toJson()).toList();
    }
    if (this.campaignTypes != null) {
      data['CampaignTypes'] =
          this.campaignTypes.map((v) => v.toJson()).toList();
    }
    if (this.centers != null) {
      data['Centers'] = this.centers.map((v) => v.toJson()).toList();
    }
    if (this.sellers != null) {
      data['Sellers'] = this.sellers.map((v) => v.toJson()).toList();
    }
    if (this.projectPlan != null) {
      data['ProjectPlan'] = this.projectPlan.toJson();
    }
    if (this.typeProjectMoney != null) {
      data['TypeProjectMoney'] =
          this.typeProjectMoney.map((v) => v.toJson()).toList();
    }
    data['IsSelectSeller'] = this.isSelectSeller;
    data['IsSelectTypeBusiness'] = this.isSelectTypeBusiness;
    data['IsSelectCustomer'] = this.isSelectCustomer;
    data['IsSelectContact'] = this.isSelectContact;
    data['IsChangePhase'] = this.isChangePhase;
    return data;
  }
}

class TypeProjectMoney {
  int moneyID;
  int moneyIDTypeProject;
  String moneyTotalMoney;
  String moneyCapital;
  String grossProfit;
  bool isDelete = false;
  TypeProjects typeProject;
  String nameTypeProject;

  TypeProjectMoney(
      {this.moneyID,
      this.moneyIDTypeProject,
      this.moneyTotalMoney,
      this.moneyCapital,
      this.grossProfit,
      this.isDelete,
      this.typeProject,
      this.nameTypeProject});

  TypeProjectMoney.fromJson(Map<String, dynamic> json) {
    moneyID = json['ID'];
    moneyIDTypeProject = json['IDTypeProject'];
    moneyTotalMoney = json['TotalMoney'];
    moneyCapital = json['Capital'];
    grossProfit = json['GrossProfit'];
    isDelete = json['IsDelete'];
    typeProject = json['TypeProject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.moneyID;
    data['IDTypeProject'] = this.moneyIDTypeProject;
    data['TotalMoney'] = this.moneyTotalMoney;
    data['Capital'] = this.moneyCapital;
    data['GrossProfit'] = this.grossProfit;
    data['IsDelete'] = this.isDelete;
    data['TypeProject'] = this.typeProject;
    return data;
  }
}

class TypeProjects {
  int iD;
  String key;
  String name;
  bool isEnable;
  bool isSelected = false;

  TypeProjects({this.iD, this.key, this.name, this.isEnable, this.isSelected});

  TypeProjects.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    key = json['Key'];
    name = json['Name'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Key'] = this.key;
    data['Name'] = this.name;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class ProjectPlan {
  List<DataFields> dataFields;
  String potentialTypeDescribe;
  int potentialTypeSuccessPercent;

  ProjectPlan(
      {this.dataFields,
      this.potentialTypeDescribe,
      this.potentialTypeSuccessPercent});

  ProjectPlan.fromJson(Map<String, dynamic> json) {
    if (json['DataFields'] != null) {
      dataFields = new List<DataFields>();
      json['DataFields'].forEach((v) {
        dataFields.add(new DataFields.fromJson(v));
      });
    }
    potentialTypeDescribe = json['PotentialTypeDescribe'];
    potentialTypeSuccessPercent = json['PotentialTypeSuccessPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataFields != null) {
      data['DataFields'] = this.dataFields.map((v) => v.toJson()).toList();
    }
    data['PotentialTypeDescribe'] = this.potentialTypeDescribe;
    data['PotentialTypeSuccessPercent'] = this.potentialTypeSuccessPercent;
    return data;
  }
}

class DataFields {
  String title;
  String name;
  String value;
  bool isUpdate;
  bool isTemp;

  DataFields({this.title, this.name, this.value, this.isUpdate, this.isTemp});

  DataFields.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    name = json['Name'];
    value = json['Value'];
    isUpdate = json['IsUpdate'];
    isTemp = json['IsTemp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['IsUpdate'] = this.isUpdate;
    data['IsTemp'] = this.isTemp;
    return data;
  }
}
