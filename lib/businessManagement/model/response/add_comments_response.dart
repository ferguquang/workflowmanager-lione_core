import 'package:workflow_manager/base/models/base_response.dart';

import 'detail_management_response.dart';

class AddCommentsResponse extends BaseResponse {
  DataAddComments data;

  AddCommentsResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataAddComments.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataAddComments {
  Comments comments;

  DataAddComments({
    this.comments,
  });

  DataAddComments.fromJson(Map<String, dynamic> json) {
    comments = Comments.fromJson(json['Comment']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Comment'] = this.comments;
  }
}
