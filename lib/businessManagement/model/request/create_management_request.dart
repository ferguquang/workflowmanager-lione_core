import 'package:workflow_manager/base/utils/common_function.dart';

/**
 TẠO MỚI CƠ HỘI
 */
class CreateManagementRequest {
  // dành cho api update id của cơ hội
  int id;
  // IDCustomer : id khách hàng
  int iDCustomer;
  // IDTypeBusiness: nhóm khách hàng (sau khi chọn KH)
  int iDTypeBusiness;
  // IDContact: người liên hệ   (sau khi chọn KH)
  int iDContact;
  // Name:tên dự án
  String nameOpportunity;
  // IDTypeProject: 144380 //loại dự án
  int iDTypeProject;
  // StartDate:ngày bắt đầu dự án
  String startDate;
  // TotalMoney:tổng tiền dự kiến
  // String totalMoney;
  // Capital:giá vốn
  // String capital;
  // MarketingCost : chi phí marketing
  String marketingCost;
  // Province:13743 //địa điểm triển khai
  int province;
  // PotentialType:1 //đánh giá cơ hội
  int potentialType;
  // IDPhase: giai đoạn
  int iDPhase;
  // CampaignType: //chiến dịch mkt
  int campaignType;
  // IDCenter:602 //phòng ban
  int iDCenter;
  // IDSeller:29// id của sale
  int iDSeller;
  // Investors // Đơn vị sử dụng
  String investors;
  // ExecuteDuration // Thời gian thực hiện hợp đồng (ngày)
  String executeDuration;
  // TendererDate // Ngày dự kiến thầu/mở thầu
  String tendererDate;
  // DemoDate // Ngày triển khảo sát, tư ván, demo
  String demoDate;
  // DeployDate // Ngày dự kiến triển khai
  String deployDate;
  // DetailAmount  // Khối lượng chi tiết
  String detailAmount;
  // ProfileType  // Loại hồ sơ
  String profileType;
  // AdvanceTerms // Điều khoản tạm ứng
  String advanceTerms;
  // PaymentTerms // Điều khoản thanh toán
  String paymentTerms;
  // ================ DS Chi tiết giá trị dự án *
  // Money_ID // thêm mới truyền 0
  String money_ID;
  // Money_IDTypeProject //Loại dự án
  String money_IDTypeProject;
  // Money_TotalMoney //Giá trị
  String money_TotalMoney;
  // Money_Capital //lãi vốn
  String money_Capital;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) params["ID"] = id;
    if (isNotNullOrEmpty(iDCustomer)) params["IDCustomer"] = iDCustomer;
    if (isNotNullOrEmpty(iDTypeBusiness))
      params["IDTypeBusiness"] = iDTypeBusiness;
    if (isNotNullOrEmpty(iDContact)) params["IDContact"] = iDContact;
    if (isNotNullOrEmpty(nameOpportunity)) params["Name"] = nameOpportunity;
    if (isNotNullOrEmpty(iDTypeProject))
      params["IDTypeProject"] = iDTypeProject;
    if (isNotNullOrEmpty(startDate)) params["StartDate"] = startDate;
    // if (isNotNullOrEmpty(totalMoney)) params["TotalMoney"] = totalMoney;
    // if (isNotNullOrEmpty(capital)) params["Capital"] = capital;
    if (isNotNullOrEmpty(marketingCost))
      params["MarketingCost"] = marketingCost;
    if (isNotNullOrEmpty(province)) params["Province"] = province;
    if (isNotNullOrEmpty(potentialType))
      params["PotentialType"] = potentialType;
    if (isNotNullOrEmpty(iDPhase)) params["IDPhase"] = iDPhase;
    if (isNotNullOrEmpty(campaignType)) params["CampaignType"] = campaignType;
    if (isNotNullOrEmpty(iDCenter)) params["IDCenter"] = iDCenter;
    if (isNotNullOrEmpty(iDSeller)) params["IDSeller"] = iDSeller;
    if (isNotNullOrEmpty(investors)) params["Investors"] = investors;
    if (isNotNullOrEmpty(executeDuration))
      params["ExecuteDuration"] = executeDuration;
    if (isNotNullOrEmpty(tendererDate)) params["TendererDate"] = tendererDate;
    if (isNotNullOrEmpty(demoDate)) params["DemoDate"] = demoDate;
    if (isNotNullOrEmpty(deployDate)) params["DeployDate"] = deployDate;
    if (isNotNullOrEmpty(detailAmount)) params["DetailAmount"] = detailAmount;
    if (isNotNullOrEmpty(profileType)) params["ProfileType"] = profileType;
    if (isNotNullOrEmpty(advanceTerms)) params["AdvanceTerms"] = advanceTerms;
    if (isNotNullOrEmpty(paymentTerms)) params["PaymentTerms"] = paymentTerms;
    if (isNotNullOrEmpty(money_ID)) params["Money_ID"] = money_ID;
    if (isNotNullOrEmpty(money_IDTypeProject))
      params["Money_IDTypeProject"] = money_IDTypeProject;
    if (isNotNullOrEmpty(money_TotalMoney))
      params["Money_TotalMoney"] = money_TotalMoney;
    if (isNotNullOrEmpty(money_Capital))
      params["Money_Capital"] = money_Capital;

    return params;
  }
}
