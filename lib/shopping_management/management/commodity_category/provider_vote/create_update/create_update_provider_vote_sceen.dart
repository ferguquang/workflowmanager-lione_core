import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_vote/create_update/create_update_provider_vote_repository.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class CreateUpdateProviderVoteScreen extends StatefulWidget {
  int id;

  CreateUpdateProviderVoteScreen({this.id});

  @override
  _CreateUpdateProviderVoteScreenState createState() => _CreateUpdateProviderVoteScreenState();
}

class _CreateUpdateProviderVoteScreenState extends State<CreateUpdateProviderVoteScreen> {
  CreateUpdateProviderVoteRepository _repository = CreateUpdateProviderVoteRepository();

  @override
  void initState() {
    super.initState();
    _repository.renderCreateUpdate(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, CreateUpdateProviderVoteRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.id == null ? "Thêm mới đánh giá nhà cung cấp" : "Chỉnh sửa đánh giá nhà cung cấp"),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: repository.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ContentViewShoppingItem(
                          model: repository.list[index],
                          onClick: (item, position) {
                            switch (item.key) {
                              case "IDProject" : {
                                ChoiceDialog<CategorySearchParams>(
                                    context,
                                    repository.data.projects,
                                    getTitle: (CategorySearchParams item) {
                                      return item.name;
                                    },
                                    hintSearchText: "Tìm kiếm dự án",
                                    title: "${item.title}",
                                    itemBuilder: (CategorySearchParams item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        child: Text(item.name, style: TextStyle(fontSize: 15),),
                                      );
                                    },
                                    isSingleChoice: true,
                                    onAccept: (List<CategorySearchParams> items) async {
                                      if (isNotNullOrEmpty(items)) {
                                          // _repository.setSelectHang(items[0]);

                                          _repository.projectSelected =
                                              items[0];
                                          item.selected = items;
                                          item.idValue = items[0].iD;
                                          item.value = items[0].name;
                                          _repository.updateItem(item);

                                          _repository.getProviderByProject(
                                              item.idValue);
                                        } else {
                                          _repository.projectSelected = null;
                                          item.idValue = "";
                                          item.value = "";
                                          _repository.updateItem(item);
                                        }
                                      },
                                      selectedObject: [
                                        _repository.projectSelected
                                      ]).showChoiceDialog();
                                  break;
                                }
                              case "IDProvider" : {
                                ChoiceDialog<CategorySearchParams>(
                                    context,
                                    repository.data.providers,
                                    getTitle: (CategorySearchParams item) {
                                      return item.name;
                                    },
                                    hintSearchText: "Tìm kiếm mã nhà cung cấp",
                                    title: "${item.title}",
                                    itemBuilder: (CategorySearchParams item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        child: Text(item.name, style: TextStyle(fontSize: 15),),
                                      );
                                    },
                                    isSingleChoice: true,
                                    onAccept: (List<CategorySearchParams> items) {
                                      if (isNotNullOrEmpty(items)) {
                                          // _repository.setSelectHang(items[0]);

                                          _repository.codeSelected = items[0];
                                          item.selected = items;
                                          item.idValue = items[0].iD;
                                          item.value = items[0].name;
                                          _repository.updateItem(item);

                                          _repository
                                              .getNameByProvider(item.idValue);
                                        } else {
                                          _repository.codeSelected = null;
                                          item.idValue = "";
                                          item.value = "";
                                          _repository.updateItem(item);
                                        }
                                      },
                                      selectedObject: [
                                        _repository.codeSelected
                                      ]).showChoiceDialog();
                                  break;
                                }
                              default:
                                {
                                  pushPage(
                                      context,
                                      InputTextWidget(
                                        title: item.title,
                                        content: "${item.value}",
                                        isNumberic: item.key == "PricePoint" ||
                                            item.key == "PaymentPoint" ||
                                            item.key == "DeliveryPoint" ||
                                            item.key == "QualityPoint" ||
                                            item.key == "CoordinatePoint",
                                        onSendText: (text) async {
                                          item.value = text;
                                          await _repository.updateItem(item);
                                          _repository.calculateTotal();
                                        },
                                      ));
                                  break;
                                }
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SaveButton(
                    title: "XONG",
                    margin: EdgeInsets.all(16),
                    onTap: () async {
                      int status = await _repository.providerSave(id: widget.id);
                      if (status == 1) {
                        Navigator.pop(context, status);
                      }
                    },
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
