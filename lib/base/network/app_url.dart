import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/storage/screens/tabs/main_tab_storage_screen.dart';

class AppUrl {
  // TEST
  // static const String baseURL = "http://api-gateway.lione.vn/api/";
  // static const String baseURL = "http://test-api.lione.vn/api/";
  // static const String oneSignalAppID = '174cef11-9b50-4e38-9304-940f6b909233';

  // DEV
  // static const String baseURL = "http://dev-api.lione.vn/api/";
  // static const String oneSignalAppID = '174cef11-9b50-4e38-9304-940f6b909233';

  // DEV SME
  // static const String baseURL = "http://dev-api.sme.lione.vn/api/";
  // static const String oneSignalAppID = '174cef11-9b50-4e38-9304-940f6b909233';

  // UAT:
  // static String baseURL = "https://api-gateway.lione.vn/api/";
  // static const String oneSignalAppID ='dc6a8a20-0674-4d87-b681-cf67d5308fa4';

  // RELEASE:
  // static const String baseURL = "https://api-gateway.lione.vn/api/";
  // static const String baseURL = "https://apiqtnb.evngenco2.vn:8091/api/";
  // static const String baseURL = "http://118.70.48.211:1681/api/";
  static const String baseURL = "http://27.72.28.202:9110/api/";
  static const String oneSignalAppID = '93463f14-ade9-4705-aa0c-bf98b60d98c6';

  // ------------------------------ manager ----------------------------------//
  static const String url_google_doc =
      "https://docs.google.com/gview?embedded=true&url=";
  static const String login = "account/login";
  static const String homeIndex = "home/index";
  static const String homeChangeViewFile = "home/ChangeViewFile";
  static const String changePassword = "Account/ChangePassword";
  static const String updateProfile = "Account/UpdateProfile";
  static const String profileDetail = "account/ProfileDetail";
  static const String sendInfoDevice = "device/reg";
  static const String removeInfoDevice = "device/remove";
  static const String getInfoNotifyById = "Notification/NtfsById";
  static const String getConfigApp = "home/infoversion";

  // ------------------ Quy tr??nh th??? t???c - procedures -----------------------//
  static const String listRegister = "register/index";
  static const String reportProcedure = "report/wf";
  static const String listResolve = "record/index";
  static const String listReportState = "report/ResolveStatusIndex";
  static const String exportResolveStatusExcel =
      "report/ExportResolveStatusExcel";
  static const String registerRemove = "register/remove";

  static const String registerRating = "register/Rating";
  static const String registerInfo = "register/Info";
  static const String recordInfo = "record/Info";
  static const String recordRating = "record/Rating";

  // action gi???i quy???t
  static const String recordIsResolve = "record/IsResolve";
  static const String recordIsDoneInfo = "record/IsDoneInfo";
  static const String recordDoneInfo = "record/DoneInfo";

  static const String registerIsResentInfo = "register/IsResentInfo";
  static const String registerResentInfo = "register/ResentInfo";

  static const String recordIsRequireAddition = "record/IsRequireAddition";
  static const String recordRequireAddition = "record/RequireAddition";

  // require addition trong ????ng k?? v?? gi???i quy???t
  static const String registerIsDoneRequireAddition =
      "register/IsDoneRequireAddition";
  static const String registerDoneRequireAddition =
      "register/DoneRequireAddition";
  static const String recordIsDoneRequireAddition =
      "record/IsDoneRequireAddition";
  static const String recordDoneRequireAddition = "record/DoneRequireAddition";

  static const String recordSaveInfoFs = "record/SaveInfoFs";
  static const String recordRemoveInfoFs = "record/RemoveInfoFs";

  static const String recordSaveInfoStepFs = "record/SaveInfoStepFs";
  static const String recordRemoveInfoStepFs = "record/RemoveInfoStepFs";

  static const String recordIsResolveList = "record/IsResolveList";
  static const String recordResolveList = "record/ResolveList";

  static const String ratingIsRateServiceRecord = "rating/IsRateServiceRecord";
  static const String ratingSaveRateServiceRecord =
      "rating/SaveRateServiceRecord";

  static const String registerInfoStepHistory = "register/InfoStepHistory";

  static const String listHistory = "Task/GetListJobHistory";
  static const String listComment = "Task/GetDiscuss";
  static const String addComment = "Task/AddDiscuss";
  static const String likeComment = "Task/Like";
  static const String deleteComment = "Task/DeleteDiscuss";
  static const String listProcessContent = "Task/GetProcessedContent";
  static const String addProcessContent = "Task/AddProcessedContent";
  static const String editProcessContent = "Task/EditProcessedContent";
  static const String deleteProcessContent = "Task/DeleteProcessedContent";

  static const String getQTTTRegisterTypes = "register/types";
  static const String getQTTTRegisterServices = "register/services";
  static const String getQTTTRegisterCreate = "register/create";
  static const String getQTTTRegisterUpdate = "register/update";
  static const String getQTTTRegisterChange = "register/change";
  static const String getQTTTRegisterSave = "register/save";
  static const String getQTTTRegisterChangeFeatured = "register/ChangeFeatured";
  static const String getQTTTRegisterUserInfo = "register/userInfo";
  static const String getQTTTRecordSaveData = "record/SaveData";
  static const String getQTTTRecordSignatures = "record/signatures";
  static const String getQTTTSignatureCheckPasswordSignature =
      "Signature/CheckPasswordSignature";
  static const String getQTTTSignatureSavePDF = "Signature/savePDF";
  static const String getQTTTRatingServiceRateView = "rating/ServiceRateView";
  static const String getQTTTRecordIsDoneInfo = "record/IsDoneInfo";
  static const String getQTTTRegisterSavePdfForm = "register/SavePdfForm";
  static const String getQTTTRecordSavePdfForm = "record/SavePdfForm";

  // -------------------- Qu???n l?? c??ng vi???c - workflow -----------------------//
  static const String createNewTrip = "/goTogether/trip/create";

  static const String getListTrip = "/goTogether/trip/list";

