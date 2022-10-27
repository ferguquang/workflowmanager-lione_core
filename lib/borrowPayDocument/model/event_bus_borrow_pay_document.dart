// dành cho các danh sách mượn trả tài liệu
class GetDataBorrowIndexEvent {
  List<int> listCount;

  GetDataBorrowIndexEvent(this.listCount);
}

// dành cho các action ở bottomSheet bottomsheet_approved_repository.dart chuyển đến class list_borrow_document_repository.dart
class GetDataBorrowApprovedEvent {
  bool status;

  GetDataBorrowApprovedEvent(this.status);
}

// dành cho xóa ở detail_borrow_document_repository.dart chuyển đến class list_borrow_document_repository.dart
class GetDataBorrowDeleteEvent {
  bool status;
  int idItem;

  GetDataBorrowDeleteEvent(this.status, this.idItem);
}

// dành cho search ở tab_borrow_pay_document_screen.dart chuyển đến class list_borrow_document_repository.dart
class GetDataBorrowSearchEvent {
  String textSearch;

  GetDataBorrowSearchEvent(this.textSearch);
}

// dành cho search ở detail_register_borrow_document_repository.dart chuyển đến class thống kê
class GetDataBorrowDetailSearchEvent {
  GetDataBorrowDetailSearchEvent();
}
