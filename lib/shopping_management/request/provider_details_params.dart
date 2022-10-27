class ProviderDetailsParams {
  int id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    return params;
  }
}

class ProviderDetailsApproveParams {
  int id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    return params;
  }
}

class ProviderDetailsRejectParams {
  int id;
  String reason;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    if (reason != null) {
      params["Reason"] = reason;
    }
    return params;
  }
}

class ProviderSendApproveParams {
  int iDRecord;
  String fromMail;
  int toMail;
  String cCMail;
  String subject;
  String content;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDRecord"] = iDRecord;
    params["FromMail"] = fromMail;
    params["ToMail"] = toMail;
    params["CCMail"] = cCMail;
    params["Subject"] = subject;
    params["Content"] = content;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}
