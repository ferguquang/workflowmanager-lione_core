import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/history_import/history_import_detail_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/history_import/history_import_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/history_import/history_import_repository.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class HistoryImportScreen extends StatefulWidget {
  ProvidersIndex model;

  HistoryImportScreen({this.model});

  @override
  _HistoryImportScreenState createState() => _HistoryImportScreenState();
}

class _HistoryImportScreenState extends State<HistoryImportScreen> {
  HistoryImportRepository _repository = HistoryImportRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getProviderDetailDebtLog(widget.model.iD);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, HistoryImportRepository repository, Widget child) {

          return  Scaffold(
            appBar: AppBar(
              title: Text("Lịch sử nhập hàng"),
            ),
            body: repository.data == null ||
                    repository.data.providerImportLogs.length == 0
                ? EmptyScreen()
                : SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                repository.data.providerImportLogs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HistoryImportItem(
                                model:
                                    repository.data.providerImportLogs[index],
                                onClickItem: (itemCLick) {
                                  pushPage(
                                      context,
                                      HistoryImportDetailScreen(
                                        model: repository.data.providerImportLogs[index],
                            ));
                          },
                        );
                     },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
