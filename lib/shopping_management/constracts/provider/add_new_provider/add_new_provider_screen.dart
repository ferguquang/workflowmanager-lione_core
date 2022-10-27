import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/search_provider_reponse.dart';

import 'add_new_provider_repository.dart';

class AddNewProviderScreen extends StatefulWidget {
  static const int TYPE_DETAIL = 1;
  static const int TYPE_CREATE = 2;
  static const int TYPE_EDIT = 3;
  static const int TYPE_CREATE_KHAOGIA_NCC = 4;

  static const String TYPE = "type";

  int providerId = 0, type = 0;
  List<Regions> regions;
  List<Nations> nations;
  List<Categorys> categorys;

  AddNewProviderScreen(
      this.providerId, this.type, this.regions, this.categorys, this.nations);

  @override
  _AddNewProviderScreenState createState() => _AddNewProviderScreenState();
}

class _AddNewProviderScreenState extends State<AddNewProviderScreen> {
  AddNewProviderRepository _addNewProviderRepository =
      AddNewProviderRepository();
  static const String CODE = "Mã nhà cung cấp";
  static const String NAME = "Tên nhà cung cấp";
  static const String ABBREVIATION = "Tên viết tắt";
  static const String REGION = "Vùng miền";
  static const String NATION = "Quốc gia";
  static const String ADDRESS = "Địa chỉ";
  static const String PERSON_CONTACT = "Người liên hệ";
  static const String PHONE_CONTACT = "Số điện thoại liên hệ";
  static const String EMAIL = "Email";
  static const String TAX_CODE = "Mã số thuế";
  static const String CATEGORY = "Danh mục hàng hoá";
  List<ContentShoppingModel> listData = [];
  int idRegion;
  String idCategorys;
  int idNation;

  @override
  void initState() {
    super.initState();
    addItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo mới"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return ContentViewShoppingItem(
                    model: listData[index],
                    position: index,
                    onClick: (model, position) {
                      if (model.isDropDown) {
                        ChoiceDialog choiceDialog = ChoiceDialog(
                          context,
                          model.dropDownData,
                          selectedObject: model.selected,
                          getTitle: model.getTitle,
                          isSingleChoice: model.title != CATEGORY,
                          title: model.title,
                          hintSearchText: "Tìm kiếm",
                          onAccept: (list) {
                            model.selected = list;
                            if (isNotNullOrEmpty(list)) {
                              model.value = model.getTitle(list[0]);
                              if (model.title == REGION) {
                                idRegion = list[0].iD;
                              } else if (model.title == CATEGORY) {
                                idCategorys =
                                    list.map((e) => e.iD).toList().join(", ");
                                model.value =
                                    list.map((e) => e.name).toList().join(", ");
                              } else if (model.title == NATION) {
                                idNation = list[0].iD;
                              }
                            } else {
                              model.value = "";
                              if (model.title == REGION) {
                                idRegion = 0;
                              } else if (model.title == CATEGORY) {
                                idCategorys = null;
                              } else if (model.title == NATION) {
                                idNation = 0;
                              }
                            }
                            setState(() {});
                          },
                        );
                        choiceDialog.showChoiceDialog();
                      } else {
                        pushPage(
                            context,
                            InputTextWidget(
                              isNumberic: model.isNumeric,
                              isDecimal: model.isDecimal,
                              title: model.title,
                              content: model.value,
                              onSendText: (text) {
                                if (model.isMoney == true)
                                  text = getCurrencyFormat(text);
                                model.value = text;
                                setState(() {});
                              },
                            ));
                      }
                    });
              },
            ),
          ),
          SaveButton(
            margin: EdgeInsets.all(16),
            title: "Xong",
            onTap: () async {
              for (ContentShoppingModel model in listData) {
                if (model.isRequire && isNullOrEmpty(model.value)) {
                  showErrorToast("Trường ${model.title} bắt buộc nhập");
                  return;
                }
              }
              _addNewProviderRepository.params.code = listData[0].value;
              _addNewProviderRepository.params.name = listData[1].value;
              _addNewProviderRepository.params.region = idRegion;
              _addNewProviderRepository.params.iDNation = idNation;
              _addNewProviderRepository.params.address = listData[4].value;
              _addNewProviderRepository.params.personContact =
                  listData[5].value;
              _addNewProviderRepository.params.phoneContact = listData[6].value;
              _addNewProviderRepository.params.taxCode = listData[8].value;
              _addNewProviderRepository.params.iDCategorys = idCategorys;
              _addNewProviderRepository.params.abbreviation = listData[2].value;
              _addNewProviderRepository.params.email = listData[7].value;
              bool isSuccess = false;
              if (widget.type == AddNewProviderScreen.TYPE_CREATE ||
                  widget.type == AddNewProviderScreen.TYPE_CREATE_KHAOGIA_NCC) {
                isSuccess = await _addNewProviderRepository.create();
              } else if (widget.type == AddNewProviderScreen.TYPE_EDIT) {
                _addNewProviderRepository.params.idProvider = widget.providerId;
                isSuccess = await _addNewProviderRepository.save();
              }
              if (isSuccess) {
                Navigator.pop(context, true);
              }
            },
          )
        ],
      ),
    );
  }

  addItems() {
    ContentShoppingModel codeModel,
        nameModel,
        abbreviationModel,
        regionModel,
        addressModel,
        personContactModel,
        phoneContactModel,
        emailModel,
        taxCodeModel,
        categoryModel,
        nation;
    codeModel =
        ContentShoppingModel(title: CODE, isRequire: true, value: "NCC_");
    listData.add(codeModel);

    nameModel = ContentShoppingModel(title: NAME, isRequire: true);
    listData.add(nameModel);

    abbreviationModel =
        ContentShoppingModel(title: ABBREVIATION, isRequire: true);
    listData.add(abbreviationModel);

    regionModel = ContentShoppingModel(
      title: REGION,
      isRequire: true,
      isDropDown: true,
      dropDownData: widget.regions,
      getTitle: (data) => data.name,
    );
    listData.add(regionModel);
    nation = ContentShoppingModel(
      title: NATION,
      isRequire: true,
      isDropDown: true,
      dropDownData: widget.nations,
      getTitle: (data) => data.name,
    );
    listData.add(nation);

    addressModel = ContentShoppingModel(title: ADDRESS, isRequire: false);
    listData.add(addressModel);

    personContactModel =
        ContentShoppingModel(title: PERSON_CONTACT, isRequire: false);
    listData.add(personContactModel);

    phoneContactModel = ContentShoppingModel(
        title: PHONE_CONTACT, isRequire: false, isNumeric: true);
    listData.add(phoneContactModel);

    emailModel = ContentShoppingModel(title: EMAIL, isRequire: false);
    listData.add(emailModel);

    taxCodeModel = ContentShoppingModel(title: TAX_CODE, isRequire: false);
    listData.add(taxCodeModel);

    categoryModel = ContentShoppingModel(
        title: CATEGORY,
        isRequire: true,
        isDropDown: true,
        dropDownData: widget.categorys,
        getTitle: (model) => model.name);
    listData.add(categoryModel);
  }
}
