import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/plan_shopping_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/response/plan_shopping_response.dart';

class PlanShoppingRepository with ChangeNotifier {
  PlanShoppingIndexRequest request = PlanShoppingIndexRequest();
  int skip = 1;
  int _take = 10;
  DataPlanIndex data = DataPlanIndex();

  void pullToRefreshData() {
    data.plannings?.clear();
    skip = 1;
  }

  Future<void> getPlanIndex() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsPlanningIndex, request.getParams());
    PlanIndexResponse response = PlanIndexResponse.fromJson(json);
    if (response.status == 1) {
      data.totalRecord = response.data.totalRecord;
      data.searchParam = response.data.searchParam;
      if (skip == 1) {
        data.plannings = response.data.plannings;
      } else {
        data.plannings.addAll(response.data.plannings.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  DataPlanningDetail dataPlanningDetail = DataPlanningDetail();
  List<ContentShoppingModel> listDetail = [];
  List<ContentShoppingModel> listSubDetail = [];

  Future<void> getPlanDetail(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsPlanningDetail, params);
    PlanningDetailResponse response = PlanningDetailResponse.fromJson(json);
    if (response.status == 1) {
      dataPlanningDetail = response.data;

      listDetail.add(ContentShoppingModel(title: "K??? ho???ch", value: "${dataPlanningDetail.planning.quarter} ${dataPlanningDetail.planning.year}"));
      listDetail.add(ContentShoppingModel(title: "Lo???i ????? ngh???", value: "${dataPlanningDetail.planning.suggestionType}"));
      listDetail.add(ContentShoppingModel(title: "H??nh th???c mua s???m", value: "${dataPlanningDetail.planning.shoppingType}"));
      listDetail.add(ContentShoppingModel(title: "Ph??ng ban l???p", value: "${dataPlanningDetail.planning.dept}"));
      listDetail.add(ContentShoppingModel(title: "Ng?????i l???p", value: "${dataPlanningDetail.planning.creator}"));
      listDetail.add(ContentShoppingModel(title: "T???ng c???ng (VN??)", value: "${dataPlanningDetail.planning.totalAmount}"));
      listDetail.forEach((element) {
        element.isNextPage = false;
      });

      notifyListeners();
    }
  }

  List<ContentShoppingModel> getSubDetail(PlanningDetails model, PlanningDetailHeader planningDetailHeader) {
    Map<String, dynamic> modelJSON = model.toJson();
    // for (final name in modelJSON.keys) {
    //   var value = modelJSON[name];
    //
    //   for (int i = 0; i < planningDetailHeader.codes.length; i++) {
    //     String code = planningDetailHeader.codes[i];
    //     if (name == code) {
    //       if (!listSubDetail.any((item) => item.key == name)) {
    //         if (planningDetailHeader.codes[i] == "RequestDate" || planningDetailHeader.codes[i] == "ContractExpectDate" || planningDetailHeader.codes[i] == "DeployExpectDate") {
    //           value = "${convertTimeStampToHumanDate(int.parse(value.toString()), Constant.ddMMyyyy2)}";
    //         }
    //         listSubDetail.add(ContentShoppingModel(title: planningDetailHeader.titles[i], value: value, key: planningDetailHeader.codes[i]));
    //       }
    //     }
    //   }
    // }

    for (int i = 0; i < planningDetailHeader.codes.length; i++) {
      for (final name in modelJSON.keys) {
        var value = modelJSON[name];
        String code = planningDetailHeader.codes[i];
        if (name == code) {
          if (!listSubDetail.any((item) => item.key == name)) {
            if (planningDetailHeader.codes[i] == "RequestDate" || planningDetailHeader.codes[i] == "ContractExpectDate" || planningDetailHeader.codes[i] == "DeployExpectDate") {
              value = "${convertTimeStampToHumanDate(int.parse(value.toString()), Constant.ddMMyyyy2)}";
            }
            listSubDetail.add(ContentShoppingModel(title: planningDetailHeader.titles[i], value: value, key: planningDetailHeader.codes[i]));
          }
        }
      }
    }

    listSubDetail.forEach((element) {
      element.isNextPage = false;
    });
    return listSubDetail;
  }

  List<ContentShoppingModel> addFilter() {
    CategorySearchParams deptSelected,
        yearSelected,
        suggestionTypeSelected,
        shoppingTypeSelected;
    List<ContentShoppingModel> list = [];

    String valueDept = "";
    if (request.idDept != null) {
      data.searchParam.depts.forEach((element) {
        if ("${element.iD}" == request.idDept) {
          valueDept = element.name;
          deptSelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        key: "IDDept",
        title: "Ph??ng ban",
        isDropDown: true,
        selected: isNotNullOrEmpty(request.idDept) ? [deptSelected] : [],
        isSingleChoice: true,
        dropDownData: data.searchParam.depts,
        idValue: isNotNullOrEmpty(request.idDept) ? request.idDept : "",
        getTitle: (status) => status.name,
        value: valueDept));

    String valueYear = "";
    if (isNotNullOrEmpty(request.year)) {
      data.searchParam.years.forEach((element) {
        if ("${element.iD}" == request.year) {
          valueYear = element.name;
          yearSelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        key: "Year",
        title: "N??m",
        isDropDown: true,
        isSingleChoice: true,
        selected: isNotNullOrEmpty(request.year) ? [yearSelected] : [],
        getTitle: (status) => status.name,
        dropDownData: data.searchParam.years,
        idValue: isNotNullOrEmpty(request.year) ? request.year : "",
        value: valueYear));

    String valueQuarter = "";
    List<CategorySearchParams> quarterSelected = [];
    if (isNotNullOrEmpty(request.quarter) && request.quarter != "null") {
      List<String> stringList = request.quarter.toString().replaceAll(" ", "").split(',');
      for (int i = 0; i < stringList.length; i++) {
        String idCategory = stringList[i];
        for (int j = 0; j < data.searchParam.quarters.length; j++) {
          String id = "${data.searchParam.quarters[j].iD}";
          if (idCategory == (id)) {
            quarterSelected.add(data.searchParam.quarters[j]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        key: "Quarters",
        title: "Qu??",
        isDropDown: true,
        selected: quarterSelected,
        isSingleChoice: false,
        dropDownData: data.searchParam.quarters,
        idValue: isNotNullOrEmpty(request.quarter) && request.quarter != "null"
            ? request.quarter
            : "",
        getTitle: (status) => status.name,
        value: valueQuarter));

    String valueSuggestionType = "";
    if (isNotNullOrEmpty(request.suggestionType)) {
      data.searchParam.suggestionTypes.forEach((element) {
        if ("${element.iD}" == request.suggestionType) {
          valueSuggestionType = element.name;
          suggestionTypeSelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        key: "SuggestionType",
        title: "Lo???i ????? ngh???",
        isDropDown: true,
        isSingleChoice: true,
        selected: isNotNullOrEmpty(request.suggestionType)
            ? [suggestionTypeSelected]
            : [],
        getTitle: (status) => status.name,
        dropDownData: data.searchParam.suggestionTypes,
        idValue: isNotNullOrEmpty(request.suggestionType)
            ? request.suggestionType
            : "",
        value: valueSuggestionType));

    String valueShoppingType = "";
    if (isNotNullOrEmpty(request.shoppingType)) {
      data.searchParam.shoppingTypes.forEach((element) {
        if ("${element.iD}" == request.shoppingType) {
          valueShoppingType = element.name;
          shoppingTypeSelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        key: "ShoppingType",
        title: "H??nh th???c mua s???m",
        isDropDown: true,
        isSingleChoice: true,
        selected: isNotNullOrEmpty(request.shoppingType)
            ? [shoppingTypeSelected]
            : [],
        getTitle: (status) => status.name,
        dropDownData: data.searchParam.shoppingTypes,
        idValue:
            isNotNullOrEmpty(request.shoppingType) ? request.shoppingType : "",
        value: valueShoppingType));
    return list;
  }
}