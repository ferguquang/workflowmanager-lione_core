import 'filter_request.dart';

class ReportStatusRequest extends FilterRequest {

  ReportStatusRequest();

  ReportStatusRequest.from(FilterRequest request) {
    this.startDate = request.startDate;
    this.endDate = request.endDate;
  }

}
