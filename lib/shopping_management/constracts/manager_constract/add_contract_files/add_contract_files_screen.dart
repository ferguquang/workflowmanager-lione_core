import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/ui/webview_screen.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';

import 'add_contract_file_repository.dart';

class AddContractFilesScreen extends StatefulWidget {
  List<ContractFiles> files;
  bool isEditable;

  AddContractFilesScreen(this.files, this.isEditable);

  @override
  _AddContractFilesScreenState createState() => _AddContractFilesScreenState();
}

class _AddContractFilesScreenState extends State<AddContractFilesScreen> {
  AddContractFileRepository _addContractFileRepository =
      AddContractFileRepository();
  List<ContractFiles> rootFile = [];

  @override
  void initState() {
    super.initState();
    rootFile.addAll(widget.files);
    _addContractFileRepository.files = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tải file"),
          actions: [
            Visibility(
              visible: widget.isEditable,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  var file =
                      await FileUtils.instance.uploadFileFromSdcard(context);
                  if (file != null) {
                    _addContractFileRepository
                        .addFile(ContractFiles(file.fileName, file.filePath));
                  }
                },
              ),
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, rootFile);
            return Future.value(false);
          },
          child: ChangeNotifierProvider.value(
            value: _addContractFileRepository,
            child: Consumer(
              builder: (context,
                  AddContractFileRepository addContractFileRepository, child) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            addContractFileRepository?.files?.length ?? 0,
                        itemBuilder: (context, index) {
                          ContractFiles contractFiles =
                              addContractFileRepository?.files[index];
                          return InkWell(
                            onTap: () {
                              _openFile(contractFiles.fileName,
                                  contractFiles.filePath, context);
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                              contractFiles?.fileName ?? "")),
                                    ),
                                    Visibility(
                                      visible: widget.isEditable,
                                      child: InkWell(
                                        onTap: () {
                                          showConfirmDialog(context,
                                              "Bạn có muốn xóa file này?", () {
                                            _addContractFileRepository
                                                .removeFile(contractFiles);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.close, size: 20),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: widget.isEditable,
                      child: SaveButton(
                        margin: EdgeInsets.all(16),
                        onTap: () {
                          if (isNullOrEmpty(_addContractFileRepository.files)) {
                            showErrorToast("Chưa chọn file nào");
                            return;
                          }
                          Navigator.pop(
                              context, _addContractFileRepository.files);
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }

  _openFile(String fileName, String filePath, BuildContext context) async {
    String root =
        await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
    if (isNullOrEmpty(filePath)) return;
    await FileUtils.instance.downloadFileAndOpen(fileName, filePath, context);
  }
}
