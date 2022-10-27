import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/ui/webview_screen.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/contracts_by_requisition.dart';
import 'package:workflow_manager/shopping_management/request/serial_detail_request.dart';
import 'package:workflow_manager/shopping_management/response/serial_detail_model.dart';
import 'package:workflow_manager/shopping_management/response/serial_detail_update_response.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';

class SerialDetailRepository extends ChangeNotifier {
  static const String INVOICE_DETAIL = "Số Invoice";
  static const String PACKING_DETAIL = "Số Packing List";
  static const String CO_DETAIL = "CO";
  static const String CQ_DETAIL = "CQ";
  static const String BILL_DETAIL = "Vận đơn";
  static const String TESTIMONY_DETAIL = "Lời khai";
  static const String OTHER_DETAIL = "Chứng từ khác";
  List<Requisitions> requisitions;
  List<Requisitions> contacts;
  List<Commodities> commodities;
  SerialDetailModel serialDetailModel;
  List<ContentShoppingModel> listItems = [];
  bool isEditing;
  bool isCreate;
  int iIDCodeRequest = -1;
  ContentShoppingModel codeRequestItem,
      codeContractItem,
      numberInvoiceItem,
      numberPackingListItem,
      cOItem,
      cQItem,
      billOfLadingItem,
      testimonyItem,
      otherItem;

  loadContractCode(int id) async {
    var json = await ApiCaller.instance
        .get(AppUrl.qlmsGetContractsByRequisition, params: {"ID": id});
    ContractsByRequisitionResponse detailReponse =
        ContractsByRequisitionResponse.fromJson(json);
    if (detailReponse.status == 1) {
      contacts = detailReponse.data.contracts;
      codeContractItem?.clearSelected();
      notifyListeners();
    } else {
      showErrorToast(detailReponse.messages);
    }
  }

  loadOrInitDate(int id) async {
    isCreate = id == null;
    if (id != null) {
      if (isEditing == false) {
        var json = await ApiCaller.instance
            .postFormData(AppUrl.qlmsSerialDetail, {"ID": id});
        SerialDetailReponse detailReponse = SerialDetailReponse.fromJson(json);
        if (detailReponse.status == 1) {
          serialDetailModel = detailReponse.data;
          addItem();
          notifyListeners();
        } else {
          showErrorToast(detailReponse.messages);
        }
      } else {
        var json = await ApiCaller.instance
            .postFormData(AppUrl.qlmsSerialUpdate, {"ID": id});
        SerialDetailUpdateResponse detailReponse =
            SerialDetailUpdateResponse.fromJson(json);
        if (detailReponse.status == 1) {
          SerialDetailUpdateModel model = detailReponse.data;
          serialDetailModel = SerialDetailModel(
              serial: model.serial,
              totalRecord: model.totalRecord,
              serialDetails: model.serialDetails);
          requisitions = model.requisitions;
          commodities = model.commodities;
          if (isNotNullOrEmpty(model?.serial?.requisition))
            await loadContractCode(model.serial.requisition[0].iD);
          addItem();
          notifyListeners();
        } else {
          showErrorToast(detailReponse.messages);
        }
      }
    } else {
      var json =
          await ApiCaller.instance.postFormData(AppUrl.qlmsSerialCreate, Map());
      SerialDetailUpdateResponse detailReponse =
          SerialDetailUpdateResponse.fromJson(json);
      if (detailReponse.status == 1) {
        SerialDetailUpdateModel model = detailReponse.data;
        serialDetailModel = SerialDetailModel(
            serial: Serial(requisition: [], contract: []), serialDetails: []);
        requisitions = model.requisitions;
        commodities = model.commodities;
        if (isNotNullOrEmpty(model?.serial?.requisition))
          await loadContractCode(model.serial.requisition[0].iD);
      } else {
        showErrorToast(detailReponse.messages);
      }
      addItem();
      notifyListeners();
    }
  }

