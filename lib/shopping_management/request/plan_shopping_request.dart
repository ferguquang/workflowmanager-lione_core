import 'package:workflow_manager/base/utils/common_function.dart';

class PlanShoppingIndexRequest {
  dynamic take, skip, year, idDept, suggestionType, shoppingType, quarter;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Take"] = take;
    params["Skip"] = skip;
    params["Year"] = year;
    params["IDDept"] = idDept;
    params["SuggestionType"] = suggestionType;
    params["ShoppingType"] = shoppingType;
    params["Quarters"] = quarter;
    params.removeWhere((key, value) => isNullOrEmpty(value));
    return params;
  }
}