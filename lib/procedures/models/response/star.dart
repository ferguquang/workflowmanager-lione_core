class Star {
  int iDServiceRecord;
  int iDService;
  int isRegisterView;
  double star;
  int numberEval;
  String title;


  Star({this.iDServiceRecord, this.iDService, this.isRegisterView, this.star});

  Star.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    iDService = json['IDService'];
    isRegisterView = json['IsRegisterView'];
    star = json['Star'];
    numberEval = json['NumberEval'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['IDServiceRecord'] = iDServiceRecord;
    json['IDService'] = iDService;
    json['IsRegisterView'] = isRegisterView;
    json['Star'] = star;
    json['NumberEval'] = numberEval;
    json['Title'] = title;
    return json;
  }
}
