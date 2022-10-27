import 'package:workflow_manager/base/utils/common_function.dart';

/**
    LƯU - TẠO MỚI HỢP ĐỒNG
 */
class SaveContractRequest {
  // "IDCustomer" // khách hàng
  int iDCustomer;
  // "IDProjectPlan" // cơ hội
  int iDProjectPlan;
  // "Code" // mã hđ
  String code;
  // "Number" // số hđ
  String number;
  // "Name" // tên hợp đồng
  String name;
  // "IDTypeProject" // loại hợp đồng
  int iDTypeProject;
  // "SignDate"// ngày ký hđ
  String signDate;
  // "StartDate" // ngày hiệu lực hđ
  String startDate;
  // "EndDate" // ngày kt hợp đồng
  String endDate;
  // "IDProvince" //địa điểm triển khai
  int iDProvince;
  // "Status"//giai đoạn hợp đồng
  int status;
  // "IDSeller"//Seller
  int iDSeller;
  // "IDCenter"//phòng ban
  int iDCenter;
  // "TotalMoney" //giá trị
  String totalMoney;
  // "Capital"//lãi vốn
  String capital;
  // "MarketingCost"//chi phí mkt
  String marketingCost;
  // "DeployCost" //chi phí triển khai
  String deployCost;
  // "Bonus" // thưởng
  String bonus;
  // "BonusType" // tiêu chí thưởng
  int bonusType;
  // "Type"// Loại hình hợp đồng
  int type;
  // "AbsoluteValue"// Loại hình hợp đồng (GIÁ TRÍ TUYỆT ĐỐI)
  String absoluteValue;
  // "HasFiles", "1"// list file đính kèm  > 0
  int hasFiles;
  // "ContractFileNames" // file name hợp đồng gốc
  String contractFileNames;
  // "ContractFilePaths" // file path hợp đồng gốc
  String contractFilePaths;

  // //giai đoạn thanh toán
  // "Payment_Name" // tên giai đoạn
  String payment_Name;
  // "Payment_Ratio"// tỉ lệ
  String payment_Ratio;
  // "Payment_Rules"// Quyết định
  String payment_Rules;
  // "Payment_Date"// ngày thanh toán
  String payment_Date;
  // "Payment_RemindDay" // Ngày nhắc trước
  String payment_RemindDay;
  // "Payment_Type" // Loại thanh toán
  String payment_Type;

  // dành cho edit - giai đoạn thanh toán
  // "Payment_ID"// ID giai đoạn
  String payment_ID;
  // "Payment_Status" // Trang thái thanh toán
  String payment_Status;

  // dành cho edit
  int id;
  String invoiceMoney; // Doanh thu xuất hóa đơn
  String deployContractFileNames; // file name hợp đồng triển khai
  String deployContractFilePaths; // file path hợp đồng triển khai

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(iDCustomer)) params["IDCustomer"] = iDCustomer;
    if (isNotNullOrEmpty(iDProjectPlan))
      params["IDProjectPlan"] = iDProjectPlan;
    if (isNotNullOrEmpty(code)) params["Code"] = code;
    if (isNotNullOrEmpty(number)) params["Number"] = number;
    if (isNotNullOrEmpty(name)) params["Name"] = name;
    if (isNotNullOrEmpty(iDTypeProject))
      params["IDTypeProject"] = iDTypeProject;
    if (isNotNullOrEmpty(signDate)) params["SignDate"] = signDate;
    if (isNotNullOrEmpty(startDate)) params["StartDate"] = startDate;
    if (isNotNullOrEmpty(endDate)) params["EndDate"] = endDate;
    if (isNotNullOrEmpty(iDProvince)) params["IDProvince"] = iDProvince;
    if (isNotNullOrEmpty(status)) params["Status"] = status;
    if (isNotNullOrEmpty(iDSeller)) params["IDSeller"] = iDSeller;
    if (isNotNullOrEmpty(iDCenter)) params["IDCenter"] = iDCenter;
    if (isNotNullOrEmpty(totalMoney)) params["TotalMoney"] = totalMoney;
    if (isNotNullOrEmpty(capital)) params["Capital"] = capital;
    if (isNotNullOrEmpty(marketingCost))
      params["MarketingCost"] = marketingCost;
    if (isNotNullOrEmpty(deployCost)) params["DeployCost"] = deployCost;
    if (isNotNullOrEmpty(bonus)) params["Bonus"] = bonus;
    if (isNotNullOrEmpty(bonusType)) params["BonusType"] = bonusType;
    if (isNotNullOrEmpty(type)) params["Type"] = type;
    if (isNotNullOrEmpty(absoluteValue))
      params["AbsoluteValue"] = absoluteValue;
    if (isNotNullOrEmpty(hasFiles)) params["HasFiles"] = hasFiles;
    if (isNotNullOrEmpty(contractFileNames))
      params["ContractFileNames"] = contractFileNames;
    if (isNotNullOrEmpty(contractFilePaths))
      params["ContractFilePaths"] = contractFilePaths;
    if (isNotNullOrEmpty(payment_Name)) params["Payment_Name"] = payment_Name;
    if (isNotNullOrEmpty(payment_Ratio))
      params["Payment_Ratio"] = payment_Ratio;
    if (isNotNullOrEmpty(payment_Rules))
      params["Payment_Rules"] = payment_Rules;
    if (isNotNullOrEmpty(payment_Date)) params["Payment_Date"] = payment_Date;
    if (isNotNullOrEmpty(payment_RemindDay))
      params["Payment_RemindDay"] = payment_RemindDay;
    if (isNotNullOrEmpty(payment_Type)) params["Payment_Type"] = payment_Type;
    if (isNotNullOrEmpty(payment_ID)) params["Payment_ID"] = payment_ID;
    if (isNotNullOrEmpty(payment_Status))
      params["Payment_Status"] = payment_Status;

    if (isNotNullOrEmpty(id)) params["ID"] = id;
    if (isNotNullOrEmpty(invoiceMoney)) params["InvoiceMoney"] = invoiceMoney;
    if (isNotNullOrEmpty(deployContractFileNames)) params["DeployContractFileNames"] = deployContractFileNames;
    if (isNotNullOrEmpty(deployContractFilePaths)) params["DeployContractFilePaths"] = deployContractFilePaths;

    return params;
  }
}