  // group task
  static const String getListGroupTask = "GroupTask/Index";
  static const String getColumnGroup = "GroupTask/GetColumn";
  static const String getListColumnGroup = "GroupTask/DataForDetail";
  static const String getTaskStatus = "GroupTask/GetListStatus";
  static const String getDataForNewGroup = "GroupTask/GetDataForCreateGroupJob";
  static const String deleteGroupTask = "GroupTask/DeleteJobGroups";
  static const String changeStatusForList = "GroupTask/ChangeStatusForList";
  static const String createNewGroup = "GroupTask/CreateGroupJob";
  static const String editGroup = "GroupTask/EditJobGroupAPI";
  static const String groupGetListDiscuss = "GroupTask/GetListDiscussAPI";
  static const String groupDeleteDiscuss = "GroupTask/DeleteDiscussAPI";
  static const String groupAddDiscuss = "GroupTask/AddDiscussAPI";
  static const String groupLikeOrDislike = "GroupTask/Like";
  static const String groupGetListHistory = "GroupTask/GetListHistoryAPI";
  static const String getDataForIndex = "ReportQLCV/GetDataForIndex";
  static const String getDataFilterColumnGroup =
      "GroupTask/GetDataForSearchDetail";
  static const String getListUserColumnGroup = "GroupTask/GetListUserForSearch";

  // List task
  static const String getListTask = "Task/Index";
  static const String getTaskInfo = "Task/DetailJob";

  static const String getJobDetails = "Task/GetListJobDetail";
  static const String getCompleteJobDetails = "Task/CompleteJobDetail";
  static const String getUncompleteJobDetails = "Task/UnCompleteJobDetail";
  static const String getDeleteJobDetail = "Task/DeleteJobDetail";
  static const String getAddJobDetail = "Task/AddJobDetail";
  static const String getChangePercent = "Task/ChangePercent";
  static const String getDeleteJob = "Task/DeleteJob";

  static const String getSubJob = "Task/GetListChildrenJob";
  static const String getAddFile = "Task/AddFile";
  static const String getDeleteFile = "Task/DeleteFile";
  static const String getGetListFile = "Task/GetListFile";

  static const String getAddExtension = "Task/AddExtension";
  static const String getApproveExtension = "Task/ApproveExtension";
  static const String getRejectExtension = "Task/RejectExtension";
  static const String getGetHistoryExtension = "Task/GetHistoryExtension";

  //group job details
  static const String getGroupTaskAddFile = "GroupTask/AddFile";
  static const String getGroupTaskGetListFile = "GroupTask/GetListFile";
  static const String getGroupTaskDeleteFile = "GroupTask/DeleteFile";
  static const String getGroupTaskGetDataForEdit = "GroupTask/GetDataForEdit";
  static const String getGroupTaskGetListStatusChange =
      "GroupTask/GetListStatusChange";
  static const String getGroupTaskChangeStatus = "GroupTask/ChangeStatus";

  static const String getGroupTaskGetListUserGroupJob =
      "GroupTask/GetListUserGroupJob";
  static const String getGroupTaskGetListDeptAPI = "GroupTask/GetListDeptAPI";
  static const String getGroupTaskGetListUserByDeptAPI =
      "GroupTask/GetListUserByDeptAPI";
  static const String getGroupTaskGetInfoUserAPI = "GroupTask/GetInfoUserAPI";
  static const String getGroupTaskAddMember = "GroupTask/AddMember";
  static const String getGroupTaskEditMemberAPI = "GroupTask/EditMemberAPI";
  static const String getGroupTaskDeleteMember = "GroupTask/DeleteMember";

  static const String getGroupTaskAddColumn = "GroupTask/AddColumn";
  static const String getGroupTaskDeleteColumn = "GroupTask/DeleteColumn";
  static const String getGroupTaskChangeTitle = "GroupTask/ChangeTitle";
  static const String changeJobCoExcuterAndSupervisors =
      "Task/ChangeJobCoExcuterAndSupervisors";

  // User
  static const String getListUser = "Task/GetUserForSearch";
  static const String getGuestPlaceContractDetail = "guestplace/contractdetail";

  // List status
  static const String getListStatus = "Task/GetListStatusForCreated";
  static const String changeJobStatus = "Task/ChangeJobStatus";
  static const String getChangeUndefinedStatus = "Task/ChangeUndefinedStatus";

  // Filter list task
  static const String listForSearch = "Task/GetListForSearch";
  static const String getJobGroupForSearch = "Task/GetJobGroupForSearch";

  // Rating
  static const String ratingCloseJob = "Task/RatingCloseJob";

  //transfer
  static const String getDataForTranferUser = "Task/GetDataForTranferUser";
  static const String getTransferAndRateUser = "Task/TranferAndRateUser";
  static const String getTranferUser = "Task/TranferUser";
  static const String getListExecutorAPI = "Task/GetListExecutorAPI";

  //create
  static const String getCreateJob = "Task/CreateJob";
  static const String getDataForCreateJob = "Task/GetDataForCreateJob";
  static const String getCreateJobGroupForSearch = "Task/GetJobGroupForSearch";
  static const String getListGroupJobCol = "Task/GetListGroupJobCol";
  static const String getUserForCreateJob = "Task/GetUserForCreateJob";
  static const String getDataForEdit = "Task/GetDataForEdit";

  //edit
  static const String getSaveDetailJob = "Task/SaveDetailJob";

  // report
  static const String getDataForListGroupJob =
      "ReportQLCV/GetDataForListGroupJob";
  static const String getDataForListGroupJobReport =
      "ReportQLCV/GetDataGroupJobReport";
  static const String getDataForListGroupJobPesonal =
      "ReportQLCV/GetDataForListGroupJobPesonal";
  static const String getDataGroupJobReportPersonal =
      "ReportQLCV/GetDataGroupJobReportPersonal";
  static const String getDataGroupJobManagerReport =
      "ReportQLCV/GetDataGroupJobManagerReport";
  static const String getDataForListGroupJobManager =
      "ReportQLCV/GetDataForListGroupJobManager";

