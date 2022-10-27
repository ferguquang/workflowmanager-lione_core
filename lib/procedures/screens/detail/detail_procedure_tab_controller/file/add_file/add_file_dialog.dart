import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_item.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_model.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_repository.dart';

class AddFileProcedureDialog extends StatefulWidget {
  int idHoSo;
  bool isEnableAttachSignFile;

  @override
  _AddFileProcedureDialogState createState() => _AddFileProcedureDialogState();

  AddFileProcedureDialog({this.idHoSo, this.isEnableAttachSignFile});
}

class _AddFileProcedureDialogState extends State<AddFileProcedureDialog> {
  List<AddFileProcedureModel> listFiles = [];
  AddFileProcedureRepository _repository = AddFileProcedureRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, AddFileProcedureRepository repository, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Thêm file đính kèm"),),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemCount: repository.listFiles.length,
                          itemBuilder: (context, index) {
                            return AddFileProcedureItem(
                              model: repository.listFiles[index],
                              isEnableAttachSignFile: widget.isEnableAttachSignFile,
                              onUpdateItem: (AddFileProcedureModel itemUpdate) {
                                _repository.updateTrinhKy(itemUpdate);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          }
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SaveButton(
                            margin: EdgeInsets.only(right: 2),
                            onTap: () {
                              _repository.uploadFile(context);
                            },
                            title: "Tải file",
                          ),
                        ),
                        Expanded(
                          child: SaveButton(
                            margin: EdgeInsets.only(left: 2),
                            onTap: () async {
                              List<AllAttachedFiles> listFiles = await _repository.saveInfoFs(repository.listFiles, widget.idHoSo);
                              Navigator.pop(context, listFiles);
                            },
                            title: "Xong",
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
