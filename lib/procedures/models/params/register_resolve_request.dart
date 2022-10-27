import 'filter_request.dart';

class RegisterResolveRequest extends FilterRequest {

  RegisterResolveRequest();

  RegisterResolveRequest.from(FilterRequest request) {
    this.startDate = request.startDate;
    this.endDate = request.endDate;
    this.filterYear = request.filterYear;
  }

}
