import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/register_create_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_repository.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_show_action.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/assign_widget/assign_repository.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/assign_widget/assign_widget.dart';

class ActionBottomSheet extends StatefulWidget {
  Conditions conditions;
  int idServiceRecord;
  bool isReject;
  bool isFinish = true;
  bool isAutoSave;

  ActionBottomSheet(
      {this.conditions,
      this.idServiceRecord,
      this.isReject = false,
      this.isAutoSave,
      this.isFinish = true});

  @override
  _ActionBottomSheetState createState() => _ActionBottomSheetState();
}

class _ActionBottomSheetState extends State<ActionBottomSheet> {
  Conditions conditions;
  ActionRepository _repository = ActionRepository();
  TextEditingController controller = TextEditingController();

  AssignWidget _assignWidget;
  List<AssignWidget> listAssignWidget = [];
  AssignRepository _assignRepository;
  bool isRequireNote = false;
  DataIsDoneInfo dataIsDoneInfo;
  List<StepAssignParallels> stepAssignParallels = [];

  @override
  void initState() {
    super.initState();
    conditions = widget.conditions;
    _repository.isAutoSave = widget.isAutoSave;
    eventBus.on<EventShowAction>().listen((event) async {
      getData(true);
    });
    getData(false);
  }

  Future<void> getData(bool isOnEventBus) async {
    int status = await _repository.getIsResolve(
        conditions, widget.idServiceRecord, widget.isReject, isOnEventBus: isOnEventBus);

    if (status != 1) {
      Navigator.pop(context);
      return;
    }

    stepAssignParallels = _repository.dataIsDoneInfo?.stepAssignParallels;
    if (widget.isReject) {
      isRequireNote = false;
    }

    dataIsDoneInfo = _repository.dataIsDoneInfo;
    RegisterCreateModel registerCreateModel = RegisterCreateModel();

    if (dataIsDoneInfo != null) {
      registerCreateModel.users = dataIsDoneInfo.users;
      registerCreateModel.depts = dataIsDoneInfo.depts;
      registerCreateModel.postions = dataIsDoneInfo.postions;
      registerCreateModel.teams = dataIsDoneInfo.teams;
      registerCreateModel.isAssignNewExecutor =
          dataIsDoneInfo.isAssignNewExecutor;
      isRequireNote = dataIsDoneInfo.isRequiredNote;
    }

    _assignRepository = AssignRepository();
    await _assignRepository.loadData();

    if (dataIsDoneInfo?.isParallelAssign == true) {
      //bước song song hay quy trình song song sẽ vào đây
      listAssignWidget.clear();
      stepAssignParallels?.forEach((element) {
        registerCreateModel.isParallelAssign = true;
        AssignWidget assignWidget = AssignWidget(
          registerCreateModel,
          false,
          globalKey: GlobalKey(),
          userInfoModel: _assignRepository?.userInfoModel,
          isType: true,
          titleStep: element?.name,
        );
        listAssignWidget.add(assignWidget);
      });
    } else {
      //nếu có quy trình bước hay đơn thì vào đây
      _assignWidget = AssignWidget(
        registerCreateModel,
        false,
        globalKey: GlobalKey(),
        userInfoModel: _assignRepository?.userInfoModel,
        isType: true,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder:
            (BuildContext context, ActionRepository repository, Widget child) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500, minHeight: 240),
            child: Container(
              // padding: MediaQuery.of(context).viewInsets,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    color: Colors.blue,
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child: Text("Xác nhận chuyển hồ sơ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18))),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tên hồ sơ: ${conditions.titleHoSo}"),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text("Nhập nội dung xử lý"),
                            Visibility(
                              visible: isRequireNote,
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              // hintText: "Nhập nội dung xử lý"
                              ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: dataIsDoneInfo != null &&
                          dataIsDoneInfo?.isAssignNewExecutor == true,
                      child: _assignWidget ?? Container()),
                  Visibility(
                    visible: dataIsDoneInfo != null &&
                        dataIsDoneInfo?.isParallelAssign == true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listAssignWidget?.length ?? 0,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _logicAssignWidget(listAssignWidget[index]);
                      },
                    ),
                  ),
                  SaveButton(
                    onTap: () async {
                      if (widget.isReject) {
                        int idNextStep =
                            repository.dataIsResentInfo.iDServiceRecordWfStep;
                        int status = await _repository.registerResentInfo(
                            context,
                            idNextStep,
                            widget.idServiceRecord,
                            controller.text);
                        if (status == 1) {
                          eventBus
                              .fire(EventReloadDetailProcedure(isFinish: true));
                          Navigator.pop(context);
                        }
                      } else {
                        if (dataIsDoneInfo.isRequiredNote &&
                            controller.text.isEmpty) {
                          ToastMessage.show(
                              "Chưa nhập nội dung xử lý", ToastStyle.error);
                          return;
                        }

                        conditions.describe = controller.text;
                        int status = await _repository.recordDoneInfo(
                            conditions,
                            widget.idServiceRecord,
                            dataIsDoneInfo.isAssignNewExecutor,
                            listAssignWidget,
                            _assignWidget,
                            stepAssignParallels,
                            context);
                        if (status == 1) {
                          if (conditions.schemaConditionType == 1) {
                            widget.isFinish = false;
                          }
                          eventBus.fire(EventReloadDetailProcedure(
                            isFinish: widget.isFinish,
                            schemaConditionType: conditions.schemaConditionType
                          ));
                          Navigator.pop(context);
                        }
                      }
                    },
                    title: "XONG",
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _logicAssignWidget(Widget widget1) {
    if (widget.isReject) {
      return Container();
    } else {
      if (dataIsDoneInfo?.isAssignNewExecutor == true ||
          dataIsDoneInfo?.isParallelAssign == true) {
        return widget1;
      } else {
        return Container();
      }
    }
  }
}
