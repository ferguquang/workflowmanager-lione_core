import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';

class DataManagerContractDetailRepository extends ChangeNotifier {
  List<ContentShoppingModel> listData = [];
  static const String DESCRIPTION_LINE = "Mô tả sản phẩm";
  static const String NOTE_LINE = "Ghi chú";
  static const String ONE = "Lần 1(%)";
  static const String TWO = "Lần 2(%)";
  static const String THREE = "Lần 3(%)";
  static const String MONEY_PR = "Thành tiền PR";
  static const String PRICE_LINE = "Đơn giá";
  ContentShoppingModel nameItem,
      hangItem,
      descriptionItem,
      qTYItem,
      unitItem,
      priceItem,
      pRItem,
      rentalTimeItem,
      rentalTypeItem,
      originItem,
      guaranteeItem,
      cOItem,
      cQmeItem,
      otherDocumentsItem,
      noteItem,
      oneItem,
      moneyOneItem,
      timeRquestOneItem,
      twoItem,
      moneyTwoItem,
      timeRquestTwoItem,
      threeItem,
      moneyThreeItem,
      timeRquestThreeItem;
  Lines data;

  double iRentTime = 1;
  bool isEditable = false;

  loadData(Lines data, int iIDSuggestionType, bool isEditable) async {
    this.data = data;
    nameItem = ContentShoppingModel(
        title: "Tên hàng hóa", value: data.product, isNextPage: false);
    hangItem = ContentShoppingModel(
        title: "Hãng", value: data.manufactur, isNextPage: false);
    descriptionItem = ContentShoppingModel(
        title: DESCRIPTION_LINE,
        value: data.description,
        isNextPage: false,
        isEditable: false);
    qTYItem = ContentShoppingModel(
        title: "Số lượng",
        value: data?.qTY?.toInt()?.toString() ?? "",
        isNextPage: false);
    unitItem = ContentShoppingModel(
        title: "Đơn vị tính", value: data.unit, isNextPage: false);
    priceItem = ContentShoppingModel(
        title: PRICE_LINE,
        isMoney: true,
        isRequire: isEditable,
        value: getCurrencyFormat(data.price.toString(), isAllowDot: true),
        isNextPage: isEditable);
    pRItem = ContentShoppingModel(
        title: MONEY_PR,
        isMoney: true,
        value: getCurrencyFormat(data.amount.toString(), isAllowDot: true),
        isNextPage: false);

    rentalTimeItem = ContentShoppingModel(
      isNextPage: isEditable,
        title: "Thời gian thuê",
        isNumeric: true,
        value: _replaceDoubleMoney(data.rentalTime.toString()));
    rentalTypeItem = ContentShoppingModel(      isNextPage: isEditable,
        title: "Đơn vị tính thời gian", value: data.rentType);

    originItem = ContentShoppingModel(
        title: "Xuất xứ", value: data.origin, isNextPage: isEditable);
    guaranteeItem = ContentShoppingModel(
        title: "Bảo hành", value: data.warranty, isNextPage: isEditable);
    cOItem = ContentShoppingModel(
        title: "CO", value: data.cO, isCheckbox: true, isNextPage: isEditable);
    cQmeItem = ContentShoppingModel(
        title: "CQ", value: data.cQ, isCheckbox: true, isNextPage: isEditable);
    otherDocumentsItem = ContentShoppingModel(
        title: "Chứng từ khác",
        value: data.other,
        isCheckbox: true,
        isNextPage: isEditable);
    noteItem = ContentShoppingModel(
        title: NOTE_LINE,
        value: data.note,
        isNextPage: isEditable,
        isEditable: isEditable);
    oneItem = ContentShoppingModel(
        title: ONE,
        value:
            isNullOrEmpty(data.payPercent1) ? "0" : data.payPercent1.toString(),
        isNumeric: true,
        isRequire: true,
        isNextPage: isEditable);
    moneyOneItem = ContentShoppingModel(
        title: "Thành tiền (lần 1)",
        isMoney: true,
        value: getCurrencyFormat(data.payAmount1.toString(), isAllowDot: true),
        isNextPage: false);
    timeRquestOneItem = ContentShoppingModel(
        title: "Ngày yêu cầu thanh toán (lần 1)",
        isOnlyDate: true,
        isRequire: true,
        value: getDatetime(data.payDate1),
        isNextPage: isEditable);
    twoItem = ContentShoppingModel(
        title: TWO,
        isRequire: true,
        value:
            isNullOrEmpty(data.payPercent2) ? "0" : data.payPercent2.toString(),
        isNumeric: true,
        isNextPage: isEditable);
    moneyTwoItem = ContentShoppingModel(
        title: "Thành tiền (lần 2)",
        isMoney: true,
        value: getCurrencyFormat(data.payAmount2.toString()),
        isNextPage: false);
    timeRquestTwoItem = ContentShoppingModel(
        title: "Ngày yêu cầu thanh toán (lần 2)",
        isRequire: true,
        isOnlyDate: true,
        value: getDatetime(data.payDate2),
        isNextPage: isEditable);
    threeItem = ContentShoppingModel(
        isRequire: true,
        title: THREE,
        isNumeric: true,
        value:
            isNullOrEmpty(data.payPercent3) ? "0" : data.payPercent3.toString(),
        isNextPage: isEditable);
    moneyThreeItem = ContentShoppingModel(
        title: "Thành tiền (lần 3)",
        isMoney: true,
        value: getCurrencyFormat(data.payAmount3.toString(), isAllowDot: true),
        isNextPage: false);
    timeRquestThreeItem = ContentShoppingModel(
        isRequire: true,
        title: "Ngày yêu cầu thanh toán (lần 3)",
        value: getDatetime(data.payDate3),
        isOnlyDate: true,
        isNextPage: isEditable);

    listData.add(nameItem);
    listData.add(hangItem);
    listData.add(descriptionItem);
    listData.add(qTYItem);
    listData.add(unitItem);
    listData.add(priceItem);
    listData.add(pRItem);
    if (iIDSuggestionType == 2) {
      //thuê
      iRentTime = getDouble(data.rentalTime.toString());
      listData.add(rentalTimeItem);
      listData.add(rentalTypeItem);
    }
    listData.add(originItem);
    listData.add(guaranteeItem);
    listData.add(cOItem);
    listData.add(cQmeItem);
    listData.add(otherDocumentsItem);
    listData.add(noteItem);
    listData.add(oneItem);
    listData.add(moneyOneItem);
    listData.add(timeRquestOneItem);
    listData.add(twoItem);
    listData.add(moneyTwoItem);
    listData.add(timeRquestTwoItem);
    listData.add(threeItem);
    listData.add(moneyThreeItem);
    listData.add(timeRquestThreeItem);
    notifyListeners();
  }

