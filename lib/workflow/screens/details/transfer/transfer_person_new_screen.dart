import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/params/for_tranfer_user_request.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/details/transfer/transfer_job/transfer_job_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_status_repository.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import '../back_detail_data.dart';

class TransferPersonNewScreen extends StatefulWidget {
  int iDJob;
  String sIDOldCoExecuter, sIDOldSupervisor;
  int iDGroup;

  // ĐÂY LÀ MÀN CHUYỂN TRẠNG THÁI CÔNG VIỆC FULLSCREEN
  // CHUYỂN GIAO NHÂN SỰ MỚI
  TransferPersonNewScreen(
      this.iDJob, this.sIDOldCoExecuter, this.sIDOldSupervisor, this.iDGroup);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _TransferPersonNewScreenState();
  }
}

class _TransferPersonNewScreenState extends State<TransferPersonNewScreen> {
  TransferJobRepository _transferJobRepository = TransferJobRepository();
  GlobalKey _headerKey = GlobalKey();
  HeaderWidget _headerWidget;

  void _transfer() async {
    if (isNullOrEmpty(_headerWidget.text)) {
      ToastMessage.show(
          "Lý do chuyển giao không được để trống", ToastStyle.error);
      return;
    }
    if (_headerWidget.userItem.iD == null) {
      ToastMessage.show(
          "Người chuyển giao không được để trống", ToastStyle.error);
      return;
    }
    var id = await _transferJobRepository.transferUser(
        widget.iDJob,
        _headerWidget.userItem.iD,
        widget.sIDOldCoExecuter,
        widget.sIDOldSupervisor,
        _headerWidget.text);
    if (id != null) {
      BackDetailData backData = BackDetailData(
          newTransferJobId: id, newExcuteId: _headerWidget.userItem.iD);
      Navigator.pop(context, backData);
    }
  }

  @override
  void initState() {
    // _headerWidget = HeaderWidget(_headerKey);
    // TODO: implement initState
    _headerWidget = HeaderWidget(_headerKey, widget.iDGroup);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ForTranferUserRequest request = ForTranferUserRequest();
      request.idJob = widget.iDJob.toString();
      _transferJobRepository.loadDataForTransferUser(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _transferJobRepository,
      child: Consumer(
        builder: (context, TransferJobRepository transferJobRepository, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Chuyển giao nhân sự mới'),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _headerWidget,
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          // controller: controllerListView,
                          itemCount: _transferJobRepository
                              .dataForTranferUserModel.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _transferJobRepository
                                                .dataForTranferUserModel[index]
                                                .created
                                                .toDateTimeFormat(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(_transferJobRepository
                                              .dataForTranferUserModel[index]
                                              .describe)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SaveButton(
                      title: 'Chuyển giao'.toUpperCase(),
                      onTap: () {
                        _transfer();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  UserItem userItem = UserItem();
  String text;
  int iDGroup;

  HeaderWidget(Key key, this.iDGroup);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HeaderWidgetState();
  }
}

class _HeaderWidgetState extends State<HeaderWidget> {
  ChangeStatusRepository _changeStatusRepository = ChangeStatusRepository();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
        value: _changeStatusRepository,
        child: Consumer(
          builder:
              (context, ChangeStatusRepository changeStatusRepository, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bạn hãy nhập lý do và thông tin người nhận công việc',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      TextField(
                        onChanged: (value) {
                          widget.text = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Lý do chuyển ',
                            labelStyle: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      TagLayoutWidget(
                          horizontalPadding: 0,
                          title: "Người nhận việc",
                          isShowValidate: true,
                          value: _changeStatusRepository?.userItem?.name ?? "",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            eventChooseJobUser();
                          })
                    ],
                  ),
                ),
                Container(
                  height: 5,
                  color: "E9ECEF".toColor(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          'Lịch sử chuyển giao '.toUpperCase(),
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }

  void eventChooseJobUser() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageSize"] = 20;
    params["IDGroupJob"] = widget.iDGroup;
    // params["SearchName"] = '';

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return SharedSearchScreen(
          AppUrl.getUserForCreateJob, 'Tìm kiếm tên nhân viên', params: params,
          onSharedSearchSelected: (item) {
        this.setState(() {
          widget.userItem.iD = item.iD;
          widget.userItem.name = item.name;
          _changeStatusRepository.changeUser(widget.userItem);
        });
      });
    }));
  }
}
