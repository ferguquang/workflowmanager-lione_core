import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/action_adjusted/action_adjusted_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class ActionAdjustedScreen extends StatefulWidget {
  int id;
  void Function(List<ProviderDebts>) onUpdateList;

  ActionAdjustedScreen(this.id, {this.onUpdateList});

  @override
  _ActionAdjustedScreenState createState() => _ActionAdjustedScreenState();
}

class _ActionAdjustedScreenState extends State<ActionAdjustedScreen> {
  ActionAdjustedRepository _repository = ActionAdjustedRepository();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getDataProviderUpdateDebtLog(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, ActionAdjustedRepository repository, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Điều chỉnh"),
              actions: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    List<ProviderDebts> list = await _repository.getProviderChangeDebt(repository.list, widget.id);
                    if (list != null) {
                      widget.onUpdateList(list);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
            body: SafeArea(
              child: isNullOrEmpty(repository.list) ? EmptyScreen() : ListView.builder(
                itemCount: repository.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContentViewShoppingItem(
                    model: repository.list[index],
                    onClick: (item, position) {
                      pushPage(context, InputTextWidget(
                        title: "Số tiền thanh toán",
                        content: repository.list[1].value ?? "",
                        // isNumberic: true,
                        isMoney: true,
                        isDecimal: false,
                        onSendText: (String value) {
                          if (isNotNullOrEmpty(value)) {
                            _repository.calculate(repository.list, value);
                          }
                        },
                      ));
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