  // static const String getDataPerformanceReport =
  //     "ReportQLCV/GetDataPerformanceReport";
  static const String getListUserPerformanceReport =
      "ReportQLCV/GetListUserPerformanceReport";
  static const String getListJobGroup = "ReportQLCV/GetListJobGroup";
  static const String getDataDetailGroupJobReport =
      "ReportQLCV/GetDataDetailGroupJobReport";

  //notification
  static const String getNotification = "Notification/Index";
  static const String markNotificationRead = "Notification/StatusChange";

  // -------------------- M?????n tr??? t??i li???u - borrowPayDocument -----------------------//
  static const String getBorrowSearch = "Borrow/Search";
  static const String getBorrowAuser = "Borrow/Auser";
  static const String getBorrowCreated = "Borrow/Created";
  static const String getBorrowIndex = "Borrow/Index";
  static const String getStatistic = "report/stgdocborrow";
  static const String getBorrowRemoves = "Borrow/Removes"; // x??a nhi???u t??i li???u
  static const String getBorrowApproved =
      "Borrow/Approved"; // x??c nh???n duy???t - t??i li???u ???? ????ng k?? m?????n(quy???n c???a l??nh ?????o)
  static const String getBorrowRejected =
      "Borrow/Rejected"; // x??c nh???n t??? ch???i - t??i li???u ???? ????ng k?? m?????n(quy???n c???a l??nh ?????o)
  static const String getBorrowDisabled =
      "Borrow/Disabled"; //  x??c nh???n thu h???i - t??i li???u ???? ???????c duy???t(quy???n c???a l??nh ?????o)
  static const String getBorrowClosed =
      "Borrow/Closed"; //  x??c nh???n ????ng h??? s??- t??i li???u ???? tr???(quy???n c???a v??n th??)
  static const String getBorrowBorrowed =
      "Borrow/Borrowed"; //  x??c nh???n CHO M?????N - T??I LI???U ???? DUY???T(quy???n c???a v??n th??)
  static const String getBorrowRemove =
      "Borrow/Remove"; //  x??a 1 t??i li???u trong bottonsheet
  static const String getBorrowDetail = "Borrow/Detail";

  // -------------------- Qu???n l?? serial -----------------------//
  static const String qlmsSerialRemove = "qlms/SerialRemove";
  static const String qlmsSerialUpdate = "qlms/SerialUpdate";
  static const String qlmsSerialCreate = "qlms/SerialCreate";
  static const String qlmsSerialChange = "qlms/SerialChange";
  static const String qlmsSerialSave = "qlms/SerialSave";
  static const String qlmsGetContractsByRequisition =
      "qlms/GetContractsByRequisition";

  // -------------------- Qu???n l?? thanh to??n -----------------------//

  static const String qlmsPaymentProgressIndex = "qlms/PaymentProgressIndex";
  static const String qlmsDeliveryProgressSendMail =
      "qlms/DeliveryProgressSendMail";
  static const String qlmsPaymentProgressDetail = "qlms/PaymentProgressDetail";
  static const String qlmsPaymentProgressUpdate = "qlms/PaymentProgressUpdate";
  static const String qlmsContractOutOfStock = "qlms/ContractOutOfStock";
  static const String qlmsDeliveryProgress = "qlms/DeliveryProgress";
  static const String qlmsDeliveryProgressHistory =
      "qlms/DeliveryProgressHistory";
  static const String qlmsSendCheck = "qlms/SendCheck";
  static const String qlmsUpdateDeliveryProgress =
      "qlms/UpdateDeliveryProgress";
  static const String qlmsCreateDeliveryProgress =
      "qlms/CreateDeliveryProgress";
  static const String qlmsPaymentProgressComplete =
      "qlms/PaymentProgressComplete";
  static const String qlmsPaymentProgressSave = "qlms/PaymentProgressSave";
  static const String qlmsDeliveryIndex = "qlms/DeliveryIndex";
  static const String qlmsDeliveryView = "qlms/DeliveryView";
  static const String qlmsDeliveryUpdate = "qlms/DeliveryUpdate";
  static const String qlmsDeliverySave = "qlms/DeliverySave";
  static const String qlmsDeliveryFinish = "qlms/DeliveryFinish";
  static const String qlmsSaveDeliveryProgress = "qlms/SaveDeliveryProgress";
  static const String qlmsDeliveryProgressViewSendMail =
      "qlms/DeliveryProgressViewSendMail";
  static const String qlmsChangeDeliveryProgress =
      "qlms/ChangeDeliveryProgress";
  static const String qlmsViewCheckSlip = "qlms/ViewCheckSlip";

  // -------------------- Qu???n l?? mua s???m -----------------------//
  static const String qlmsDashboard = "qlms/Dashboard";
  static const String qlmsContractSave = "qlms/ContractSave";
  static const String qlmsContractSigninInfo = "qlms/ContractSigninInfo";
  static const String qlmsSerialDetail = "qlms/SerialDetail";
  static const String qlmsSerialIndex = "qlms/SerialIndex";
  static const String qlmsReportShoppingList =
      "qlms/DashboardInternalByCategory";
  static const String qlmsDashboardProjectByCategory =
      "qlms/DashboardProjectByCategory";
  static const String qlmsChooseProviderIndex = "qlms/ChooseProviderIndex";
  static const String qlmsChooseProviderSendMail =
      "qlms/ChooseProviderSendMail";
  static const String qlmsChooseProviderCreateContentMail =
      "qlms/ChooseProviderCreateContentMail";
  static const String qlmsSuggestProviderSeletected =
      "qlms/SuggestProviderSeletected";
  static const String qlmsConfirmProviderDetail = "qlms/ConfirmProviderDetail";
  static const String qlmsChooseProviderDetail = "qlms/ChooseProviderDetail";
  static const String qlmsTyGia = "qlms/TyGia";
  static const String qlmsConfirmProviderApproval =
      "qlms/ConfirmProviderApproval";
  static const String qlmsConfirmProviderReject = "qlms/ConfirmProviderReject";
  static const String qlmsChooseProviderSave = "qlms/ChooseProviderSave";
  static const String qlmsConfirmProviderIndex = "qlms/ConfirmProviderIndex";
  static const String qlmsConfirmProviderMutilApproval =
      "qlms/ConfirmProviderMutilApproval";
  static const String qlmsPriceReferProvider = "qlms/PriceReferProvider";
  static const String qlmsProviderIndex = "qlms/ProviderIndex";
  static const String qlmsSavePriceReferProvider =
      "qlms/SavePriceReferProvider";
  static const String qlmsGetIModule = "qlms/GetIModule";
  static const String qlmsContractIndex = "qlms/ContractIndex";
  static const String qlmsContractDetail = "qlms/ContractDetail";