  Future<bool> updateOrCreate() async {
    if (isNullOrEmpty(iIDCodeRequest)) {
      showErrorToast("Mã yêu cầu không được để trống");
      return false;
    }

    if (isNullOrEmpty(serialDetailModel.serial.contract)) {
      showErrorToast("Mã hợp đồng không được để trống");
      return false;
    }

    if (isNullOrEmpty(serialDetailModel.serialDetails)) {
      showErrorToast("Chưa có hàng hóa nào");
      return false;
    }

    String sSerialNo = "", sIDCommodity = "";
    List<String> listSerialNo = [];
    List<String> lisIDCommodity = [];

    for (SerialDetails data in serialDetailModel.serialDetails) {
      listSerialNo.add("\"" + data.serialNo + "\"");
      lisIDCommodity.add(data.commodity.iD.toString());
    }

    sSerialNo = "[" + listSerialNo.join(",") + "]";
    sIDCommodity = "[" + lisIDCommodity.join(",") + "]";

    SerialDetailParams params = SerialDetailParams();
    params.iDRequisition =
        serialDetailModel.serial.requisition[0].iD.toString();
    params.iDContract = serialDetailModel.serial.contract[0].iD.toString();
    params.invoiceNumber = serialDetailModel.serial.invoiceNumber;
    params.invFilePath = serialDetailModel.serial.invFilePath;
    params.packingNumber = serialDetailModel.serial.packingNumber;
    params.packingFilePath = serialDetailModel.serial.packingFilePath;
    params.cOName = serialDetailModel.serial.cOName;
    params.cOFilePath = serialDetailModel.serial.cOFilePath;
    params.cQName = serialDetailModel.serial.cQName;
    params.cQFilePath = serialDetailModel.serial.cQFilePath;
    params.bolNumber = serialDetailModel.serial.bolNumber;
    params.bolFilePath = serialDetailModel.serial.bolFilePath;
    params.tkNumber = serialDetailModel.serial.tkNumber;
    params.tkFilePath = serialDetailModel.serial.tkFilePath;
    params.otherFile = serialDetailModel.serial.otherFile;
    params.otherFilePath = serialDetailModel.serial.otherFilePath;
    params.iDCommodity = sIDCommodity;
    params.serialNo = sSerialNo;

    if (!isCreate) {
      params.providerId = serialDetailModel.serial.iD;
      return await update(params);
    } else {
      return await create(params);
    }
  }

