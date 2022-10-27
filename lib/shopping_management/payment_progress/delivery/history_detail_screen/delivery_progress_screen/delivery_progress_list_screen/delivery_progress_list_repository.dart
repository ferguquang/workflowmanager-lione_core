import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_list_response.dart';

class DeliveryProgressListRepository extends ChangeNotifier {
  DeliveryProgressListModel deliveryProgressListModel;
  bool isUpdate;
  List<double> listRemainQTY = [];
  List<double> listTotalQTY = [];

  loadData(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryProgress, {"ID": id});
    DeliveryProgressListResponse response =
        DeliveryProgressListResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryProgressListModel = response.data;
      if (isUpdate &&
          deliveryProgressListModel.deliveries.length >
              1) // dùng khi chỉnh sửa và có 1 phiếu đã hoàn tất trước đó
      {
        List<Deliveries> deliveryListNews = [];
        for (Deliveries data in deliveryProgressListModel.deliveries) {
          if (data.iDStatus == 5) // id trạng thái hoàn tất = 5
          {
            deliveryListNews.add(data);
          }
        }

        int lMax = 0;
        int iIDDelivery = 0;
        if (deliveryListNews.length > 0) {
          for (Deliveries data in deliveryListNews) {
            if (data.created > lMax) // ngày tạo của phiếu
            {
              lMax = data.created;
              iIDDelivery = data.iD;
            }
          }

          var json = await ApiCaller.instance.postFormData(
              AppUrl.qlmsUpdateDeliveryProgress, {"ID": iIDDelivery});
          DeliveryProgressDetailResponse response =
              DeliveryProgressDetailResponse.fromJson(json);
          if (response.isSuccess()) {
            DeliveryProgressDetailModel model = response.data;
            for (DetailDeliveries data in model.detailDeliveries) {
              listRemainQTY.add(data.remainQTY);
              listTotalQTY.add(data.totalQTY);
            }
          }
        }
      }
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
