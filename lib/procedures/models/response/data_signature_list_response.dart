import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class DataSignatureListResponse extends BaseResponse {
  int status;
  DataSignatureList data;

  DataSignatureListResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DataSignatureList.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class DataSignatureList {
  List<Signatures> signatures;
  List<Signatures> signedSignatures;
  SignatureLocation signatureLocation;
  int pickIndex;

  DataSignatureList(
      {this.signatures, this.signedSignatures, this.signatureLocation});

  DataSignatureList.fromJson(Map<String, dynamic> json) {
    if (json['Signatures'] != null) {
      signatures = new List<Signatures>();
      json['Signatures'].forEach((v) {
        signatures.add(new Signatures.fromJson(v));
      });
    }
    if (json['SignedSignatures'] != null) {
      signedSignatures = new List<Signatures>();
      json['SignedSignatures'].forEach((v) {
        signedSignatures.add(new Signatures.fromJson(v));
      });
    }
    signatureLocation = isNotNullOrEmpty(json['SignatureLocation'])
        ? new SignatureLocation.fromJson(json['SignatureLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.signatures != null) {
      data['Signatures'] = this.signatures.map((v) => v.toJson()).toList();
    }
    if (this.signedSignatures != null) {
      data['SignedSignatures'] =
          this.signedSignatures.map((v) => v.toJson()).toList();
    }
    if (this.signatureLocation != null) {
      data['SignatureLocation'] = this.signatureLocation.toJson();
    }
    return data;
  }
}

class Signatures {
  int iD;
  String name;
  String fileName;
  String filePath;
  int created;
  int signedDate;
  CreatedBy createdBy;
  bool isError = false;

  Signatures(
      {this.iD,
      this.name,
      this.fileName,
      this.filePath,
      this.created,
      this.signedDate,
      this.createdBy});

  Signatures.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    created = json['Created'];
    signedDate = json['SignedDate'];
    createdBy = json['CreatedBy'] != null
        ? new CreatedBy.fromJson(json['CreatedBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    data['Created'] = this.created;
    data['SignedDate'] = this.signedDate;
    if (this.createdBy != null) {
      data['CreatedBy'] = this.createdBy.toJson();
    }
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

class SignatureLocation {
  int signPage;
  int totalPage;
  int page;
  double x;
  double y;
  double width;
  double height;
  double pageWidth;
  double pageHeight;

  SignatureLocation(
      {this.signPage,
      this.totalPage,
      this.page,
      this.x,
      this.y,
      this.width,
      this.height,
      this.pageWidth,
      this.pageHeight});

  SignatureLocation.fromJson(Map<String, dynamic> json) {
    signPage = json['SignPage'];
    totalPage = json['TotalPage'];
    page = json['Page'];
    x = json['X'];
    y = json['Y'];
    width = json['Width'];
    height = json['Height'];
    pageWidth = json['PageWidth'];
    pageHeight = json['PageHeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SignPage'] = this.signPage;
    data['TotalPage'] = this.totalPage;
    data['Page'] = this.page;
    data['X'] = this.x;
    data['Y'] = this.y;
    data['Width'] = this.width;
    data['Height'] = this.height;
    data['PageWidth'] = this.pageWidth;
    data['PageHeight'] = this.pageHeight;
    return data;
  }
}
