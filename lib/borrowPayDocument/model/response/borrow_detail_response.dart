import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';

class BorrowDetailResponse extends BaseResponse {
  DataBorrowDetail data;

  BorrowDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataBorrowDetail.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class DataBorrowDetail {
  StgDocBorrows stgDocBorrow;

  DataBorrowDetail({this.stgDocBorrow});

  DataBorrowDetail.fromJson(Map<String, dynamic> json) {
    stgDocBorrow = json['StgDocBorrow'] != null
        ? new StgDocBorrows.fromJson(json['StgDocBorrow'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stgDocBorrow != null) {
      data['StgDocBorrow'] = this.stgDocBorrow.toJson();
    }
    return data;
  }
}
