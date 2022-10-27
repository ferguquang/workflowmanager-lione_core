import 'package:workflow_manager/base/models/base_response.dart';

class ImportReportResponse extends BaseResponse {
  DataImportReport data;

  ImportReportResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataImportReport.fromJson(json['Data']) : null;
  }
}

class DataImportReport {
  List<ImportReport> report;
  int totalRecord;

  DataImportReport({this.report, this.totalRecord});

  DataImportReport.fromJson(Map<String, dynamic> json) {
    if (json['Report'] != null) {
      report = new List<ImportReport>();
      json['Report'].forEach((v) {
        report.add(new ImportReport.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
  }
}

class ImportReport {
  String codeCommodity;
  String nameCommodity;
  String codeContract;
  String nameProvider;
  String qTY;
  String actDeliveryDate;
  String totalAmount;
  String currency;

  ImportReport(
      {this.codeCommodity,
        this.nameCommodity,
        this.codeContract,
        this.nameProvider,
        this.qTY,
        this.actDeliveryDate,
        this.totalAmount,
        this.currency});

  ImportReport.fromJson(Map<String, dynamic> json) {
    codeCommodity = json['CodeCommodity'];
    nameCommodity = json['NameCommodity'];
    codeContract = json['CodeContract'];
    nameProvider = json['NameProvider'];
    qTY = json['QTY'];
    actDeliveryDate = json['ActDeliveryDate'];
    totalAmount = json['TotalAmount'];
    currency = json['Currency'];
  }
}