  bool save() {
    if (isNullOrEmpty(oneItem.value)) {
      showErrorToast("Chưa nhập lần 1");
      return false;
    }
    if (isNullOrEmpty(twoItem.value)) {
      showErrorToast("Chưa nhập lần 2");
      return false;
    }
    if (isNullOrEmpty(threeItem.value)) {
      showErrorToast("Chưa nhập lần 3");
      return false;
    }
    if (int.parse(oneItem.value) > 100) {
      showErrorToast("lần 1 quá lớn");
      return false;
    }

    if (int.parse(twoItem.value) > 100) {
      showErrorToast("lần 2 quá lớn");
      return false;
    }

    if (int.parse(threeItem.value) > 100) {
      showErrorToast("lần 3 quá lớn");
      return false;
    }
    if (isNullOrEmpty(priceItem.value) || getDouble(priceItem.value) == 0) {
      showErrorToast("Chưa nhập đơn giá");
      return false;
    }

    if (checkTime(oneItem, timeRquestOneItem)) {
      showErrorToast("Hãy chọn ngày thanh toán lần 1");
      return false;
    }

    if (checkTime(twoItem, timeRquestTwoItem)) {
      showErrorToast("Hãy chọn ngày thanh toán lần 2");
      return false;
    }

    if (checkTime(threeItem, timeRquestThreeItem)) {
      showErrorToast("Hãy chọn ngày thanh toán lần 3");
      return false;
    }

    if (int.parse(oneItem.value) +
            int.parse(twoItem.value) +
            int.parse(threeItem.value) !=
        100) {
      showErrorToast("Tổng 3 lần phải bằng 100");
      return false;
    }

    String sAmount = isNullOrEmpty(qTYItem.value) ? "0" : qTYItem.value;
    sAmount = sAmount.replaceAll(",", "");

    String moneyOneItemValue =
        isNullOrEmpty(moneyOneItem.value) ? "0" : moneyOneItem.value;
    moneyOneItemValue = moneyOneItemValue.replaceAll(",", "");

    String moneyTwoItemValue =
        isNullOrEmpty(moneyTwoItem.value) ? "0" : moneyTwoItem.value;
    moneyTwoItemValue = moneyTwoItemValue.replaceAll(",", "");

    String moneyThreeItemValue =
        isNullOrEmpty(moneyThreeItem.value) ? "0" : moneyThreeItem.value;
    moneyThreeItemValue = moneyThreeItemValue.replaceAll(",", "");

    data.payDate1 = timeRquestOneItem.value;
    data.payDate2 = timeRquestTwoItem.value;
    data.payDate3 = timeRquestThreeItem.value;
    data.origin = originItem.value;
    data.warranty = guaranteeItem.value;
    data.note = noteItem.value;
    data.payAmount1 = getDouble(moneyOneItemValue);
    data.payAmount2 = getDouble(moneyTwoItemValue);
    data.payAmount3 = getDouble(moneyThreeItemValue);
    data.price = getDouble(priceItem.value);
    data.amount = getDouble(pRItem.value);
    data.qTY = getDouble(qTYItem.value);
    data.payPercent1 = getInt(oneItem.value);
    data.payPercent2 = getInt(twoItem.value);
    data.payPercent3 = getInt(threeItem.value);
    data.cO = cOItem.value;
    data.cQ = cQmeItem.value;
    data.other = cOItem.value;
    return true;
  }
  String getDatetime(String datetime){
    if(isNullOrEmpty(datetime))
      return "";
    return datetime.replaceAll("-", "/");
  }
  calcNext(ContentShoppingModel model) {
    switch (model.title) {
      case ONE:
        {
          moneyOneItem.value = multiple(oneItem.value);
          notifyListeners();
          break;
        }

      case TWO:
        {
          moneyTwoItem.value = multiple(twoItem.value);
          notifyListeners();
          break;
        }

      case THREE:
        {
          moneyThreeItem.value = multiple(threeItem.value);
          notifyListeners();
          break;
        }

      case PRICE_LINE:
        {
          double result =
              getDouble(priceItem.value) * getDouble(qTYItem.value) * iRentTime;
          pRItem.value = getCurrencyFormat(result.toString());
          moneyOneItem.value = multiple(oneItem.value);
          moneyTwoItem.value = multiple(twoItem.value);
          moneyThreeItem.value = multiple(threeItem.value);
          notifyListeners();
          break;
        }
    }
  }

  String multiple(String value) {
    return getCurrencyFormat(
        (getDouble(value) * getDouble(pRItem.value) / 100).toString());
  }


  double getDouble(dynamic value) {
    if (isNullOrEmpty(value)) return 0;
    String text= value.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
    return double.parse(text);
  }

  int getInt(dynamic value) {
    if (isNullOrEmpty(value)) return 0;
    String text = value.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
    return int.parse(text);
  }

  bool checkTime(ContentShoppingModel percent, ContentShoppingModel date) {
    return isNotNullOrEmpty(percent.value) &&
        int.parse(percent.value) > 0 &&
        isNullOrEmpty(date.value);
  }

  bool valid(ContentShoppingModel model, String value) {
    if ([ONE, TWO, THREE].contains(model.title)) {
      if (isNotNullOrEmpty(value) && double.parse(value) > 100) {
        showErrorToast("${model.title.split("(")[0]} không được lớn hơn 100");
        return false;
      }
    }
    return true;
  }

  String _replaceDoubleMoney(String s) {
    if (s == null) {
      return "0";
    }

    s = s.replaceAll(".0", "");
    return s;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
