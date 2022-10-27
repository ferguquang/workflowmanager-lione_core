import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/requisition_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class RequisitionDetailRepository with ChangeNotifier {
  DataRequisitionDetail dataPlanningDetail = DataRequisitionDetail();
  List<ContentShoppingModel> listDetail = [];
  // List<ContentShoppingModel> listSubDetail = [];

  Future<void> getRequisitionDetail(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsRequisitionDetail, params);
    RequisitionDetailResponse response = RequisitionDetailResponse.fromJson(json);
    if (response.status == 1) {
      dataPlanningDetail = response.data;
      listDetail.clear();
      listDetail.add(ContentShoppingModel(
          title: "Mã yêu cầu",
          value: "${dataPlanningDetail.requisition.requisitionNumber}"));
      listDetail.add(ContentShoppingModel(
          title: "Loại đề nghị",
          value: "${dataPlanningDetail.requisition.suggestionType}"));
      listDetail.add(ContentShoppingModel(
          title: "Hình thức mua sắm",
          value: "${dataPlanningDetail.requisition.shoppingType}"));
      listDetail.add(ContentShoppingModel(
          title: "Mục đích",
          value: "${dataPlanningDetail.requisition.purpose}"));
      listDetail.add(ContentShoppingModel(
          title: "Người đề nghị",
          value: "${dataPlanningDetail.requisition.requestBy}"));
      listDetail.add(ContentShoppingModel(
          title: "Bộ phận đề nghị",
          value: "${dataPlanningDetail.requisition.dept.name}"));
      listDetail.add(ContentShoppingModel(
          title: "Ngày yêu cầu",
          value:
              "${convertTimeStampToHumanDate(dataPlanningDetail.requisition.requestDate, "dd/MM/yyyy")}"));
      listDetail.add(ContentShoppingModel(
          title: "Dự án", value: "${dataPlanningDetail.requisition.project}"));
      listDetail.add(ContentShoppingModel(
          title: "Chủ đầu tư",
          value: "${dataPlanningDetail.requisition.investor}"));
      listDetail.add(ContentShoppingModel(
          title: "Trạng thái",
          value: "${dataPlanningDetail.requisition.status}"));
      listDetail.add(ContentShoppingModel(
          title: "Ghi chú lý do",
          value: isNotNullOrEmpty(dataPlanningDetail.requisition.reason) &&
                  dataPlanningDetail.requisition.reason != "null"
              ? "${dataPlanningDetail.requisition.reason}"
              : ""));
      listDetail
          .add(ContentShoppingModel(title: "Chi tiết", value: "Chi tiết"));
      listDetail.add(ContentShoppingModel(
          title: "Tổng cộng",
          value: "${dataPlanningDetail.requisition.totalAmount}"));
      listDetail.forEach((element) {
        if (element.title != "Chi tiết") {
          element.isNextPage = false;
        }
        if (element.title == "Ghi chú lý do" &&
            dataPlanningDetail.requisition.isNote) {
          element.isNextPage = true;
        }
      });

      notifyListeners();
    }
  }

  List<ContentShoppingModel> getSubDetail(RequisitionDetails itemClick, RequisitionDetails model) {
    List<ContentShoppingModel> listSubDetail = [];
    listSubDetail.add(ContentShoppingModel(
        title: "Tên hàng hóa - Mã sản phẩm", value: "${model.commodity}"));
    listSubDetail
        .add(ContentShoppingModel(title: "Hãng", value: isNotNullOrEmpty(model.manufactur) ? "${model.manufactur}" : ""));
    listSubDetail.add(ContentShoppingModel(
        title: "Danh mục hàng hóa", value: "${model.commodityCategory}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Mô tả hàng hóa", value: "${model.description}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Số lượng yêu cầu", value: "${model.qTY.toInt()}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Số lượng tồn kho", value: "${model.inventoryQTY.toInt()}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Số lượng duyệt mua", value: "${model.approvedQTY.toInt()}"));
    listSubDetail.add(
        ContentShoppingModel(title: "Đơn vị tính", value: "${model.unit}"));
    listSubDetail
        .add(ContentShoppingModel(title: "Xuất xứ", value: "${model.origin}"));
    listSubDetail.add(
        ContentShoppingModel(title: "Bảo hành", value: "${model.warranty}"));
    listSubDetail.add(
        ContentShoppingModel(title: "Đơn giá (VNĐ)", value: "${model.price}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Thành tiền", value: "${model.totalAmount}"));
    listSubDetail.add(
        ContentShoppingModel(title: "CO", isCheckbox: true, value: model.cO));
    listSubDetail.add(
        ContentShoppingModel(title: "CQ", isCheckbox: true, value: model.cQ));
    listSubDetail.add(ContentShoppingModel(
        title: "Chứng từ khác", isCheckbox: true, value: model.otherDoc));
    listSubDetail.add(ContentShoppingModel(
        title: "Ngày yêu cầu giao hàng",
        value:
            "${convertTimeStampToHumanDate(model.deliveryDate, "dd/MM/yyyy")}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Địa điểm giao hàng", value: "${model.deliveryDestination}"));
    listSubDetail.add(ContentShoppingModel(
        title: "Thời gian thuê", value: "${model.nbRent}"));
    listSubDetail.add(
        ContentShoppingModel(title: "Đơn vị thuê", value: "${model.rentType}"));
    listSubDetail
        .add(ContentShoppingModel(title: "Ghi chú", value: "${model.note}"));

    listSubDetail.forEach((element) {
      element.isNextPage = false;
    });

    return listSubDetail;
  }

  Future<int> requisitionApprove(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsRequisitionApprove, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    responseMessage.isSuccess();
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  Future<int> requisitionReject(int id, String note) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    params["Note"] = note;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsRequisitionReject, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    responseMessage.isSuccess();
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }
}