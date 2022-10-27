import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/plan_shopping/detail/plan_detail_item.dart';
import 'package:workflow_manager/shopping_management/management/plan_shopping/plan_shopping_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class PlanShoppingDetailScreen extends StatefulWidget {
  int id;

  PlanShoppingDetailScreen({@required this.id});

  @override
  _PlanShoppingDetailScreenState createState() => _PlanShoppingDetailScreenState();
}

class _PlanShoppingDetailScreenState extends State<PlanShoppingDetailScreen> {
  PlanShoppingRepository _repository = PlanShoppingRepository();

  @override
  void initState() {
    super.initState();
    _repository.getPlanDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, PlanShoppingRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Chi tiết kế hoạch mua sắm"),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _repository.listDetail.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ContentViewShoppingItem(
                          model: _repository.listDetail[index],
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      child: Text("Dữ liệu kế hoạch mua sắm"),
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(16),
                    ),
                    isNotNullOrEmpty(
                            _repository.dataPlanningDetail.planningDetails)
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _repository
                                .dataPlanningDetail.planningDetails.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PlanDetailItem(
                                model: _repository
                                    .dataPlanningDetail.planningDetails[index],
                                idShoppingType: _repository
                                    .dataPlanningDetail.planning.iDShoppingType,
                                idSuggestionType: _repository.dataPlanningDetail
                                    .planning.iDSuggestionType,
                                onClickItem: (itemClick) async {
                                  List<ContentShoppingModel> list =
                                      _repository.getSubDetail(
                                          itemClick,
                                          _repository.dataPlanningDetail
                                              .planningDetailHeader);
                                  pushPage(
                                      context,
                                      ListWithArrowScreen(
                                        data: list,
                                        screenTitle: "Chi tiết dữ liệu",
                                        isShowSaveButton: false,
                                      ));
                                },
                              );
                            },
                          )
                        : SizedBox()
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
