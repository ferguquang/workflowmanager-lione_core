import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_repository.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';

class AddActionBottomSheet extends StatefulWidget {
  AddAction addAction;
  int idServiceRecord;

  AddActionBottomSheet({this.addAction, this.idServiceRecord});

  @override
  _AddActionBottomSheetState createState() => _AddActionBottomSheetState();
}

class _AddActionBottomSheetState extends State<AddActionBottomSheet> {
  ActionRepository _repository = ActionRepository();
  TextEditingController controller = TextEditingController();
  int idServiceRecordWfStepAddition = 0;

  @override
  void initState() {
    super.initState();
    _repository.recordIsRequireAddition(
        widget.addAction, widget.idServiceRecord);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ActionRepository repository, child) {
          List<SelectSteps> _selectSteps = repository.selectSteps;
          if (_selectSteps == null) {
            return Container();
          }

          return Container(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: Text(widget.addAction.name,
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            Text("Bước: "),
                            Expanded(
                                child: Text(repository.selectStep != null
                                    ? repository.selectStep.name
                                    : "")),
                            Icon(Icons.arrow_drop_down_outlined)
                          ],
                        ),
                        onTap: () {
                          ChoiceDialog<SelectSteps>(
                                  context, _repository.selectSteps,
                                  getTitle: (SelectSteps item) {
                                    return item.name;
                                  },
                                  title: "Chọn bước",
                                  itemBuilder: (SelectSteps item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Text(
                                        item.name,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    );
                                  },
                                  isSingleChoice: true,
                                  onAccept: (List<SelectSteps> items) {
                                    idServiceRecordWfStepAddition =
                                        items[0].iDServiceRecordWfStepAddition;
                                    _repository.setSelectStep(items[0]);
                                  },
                                  selectedObject: [_repository.selectStep])
                              .showChoiceDialog();
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: "Nội dung"),
                      ),
                    ],
                  ),
                ),
                SaveButton(
                  onTap: () async {
                    if (idServiceRecordWfStepAddition == 0) {
                      ToastMessage.show("Cần chọn bước", ToastStyle.error);
                      return;
                    }
                    String content = controller.text;
                    if (content.isEmpty) {
                      ToastMessage.show(
                          "Bắt buộc nhập trường Nội dung!!!", ToastStyle.error);
                      return;
                    }

                    int status = await _repository.recordRequireAddition(
                        widget.idServiceRecord,
                        idServiceRecordWfStepAddition,
                        widget.addAction.iDServiceRecordWfStep,
                        controller.text);
                    if (status == 1) {
                      eventBus.fire(EventReloadDetailProcedure(isFinish: true));
                      Navigator.pop(context);
                    }
                  },
                  title: "XONG",
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
