import 'package:workflow_manager/base/models/base_response.dart';

class BorrowIndexResponse extends BaseResponse {
  DataBorrowIndex data;

  BorrowIndexResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataBorrowIndex.fromJson(json['Data'])
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

class DataBorrowIndex {
  List<StgDocBorrows> stgDocBorrows;
  int totalPending;
  int totalApproved;
  int totalRejected;
  int totalBorrowed;
  int totalDisabled;
  int totalClosed;
  int totalApprovedExpried;
  int totalBorrowedExpried;
  bool isShowButtonBorrow;

  DataBorrowIndex(
      {this.stgDocBorrows,
      this.totalPending,
      this.totalApproved,
      this.totalRejected,
      this.totalBorrowed,
      this.totalDisabled,
      this.totalClosed,
      this.totalApprovedExpried,
      this.totalBorrowedExpried,
      this.isShowButtonBorrow});

  DataBorrowIndex.fromJson(Map<String, dynamic> json) {
    if (json['StgDocBorrows'] != null) {
      stgDocBorrows = new List<StgDocBorrows>();
      json['StgDocBorrows'].forEach((v) {
        stgDocBorrows.add(new StgDocBorrows.fromJson(v));
      });
    }
    totalPending = json['TotalPending'];
    totalApproved = json['TotalApproved'];
    totalRejected = json['TotalRejected'];
    totalBorrowed = json['TotalBorrowed'];
    totalDisabled = json['TotalDisabled'];
    totalClosed = json['TotalClosed'];
    totalApprovedExpried = json['TotalApprovedExpried'];
    totalBorrowedExpried = json['TotalBorrowedExpried'];
    isShowButtonBorrow = json['IsShowButtonBorrow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stgDocBorrows != null) {
      data['StgDocBorrows'] =
          this.stgDocBorrows.map((v) => v.toJson()).toList();
    }
    data['TotalPending'] = this.totalPending;
    data['TotalApproved'] = this.totalApproved;
    data['TotalRejected'] = this.totalRejected;
    data['TotalBorrowed'] = this.totalBorrowed;
    data['TotalDisabled'] = this.totalDisabled;
    data['TotalClosed'] = this.totalClosed;
    data['TotalApprovedExpried'] = this.totalApprovedExpried;
    data['TotalBorrowedExpried'] = this.totalBorrowedExpried;
    data['IsShowButtonBorrow'] = this.isShowButtonBorrow;
    return data;
  }
}

class StgDocBorrowFiles {
  String filePath;
  String fileName;

  StgDocBorrowFiles({this.filePath, this.fileName});

  StgDocBorrowFiles.fromJson(Map<String, dynamic> json) {
    filePath = json['FilePath'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FilePath'] = this.filePath;
    data['FileName'] = this.fileName;
    return data;
  }
}

class StgDocBorrows {
  int iD;
  int iDDoc;
  String name;
  String extension;
  String symbolNo;
  String describe;
  String reason;
  String note;
  bool isBorrowRead;
  bool isBorrowBackup;
  bool isBorrowCopy;
  bool isBorrowTake;
  bool isBorrowCertifiedCopy;
  List<String> purposes;
  int statusID;
  String statusName;
  String statusColor;
  String reasonRD;
  List<StgDocBorrowFiles> stgDocBorrowFiles;
  Borrower borrower;
  String phone;
  String receiver;
  int created;
  int startDate;
  int endDate;
  Borrower leader;
  Borrower archiver;
  Borrower approver;
  bool isFolder;
  bool isApproved;
  bool isRejected;
  bool isDisabled;
  bool isBorrowed;
  bool isClosed;
  bool isBorrowMutil;
  bool isForwardLD;
  bool isBorrowDelete;
  String titleForwardLD;
  bool isForwardVT;
  String titleForwardVT;
  bool isRejectedVT;
  int iDModuleLD;
  int iDModuleVT;
  bool isSelected = false;
  String path;

  StgDocBorrows(
      {this.iD,
      this.iDDoc,
      this.name,
      this.path,
      this.extension,
      this.symbolNo,
      this.describe,
      this.reason,
      this.note,
      this.isBorrowRead,
      this.isBorrowBackup,
      this.isBorrowCopy,
      this.isBorrowTake,
      this.isBorrowCertifiedCopy,
      this.purposes,
      this.statusID,
      this.statusName,
      this.statusColor,
      this.reasonRD,
      this.stgDocBorrowFiles,
      this.borrower,
      this.phone,
      this.receiver,
      this.created,
      this.startDate,
      this.endDate,
      this.leader,
      this.archiver,
      this.approver,
      this.isFolder,
      this.isApproved,
      this.isRejected,
      this.isDisabled,
      this.isBorrowed,
      this.isClosed,
      this.isBorrowMutil,
      this.isForwardLD,
      this.titleForwardLD,
      this.isForwardVT,
      this.titleForwardVT,
      this.isRejectedVT,
      this.iDModuleLD,
      this.iDModuleVT,
      this.isBorrowDelete});