  // -------------------- Qu???n l?? thanh to??n -----------------------//
  static const String qlmsPaymentProgressChangeProject =
      "qlms/PaymentProgressChangeProject";
  static const String qlmsPaymentProgressChangePRCode =
      "qlms/PaymentProgressChangePRCode";
  static const String qlmsGetRequisitionsByProjectContract =
      "qlms/GetRequisitionsByProjectContract";
  static const String qlmsGetContractsByReqDelivery =
      "qlms/GetContractsByReqDelivery";

  // -------------------- Qu???n l?? nh?? danh m???c h??ng ho?? -----------------------//
  static const String qlmsCommodityCategoryIndex =
      "qlms/CommodityCategoryIndex";
  static const String qlmsCommodityCategorySave = "qlms/CommodityCategorySave";
  static const String qlmsCommodityCategoryDelete =
      "qlms/CommodityCategoryDelete";
  static const String qlmsCommodityCategoryUpdate =
      "qlms/CommodityCategoryUpdate";
  static const String qlmsCommodityCategoryChange =
      "qlms/CommodityCategoryChange";

  // -------------------- Qu???n l?? h??ng ho?? -----------------------//
  static const String qlmsCommodityIndex = "qlms/CommodityIndex";
  static const String qlmsCommodityDetail = "qlms/CommodityDetail";
  static const String qlmsCommodityCreate = "qlms/CommodityCreate";
  static const String qlmsCommoditySave = "qlms/CommoditySave";
  static const String qlmsCommodityUpdate = "qlms/CommodityUpdate";
  static const String qlmsCommodityChange = "qlms/CommodityChange";
  static const String qlmsCommodityDelete = "qlms/CommodityDelete";
  static const String qlmsGetCommodityByCategory =
      "qlms/GetCommodityByCategory";

  // -------------------- Qu???n l?? nh?? cung c???p -----------------------//
  // static const String qlmsProviderIndex = "qlms/ProviderIndex";
  static const String qlmsProviderDetail = "qlms/ProviderDetail";
  static const String qlmsProviderDetailDebtLog = "qlms/ProviderDetailDebtLog";
  static const String qlmsProviderCreate = "qlms/ProviderCreate";
  static const String qlmsProviderSave = "qlms/ProviderSave";
  static const String qlmsProviderUpdate = "qlms/ProviderUpdate";
  static const String qlmsProviderChange = "qlms/ProviderChange";
  static const String qlmsProviderViewDebtLog = "qlms/ProviderViewDebtLog";
  static const String qlmsProviderRemove = "qlms/ProviderRemove";
  static const String qlmsProviderDetailDebt = "qlms/ProviderDetailDebt";
  static const String qlmsProviderUpdateDebtLog = "qlms/ProviderUpdateDebtLog";
  static const String qlmsProviderChangeDebtLog = "qlms/ProviderChangeDebtLog";
  static const String qlmsSuggestProvider = "qlms/SuggestProvider";

  // qu???n l?? h??ng
  static const String qlmsManufacturIndex = "qlms/ManufacturIndex";
  static const String qlmsManufacturRemove = "qlms/ManufacturRemove";
  static const String qlmsManufacturCreate =
      "qlms/ManufacturCreate"; // render t???o m???i
  static const String qlmsManufacturSave = "qlms/ManufacturSave"; // l??u t???o m???i
  static const String qlmsManufacturUpdate =
      "qlms/ManufacturUpdate"; // render update
  static const String qlmsManufacturChange =
      "qlms/ManufacturChange"; // l??u update

  // ????nh gi?? nh?? cung c???p
  static const String qlmsProviderVoteIndex = "qlms/ProviderVoteIndex";
  static const String qlmsProviderVoteDetail = "qlms/ProviderVoteDetail";
  static const String qlmsProviderVoteCreate = "qlms/ProviderVoteCreate";
  static const String qlmsProviderVoteSave = "qlms/ProviderVoteSave";
  static const String qlmsProviderVoteUpdate = "qlms/ProviderVoteUpdate";
  static const String qlmsProviderVoteChange = "qlms/ProviderVoteChange";
  static const String qlmsProviderVoteRemove = "qlms/ProviderVoteRemove";
  static const String qlmsGetProvidersByProject = "qlms/GetProvidersByProject";
  static const String qlmsGetNameByProvider = "qlms/GetNameByProvider";

  // k??? ho???ch mua s???m:
  static const String qlmsPlanningIndex = "qlms/PlanningIndex";
  static const String qlmsPlanningDetail = "qlms/PlanningDetail";

  // y??u c???u mua s???m
  static const String qlmsRequisitionIndex = "qlms/RequisitionIndex";
  static const String qlmsRequisitionDetail = "qlms/RequisitionDetail";
  static const String qlmsRequisitionReject = "qlms/RequisitionReject";
  static const String qlmsRequisitionApprove = "qlms/RequisitionApprove";

  // b??o c??o th???ng k??
  static const String qlmsGeneralReport = "qlms/GeneralReport";
  static const String qlmsDetailReport = "qlms/DetailReport";
  static const String qlmsProgressReport = "qlms/ProgressReport";
  static const String qlmsGetRequisitionsByProjectRp =
      "qlms/GetRequisitionsByProjectRp";

  // static const String qlmsGetContractsByRequisition = "qlms/GetContractsByRequisition";
  static const String qlmsImportReport = "qlms/importReport";
  static const String qlmsManufacturReport = "qlms/ManufacturReport";

