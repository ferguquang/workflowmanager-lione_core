class NotificationType {
  static NotificationType _instance;

  static NotificationType get instance {
    if (_instance == null) {
      _instance = NotificationType();
    }
    return _instance;
  }

  /// Quả lý tài liệu
  //Quản lý tài liệu
  bool isStorage(int type) {
    return type == 4;
  }

  //chia sẻ thư mục | tài liệu cá nhân
  bool isShareDoc(int type) {
    return type == 2;
  }

  /// Quản lý công việc
  //Chi tiết công việc
  bool isDetailJob(int type) {
    return type == 273;
  }

  //Chi tiết nhóm công việc
  bool isDetailGroupJob(int type) {
    return type == 278;
  }

  /// Mượn trả tài liệu
  //Chi tiết mượn trả tài liệu
  bool isDetailBorrow(int type) {
    return type == 63 ||
        type == 20 ||
        type == 21 ||
        type == 22 ||
        type == 26 ||
        type == 27;
  }

  //MƯỢN TRẢ TÀI LIỆU - CHỜ DUYỆT
  bool isBorrowPending(int type) {
    return type == 63;
  }

  //MƯỢN TRẢ TÀI LIỆU - ĐÃ DUYỆT
  bool isBorrowApproved(int type) {
    return type == 20;
  }

  //MƯỢN TRẢ TÀI LIỆU - ĐÃ TRẢ
  bool isBorrowClosed(int type) {
    return type == 22;
  }

  //MƯỢN TRẢ TÀI LIỆU - THU HỒI
  bool isBorrowDisabled(int type) {
    return type == 27;
  }

  //MƯỢN TRẢ TÀI LIỆU - TỪ CHỐI
  bool isBorrowRejected(int type) {
    return type == 26;
  }

  bool isDownloadFile(int type) {
    return type == 5;
  }

  //MƯỢN TRẢ TÀI LIỆU - XEM FILE
  bool isOpenFile(int type) {
    return type == 21;
  }

  bool zipFolderEmpty(int type) {
    return type == 25;
  }

  /// Quy trình thủ tục
  //Chi tiết đăng ký
  bool isDetailRegister(int type) {
    return [43].contains(type);
  }

  //Chi tiết giải quyết cần idShare
  bool isDetailResolveIDShare(int type) {
    return type == 5002;
  }
  //Chi tiết giải quyết
  bool isDetailResolve(int type) {
    return [36,5000].contains(type);
  }

  ///Quản lý kinh doanh
  //Chi tiết quản lý kinh doanh
  bool isDetailBusiness(int type) {
    return type == 65;
  }

  ///Quản lý dự án
  //Yêu cầu deploy dự án ?
  bool isRequestDeployPlan(int type) {
    return type == 53;
  }

  bool isDetailPlan(int type) {
    return type == 48;
  }

  bool isNoNavigation(int type) {
    return type == 279;
  }

}
