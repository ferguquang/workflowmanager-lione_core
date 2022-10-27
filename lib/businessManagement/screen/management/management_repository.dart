import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/list_plans_request.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';

import '../../../main.dart';

class ManagementRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  DataProjectPlanIndex dataPlan;

  List<ProjectPlanItem> listProjectPlans;

  ListPlansRequest listPlanRequest = ListPlansRequest();

  // danh sách quản lý
  Future<bool> getProjectPlanIndex(bool isOnlyView) async {
    // isOnlyView = true là khách, false là admin
    // bool isLoading = true;
    // if (this.listPlanRequest.pageIndex != 1) {
    //   isLoading = false;
    // }
    final response = await apiCaller.postFormData(
        isOnlyView ? AppUrl.getGuestPlaceIndex : AppUrl.getProjectPlanIndex,
        listPlanRequest.getParams(),
        isLoading: this.listPlanRequest.pageIndex == 1);

    ProjectPlanIndexResponse _projectPlanIndexResponse =
        ProjectPlanIndexResponse.fromJson(response);

    if (_projectPlanIndexResponse.status == 1) {
      dataPlan = _projectPlanIndexResponse.data;
      if (listPlanRequest.pageIndex == 1) {
        listProjectPlans = [];
        listProjectPlans = _projectPlanIndexResponse.data.projectPlans;
      } else {
        listProjectPlans.addAll(_projectPlanIndexResponse.data.projectPlans);
      }
      eventBus.fire(GetListDataFilterManagerEventBus(
          plansRequest: this.listPlanRequest,
          searchParam: dataPlan.searchParam));
      notifyListeners();
    } else {
      ToastMessage.show(_projectPlanIndexResponse.messages, ToastStyle.error);
    }
  }
}