  // -------------------- Qu???n l?? kinh doanh - businessManagement -----------------------//
  static const String getProjecTreportIndex =
      "projectreport/index"; // t???ng quan
  static const String getdataDetailPartMent =
      "projectreport/depts"; // Th???ng k?? chi ti???t - theo ph??ng ban
  static const String getDataDetailSeller =
      "projectreport/sellers"; // Th???ng k?? chi ti???t - theo seller
  static const String getDataDetailRegion =
      "ProjectReport/Areas"; // Th???ng k?? chi ti???t - theo t???nh th??nh(v??ng)
  static const String getDataDetailCustomers =
      "ProjectReport/customers"; // Th???ng k?? chi ti???t - theo kh??ch h??ng
  static const String getByTheTimeReport =
      "projectreport/Timereport"; // Doanh thu - theo th???i gian
  static const String getDataByStateBusinessManager =
      "projectreport/PhaseReport"; // Doanh thu - theo th???i gian
  static const String getTopContract =
      "projectreport/TopContract"; // top h???p ?????ng
  static const String getContractListAll =
      "contract/getall"; // danh s??ch h???p ?????ng
  static const String getTopSeller =
      "projectreport/TopSeller"; // danh s??ch top seller
  static const String getBonusDept =
      "projectreport/bonusPB"; // th?????ng - theo ph??ng ban
  static const String getBonusBranch =
      "projectreport/bonusCN"; // th?????ng - theo chi nh??nh
  static const String getBonusSeller =
      "projectreport/bonusSeller"; // th?????ng - top th?????ng c?? nh??n
  static const String getExpectedYear =
      "projectreport/ExpectedYear"; // Doanh thu d??? ki???n  - c??c n??m g???n ????y
  static const String getExpectedQuarter =
      "projectreport/ExpectedQuarter"; // Doanh thu d??? ki???n  - theo qu??
  static const String getExpectedMonth =
      "projectreport/ExpectedMonth"; // Doanh thu d??? ki???n  - theo th??ng
  static const String getExpectedPlan =
      "projectreport/ExpectedPlan"; // Doanh thu d??? ki???n  - theo k??? ho???ch

  // qu???n l??
  static const String getIModule = "projectplan/getimodule"; //
  static const String getProjectPlanIndex =
      "projectplan/index"; // danh s??ch c?? h???i ADMIN
  static const String getGuestPlaceIndex =
      "guestplace/projectplan"; // danh s??ch c?? h???i kh??ch
  static const String getProjectPlanCreate = "projectplan/Create"; // t???o c?? h???i
  static const String getSelectCustomer =
      "projectplan/selectCustomer"; // nh??m kh??ch h??ng
  static const String getPotentialTypeInfo =
      "projectplan/GetPotentialTypeInfo"; // ?????nh ngh??a m???c ????? ????nh gi??

  // -------------------- Qu???n l?? t??i li???u - storage -----------------------//
  // Storage
  static const String storageIndex = "StgFile/Index";

  static String checkDownloadFile({bool isShared}) {
    var type = AppStore.currentBottomViewTypeStorage;
    if (isShared == true) {
      return "ShareFile/F";
    } else if (isShared == false) {
      return "/StgFile/F";
    }
    if (type == StorageBottomTabType.DataStorage) {
      return "/StgFile/F";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/F";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/F";
    }
  }

  static String getStorageIndex() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Index";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Index";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Index";
    }
  }

  static String getCreateNewFolder() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Savefolder";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Savefolder";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Savefolder";
    }
  }

  static String getStorageChange() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Change";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Change";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Change";
    }
  }

  static String getStoragePinDoc() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/PinDoc";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/PinDoc";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/PinDoc";
    }
  }

  static String getStorageDeletes() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Deletes";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Deletes";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Deletes";
    }
  }

  static String getStorageSavePassword() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/SavePassword";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/SavePassword";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/SavePassword";
    }
  }

  static String getStorageDeletePassword() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/DeletePassword";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/DeletePassword";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/DeletePassword";
    }
  }

  static String getStorageAuthenPassword() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/PasswordAuthen";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/PasswordAuthen";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/PasswordAuthen";
    }
  }

  static String getStorageMove() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Move";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Move";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Move";
    }
  }

  static String getSaveupFile() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/SaveupFile";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/SaveupFile";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/SaveupFile";
    }
  }

  static String getStorageChangeFile() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/ChangeFile";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/ChangeFile";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/ChangeFile";
    }
  }

  static String getStoragePins() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Pins";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Pins";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Pins";
    }
  }

  static String getStorageRecents() {
    var type = AppStore.currentBottomViewTypeStorage;
    if (type == StorageBottomTabType.DataStorage) {
      return "StgFile/Recents";
    } else if (type == StorageBottomTabType.MyFile) {
      return "MyFile/Recents";
    } else if (type == StorageBottomTabType.Shared) {
      return "ShareFile/Recents";
    }
  }

