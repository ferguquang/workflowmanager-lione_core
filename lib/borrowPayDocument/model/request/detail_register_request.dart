import 'package:workflow_manager/base/utils/common_function.dart';

class DetailRegisterRequest {
  String fileName;
  String filePath;
  String note;
  String startDate;
  String endDate;
  String reason;

  String nameBorrower;
  String phoneNumber;
  String consultByName;
  int idConsultByName;
  int iDDoc;
  //đọc,sao lưu,copy,bản cứng,bản sao y
  bool isBorrowRead = false;
  bool isBorrowBackup = false;
  bool isBorrowCopy = false;
  bool isBorrowTake = false;
  bool isBorrowCertifiedCopy = false;
  // lãnh đạo, Văn thư
  bool isLD = false;
  bool isVT = false;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isLD) {
      // người mượn
      params["Receiver"] = this.nameBorrower;
      //  số điện thoại người mượn
      params["Phone"] = this.phoneNumber;
      // tên lãnh đạo
      params["ConsultByName"] = this.consultByName;
      // ID lãnh đạo
      params["ConsultBy"] = this.idConsultByName;
    } else if (isVT) {
      // tên văn thư
      params["ArchiveByName"] = this.consultByName;
      // ID văn thư
      params["ArchiveBy"] = this.idConsultByName;
    } else {
      // tên trưởng phòng
      params["LeadDeptByName"] = this.consultByName;
      // ID trưởng phòng
      params["LeadDeptBy"] = this.idConsultByName;
    }

    params["IDDoc"] = this.iDDoc;
    params["Reason"] = this.reason;
    params["Note"] = this.note;
    params["StartDate"] = this.startDate;
    params["EndDate"] = this.endDate;

    params["IsBorrowRead"] = this.isBorrowRead;
    params["IsBorrowBackup"] = this.isBorrowBackup;
    params["IsBorrowCopy"] = this.isBorrowCopy;
    params["IsBorrowTake"] = this.isBorrowTake;
    params["IsBorrowCertifiedCopy"] = this.isBorrowCertifiedCopy;

    if (isNotNullOrEmpty(fileName) && isNotNullOrEmpty(filePath)) {
      params["FileName"] = this.fileName;
      params["FilePath"] = this.filePath;
    }

    return params;
  }
}
