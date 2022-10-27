import 'package:workflow_manager/base/utils/common_function.dart';

class BorrowApprovedRequest {
  String reason;
  bool isBorrowRead;
  bool isBorrowBackup;
  bool isBorrowCopy;
  bool isBorrowTake;
  bool isBorrowCertifiedCopy;
  String startDate;
  String endDate;
  int id;
  int idDoc;

  String archiveByName;
  int archiveBy;
  String consultByName;
  int consultBy;

  String reasonRejected;

  String note;

  String reasonDisabled;
  String fileName;
  String filePath;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Reason"] = reason;
    params["IsBorrowRead"] = isBorrowRead;
    params["IsBorrowBackup"] = isBorrowBackup;
    params["IsBorrowCopy"] = isBorrowCopy;
    params["IsBorrowTake"] = isBorrowTake;
    params["IsBorrowCertifiedCopy"] = isBorrowCertifiedCopy;
    params["StartDate"] = startDate;
    params["EndDate"] = endDate;
    params["ID"] = id;
    params["IDDoc"] = idDoc;

    //duyệt, chuyển tiếp
    if (isNotNullOrEmpty(archiveByName))
      params["ArchiveByName"] = archiveByName;
    if (isNotNullOrEmpty(archiveBy)) params["ArchiveBy"] = archiveBy;
    if (isNotNullOrEmpty(consultByName))
      params["ConsultByName"] = consultByName;
    if (isNotNullOrEmpty(consultBy)) params["ConsultBy"] = consultBy;

    // Từ chối
    if (isNotNullOrEmpty(reasonRejected))
      params["ReasonRejected"] = reasonRejected;

    //đóng (thêm param của thu hồi)
    if (isNotNullOrEmpty(note)) params["Note"] = note;

    // thu hồi
    if (isNotNullOrEmpty(reasonDisabled))
      params["ReasonDisabled"] = reasonDisabled;
    if (isNotNullOrEmpty(fileName)) params["FileName"] = fileName;
    if (isNotNullOrEmpty(filePath)) params["FilePath"] = filePath;

    return params;
  }
}
