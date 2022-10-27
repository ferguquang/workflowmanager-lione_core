class SerialDetailParams {
  int providerId;
  String iDRequisition;
  String iDContract;
  String invoiceNumber;
  String invFilePath;
  String packingNumber;
  String packingFilePath;
  String cOName;
  String cOFilePath;
  String cQName;
  String cQFilePath;
  String bolNumber;
  String bolFilePath;
  String tkNumber;
  String tkFilePath;
  String otherFile;
  String otherFilePath;
  String iDCommodity;
  String serialNo;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDRequisition"] = iDRequisition;
    params["IDContract"] = iDContract;
    params["InvoiceNumber"] = invoiceNumber;
    params["InvFilePath"] = invFilePath;
    params["PackingNumber"] = packingNumber;
    params["PackingFilePath"] = packingFilePath;
    params["COName"] = cOName;
    params["COFilePath"] = cOFilePath;
    params["CQName"] = cQName;
    params["CQFilePath"] = cQFilePath;
    params["BolNumber"] = bolNumber;
    params["BolFilePath"] = bolFilePath;
    params["TkNumber"] = tkNumber;
    params["TkFilePath"] = tkFilePath;
    params["OtherFile"] = otherFile;
    params["OtherFilePath"] = otherFilePath;
    params["IDCommodity"] = iDCommodity;
    params["SerialNo"] = serialNo;
    if (providerId != null) params["ID"] = providerId;
    return params;
  }
}
