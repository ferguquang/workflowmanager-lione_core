import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/pair_reponse.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_detail_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_details_screen/group_details_screen_provider.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/list_member_screen.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_files_screen.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/file_response.dart';

class GroupJobDetailHeadScreen extends StatefulWidget {
  GroupJobDetailModel groupDetailModel;

  GroupJobDetailHeadScreen(this.groupDetailModel);

  @override
  State<StatefulWidget> createState() {
    return _GroupJobDetailHeadScreenState();
  }
}

class _GroupJobDetailHeadScreenState extends State<GroupJobDetailHeadScreen> {
  double blockPadding = 16;
  GroupDetailsHeadProvider _groupDetailHeadProvider;
  bool visibleViewMore = false;
  GlobalKey _keyDescription = GlobalKey();
  final double groupPadding = 16;
  var labelTextColor = TextStyle(color: "555555".toColor());
  var textColor = TextStyle(color: "242424".toColor());
  double _defaultJobDescriptionHeight = 100;
  double _jobDescriptionheight = 100;
  bool expand = false;

  @override
  void initState() {
    _groupDetailHeadProvider =
        GroupDetailsHeadProvider(widget.groupDetailModel);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      visibleViewMore = _keyDescription.currentContext.size.height ==
          _defaultJobDescriptionHeight;
      _groupDetailHeadProvider.notifyListeners();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _groupDetailHeadProvider.changeTaskDetailModel(widget.groupDetailModel);
    return ChangeNotifierProvider.value(
        value: _groupDetailHeadProvider,
        child: Consumer(builder: (context,
            GroupDetailsHeadProvider groupDetailsHeadProvider, child) {
          return SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(top: groupPadding),
                  child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: groupPadding,
                                      left: groupPadding,
                                      right: groupPadding),
                                  child: Text(
                                      _groupDetailHeadProvider
                                              ?.groupDetailModel?.name ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black))),
                              _getJobInfos(),
                              _getJobDescription(),
                              _getToDoWork(),
                              _getAttachFile(),
                              _getLargerLine()
                            ])
                      ])));
        }));
  }

  BuildContext getContext() {
    return context;
  }

  _changeStatus() async {
    if (_groupDetailHeadProvider.groupDetailModel.role == 1) {
      List<Pair> statusList = await _groupDetailHeadProvider.loadStatus(
          _groupDetailHeadProvider?.groupDetailModel?.currentStatus?.key ?? 0);
      if (statusList != null) {
        BottomSheetDialog bottomSheetDialog = BottomSheetDialog(
          context: context,
          onTapListener: (item) {
            _groupDetailHeadProvider.changeStatus(
                item.key, _groupDetailHeadProvider.groupDetailModel.iD);
          },
        );
        bottomSheetDialog.showBottomSheetDialog(statusList);
      }
    }
  }

  Widget _getJobInfos() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: groupPadding),
      child: Column(children: [
        _buildRow(Icons.clear_all, "Độ ưu tiên", "",
            contentWidget: Text(_groupDetailHeadProvider?.groupDetailModel?.currentPriority?.value ?? "", style: TextStyle(color: getColor(_groupDetailHeadProvider?.groupDetailModel?.currentPriority?.color ?? "#000000")),)),
        _buildRow(
          Icons.access_time_rounded,
          "",
          (_groupDetailHeadProvider?.groupDetailModel?.startDate
                      ?.toDateFormat() ??
                  "--") +
              " - " +
              (_groupDetailHeadProvider?.groupDetailModel?.endDate
                      ?.toDateFormat() ??
                  "--"),
        ),
        // _buildRow(Icons.clear_all, "Người tạo", "",
        //     contentWidget: Text(_groupDetailHeadProvider
        //         ?.groupDetailModel?.??
        //         "")),
        _buildRow(Icons.circle, "Trạng thái", "",
            iconSize: 8,
            contentWidget: InkWell(
              onTap: _groupDetailHeadProvider?.groupDetailModel.role == 1
                  ? (() async {
                      _changeStatus();
                    })
                  : null,
              child: Text(
                _groupDetailHeadProvider
                        ?.groupDetailModel?.currentStatus?.value ??
                    "",
                style: TextStyle(
                    color: getColor(_groupDetailHeadProvider
                            ?.groupDetailModel?.currentStatus?.color ??
                        "ffffff")),
              ),
            )),
      ]),
    );
  }

  Widget _getJobDescription() {
    var document =
        parse(_groupDetailHeadProvider?.groupDetailModel?.describe?.trim())
            .body
            .text; // dùng để xóa thẻ html
    return Padding(
        padding: EdgeInsets.symmetric(vertical: blockPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _getBlockTitle("Mô tả công việc", null),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: groupPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // AnimateContent(key:_jobDescriptionKey,expand: expand, child: ,minHeight: 100,),
              Container(
                  constraints: BoxConstraints(maxHeight: _jobDescriptionheight),
                  child: Text(document ?? ""),
                  key: _keyDescription),
              Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        expand = !expand;
                        // (_jobDescriptionKey.currentWidget as AnimateContent)
                        //     .toggle();
                        _jobDescriptionheight = _jobDescriptionheight !=
                                _defaultJobDescriptionHeight
                            ? _defaultJobDescriptionHeight
                            : double.infinity;
                      });
                    },
                    child: Visibility(
                      visible: visibleViewMore,
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(expand ? "Thu gọn" : "Xem thêm")),
                    ),
                  ))
            ]),
          )
        ]));
  }

  double oneRowPadding = 18;

  _attachFile() {}

  Widget _getToDoWork() {
    return _getOneRow("Danh sách thành viên",
        _groupDetailHeadProvider.groupDetailModel.totalMember, () {}, () async {
      List<GroupJobMemberModel> list =
          await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListMemberScreen(
          _groupDetailHeadProvider.groupDetailModel.role,
          groupId: _groupDetailHeadProvider.groupDetailModel.iD,
        ),
      ));
      if (list != null) {
        _groupDetailHeadProvider.changeTotalMember(list.length);
      }
    });
  }

  Widget _getAttachFile() {
    return _getOneRow(
        "Danh sách file đính kèm",
        _groupDetailHeadProvider.groupDetailModel.totalFile,
        _attachFile, () async {
      List<FileModel> list = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AttachFilesScreen(
          AttachFileType.group_job_detail,
          id: _groupDetailHeadProvider.groupDetailModel.iD,
          role: _groupDetailHeadProvider.groupDetailModel.role,
        ),
      ));
      if (list != null) {
        _groupDetailHeadProvider.changeTotalFile(list.length);
      }
    });
  }

  Widget _getOneRow(String content, int count, GestureTapCallback onTap,
      GestureTapCallback onListTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getLargerLine(),
        InkWell(
            onTap: onListTap,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: oneRowPadding, horizontal: groupPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(content,
                              style: TextStyle(color: "00689D".toColor())),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: "DFEAFB".toColor(),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                child: Text("$count")),
                          )
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: "939BA2".toColor(),
                      size: 15,
                    ),
                  ],
                )))
      ],
    );
  }

  Widget _getBlockTitle(String text, GestureTapCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getLargerLine(),
              Padding(
                  padding: EdgeInsets.only(
                      top: blockPadding,
                      left: blockPadding,
                      right: blockPadding),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(text.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                ))),
                        // Visibility(
                        //     visible: onTap != null && taskType != 2,
                        //     child: InkWell(
                        //       onTap: onTap,
                        //       child: Icon(Icons.add),
                        //     ))
                      ]))
            ],
          ),
        ),
      ],
    );
  }

  Widget _getLargerLine() {
    return Container(
      color: "E9ECEF".toColor(),
      height: 4,
    );
  }

  _buildRow(IconData icon, String label, String content,
      {String rightContent,
      contentWidget,
      GestureTapCallback onExtendTap,
      Widget rightWidget,
      String imagePath,
      double iconSize}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(right: groupPadding, top: 4, bottom: 4),
            child: (imagePath == null
                ? Container(
                    alignment: Alignment.center,
                    width: 18,
                    height: 18,
                    child: Icon(
                      icon ?? Icons.email,
                      size: iconSize ?? 18,
                      color: "939BA2".toColor(),
                    ),
                  )
                : Image.asset(
                    imagePath,
                    width: 18,
                    height: 18,
                  ))),
        Text(
          isNullOrEmpty(label) ? "" : label + ": ",
          style: labelTextColor,
        ),
        Expanded(
            child: contentWidget ??
                Text(
                  content ?? "",
                  style: textColor,
                )),
        InkWell(
          child: rightWidget ?? Text(rightContent ?? ""),
          onTap: onExtendTap,
        ),
      ],
    );
  }

  Widget _getPriorityText(String priority) {
    return Text(priority);
    // switch (priority) {
    //   case 1:
    //     return Text("Thấp");
    //   case 2:
    //     return Text("Trung bình");
    //   default:
    //     return Text("Cao", style: TextStyle(color: Colors.red.withAlpha(180)));
    // }
  }
}
