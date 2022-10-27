import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';

class ContractDetailSendParams {
  Contract contract;
  String pONumber;
  String signDate;
  String signBy;
  String  jobPosition;
  String  paymentMethod;
  String note;
  double  totalAmount;
  int act;
  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    String sId = "";

    List<String> listID = [];
    List<Lines> lineList=contract.lines;
    if (lineList.length > 0)
    {
      for (int i = 0; i < lineList.length; i++)
      {
        Lines data = lineList[i];
        String sID = data.iD.toString();

        listID.add(sID);

        params[sID + "_Price"]=data.price;
        params[sID + "_Amount"]=data.amount;
        params[sID + "_Origin"]=data.origin;
        params[sID + "_Warranty"]=data.warranty;
        params[sID + "_CO"]=data.cO;
        params[sID + "_CQ"]=data.cQ;
        params[sID + "_Other"]=data.other;
        params[sID + "_Note"]=data.note;
        params[sID + "_Per1"]=data.payPercent1;
        params[sID + "_Date1"]=getServerDatetime(data.payDate1);
        params[sID + "_Amount1"]=data.payAmount1;
        params[sID + "_Per2"]=data.payPercent2;
        params[sID + "_Date2"]=getServerDatetime(data.payDate2);
        params[sID + "_Amount2"]=data.payAmount2;
        params[sID + "_Per3"]=data.payPercent3;
        params[sID + "_Date3"]=getServerDatetime(data.payDate3);
        params[sID + "_Amount3"]=data.payAmount3;
      }

      sId = listID.join(",");

      params["LineID"]="[" + sId +"]";
    }

    String sFileName = "", sFilePath = "";
    List<String> listFileName = [];
    List<String> listFilePath = [];

    for (ContractFiles contract in contract.contractFiles) {
      listFileName.add("\"" + contract.fileName + "\"");
      listFilePath.add("\"" + contract.filePath + "\"");
    }

    sFileName = "[" + listFileName.join(",") + "]";
    sFilePath = "[" + listFilePath.join(",") + "]";

    params["ID"] = contract.iD;
    params["PONumber"] = pONumber;
    params["SignDate"] = getServerDatetime(signDate);
    params["SignBy"] = signBy;
    params["JobPosition"] = jobPosition;
    params["PaymentMethod"] = paymentMethod;
    params["Note"] = note;
    params["TotalAmount"] = contract.totalAmount;
    if (listFilePath.length > 0) {
      params["FileName"] = sFileName;
      params["FilePath"] = sFilePath;
    }
    params["Act"] = act;
    return params;
  }
  String getServerDatetime(String datetime){
    if(isNullOrEmpty(datetime))
      return "";
    return datetime.replaceAll("/", "-");
  }
}
