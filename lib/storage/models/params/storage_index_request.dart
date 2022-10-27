import 'package:workflow_manager/base/utils/common_function.dart';

class StorageIndexRequest {
  int take;
  int sortType;
  int skip;
  int idDoc;
  String sortname;

  String term;
  String typeExtension;
  String tpDateCreate;
  String iDDoctype;
  String accessSafePassword;

  // Token(Đây là mã mà lúc đăng nhập server trả về cho app )
  // IDDoc (Đây là mã danh mục hoặc tài liệu muốn lấy theo)
  // Lấy tất cả IDDoc = 0
  // AccessSafePassword: Mật khẩu nếu có
  // Take :   số lượng thư mục, tài liệu cần lấy  ( Giá trị mặc định 20)
  // Skip :   từ số bao nhiêu ( Giá trị mặc định là từ 0)
  // TypeExtension:Loại tìm kiếm (Sheet Ds loại tìm kiếm)
  // Term:Từ khóa tìm kiếm
  // TpDateCreate :danh sách ngày tạo (Sheet Danh sách loại ngày tạo)
  // IDDoctype :Loại văn bản
  // Sortname:("Created":Ngày tạo,"Updated":Ngày cập nhật,Name:Sap xep theo ten )
  // Sorttype :1 :Tang dan ,0:Giam dam

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    params["Take"] = this.take;
    params["Skip"] = this.skip;

    if (sortType != null) {
      params["Sorttype"] = sortType;
    }
    if (idDoc != null) {
      params["IDDoc"] = idDoc;
    }
    if (sortname != null) {
      params["Sortname"] = sortname;
    }
    if (isNotNullOrEmpty(term)) {
      params["Term"] = term;
    }
    if (typeExtension != null) {
      params["TypeExtension"] = typeExtension;
    }
    if (tpDateCreate != null) {
      params["TpDateCreate"] = tpDateCreate;
    }
    if (iDDoctype != null) {
      params["IDDoctype"] = iDDoctype;
    }
    if (accessSafePassword != null) {
      params["AccessSafePassword"] = accessSafePassword;
    }

    return params;
  }
}
