import 'package:workflow_manager/base/models/base_response.dart';

import 'create_management_response.dart';

class SelectGroupCustomerResponse extends BaseResponse {
  DataSelectGroupCustomer data;

  SelectGroupCustomerResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataSelectGroupCustomer.fromJson(json['Data'])
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

class DataSelectGroupCustomer {
  List<TypeProjects> typeBusiness;
  List<TypeProjects> contacts;
  List<TypeProjects> phases;

  DataSelectGroupCustomer({this.typeBusiness, this.contacts, this.phases});

  DataSelectGroupCustomer.fromJson(Map<String, dynamic> json) {
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
    if (json['Phases'] != null) {
      phases = new List<TypeProjects>();
      json['Phases'].forEach((v) {
        phases.add(new TypeProjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.typeBusiness != null) {
      data['TypeBusiness'] = this.typeBusiness.map((v) => v.toJson()).toList();
    }
    if (this.contacts != null) {
      data['Contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    if (this.phases != null) {
      data['Phases'] = this.phases.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
