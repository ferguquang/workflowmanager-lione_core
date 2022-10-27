import 'filter_request.dart';

class ReportProcedureRequest extends FilterRequest {

  ReportProcedureRequest();

  ReportProcedureRequest.from(FilterRequest request) {
    this.startDate = request.startDate;
    this.endDate = request.endDate;
    this.filterYear = request.filterYear;
  }

}
