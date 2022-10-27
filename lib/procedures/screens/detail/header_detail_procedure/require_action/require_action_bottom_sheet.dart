import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_repository.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';

class RequireActionBottomSheet extends StatefulWidget {
  AddAction addAction;
  int idHoSo;
  int type;
  // giải quyết:
  RequiredAction requiredAction;

  RequireActionBottomSheet(
      {this.addAction, this.idHoSo, this.type, this.requiredAction});

  @override
  _RequireActionBottomSheetState createState() =>
      _RequireActionBottomSheetState();
}

class _RequireActionBottomSheetState extends State<RequireActionBottomSheet> {
  ActionRepository _repository = ActionRepository();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.type == DetailProcedureScreen.TYPE_REGISTER) {
      _repository.registerIsDoneRequireAddition(
          widget.addAction, widget.idHoSo);
    } else {
      if (widget.requiredAction != null) {
        _repository.recordIsDoneRequireAddition(
            widget.idHoSo, widget.requiredAction);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ActionRepository repository, Widget child) {
          DataIsDoneRequireAddition dataIsDoneRequireAddition =
              repository.dataIsDoneRequireAddition;
          return Container(
            // padding: MediaQuery.of(context).viewInsets,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.blue,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    widget.type == DetailProcedureScreen.TYPE_REGISTER
                        ? widget.addAction.action
                        : widget.requiredAction.action,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: contentController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 16),
                      hintText: "Nội dung",
                      // hintStyle: TextStyle(color: Colors.grey),
                      // filled: true,
                      // // fillColor: "F5F6FA".toColor(),
                      // enabledBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      //   borderSide: BorderSide(color: Colors.white),
                      // ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      //   borderSide: BorderSide(color: Colors.white),
                      // )
                    )),
                SizedBox(height: 16),
                SaveButton(
                  margin: EdgeInsets.all(16),
                  onTap: () async {
                    if (contentController.text.isEmpty) {
                      ToastMessage.show("Cần nhập nội dụng", ToastStyle.error);
                      return;
                    }
                    int status = await _repository.doneRequireAddition(
                        widget.idHoSo,
                        dataIsDoneRequireAddition.additionalRequired,
                        contentController.text,
                        widget.type);
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
