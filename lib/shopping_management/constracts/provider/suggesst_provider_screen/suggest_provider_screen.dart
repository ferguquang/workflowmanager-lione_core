import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/column_logic.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/suggesst_provider_screen/suggest_provider_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart'
    as refer;
import 'package:workflow_manager/shopping_management/response/suggest_provider_response.dart';

class SuggestProviderScreen extends StatefulWidget {
  List<refer.Provider> removeList;
  int id;

  SuggestProviderScreen(this.removeList, this.id);

  @override
  _SuggestProviderScreenState createState() => _SuggestProviderScreenState();
}

class _SuggestProviderScreenState extends State<SuggestProviderScreen> {
  SuggestProviderRepository _suggestProviderRepository =
      SuggestProviderRepository();
  List<SuggestProviderModel> selected = [];

  @override
  void initState() {
    super.initState();
    _suggestProviderRepository.removeList = widget.removeList;
    _suggestProviderRepository.loadData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nhận gợi ý".toUpperCase()),
      ),
      body: provider.ChangeNotifierProvider.value(
        value: _suggestProviderRepository,
        child: provider.Consumer(
          builder: (context,
              SuggestProviderRepository suggestProviderRepository, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: suggestProviderRepository?.listData?.length ?? 0,
                    itemBuilder: (context, index) {
                      SuggestProviderModel suggest =
                          suggestProviderRepository.listData[index];
                      return InkWell(
                        onTap: () {
                          showDetail(suggest);
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, right: 16),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (selected.contains(suggest))
                                          selected.remove(suggest);
                                        else {
                                          selected.add(suggest);
                                        }
                                        suggestProviderRepository
                                            .notifyListeners();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: !selected.contains(suggest)
                                            ? Image.asset(
                                                "assets/images/icon_statistic.webp",
                                                width: 30,
                                                height: 30,
                                              )
                                            : Icon(
                                                Icons.check_circle_rounded,
                                                size: 30,
                                                color: getColor("#82D000"),
                                              ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          suggest?.suggest?.provider?.name ??
                                              "",
                                          style: TextStyle(
                                              color: getColor("#54A0F5"),
                                              fontSize: 20),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                        ),
                                        Text(
                                            "Mã NCC: ${(suggest?.suggest?.provider?.code ?? "")}"),
                                        Text(
                                            "Điểm đánh giá: ${(suggest?.suggest?.providerVote?.totalPoint ?? "")}"),
                                      ],
                                    ),
                                  ),
                                  RightArrowIcons()
                                ],
                              ),
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
                SaveButton(
                  margin: EdgeInsets.all(16),
                  title: "Chọn",
                  onTap: done,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  done() async {
    List<refer.PriceRefers> result =
        await _suggestProviderRepository.done(selected);
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  showDetail(SuggestProviderModel suggest) {
    List<ContentShoppingModel> list = [];
    ContentShoppingModel model;
    model = ContentShoppingModel(
        title: "Mã nhà cung cấp",
        value: suggest.suggest.provider.code,
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Tên nhà cung cấp",
        value: suggest.suggest.provider.name,
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Giá gần nhất",
        value: suggest.suggest.providerVote.pricePoint.toString(),
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Điều khiển thanh toán gần nhất",
        value: suggest.suggest.providerVote.paymentPoint.toString(),
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Tiến độ giao hàng gần nhất",
        value: suggest.suggest.providerVote.deliveryPoint.toString(),
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Chất lượng sản phẩm gần nhất",
        value: suggest.suggest.providerVote.qualityPoint.toString(),
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Phối hợp gần nhất",
        value: suggest.suggest.providerVote.coordinatePoint.toString(),
        isNextPage: false);
    list.add(model);
    model = ContentShoppingModel(
        title: "Điểm đánh giá gần nhất",
        value: suggest.suggest.providerVote.totalPoint.toString(),
        isNextPage: false);
    list.add(model);
    pushPage(
        context,
        ListWithArrowScreen(
          screenTitle: "Chi tiết nhà cung cấp".toUpperCase(),
          data: list,
          isShowSaveButton: false,
        ));
  }
}
