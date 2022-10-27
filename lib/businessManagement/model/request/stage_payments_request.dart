import 'package:workflow_manager/base/utils/common_function.dart';

class StagePaymentsRequest {
  String name;
  int status;
  int type;
  String ratio;
  String rules;
  String paymentDate;
  String remindDay;
  int iDContract;
  int iDPayment;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(name)) params["Name"] = name;
    if (isNotNullOrEmpty(status)) params["Status"] = status;
    if (isNotNullOrEmpty(type)) params["Type"] = type;
    if (isNotNullOrEmpty(ratio)) params["Ratio"] = ratio;
    if (isNotNullOrEmpty(rules)) params["Rules"] = rules;
    if (isNotNullOrEmpty(paymentDate)) params["PaymentDate"] = paymentDate;
    if (isNotNullOrEmpty(remindDay)) params["RemindDay"] = remindDay;
    if (isNotNullOrEmpty(iDContract)) params["IDContract"] = iDContract;
    if (isNotNullOrEmpty(iDPayment)) params["IDPayment"] = iDPayment;

    return params;
  }
}
