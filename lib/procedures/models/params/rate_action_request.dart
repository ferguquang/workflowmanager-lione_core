
class IsRateServiceRequest {
  int idServiceRecord;

  IsRateServiceRequest({this.idServiceRecord});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IDServiceRecord"] = idServiceRecord;
    return params;
  }
}

class SaveRateServiceRequest {
  dynamic content, idService, idServiceRecord, idServiceRecordRate, star;

  SaveRateServiceRequest({this.content, this.idService, this.idServiceRecord, this.idServiceRecordRate, this.star});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Content"] = content;
    params["IDService"] = idService;
    params["IDServiceRecord"] = idServiceRecord;
    params["IDServiceRecordRate"] = idServiceRecordRate;
    params["Star"] = star;
    return params;
  }
}