import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import 'request/list_plans_request.dart';
import 'request/over_view_request.dart';
import 'response/detail_contract_response.dart';
import 'response/project_plan_index_response.dart';
import 'response/revenue_phased_response.dart';

// dành cho tab doanh thu - theo giai đoạn
class GetListDataRevenueEventBus {
  DataRevenuePhased dataRevenuePhased;
  List<ColorNotes> colorNotes;

  GetListDataRevenueEventBus(this.dataRevenuePhased, this.colorNotes);
}

// dành cho tab doanh thu - theo kế hoạch
class GetListDataOverviewEventBus {
  DataOverView dataOverView;
  List<ColorNotes> colorNotes;

  GetListDataOverviewEventBus(this.dataOverView, this.colorNotes);
}

// truyền các dữ liệu ở các tab thống kê về class filter_statistic_screen.dart
// khi call api để lấy dữ liệu lọc, chỉ lấy lần đầu tiên
class GetListDataFilterStatisticEventBus {
  SearchParam searchParam;
  int numberTabFilter;

  GetListDataFilterStatisticEventBus({this.numberTabFilter, this.searchParam});
}

// truyền request class filter_statistic_screen.dart đến các tab thống kê
class GetRequestFilterToTabEventBus {
  OverViewRequest request;
  int numberTabFilter;

  GetRequestFilterToTabEventBus({this.numberTabFilter, this.request});
}

// event truyền quyền admin hoặc khách từ class business_management_repository.dart đến management_screen.dart
class GetDataIsOnlyViewEventBus {
  bool isOnlyView;

  GetDataIsOnlyViewEventBus({this.isOnlyView});
}

// ddành cho tạo mới cơ hội, và các action khác trên bottomsheet
class GetDataSaveEventBus {
  bool isCheckData;

  GetDataSaveEventBus({this.isCheckData});
}

// tạo, sửa hơp đồng create_contract_repository.dart truyền cho danh sách contract_opportunity_screen.dart hoặc detail_contract_screen.dart
class GetDataContractEventBus {
  bool isCreate;
  Contracts contracts;

  GetDataContractEventBus(this.contracts, this.isCreate);
}

//detail_contract_screen.dart truyền cho information_contract_screen.dart
class GetDataContractDetailEventBus {
  ContractDetail contracts;

  GetDataContractDetailEventBus(this.contracts);
}

//bottom_sheet_create_phase_repository.dart truyền cho stage_payment_contract_screen.dart
class GetDataContractPaymentsEventBus {
  ContractPayments contracts;
  bool isCreate;

  GetDataContractPaymentsEventBus(this.contracts, this.isCreate);
}

// lấy dữ liệu từ danh sách quản lý truyền cho lọc
class GetListDataFilterManagerEventBus {
  SearchParamListManage searchParam;

  ListPlansRequest plansRequest;

  GetListDataFilterManagerEventBus({this.searchParam, this.plansRequest});
}

// truyền request class management_filter_screen.dart đến management_screen.dart
class GetRequestFilterToManagerEventBus {
  ListPlansRequest plansRequest;

  GetRequestFilterToManagerEventBus({this.plansRequest});
}
