import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_vote/create_update/create_update_provider_vote_sceen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_vote/provider_vote_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/provider_vote_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';
import 'provider_vote_repository.dart';

class ProviderVoteScreen extends StatefulWidget {
  @override
  _ProviderVoteScreenState createState() => _ProviderVoteScreenState();
}

class _ProviderVoteScreenState extends State<ProviderVoteScreen> {
  ProviderVoteRepository _repository = ProviderVoteRepository();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _sortType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getProviderVote();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, ProviderVoteRepository repository,
            Widget child) {
          _repository = repository;
          return Scaffold(
              appBar: AppBar(
                title: Text("Đánh giá nhà cung cấp"),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                      height: 8,
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(
                          complete: Container(),
                        ),
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus mode) {
                            return Container(
                              height: 55.0,
                              child: Center(),
                            );
                          },
                        ),
                        onRefresh: () {
                          _onRefresh();
                        },
                        onLoading: () {
                          _onLoadMore();
                        },
                        child: _listWidget(repository.dataProviderVotes),
                      ),
                    ),
                    SortFilterBaseWidget(
                      sortType: _sortType,
                      onSortType: (type) {
                        repository.dataProviderVotes.providerVotes.sort((a,
                                b) =>
                            (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
                            a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase()));
                        _repository.notifyListeners();
                      },
                      onFilter: _filter,
                    ),
                  ],
                ),
              ),
              floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Visibility(
                  visible: repository.dataProviderVotes?.isCreate == null
                      ? false
                      : repository.dataProviderVotes.isCreate,
                  child: FloatingButtonWidget(
                    onSelectedButton: () async {
                      int status = await pushPage(context, CreateUpdateProviderVoteScreen());
                      if (status == 1) {
                        _repository.pullToRefreshData();
                        _repository.getProviderVote();
                      }
                    },
                  ),
                ),
              ));
        },
      ),
    );
  }

  void _onRefresh() async {
    _sortType = 0;
    _refreshController.refreshCompleted();
    _repository.pullToRefreshData();
    _getListData();
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListData();
  }

  void _getListData() {
    _repository.getProviderVote();
  }

  Widget _listWidget(DataProviderVotes dataProviderVotes) {
    if (isNullOrEmpty(dataProviderVotes?.providerVotes)) {
      return EmptyScreen();
    }
    return ListView.separated(
      itemCount: dataProviderVotes.providerVotes?.length,
      itemBuilder: (BuildContext context, int index) {
        return ProviderVoteItem(
          model: dataProviderVotes.providerVotes[index],
          onClickItem: (itemClick) async {
            List<ContentShoppingModel> list = await _repository.renderDetail(
                id: itemClick.iD, isDetail: true);
            pushPage(
                context,
                ListWithArrowScreen(
                  data: list,
                  screenTitle: "Chi tiết đánh giá",
                  isShowSaveButton: false,
                ));
          },
          onEdit: (itemUpdate) async {
            int status = await pushPage(context, CreateUpdateProviderVoteScreen(id: itemUpdate.iD,));
            if (status == 1) {
              _repository.pullToRefreshData();
              _repository.getProviderVote();
            }
          },
          onDelete: (itemDelete) {
            ConfirmDialogFunction(
                context: context,
                content: "Bạn có muốn xóa đánh giá nhà cung cấp này không?",
                onAccept: () {
                  _repository.removeItem(itemDelete);
                }).showConfirmDialog();
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  Future<void> _filter() async {
    List<ContentShoppingModel> list = _repository.addFilter();
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          screenTitle: "Lọc nâng cao",
          saveTitle: "Lọc",
          isCanClear: true,
        ));

    _repository.request.provider =
        result[0].value.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.contract =
        result[1].value.toString().replaceAll("]", "").replaceAll("[", "");
    _repository.request.idCategorys = result[2]
        .idValue
        .toString()
        .replaceAll("]", "")
        .replaceAll("[", "")
        .replaceAll("'", "");
    _repository.pullToRefreshData();
    _repository.getProviderVote();
  }
}
