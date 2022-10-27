import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/detail_borrow_document/detail_borrow_document_repository.dart';
import 'package:workflow_manager/storage/utils/ImageUtils.dart';

class DetailBorrowDocumentScreen extends StatefulWidget {
  int id;

  @override
  State<StatefulWidget> createState() {
    return _DetailBorrowDocumentState();
  }

  DetailBorrowDocumentScreen(this.id);
}

class _DetailBorrowDocumentState extends State<DetailBorrowDocumentScreen> {
  DetailBorrowDocumentRepository _repository = DetailBorrowDocumentRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getBorrowDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, DetailBorrowDocumentRepository _repository, child) {
          return Scaffold(
            appBar: AppBar(
              leading: BackIconButton(),
              title: Text('Chi tiết mượn trả'),
              actions: [
                Visibility(
                  visible: _repository.dataDetail?.isBorrowDelete ?? false,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: PopupMenuButton(
                      child: Icon(Icons.more_vert),
                      onSelected: (value) {
                        showConfirmDialog(
                            context, 'Bạn có muốn xóa phiếu đăng ký này không?',
                            () async {
                          bool status = await _repository
                              .getBorrowOptionDelete(widget.id);
                          if (status) Navigator.of(context).pop();
                        });
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 0,
                            child: Text("Xóa phiếu mượn"),
                          ),
                        ];
                      },
                    ),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 4),
                            child: InkWell(
                              onTap: () {
                                _eventClickOpenFile();
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    ImageUtils.instance.getImageType(
                                        _repository.dataDetail?.extension ??
                                            ''),
                                    width: 32,
                                    height: 32,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${_repository.dataDetail?.name ?? ''}",
                                      style: TextStyle(
                                          decoration: isNotNullOrEmpty(
                                                  _repository.dataDetail?.path)
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          decorationColor: Colors.blue,
                                          color: isNotNullOrEmpty(
                                                  _repository.dataDetail?.path)
                                              ? Colors.blue
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: EdgeInsets.only(top: 8, bottom: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: getColor(
                                    '${_repository.dataDetail?.statusColor ?? ''}')),
                            child: Text(
                              _repository.dataDetail?.statusName ?? '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          Visibility(
                            visible: isNotNullOrEmpty(
                                    _repository.dataDetail?.reasonRD) &&
                                _repository.dataDetail.reasonRD.length > 0,
                            child: _buildRichText(
                                'Lý do từ chối: ',
                                '${_repository.dataDetail?.reasonRD ?? ''}',
                                true),
                          ),
                          _buildRichText(
                              'Số ký hiệu: ',
                              '${_repository.dataDetail?.symbolNo ?? ''}',
                              false),
                          _buildRichText(
                              'Trích yếu: ',
                              '${_repository.dataDetail?.describe ?? ''}',
                              false),
                        ],
                      ),
                    ),
                    _buildListViewFile(),
                    _buildColumnInfor(
                        'Thông tin đăng ký',
                        '${_repository.dataDetail?.borrower?.avatar ?? ''}',
                        '${_repository.dataDetail?.borrower?.name ?? ''}',
                        '${_repository.dataDetail?.borrower?.email ?? ''}',
                        true),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildText('Mục đích'),
                          Wrap(
                            children: isNotNullOrEmpty(
                                        _repository.dataDetail?.purposes) &&
                                    _repository.dataDetail.purposes.length > 0
                                ? getListWidgets()
                                : [],
                          ),
                          _buildText(
                              'Mượn từ ngày : ${convertTimeStampToHumanDate(_repository.dataDetail?.startDate ?? 0, Constant.ddMMyyyy)}'),
                          _buildText(
                              'Đến ngày: ${convertTimeStampToHumanDate(_repository.dataDetail?.endDate ?? 0, Constant.ddMMyyyy)}'),
                          _buildText(
                              'Ngày đăng ký: ${convertTimeStampToHumanDate(_repository.dataDetail?.created ?? 0, Constant.ddMMyyyy)}'),
                        ],
                      ),
                    ),
                    _buildColumnInfor(
                        'Trưởng phòng',
                        _repository.dataDetail?.leader?.avatar ?? '',
                        _repository.dataDetail?.leader?.name ?? '',
                        _repository.dataDetail?.leader?.email ?? '',
                        isNullOrEmpty(_repository.dataDetail?.leader?.iD)
                            ? false
                            : true),
                    _buildColumnInfor(
                        'Văn thư',
                        _repository.dataDetail?.archiver?.avatar ?? '',
                        _repository.dataDetail?.archiver?.name ?? '',
                        _repository.dataDetail?.archiver?.email ?? '',
                        isNullOrEmpty(_repository.dataDetail?.archiver?.iD)
                            ? false
                            : true),
                    _buildColumnInfor(
                        'Lãnh đạo',
                        _repository.dataDetail?.approver?.avatar ?? '',
                        _repository.dataDetail?.approver?.name ?? '',
                        _repository.dataDetail?.approver?.email ?? '',
                        isNullOrEmpty(_repository.dataDetail?.approver?.iD)
                            ? false
                            : true),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getListWidgets() {
    if (isNullOrEmpty(_repository.dataDetail?.purposes) &&
        _repository.dataDetail.purposes.length < 1) return [];
    List<Widget> listData = _repository.dataDetail.purposes
        .map((e) => _buildContainerText(e))
        .toList();
    return listData;
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(text),
    );
  }

  Widget _buildRichText(String text1, String text2, bool isColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
          text: TextSpan(
              text: text1,
              style: TextStyle(color: isColors ? Colors.red : Colors.black),
              children: [
            TextSpan(
              text: text2,
              style: TextStyle(color: isColors ? Colors.red : Colors.black),
            ),
          ])),
    );
  }

  Widget _buildContainerText(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.only(top: 8, bottom: 8, right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.blue, fontSize: 13),
      ),
    );
  }

  Widget _buildColumnInfor(
      String textInfor, String avatar, String name, String email, bool isShow) {
    return Visibility(
      visible: isShow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 8),
            width: double.infinity,
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              textInfor,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                CircleNetworkImage(height: 40, width: 40, url: avatar ?? ''),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name ?? '',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color: Colors.grey,
                            size: 12,
                          ),
                          Text(
                            '  $email',
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListViewFile() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _repository.dataDetail?.stgDocBorrowFiles?.length ?? 0,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        StgDocBorrowFiles model =
            _repository.dataDetail?.stgDocBorrowFiles[index];
        return InkWell(
          onTap: () {
            FileUtils.instance
                .downloadFileAndOpen(model.fileName, model.filePath, context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.file_download,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                    child: Text(
                  '${model.fileName ?? ''}',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      color: Colors.blue),
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  _eventClickOpenFile() {
    if (isNotNullOrEmpty(_repository.dataDetail?.path))
      FileUtils.instance.downloadFileAndOpen(
          _repository.dataDetail?.name, _repository.dataDetail?.path, context);
  }
}
