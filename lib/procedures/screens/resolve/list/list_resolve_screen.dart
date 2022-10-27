import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/list_resolve_request.dart';
import 'package:workflow_manager/procedures/models/response/record_is_resolve_list_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/filter/filter_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/handle_fast_list_screen.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_sign_pass_widget.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/list_resolve_item.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/list_resolve_repository.dart';

class ListResolveScreen extends StatefulWidget {
  static final int TYPE_PENDING =
      1; // cần giải quyết // (đây là param của api không dc thay đổi)
  static final int TYPE_PROCESSED = 2; // đã giải quyết
  static final int TYPE_COMPLEMENTARY = 6; // cần bổ sung
  static final int TYPE_STAR = 7;

  int state;

  ListResolveScreen(this.state);

  @override
  _ListResolveScreenState createState() => _ListResolveScreenState();
}

class _ListResolveScreenState extends State<ListResolveScreen>
    with AutomaticKeepAliveClientMixin {
  ListResolveRepository _repository = ListResolveRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ServiceRecords> serviceRecordSelected = List();
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
    arrayTypeItem.add(FilterProcedureType.USER_REGISTER);
    arrayTypeItem.add(FilterProcedureType.DEPT);
    arrayTypeItem.add(FilterProcedureType.FROM_EXPECTED);
    arrayTypeItem.add(FilterProcedureType.TO_EXPECTED);
    return FilterProcedureScreen(
      searchProcedureModel: _repository.searchProcedureModel,
      originalRequest: _repository.resolveRequest,
      arrayTypeItem: arrayTypeItem,
      onDoneFilter: (result) {
        this._repository.resolveRequest = ListResolveRequest.from(result);
        _onRefresh();
      },
      rootType: FilterRootType.RESOLVE,
    );
  }

  String countTask = "";

  void _getListData() async {
    if (isNullOrEmpty(_repository.resolveRequest.filterState.state)) {
      _repository.resolveRequest.filterState.state = widget.state;
    }
    await _repository.getListResolve();
    setState(() {
      countTask =
          (_repository?.dataListResolve?.recordNumber?.toString() ?? "") +
              " hồ sơ";
    });
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    _repository.pullToRefreshData();
    _getListData();

    setState(() {
      serviceRecordSelected.clear();
    });
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListData();
  }

  Widget _listResolve(List<ServiceRecords> list) {
    return isNullOrEmpty(list)
        ? EmptyScreen()
        : ListView.separated(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ListResolveItem(
                  model: list[index],
                  position: index,
                  state: widget.state,
                  onUpdateItem: (ServiceRecords modelSelected, int position) {
                    _repository.itemSelected(modelSelected, position);
                  },
                  onRatingItem: (ServiceRecords item) {
                    _repository.recordRating(item, widget.state);
                  },
                ),
                onTap: () async {
                  await pushPage(
                      context,
                      DetailProcedureScreen(
                        type: DetailProcedureScreen.TYPE_RESOLVE,
                        idServiceRecord: list[index].iD,
                        state: widget.state,
                      ));

                  _repository.clearListServiceRecordSelected();
                  _repository.resolveRequest.filterState.state = widget.state;
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

  var removeEventBus;
  @override
  void initState() {
    super.initState();
    _repository.resolveRequest.filterState.state = widget.state;
    _repository.state = widget.state;
    _repository.pullToRefreshData();
    _getListData();

    eventBus.on<DataRecordIsResolveList>().listen((event) {
      if (event.state != widget.state) return;
      pushPage(
          context,
          HandleFastListScreen(
            data: event,
            onDone: (List<ServiceRecordsResolve> list, String password) {
              handleDoneResolve(list, password);
            },
            onCheckSignPass:
                (List<ServiceRecordsResolve> list, String password) async {
              bool isSucess = await _repository.checkPassword(password);
              if (isSucess) {
                handleDoneResolve(list, password);
              } else {
                pushPage(
                    context,
                    InputSignPassWidget(
                      title: "Mật khẩu chữ ký số",
                      onSendText: (String password) {
                        handleDoneResolve(list, password);
                      },
                    ));
              }
            },
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ListResolveRepository repository, _) {
          if (repository.dataListResolve != null) {
            // if (isFirst) { // chỉ bắn lần đầu tiên để lấy số lượng
            eventBus.fire(repository.dataListResolve);
            // isFirst = false;
            // }
          }

          return _screen(repository);
        },
      ),
    );
  }

  Widget _screen(ListResolveRepository repository) {
    serviceRecordSelected = repository.serviceRecordSelected;

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(countTask)),
                IconButton(
                  icon: Icon(Icons.filter_list_outlined),
                  color: Colors.grey,
                  onPressed: () {
                    pushPage(context, _filterScreen());
                  },
                ),
                Visibility(
                  visible: serviceRecordSelected.length != 0,
                  child: _handleRecord(serviceRecordSelected),
                )
              ],
            ),
          ),
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
          child: _listResolve(repository.serviceRecords),
        ))
      ],
    );
  }

  Widget _handleRecord(List<ServiceRecords> serviceRecordSelected) {
    return InkWell(
      onTap: () {
        String idSelecteds =
            serviceRecordSelected.map((e) => e.iD).toList().toString();

        _repository.recordIsResolveList(idSelecteds);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            const Icon(
              Icons.remove_red_eye,
              color: Colors.white,
              size: 18,
            ),
            Text(
                isNotNullOrEmpty(_repository.dataListResolve)
                    ? " Xử lý (${serviceRecordSelected.length}/${_repository.dataListResolve.recordTotalPending})"
                    : " Xử lý 0",
                style: TextStyle(color: Colors.white)),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Future<void> handleDoneResolve(
      List<ServiceRecordsResolve> list, String password) async {
    int status = await _repository.recordResolveList(list, password);
    if (status == 1) {}
    _repository.clearData();
    _onRefresh();
  }

  @override
  bool get wantKeepAlive => true;
}
