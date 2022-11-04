class ApiSource {
  String apiLink;
  List<ApiParams> apiParams;

  ApiSource({this.apiLink, this.apiParams});

  ApiSource.fromJson(Map<String, dynamic> json) {
    apiLink = json['ApiLink'];
    if (json['ApiParams'] != null) {
      apiParams = <ApiParams>[];
      json['ApiParams'].forEach((v) {
        apiParams.add(new ApiParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ApiLink'] = this.apiLink;
    if (this.apiParams != null) {
      data['ApiParams'] = this.apiParams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApiParams {
  String paramName;
  int scope;
  int iDParam;
  String code;

  ApiParams({this.paramName, this.scope, this.iDParam, this.code});

  ApiParams.fromJson(Map<String, dynamic> json) {
    paramName = json['ParamName'];
    scope = json['Scope'];
    iDParam = json['IDParam'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ParamName'] = this.paramName;
    data['Scope'] = this.scope;
    data['IDParam'] = this.iDParam;
    data['Code'] = this.code;
    return data;
  }
}

