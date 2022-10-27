import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/create_update/create_commodity_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/image/image_list_commodity_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/view/update_remove_bottomsheet.dart';

class CreateCommodityScreen extends StatefulWidget {
  bool isUpdate;
  int id;

  Commodities modelIndex;

  void Function(Commodities) onCreateItem;
  void Function(Commodities) onUpdateItem;
  void Function(int) onRemoveItem;

  CreateCommodityScreen(
      {this.isUpdate,
      this.id,
      this.onCreateItem,
      this.onUpdateItem,
      this.onRemoveItem,
      this.modelIndex});

  @override
  _CreateCommodityScreenState createState() => _CreateCommodityScreenState();
}

class _CreateCommodityScreenState extends State<CreateCommodityScreen> {
  List<ContentShoppingModel> list = [];
  CreateCommodityRepository _repository = CreateCommodityRepository();

  @override
  void initState() {
    super.initState();
    // _repository.addList(isUpdate: widget.isUpdate);
    _repository.renderCommodityCreateUpdate(id: widget.id, isUpdate: widget.isUpdate);
  }

  String _getTitle(bool isUpdate) {
    if (widget.isUpdate == null) {
      return "Chi tiết hàng hóa";
    } else {
      return widget.isUpdate ? "Chỉnh sửa hàng hóa" : "Thêm mới hàng hóa";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, CreateCommodityRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text(_getTitle(widget.isUpdate)),
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
                          position: index,
                          onClick: (item, position) {
                            switch(item.key) {
                              case "IDManufactur": {
                                ChoiceDialog<CategorySearchParams>(
                                    context,
                                    repository.dataCommodityCreateUpdate?.manufacturs,
                                    getTitle: (CategorySearchParams item) {
                                      return item.name;
                                    },
                                    hintSearchText: "Tìm kiếm hãng",
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
                                        _repository.setSelectHang(items[0]);

                                        item.idValue = items[0].iD;
                                        item.value = items[0].name;
                                        _repository.updateItem(item);
                                      } else {
                                        repository.list[2].value = "";
                                        repository.list[2].idValue = "";
                                        _repository.updateItem(repository.list[2]);
                                        _repository.setSelectHang(null);
                                      }
                                    },
                                    selectedObject: [_repository.selectedManufacture]
                                ).showChoiceDialog();
                                break;
                              }
                              case "IDCategory" : {
                                List<CategorySearchParams> selectedCategory = [_repository.selectedCategory];
                                ChoiceDialog<CategorySearchParams>(
                                    context,
                                    repository.dataCommodityCreateUpdate?.categories,
                                    getTitle: (CategorySearchParams item) => item.name,
                                    hintSearchText: "Tìm kiếm danh mục hàng hóa",
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
                                        _repository.setSelectDMHH(items[0]);

                                        item.idValue = items[0].iD;
                                        item.value = items[0].name;
                                        _repository.updateItem(item);

                                        Commodities commodities = await _repository.getByCategory(item.idValue, widget.id);
                                        if (commodities != null) {
                                          repository.list[0].value = commodities.code;
                                          _repository.updateItem(repository.list[0]);
                                        }
                                      } else {
                                        repository.list[0].value = "";
                                        _repository.updateItem(repository.list[0]);

                                        repository.list[3].value = "";
                                        repository.list[3].idValue = "";
                                        _repository.updateItem(repository.list[3]);
                                        _repository.setSelectDMHH(null);
                                        setState(() {
                                          selectedCategory = null;
                                        });
                                      }
                                    },
                                    selectedObject: selectedCategory
                                ).showChoiceDialog();
                                break;
                              }
                              case "HA" : {
                                pushPage(context, ImageListCommodityScreen(
                                  list: repository.dataCommodityCreateUpdate.commodity.images,
                                  isUpdate: widget.isUpdate,
                                  onUpdateList: (List<ImageCommodity> listUpdate) {
                                    repository.dataCommodityCreateUpdate.commodity.images = listUpdate;
                                    _repository.updateImageList(repository.dataCommodityCreateUpdate);
                                  },
                                ));
                                break;
                              }
                              default: {
                                pushPage(context, InputTextWidget(
                                  title: item.title,
                                  content: item.value,
                                  onSendText: (text) {
                                    item.value = text;
                                    _repository.updateItem(item);
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
                  Visibility(
                    visible: isVisibility(widget.isUpdate, widget.modelIndex?.isDelete, widget.modelIndex?.isUpdate),
                    child: SaveButton(
                      title: widget.isUpdate == null ?" XỬ LÝ" : "XONG",
                      onTap: () async {
                        if (widget.isUpdate == null) {
                          showModalBottomSheet(context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  UpdateRemoveBottomSheet(
                                    onDelete: () async {
                                      int status = await _repository.removeItem(repository.dataCommodityCreateUpdate.commodity.iD);
                                      if (status == 1) {
                                        Navigator.pop(context, status);
                                      }
                                      // Navigator.pop(context);
                                      // widget.onRemoveItem(repository.dataCommodityCreateUpdate.commodity.iD);
                                    },
                                    onUpdate: () {
                                      _repository.changeFromDetailToUpdate();
                                      setState(() {
                                        widget.isUpdate = true;
                                      });
                                    },
                                    isDelete: widget.modelIndex?.isDelete,
                                    isUpdate: widget.modelIndex?.isUpdate,
                                  )
                                ],
                              );
                            }
                          );
                        } else {
                          Commodities model = await _repository.saveCommodity(repository.list, repository.dataCommodityCreateUpdate.commodity.images, id: widget.id);
                          if (model != null) {
                            if (widget.id == null) {
                              widget.onCreateItem(model);
                              Navigator.pop(context);
                            } else {
                              widget.onUpdateItem(model);
                              Navigator.pop(context);
                            }
                          }

                        }
                      },
                      margin: EdgeInsets.all(16),
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

  bool isVisibility(bool isUpdate, bool isDeleleItem, bool isUpdateItem) {
    if (isUpdate == null) {
      if (!isDeleleItem && !isUpdateItem) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
