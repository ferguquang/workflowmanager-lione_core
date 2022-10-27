import 'package:workflow_manager/base/models/base_response.dart';

class ModuleRoleResponse extends BaseResponse {
  int status;
  ModuleRoleModel data;

  ModuleRoleResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ModuleRoleModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class ModuleRoleModel {
  bool isMenuHangHoaNCC;
  bool isMenuKHMuaSam;
  bool isMenuYCMuaSam;
  bool isMenuQLHopDong;
  bool isMunuTienDoThucHien;
  bool isMenuBaoCaoThongKe;
  bool isQuanlyDmHangHoa;
  bool isQuanLyHangHoa;
  bool isQuanLyHang;
  bool isQuanLyNCC;
  bool isDanhGiaNCC;
  bool isQuanLyKeHoach;
  bool isQuanLyYeuCau;
  bool isLuaChonNCC;
  bool isDuyetLuaChonNCC;
  bool isQuanLyHopDong;
  bool isQuanLySerial;
  bool isQuanLyTienDoThanhToan;
  bool isHangVeBanGiao;
  bool isBaoCaoTongHopMuaSam;
  bool isBaoCaoChiTietMuaSam;
  bool isBaoCaoTienDoMuaSam;
  bool isBaoCaoNhapHangPhanPhoi;
  bool isBaoCaoMuaSamTheoHang;
  bool isViewDardboard;

  ModuleRoleModel(
      {this.isMenuHangHoaNCC,
      this.isMenuKHMuaSam,
      this.isMenuYCMuaSam,
      this.isMenuQLHopDong,
      this.isMunuTienDoThucHien,
      this.isMenuBaoCaoThongKe,
      this.isQuanlyDmHangHoa,
      this.isQuanLyHangHoa,
      this.isQuanLyHang,
      this.isQuanLyNCC,
      this.isDanhGiaNCC,
      this.isQuanLyKeHoach,
      this.isQuanLyYeuCau,
      this.isLuaChonNCC,
      this.isDuyetLuaChonNCC,
      this.isQuanLyHopDong,
      this.isQuanLySerial,
      this.isQuanLyTienDoThanhToan,
      this.isHangVeBanGiao,
      this.isBaoCaoTongHopMuaSam,
      this.isBaoCaoChiTietMuaSam,
      this.isBaoCaoTienDoMuaSam,
      this.isBaoCaoNhapHangPhanPhoi,
      this.isBaoCaoMuaSamTheoHang,
      this.isViewDardboard});

  ModuleRoleModel.fromJson(Map<String, dynamic> json) {
    isMenuHangHoaNCC = json['IsMenuHangHoaNCC'];
    isMenuKHMuaSam = json['IsMenuKHMuaSam'];
    isMenuYCMuaSam = json['IsMenuYCMuaSam'];
    isMenuQLHopDong = json['IsMenuQLHopDong'];
    isMunuTienDoThucHien = json['IsMunuTienDoThucHien'];
    isMenuBaoCaoThongKe = json['IsMenuBaoCaoThongKe'];
    isQuanlyDmHangHoa = json['IsQuanlyDmHangHoa'];
    isQuanLyHangHoa = json['IsQuanLyHangHoa'];
    isQuanLyHang = json['IsQuanLyHang'];
    isQuanLyNCC = json['IsQuanLyNCC'];
    isDanhGiaNCC = json['IsDanhGiaNCC'];
    isQuanLyKeHoach = json['IsQuanLyKeHoach'];
    isQuanLyYeuCau = json['IsQuanLyYeuCau'];
    isLuaChonNCC = json['IsLuaChonNCC'];
    isDuyetLuaChonNCC = json['IsDuyetLuaChonNCC'];
    isQuanLyHopDong = json['IsQuanLyHopDong'];
    isQuanLySerial = json['IsQuanLySerial'];
    isQuanLyTienDoThanhToan = json['IsQuanLyTienDoThanhToan'];
    isHangVeBanGiao = json['IsHangVeBanGiao'];
    isBaoCaoTongHopMuaSam = json['IsBaoCaoTongHopMuaSam'];
    isBaoCaoChiTietMuaSam = json['IsBaoCaoChiTietMuaSam'];
    isBaoCaoTienDoMuaSam = json['IsBaoCaoTienDoMuaSam'];
    isBaoCaoNhapHangPhanPhoi = json['IsBaoCaoNhapHangPhanPhoi'];
    isBaoCaoMuaSamTheoHang = json['IsBaoCaoMuaSamTheoHang'];
    isViewDardboard = json['IsViewDardboard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsMenuHangHoaNCC'] = this.isMenuHangHoaNCC;
    data['IsMenuKHMuaSam'] = this.isMenuKHMuaSam;
    data['IsMenuYCMuaSam'] = this.isMenuYCMuaSam;
    data['IsMenuQLHopDong'] = this.isMenuQLHopDong;
    data['IsMunuTienDoThucHien'] = this.isMunuTienDoThucHien;
    data['IsMenuBaoCaoThongKe'] = this.isMenuBaoCaoThongKe;
    data['IsQuanlyDmHangHoa'] = this.isQuanlyDmHangHoa;
    data['IsQuanLyHangHoa'] = this.isQuanLyHangHoa;
    data['IsQuanLyHang'] = this.isQuanLyHang;
    data['IsQuanLyNCC'] = this.isQuanLyNCC;
    data['IsDanhGiaNCC'] = this.isDanhGiaNCC;
    data['IsQuanLyKeHoach'] = this.isQuanLyKeHoach;
    data['IsQuanLyYeuCau'] = this.isQuanLyYeuCau;
    data['IsLuaChonNCC'] = this.isLuaChonNCC;
    data['IsDuyetLuaChonNCC'] = this.isDuyetLuaChonNCC;
    data['IsQuanLyHopDong'] = this.isQuanLyHopDong;
    data['IsQuanLySerial'] = this.isQuanLySerial;
    data['IsQuanLyTienDoThanhToan'] = this.isQuanLyTienDoThanhToan;
    data['IsHangVeBanGiao'] = this.isHangVeBanGiao;
    data['IsBaoCaoTongHopMuaSam'] = this.isBaoCaoTongHopMuaSam;
    data['IsBaoCaoChiTietMuaSam'] = this.isBaoCaoChiTietMuaSam;
    data['IsBaoCaoTienDoMuaSam'] = this.isBaoCaoTienDoMuaSam;
    data['IsBaoCaoNhapHangPhanPhoi'] = this.isBaoCaoNhapHangPhanPhoi;
    data['IsBaoCaoMuaSamTheoHang'] = this.isBaoCaoMuaSamTheoHang;
    data['IsViewDardboard'] = this.isViewDardboard;
    return data;
  }
}