  StgDocBorrows.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDDoc = json['IDDoc'];
    name = json['Name'];
    path = json['Path'];
    extension = json['Extension'];
    symbolNo = json['SymbolNo'];
    describe = json['Describe'];
    reason = json['Reason'];
    note = json['Note'];
    isBorrowRead = json['IsBorrowRead'];
    isBorrowBackup = json['IsBorrowBackup'];
    isBorrowCopy = json['IsBorrowCopy'];
    isBorrowTake = json['IsBorrowTake'];
    isBorrowCertifiedCopy = json['IsBorrowCertifiedCopy'];
    isBorrowDelete = json['IsBorrowDelete'];
    purposes = json['Purposes'].cast<String>();
    statusID = json['StatusID'];
    statusName = json['StatusName'];
    statusColor = json['StatusColor'];
    reasonRD = json['ReasonRD'];
    if (json['stgDocBorrowFiles'] != null) {
      stgDocBorrowFiles = new List<StgDocBorrowFiles>();
      json['stgDocBorrowFiles'].forEach((v) {
        stgDocBorrowFiles.add(new StgDocBorrowFiles.fromJson(v));
      });
    }
    borrower = json['Borrower'] != null
        ? new Borrower.fromJson(json['Borrower'])
        : null;
    phone = json['Phone'];
    receiver = json['Receiver'];
    created = json['Created'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    leader =
        json['Leader'] != null ? new Borrower.fromJson(json['Leader']) : null;
    archiver = json['Archiver'] != null
        ? new Borrower.fromJson(json['Archiver'])
        : null;
    approver = json['Approver'] != null
        ? new Borrower.fromJson(json['Approver'])
        : null;
    isFolder = json['IsFolder'];
    isApproved = json['IsApproved'];
    isRejected = json['IsRejected'];
    isDisabled = json['IsDisabled'];
    isBorrowed = json['IsBorrowed'];
    isClosed = json['IsClosed'];
    isBorrowMutil = json['IsBorrowMutil'];
    isForwardLD = json['IsForwardLD'];
    titleForwardLD = json['TitleForwardLD'];
    isForwardVT = json['IsForwardVT'];
    titleForwardVT = json['TitleForwardVT'];
    isRejectedVT = json['IsRejectedVT'];
    iDModuleLD = json['IDModuleLD'];
    iDModuleVT = json['IDModuleVT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDDoc'] = this.iDDoc;
    data['Name'] = this.name;
    data['Path'] = this.path;
    data['Extension'] = this.extension;
    data['SymbolNo'] = this.symbolNo;
    data['Describe'] = this.describe;
    data['Reason'] = this.reason;
    data['Note'] = this.note;
    data['IsBorrowRead'] = this.isBorrowRead;
    data['IsBorrowBackup'] = this.isBorrowBackup;
    data['IsBorrowCopy'] = this.isBorrowCopy;
    data['IsBorrowTake'] = this.isBorrowTake;
    data['IsBorrowCertifiedCopy'] = this.isBorrowCertifiedCopy;
    data['Purposes'] = this.purposes;
    data['StatusID'] = this.statusID;
    data['StatusName'] = this.statusName;
    data['StatusColor'] = this.statusColor;
    data['ReasonRD'] = this.reasonRD;
    if (this.stgDocBorrowFiles != null) {
      data['stgDocBorrowFiles'] =
          this.stgDocBorrowFiles.map((v) => v.toJson()).toList();
    }
    if (this.borrower != null) {
      data['Borrower'] = this.borrower.toJson();
    }
    data['Phone'] = this.phone;
    data['Receiver'] = this.receiver;
    data['Created'] = this.created;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    if (this.leader != null) {
      data['Leader'] = this.leader.toJson();
    }
    if (this.archiver != null) {
      data['Archiver'] = this.archiver.toJson();
    }
    if (this.approver != null) {
      data['Approver'] = this.approver.toJson();
    }
    data['IsFolder'] = this.isFolder;
    data['IsApproved'] = this.isApproved;
    data['IsRejected'] = this.isRejected;
    data['IsDisabled'] = this.isDisabled;
    data['IsBorrowed'] = this.isBorrowed;
    data['IsClosed'] = this.isClosed;
    data['IsBorrowMutil'] = this.isBorrowMutil;
    data['IsForwardLD'] = this.isForwardLD;
    data['TitleForwardLD'] = this.titleForwardLD;
    data['IsForwardVT'] = this.isForwardVT;
    data['TitleForwardVT'] = this.titleForwardVT;
    data['IsRejectedVT'] = this.isRejectedVT;
    data['IDModuleLD'] = this.iDModuleLD;
    data['IDModuleVT'] = this.iDModuleVT;
    data['IsBorrowDelete'] = this.isBorrowDelete;
    return data;
  }
}

class Borrower {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;

  Borrower(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept});

  Borrower.fromJson(Map<String, dynamic> json) {
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