  create(SerialDetailParams params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsSerialSave, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  update(SerialDetailParams params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsSerialChange, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  openFile(BuildContext context, ContentShoppingModel model) async {
    bool isNeedRefresh = false;
    String fileName, filePath;
    if (isEditing) {
      if (isNotNullOrEmpty(model.value)) {
        var result = await showConfirmDialog(
            context, "Bạn muốn xóa hay đổi file khác", () async {},
            cancelText: "Xóa file", acceptText: "Chọn file");
        if (result == true) {
          UploadModel file =
              await FileUtils.instance.uploadFileFromSdcard(context);
          if (file != null) {
            fileName = file.fileName;
            filePath = file.filePath;
            isNeedRefresh = true;
          }
        } else if (result == false) isNeedRefresh = true;
      } else {
        UploadModel file =
            await FileUtils.instance.uploadFileFromSdcard(context);
        if (file != null) {
          fileName = file.fileName;
          filePath = file.filePath;
          isNeedRefresh = true;
        }
      }
    }

    switch (model.title) {
      case INVOICE_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.invoiceNumber = fileName;
            serialDetailModel.serial.invFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.invoiceNumber,
                serialDetailModel.serial.invFilePath, context);
          }
          break;
        }
      case PACKING_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.packingNumber = fileName;
            serialDetailModel.serial.packingFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.packingNumber,
                serialDetailModel.serial.packingFilePath, context);
          }
          break;
        }
      case CO_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.cOName = fileName;
            serialDetailModel.serial.cOFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.cOName,
                serialDetailModel.serial.cOFilePath, context);
          }
          break;
        }
      case CQ_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.cQName = fileName;
            serialDetailModel.serial.cQFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.cQName,
                serialDetailModel.serial.cQFilePath, context);
          }
          break;
        }
      case BILL_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.bolNumber = fileName;
            serialDetailModel.serial.bolFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.bolNumber,
                serialDetailModel.serial.bolFilePath, context);
          }
          break;
        }
      case TESTIMONY_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.tkNumber = fileName;
            serialDetailModel.serial.tkFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.tkNumber,
                serialDetailModel.serial.tkFilePath, context);
          }
          break;
        }
      case OTHER_DETAIL:
        {
          if (isEditing) {
            serialDetailModel.serial.otherFile = fileName;
            serialDetailModel.serial.otherFilePath = filePath;
          } else {
            _openFile(serialDetailModel.serial.otherFile,
                serialDetailModel.serial.otherFilePath, context);
          }
          break;
        }
    }
    if (isNeedRefresh) {
      addItem();
      notifyListeners();
    }
  }

  _openFile(String fileName, String filePath, BuildContext context) async {
    if (isNullOrEmpty(filePath)) return;
    // if ([".png", ".jpg", ".jpeg"]
    //         .where((element) => fileName.toLowerCase().endsWith(element))
    //         .length >
    //     0) {
    //   showSuccessToast("Bắt đầu tải file $fileName");
    await FileUtils.instance.downloadFileAndOpen(fileName, filePath, context);
    // } else {
    //   pushPage(
    //       context,
    //       WebViewScreen(
    //         title: fileName,
    //         url:
    //             "https://docs.google.com/gview?embedded=true&url=$root/storage/files/$filePath",
    //       ));
    // }
  }

  addItem() {
    listItems = [];
    codeRequestItem = ContentShoppingModel(
        title: "Mã yêu cầu",
        isRequire: true,
        value: serialDetailModel?.serial?.requisition
                ?.firstWhere(
                  (element) => true,
                  orElse: () => null,
                )
                ?.name ??
            "",
        isNextPage: isEditing);
    codeContractItem = ContentShoppingModel(
        isRequire: true,
        title: "Mã hợp đồng",
        value: serialDetailModel?.serial?.contract
                ?.firstWhere(
                  (element) => true,
                  orElse: () => null,
                )
                ?.name ??
            "",
        isNextPage: isEditing);
    numberInvoiceItem = ContentShoppingModel(
        title: INVOICE_DETAIL,
        value: serialDetailModel?.serial?.invoiceNumber ?? "",
        isNextPage: true);
    numberPackingListItem = ContentShoppingModel(
        title: PACKING_DETAIL,
        value: serialDetailModel?.serial?.packingNumber ?? "",
        isNextPage: true);
    cOItem = ContentShoppingModel(
        title: CO_DETAIL,
        value: serialDetailModel?.serial?.cOName ?? "",
        isNextPage: true);
    cQItem = ContentShoppingModel(
        title: CQ_DETAIL,
        value: serialDetailModel?.serial?.cQName ?? "",
        isNextPage: true);
    billOfLadingItem = ContentShoppingModel(
        title: BILL_DETAIL,
        value: serialDetailModel?.serial?.bolNumber ?? "",
        isNextPage: true);
    testimonyItem = ContentShoppingModel(
        title: TESTIMONY_DETAIL,
        value: serialDetailModel?.serial?.tkNumber ?? "",
        isNextPage: true);
    otherItem = ContentShoppingModel(
        title: OTHER_DETAIL,
        value: serialDetailModel?.serial?.otherFile ?? "",
        isNextPage: true);
    listItems.add(codeRequestItem);
    listItems.add(codeContractItem);
    listItems.add(numberInvoiceItem);
    listItems.add(numberPackingListItem);
    listItems.add(cOItem);
    listItems.add(cQItem);
    listItems.add(billOfLadingItem);
    listItems.add(testimonyItem);
    listItems.add(otherItem);
    if (isCreate == false) {
      if (isNotNullOrEmpty(serialDetailModel.serial.requisition))
        codeRequestItem.selected = [serialDetailModel.serial.requisition[0]];
      if (isNotNullOrEmpty(serialDetailModel.serial.contract))
        codeContractItem.selected = [serialDetailModel.serial.contract[0]];
    }
  }

  remove(SerialDetails serialDetails) {
    serialDetailModel.serialDetails.remove(serialDetails);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
