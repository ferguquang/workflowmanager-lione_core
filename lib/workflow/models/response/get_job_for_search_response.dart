import 'package:workflow_manager/base/models/base_response.dart';

class GetJobGroupForSearchResponse extends BaseResponse {
  List<GetJobForSearchData> data;

  GetJobGroupForSearchResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<GetJobForSearchData>();
      json['Data'].forEach((v) {
        data.add(new GetJobForSearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class GetJobForSearchData {
  int iD;
  String name;

  GetJobForSearchData({this.iD, this.name});

  GetJobForSearchData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}
