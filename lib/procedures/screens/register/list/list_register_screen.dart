import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/list_register_request.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/filter/filter_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/register/list/event_reload_list_register.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_item.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_repository.dart';

class ListRegisterScreen extends StatefulWidget {
  static final int TYPE_TOTAL =
      0; // tất cả hồ sơ  (đây là param của api không dc thay đổi)
  static final int TYPE_PENDING = 1; // chưa xử lý
  static final int TYPE_PROCESSING = 2; // đang xử lý
  static final int TYPE_PROCESSED = 3; // đã hoàn thành
  static final int TYPE_REJECTED = 4; // từ chối
  static final int TYPE_CANCEL = 5; // hủy
  static final int TYPE_COMPLEMENTARY = 6; // cần bổ sung
  static final int TYPE_STAR = 7; // có gắn sao

  int state;

  ListRegisterScreen(this.state);

  @override
  _ListRegisterScreenState createState() => _ListRegisterScreenState();
}

class _ListRegisterScreenState extends State<ListRegisterScreen>
    with AutomaticKeepAliveClientMixin {
  ListRegisterRepository _repository = ListRegisterRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isFirst = true;

  Widget _filterScreen() {
    List<FilterProcedureType> arrayTypeItem = [];
    arrayTypeItem.add(FilterProcedureType.TERM);
    arrayTypeItem.add(FilterProcedureType.START_DATE);
    arrayTypeItem.add(FilterProcedureType.END_DATE);
    arrayTypeItem.add(FilterProcedureType.STATE);
    arrayTypeItem.add(FilterProcedureType.TYPE);
    arrayTypeItem.add(FilterProcedureType.SERVICE);
    arrayTypeItem.add(FilterProcedureType.PRIORITY);
    arrayTypeItem.add(FilterProcedureType.STATUS);
    return FilterProcedureScreen(
      searchProcedureModel: _repository.searchProcedureModel,
      originalRequest: _repository.registerRequest,
      arrayTypeItem: arrayTypeItem,
      onDoneFilter: (result) {
        this._repository.registerRequest = ListRegisterRequest.from(result);
        _onRefresh();
      },
      rootType: FilterRootType.REGISTER,
    );
  }

  String countTask = "";

  void _getListData() async {
    if (isNullOrEmpty(_repository.registerRequest.filterState.state)) {
      _repository.registerRequest.filterState.state = widget.state;
    }
    await _repository.getListRegister();
    setState(() {
      countTask =
          (_repository?.dataListRegister?.recordNumber ?? 0).toString() +
              " hồ sơ";
    });
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    _repository.pullToRefreshData();
    _getListData();
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListData();
  }

  @override
  void initState() {
    super.initState();
    _repository.registerRequest.filterState.state = widget.state;
    _repository.pullToRefreshData();
    _getListData();

    eventBus.on<EventReloadListRegister>().listen((event) {
      _repository.registerRequest.filterState.state = widget.state;
      _repository.pullToRefreshData();
      _getListData();
    });
  }

  Widget _listRegister(List<ServiceRecords> list) {
    return isNullOrEmpty(list)
        ? EmptyScreen()
        : ListView.separated(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ListRegisterItem(
                  model: list[index],
                  onUpdateItem: (item) {
                    _repository.registerRating(item, widget.state);
                  },
                  onDeleteItem: (item) async {
                    int status = await _repository.removeItem(item);
                    if (status == 1) _onRefresh();
                  },
                ),
                onTap: () async {
                  var data = await pushPage(
                      context,
                      DetailProcedureScreen(
                        idServiceRecord: list[index].iD,
                        type: DetailProcedureScreen.TYPE_REGISTER,
                        state: widget.state,
                      ));

                  _repository.registerRequest.filterState.state = widget.state;
                  _repository.pullToRefreshData();
                  _getListData();
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ListRegisterRepository repository, _) {
          if (isFirst) {
            // chỉ bắn lần đầu tiên để lấy số lượng
            eventBus.fire(repository.dataListRegister);
            isFirst = false;
          }
          return _screen(repository);
        },
      ),
    );
  }

  Widget _screen(ListRegisterRepository repository) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(child: Text(countTask)),
                  IconButton(
                    icon: Icon(Icons.filter_list_outlined),
                    color: Colors.grey,
                    onPressed: () {
                      pushPage(context, _filterScreen());
                    },
                  ),
                ],
              )),
          decoration: BoxDecoration(color: Colors.grey[200]),
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
              Widget body;
              if (mode == LoadStatus.idle) {
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
              } else if (mode == LoadStatus.canLoading) {
              } else {}
              return Container(
                height: 55.0,
                child: Center(
                  child: body,
                ),
              );
            },
          ),
          onRefresh: () {
            _onRefresh();
          },
          onLoading: () {
            _onLoadMore();
          },
          child: _listRegister(repository.serviceRecords),
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