// -------------------- Qu???n l?? kinh doanh - businessManagement -----------------------//
//   static const String getProjecTreportIndex =
//       "projectreport/index"; // t???ng quan
//   static const String getdataDetailPartMent =
//       "projectreport/depts"; // Th???ng k?? chi ti???t - theo ph??ng ban
//   static const String getDataDetailSeller =
//       "projectreport/sellers"; // Th???ng k?? chi ti???t - theo seller
//   static const String getDataDetailRegion =
//       "ProjectReport/Areas"; // Th???ng k?? chi ti???t - theo t???nh th??nh(v??ng)
//   static const String getDataDetailCustomers =
//       "ProjectReport/customers"; // Th???ng k?? chi ti???t - theo kh??ch h??ng
//   static const String getByTheTimeReport =
//       "projectreport/Timereport"; // Doanh thu - theo th???i gian
//   static const String getDataByStateBusinessManager =
//       "projectreport/PhaseReport"; // Doanh thu - theo th???i gian
//   static const String getTopContract =
//       "projectreport/TopContract"; // top h???p ?????ng
//   static const String getContractListAll =
//       "contract/getall"; // danh s??ch h???p ?????ng
//   static const String getTopSeller =
//       "projectreport/TopSeller"; // danh s??ch top seller
//   static const String getBonusDept =
//       "projectreport/bonusPB"; // th?????ng - theo ph??ng ban
//   static const String getBonusBranch =
//       "projectreport/bonusCN"; // th?????ng - theo chi nh??nh
//   static const String getBonusSeller =
//       "projectreport/bonusSeller"; // th?????ng - top th?????ng c?? nh??n
//   static const String getExpectedYear =
//       "projectreport/ExpectedYear"; // Doanh thu d??? ki???n  - c??c n??m g???n ????y
//   static const String getExpectedQuarter =
//       "projectreport/ExpectedQuarter"; // Doanh thu d??? ki???n  - theo qu??
//   static const String getExpectedMonth =
//       "projectreport/ExpectedMonth"; // Doanh thu d??? ki???n  - theo th??ng
//   static const String getExpectedPlan =
//       "projectreport/ExpectedPlan"; // Doanh thu d??? ki???n  - theo k??? ho???ch

  // qu???n l??
  // static const String getIModule = "projectplan/getimodule"; //
  // static const String getProjectPlanIndex = "projectplan/index"; //
  // static const String getProjectPlanCreate = "projectplan/Create"; // t???o c?? h???i
  // static const String getSelectCustomer =
  //     "projectplan/selectCustomer"; // nh??m kh??ch h??ng
  // static const String getPotentialTypeInfo =
  //     "projectplan/GetPotentialTypeInfo"; // ?????nh ngh??a m???c ????? ????nh gi??
  static const String getPotentialSave =
      "projectplan/Save"; //l??u t???o m???i c?? h???i
  static const String getProjectPlanUpdate =
      "projectplan/Update"; // ch???nh s???a c?? h???i
  static const String getProjectPlanChange =
      "projectplan/Change"; // change ch???nh s???a c?? h???i
  static const String getDetailKhach =
      "guestplace/projectplandetail"; // chi ti???t c?? h???i kh??ch
  static const String getDetailAdmin =
      "ProjectPlan/detail"; // chi ti???t c?? h???i admin
  static const String getDetailHistories =
      "ProjectPlan/Histories"; // l???ch s??? chi ti???t c?? h???i
  static const String getDetailChangeStatus =
      "ProjectPlan/ChangeStatus"; // thay ?????i trang th??i chi ti???t
  static const String getDetailChangePhase =
      "ProjectPlan/ChangePhase"; // thay ?????i giai ??o???n chi ti???t
  static const String getContractTrash = "contract/trash"; // X??a h???p ?????ng
  static const String getContractRemove =
      "contract/remove"; // X??a v??nh vi???n h???p ?????ng
  static const String getContractRestore =
      "contract/restore"; // kh??i ph???c h???p ?????ng
  static const String getDeleteFileOpportunity =
      "ProjectPlan/DeleteFile"; // x??a file ????nh k??m
  static const String getDeleteCommentsOpportunity =
      "ProjectPlan/DeleteCmt"; // x??a ho???t ?????ng
  static const String projectPlanReject = "projectplan/Reject"; // Reject c?? h???i
  static const String projectPlanRemove = "projectplan/remove"; // Remove c?? h???i
  static const String projectPlanRestore =
      "projectplan/restore"; // Restore c?? h???i
  static const String projectPlanTrash = "projectplan/trash"; // Xo?? c?? h???i
  static const String projectPlanCopy = "projectplan/copy"; // Xo?? c?? h???i
  static const String projectPlanApprove =
      "projectplan/Approve"; // Duy???t c?? h???i
  static const String getAddCommentsOpportunity =
      "ProjectPlan/AddCmt"; // tr??? l???i ho???t ?????ng  chi ti???t c?? h???i
  static const String getOpportunityImportFile =
      "ProjectPlan/ImportFile"; // th??m file  chi ti???t c?? h???i
  static const String getOpportunityFileChange =
      "ProjectPlan/FileChange"; // ch???nh s???a file  chi ti???t c?? h???i
  static const String getProjectPlanCopy =
      "projectplan/copy"; // ch???nh s???a file  chi ti???t c?? h???i
  static const String getContractCreate = "Contract/Create"; // t???o m???i h???p ?????ng
  static const String getContractSave = "Contract/Save";
  static const String getContractUpdate =
      "Contract/Update"; // ch???nh s???a h???p ?????ng
  static const String getContractChange = "Contract/Change";
  static const String getContractDetail =
      "contract/detail"; // chi ti???t h???p ?????ng
  static const String getContractSaveAttach =
      "contract/SaveAttach"; // add file h???p ?????ng
  static const String getContractDeleteAttach =
      "contract/DeleteAttach"; // x??a file h???p ?????ng
  static const String getContractHistories =
      "Contract/Histories"; // l???ch s??? h???p ?????ng
  static const String getContractDeleteCmt =
      "contract/DeleteCmt"; // x??a comment h???p ?????ng
  static const String getContractAddCmt = "contract/AddCmt"; // comment h???p ?????ng
  static const String getContractDeletePayment =
      "contract/DeletePayment"; // x??a giai ??o???n h???p ?????ng
  static const String getContractChangePaymentStatus =
      "contract/ChangePaymentStatus"; // tr???ng th??i giai ??o???n h???p ?????ng
  static const String getContractSavePayment =
      "contract/SavePayment"; // t???o giai ??o???n h???p ?????ng
  static const String getContractChangePayment =
      "contract/ChangePayment"; // ch??nh s???a giai ??o???n h???p ?????ng
  static const String getProjectPlanApproveEdit =
      "projectplan/ApproveEdit"; // duy???t ch???nh s???a c?? h???i
  static const String getProjectPlanRejectEdit =
      "projectplan/RejectEdit"; // t??? ch???i duy???t ch???nh s???a c?? h???i



  static const String get_list_member = "Account/GetList";
  static const String get_list_department = "Dept/Index";

  //MODULE 1
  static const String work_commands = "LenhCongTac/index";
  static const String work_command_detail = "LenhCongTac/Detail";
  static const String work_command_add_member_join = "LenhCongTac/BoSungMotThanhVienThamGia";
  static const String work_command_delete_member_join = "LenhCongTac/XoaMotThanhVienThamGia";
  static const String work_command_add_work_sequence = "LenhCongTac/BoSungMotTrinhTuCongViec";
  static const String work_command_delete_work_sequence = "LenhCongTac/XoaMotTrinhTuCongViec";
  static const String work_command_notify_complete = "LenhCongTac/ThongBaoHoanThanh";
  static const String work_command_change_direct_commander = "LenhCongTac/ThayDoiChiHuyTrucTiep";
  static const String work_command_list_direct_commander = "LenhCongTac/DanhSachChiHuyTrucTiep";
  static const String work_command_is_check_in = "LenhCongTac/IsCheckIn";
  static const String work_command_check_in = "LenhCongTac/CheckIn";
  static const String work_command_is_check_out = "LenhCongTac/IsCheckOut";
  static const String work_command_check_out = "LenhCongTac/CheckOut";
  static const String work_command_confirm_attendance = "LenhCongTac/XacNhanCoMatDayDu";
  static const String work_command_confirm_withdraw = "LenhCongTac/XacNhanRutKhoi";
  static const String work_command_is_confirm_sequence = "LenhCongTac/IsTrinhTuThucHien";
  static const String work_command_confirm_sequence = "LenhCongTac/TrinhTuThucHien";
  static const String work_command_sign_process = "LenhCongTac/ViewFileTrinhKy";
  static const String work_command_change_shift_leader = "LenhCongTac/ThayDoiTruongCa";
  static const String work_command_change_assignment = "LenhCongTac/ThayDoiPhanCong";
  static const String work_command_confirm_change_shift_leader = "LenhCongTac/XacNhanThayDoi";
  static const String work_command_cancel = "LenhCongTac/IsCancel";

  //MODULE 2
  static const String work_sheets = "PhieuCongTac/index";
  static const String work_sheet_detail = "PhieuCongTac/Detail";
  static const String work_sheet_add_member_join = "PhieuCongTac/BoSungMotThanhVienThamGia";
  static const String work_sheet_delete_member_join = "PhieuCongTac/XoaMotThanhVienThamGia";
  static const String work_sheet_change_direct_commander = "PhieuCongTac/ThayDoiChiHuyTrucTiep";
  static const String work_sheet_list_direct_commander = "PhieuCongTac/DanhSachChiHuyTrucTiep";
  static const String work_sheet_notify_complete = "PhieuCongTac/ThongBaoHoanThanh";
  static const String work_sheet_add_work_place = "PhieuCongTac/BoSungMotDiaDiemCongViec";
  static const String work_sheet_delete_work_place = "PhieuCongTac/XoaMotDiaDiemCongViec";
  static const String work_sheet_is_check_in = "PhieuCongTac/IsCheckIn";
  static const String work_sheet_check_in = "PhieuCongTac/CheckIn";
  static const String work_sheet_is_check_out = "PhieuCongTac/IsCheckOut";
  static const String work_sheet_check_out = "PhieuCongTac/CheckOut";
  static const String work_sheet_confirm_attendance = "PhieuCongTac/XacNhanCoMatDayDu";
  static const String work_sheet_confirm_withdraw = "PhieuCongTac/XacNhanRutKhoi";
  static const String work_sheet_is_confirm_location = "PhieuCongTac/IsXacNhanDiaDiem";
  static const String work_sheet_confirm_location = "PhieuCongTac/XacNhanDiaDiem";
  static const String work_sheet_sign_process = "PhieuCongTac/ViewFileTrinhKy";
  static const String work_sheet_change_shift_leader = "PhieuCongTac/ThayDoiTruongCa";
  static const String work_sheet_change_assignment = "PhieuCongTac/ThayDoiPhanCong";
  static const String work_sheet_confirm_change_shift_leader = "PhieuCongTac/XacNhanThayDoi";
  static const String work_sheet_cancel = "PhieuCongTac/IsCancel";

  //MODULE 3
  static const String mechanical_work_commands = "LenhCongTacCNH/index";
  static const String mechanical_work_command_detail = "LenhCongTacCNH/Detail";
  static const String mechanical_work_command_change_direct_commander = "LenhCongTacCNH/ThayDoiChiHuyTrucTiep";
  static const String mechanical_work_command_list_direct_commander = "LenhCongTacCNH/DanhSachChiHuyTrucTiep";
  static const String mechanical_work_command_add_member_join = "LenhCongTacCNH/BoSungMotThanhVienThamGia";
  static const String mechanical_work_command_delete_member_join = "LenhCongTacCNH/XoaMotThanhVienThamGia";
  static const String mechanical_work_command_add_work_diary = "LenhCongTacCNH/BoSungMotNhatKyCongViec";
  static const String mechanical_work_command_delete_work_diary = "LenhCongTacCNH/XoaMotNhatKyCongViec";
  static const String mechanical_work_command_notify_complete = "LenhCongTacCNH/ThongBaoHoanThanh";
  static const String mechanical_work_command_is_check_in = "LenhCongTacCNH/IsCheckIn";
  static const String mechanical_work_command_check_in = "LenhCongTacCNH/CheckIn";
  static const String mechanical_work_command_is_check_out = "LenhCongTacCNH/IsCheckOut";
  static const String mechanical_work_command_check_out = "LenhCongTacCNH/CheckOut";
  static const String mechanical_work_command_confirm_attendance = "LenhCongTacCNH/XacNhanCoMatDayDu";
  static const String mechanical_work_command_confirm_withdraw = "LenhCongTacCNH/XacNhanRutKhoi";
  static const String mechanical_work_command_is_confirm_diary = "LenhCongTacCNH/IsNhatKy";
  static const String mechanical_work_command_confirm_diary = "LenhCongTacCNH/NhatKy";
  static const String mechanical_work_command_sign_process = "LenhCongTacCNH/ViewFileTrinhKy";
  static const String mechanical_work_command_change_shift_leader = "LenhCongTacCNH/ThayDoiTruongCa";
  static const String mechanical_work_command_change_assignment = "LenhCongTacCNH/ThayDoiPhanCong";
  static const String mechanical_work_command_confirm_change_shift_leader = "LenhCongTacCNH/XacNhanThayDoi";
  static const String mechanical_work_command_cancel = "LenhCongTacCNH/IsCancel";

  //MODULE 4
  static const String mechanical_work_sheets = "PhieuCongTacCNH/index";
  static const String mechanical_work_sheet_detail = "PhieuCongTacCNH/Detail";
  static const String mechanical_work_sheet_add_member_join = "PhieuCongTacCNH/BoSungMotThanhVienThamGia";
  static const String mechanical_work_sheet_delete_member_join = "PhieuCongTacCNH/XoaMotThanhVienThamGia";
  static const String mechanical_work_sheet_change_direct_commander = "PhieuCongTacCNH/ThayDoiNguoiChiHuyTrucTiep";
  static const String mechanical_work_sheet_list_direct_commander = "PhieuCongTacCNH/DanhSachChiHuyTrucTiep";
  static const String mechanical_work_sheet_notify_complete = "PhieuCongTacCNH/ThongBaoHoanThanh";
  static const String mechanical_work_sheet_add_work_place = "PhieuCongTacCNH/BoSungMotDiaDiemCongViec";
  static const String mechanical_work_sheet_delete_work_place = "PhieuCongTacCNH/XoaMotDiaDiemCongViec";
  static const String mechanical_work_sheet_is_check_in = "PhieuCongTacCNH/IsCheckIn";
  static const String mechanical_work_sheet_check_in = "PhieuCongTacCNH/CheckIn";
  static const String mechanical_work_sheet_is_check_out = "PhieuCongTacCNH/IsCheckOut";
  static const String mechanical_work_sheet_check_out = "PhieuCongTacCNH/CheckOut";
  static const String mechanical_work_sheet_confirm_attendance = "PhieuCongTacCNH/XacNhanCoMatDayDu";
  static const String mechanical_work_sheet_confirm_withdraw = "PhieuCongTacCNH/XacNhanRutKhoi";
  static const String mechanical_work_sheet_is_confirm_location = "PhieuCongTacCNH/IsXacNhanDiaDiem";
  static const String mechanical_work_sheet_confirm_location = "PhieuCongTacCNH/XacNhanDiaDiem";
  static const String mechanical_work_sheet_sign_process = "PhieuCongTacCNH/ViewFileTrinhKy";
  static const String mechanical_work_sheet_change_shift_leader = "PhieuCongTacCNH/ThayDoiTruongCa";
  static const String mechanical_work_sheet_change_assignment = "PhieuCongTacCNH/ThayDoiPhanCong";
  static const String mechanical_work_sheet_confirm_change_shift_leader = "PhieuCongTacCNH/XacNhanThayDoi";
  static const String mechanical_work_sheet_cancel = "PhieuCongTacCNH/IsCancel";

  //MODULE 5
  static const String manipulation_sheets = "PhieuThaoTac/index";
  static const String manipulation_sheet_detail = "PhieuThaoTac/Detail";
  static const String manipulation_sheet_update_unusual_event = "PhieuThaoTac/CapNhatSuKienBatThuong";
  static const String manipulation_sheet_is_order_receiving = "PhieuThaoTac/IsTrinhTuNhanLenh";
  static const String manipulation_sheet_order_receiving = "PhieuThaoTac/XacNhanTrinhTuNhanLenh";
  static const String manipulation_sheet_order_command = "PhieuThaoTac/XacNhanTrinhTuRaLenh";
  static const String manipulation_sheet_add_sequence = "PhieuThaoTac/BoSungMotTrinhTuThaoTac";
  static const String manipulation_sheet_edit_sequence  = "PhieuThaoTac/CapNhatMotTrinhTuThaoTac";
  static const String manipulation_sheet_delete_sequence  = "PhieuThaoTac/XoaMotTrinhTuThaoTac";
  static const String manipulation_sheet_notify_complete = "PhieuThaoTac/ThongBaoHoanThanh";

  //MODULE 6
  static const String manager_receiving_oil = "TiepNhanHoSoDau/index";
  static const String manager_receiving_oil_detail = "TiepNhanHoSoDau/ChiTietTiepNhan";
  static const String manager_receiving_oil_create_receipt = "TiepNhanHoSoDau/TaoTiepNhan";
  static const String manager_receiving_oil_require_before = "TiepNhanHoSoDau/YeuCauTiepNhanTruocVaTrong";
  static const String manager_receiving_oil_require_after = "TiepNhanHoSoDau/YeuCauTiepNhanSau";
  static const String manager_receiving_oil_notice_complete = "TiepNhanHoSoDau/CapNhatTrangThaiHoanThanh";

  //MODULE 7
  static const String manager_receiving_limestone = "TiepNhanHoSoDaVoi/index";
  static const String manager_receiving_limestone_detail = "TiepNhanHoSoDaVoi/ChiTietTiepNhan";
  static const String manager_receiving_limestone_create_receipt = "TiepNhanHoSoDaVoi/TaoTiepNhan";
  static const String manager_receiving_limestone_save_receipt = "TiepNhanHoSoDaVoi/LuuTiepNhan";
  static const String manager_receiving_limestone_create_require = "TiepNhanHoSoDaVoi/TaoYeuCauTiepNhan";
  static const String manager_receiving_limestone_require_before = "TiepNhanHoSoDaVoi/YeuCauTiepNhanTruocVaTrong";
  static const String manager_receiving_limestone_notice_complete = "TiepNhanHoSoDaVoi/ThongBaoHoanThanh";



//MODULE 8
// static const String reception_with_contract = "LenhCongTacCNH/index";

//MODULE 9
// static const String reception_without_contract = "LenhCongTacCNH/index";



}
