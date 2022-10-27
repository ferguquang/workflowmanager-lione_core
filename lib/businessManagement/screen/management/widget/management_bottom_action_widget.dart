import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/create/create_management_screen.dart';
import 'package:workflow_manager/main.dart';

class ManagementBottomAction {
  BuildContext context;
  ProjectPlanItem item;

  ManagementBottomAction({this.context, this.item});

  Future<dynamic> showBottomSheetDialog() async {
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return SizedBox(
            height: _getHeight(),
            child: Container(
              color: Colors.white,
              child: ManagementBottomActionScreen(
                item: this.item,
              ),
            ),
          );
        });
  }

  double _getHeight() {
    int countShow = 0;
    // if (item.isChangeStatus) {
    //   countShow += 1;
    // }
    // if (item.isView) {
    //   countShow += 1;
    // }
    if (item.isUpdate) {
      countShow += 1;
    }
    if (item.isTrash) {
      countShow += 1;
    }
    if (item.isDelete) {
      countShow += 1;
    }
    if (item.isRestore) {
      countShow += 1;
    }
    if (item.isCopy) {
      countShow += 1;
    }
    if (item.isApprove) {
      countShow += 1;
    }
    if (item.isReject) {
      countShow += 1;
    }
    return countShow * 55.0 + 60.0;
  }
}

class ManagementBottomActionScreen extends StatefulWidget {
  ProjectPlanItem item;

  ManagementBottomActionScreen({this.item});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ManagementBottomActionScreen();
  }
}

class _ManagementBottomActionScreen
    extends State<ManagementBottomActionScreen> {
  ManagementBottomActionRepository _repository =
      ManagementBottomActionRepository();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (context) => _repository,
      child: Consumer(
        builder:
            (context, ManagementBottomActionRepository _repository, child) {
          return Scaffold(
            body: SafeArea(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8, left: 8, bottom: 8, right: 4),
                            child: Icon(
                              Icons.info,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text(widget.item.name),
                          )
                        ],
                      ),

                      Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      // _iconAndTextWidget(0, widget.item.isChangeStatus, Icons.check_box, 'Trạng thái'),
                      // _iconAndTextWidget(1, widget.item.isView, Icons.remove_red_eye, 'Xem'),
                      _iconAndTextWidget(
                          2, widget.item.isUpdate, Icons.edit, 'Sửa'),
                      _iconAndTextWidget(
                          3, widget.item.isTrash, Icons.delete, 'Xoá'),
                      _iconAndTextWidget(4, widget.item.isDelete,
                          Icons.delete_outline, 'Xoá vĩnh viễn'),
                      _iconAndTextWidget(
                          5, widget.item.isRestore, Icons.refresh, 'Khôi phục'),
                      _iconAndTextWidget(
                          6, widget.item.isCopy, Icons.copy, 'Sao chép'),
                      _iconAndTextWidget(7, widget.item.isApprove,
                          Icons.check_circle, 'Duyệt'),
                      _iconAndTextWidget(8, widget.item.isReject,
                          Icons.remove_circle_outline, 'Từ chối'),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconAndTextWidget(position, isShow, icon, text, {isCheckToggle}) {
    return Visibility(
      visible: isShow,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          switch (position) {
            case 0: //Trạng thái
              break;
            case 1: //Xem
              break;
            case 2: //Sửa
              pushPage(
                  context,
                  CreateManagementScreen(
                    idOpportunity: widget.item?.iD ?? 0,
                    typeOpportunity: CreateManagementScreen.TYPE_EDIT,
                  ));
              break;
            case 3: //Xoá
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Xác nhận xoá thông tin cơ hội',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Text('Xoá cơ hội ${widget.item.name}?')
                        ],
                      ),
                      actions: [
                        FlatButton(
                          child: Text('HUỶ BỎ'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('ĐỒNG Ý'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _repository.execActionPlan(
                                widget.item.iD, AppUrl.projectPlanTrash);
                          },
                        ),
                      ],
                    );
                  });
              break;
            case 4: //Xoá vĩnh viễn
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Xác nhận xoá thông tin cơ hội',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Text(
                              'Xoá cơ hội ${widget.item.name}? Bạn sẽ không thể khôi phục sau khi xoá!')
                        ],
                      ),
                      actions: [
                        FlatButton(
                          child: Text('HUỶ BỎ'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('ĐỒNG Ý'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _repository.execActionPlan(
                                widget.item.iD, AppUrl.projectPlanRemove,
                                isDelete: true);
                          },
                        ),
                      ],
                    );
                  });
              break;
            case 5: //Khôi phục
              _repository.execActionPlan(
                  widget.item.iD, AppUrl.projectPlanRestore);
              break;
            case 6: //Sao chép
              pushPage(
                  context,
                  CreateManagementScreen(
                    idOpportunity: widget.item?.iD ?? 0,
                    typeOpportunity: CreateManagementScreen.TYPE_COPY,
                    // idOpportunity: 1195,
                  ));
              break;
            case 7: //Duyệt
              _repository.execActionPlan(
                  widget.item.iD, AppUrl.projectPlanApprove);
              break;
            case 8: //Từ chối
              _repository.execActionPlan(
                  widget.item.iD, AppUrl.projectPlanReject);
              break;
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManagementBottomActionRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  Future<void> execActionPlan(int id, String url,
      {bool isDelete = false}) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['ID'] = id;

    var response;
    if (isDelete) {
      response = await apiCaller.delete(
          url, params); //apiCaller.postFormData(url, params);
    } else {
      response = await apiCaller.postFormData(url, params);
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.status == 1) {
      ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(GetDataSaveEventBus(isCheckData: true));
    } else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }
  }
}
