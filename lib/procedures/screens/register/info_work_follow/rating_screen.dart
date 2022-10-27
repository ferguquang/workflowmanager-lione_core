import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/data_service_rate_view_response.dart';
import 'package:workflow_manager/procedures/models/response/star.dart'
    as passedStar;
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class RatingScreen extends StatefulWidget {
  passedStar.Star star;

  RatingScreen(this.star);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  passedStar.Star passStar;
  RefreshController _refreshController = RefreshController();
  Map<String, dynamic> params;
  int pageIndex = 1;
  DataServiceRateView _dataServiceRateView;
  int state = 7,oldState=-1;
  String root = '';

  @override
  void initState() {
    super.initState();
    passStar = widget.star;
    loadData(pageIndex: pageIndex);
    setRootApi();
  }

  setRootApi() async {
    root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
  }

  loadData({int pageIndex, int pageSize = 10}) async {
    if (pageIndex != null) this.pageIndex = pageIndex;
    if ((oldState==state)&&_dataServiceRateView?.pageTotal != null &&
        _dataServiceRateView.pageTotal < this.pageIndex) return;
    params = Map();
    params["IDServiceRecord"] = passStar.iDServiceRecord;
    params["IDService"] = passStar.iDService;
    params["IsRegisterView"] = passStar.isRegisterView;
    params["State"] = state;
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = pageSize;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.getQTTTRatingServiceRateView, params);
    DataServiceRateViewResponse dataServiceRateViewResponse =
        DataServiceRateViewResponse.fromJson(json);
    if (dataServiceRateViewResponse.status == 1) {
      if (this.pageIndex == 1 || _dataServiceRateView == null)
        _dataServiceRateView = dataServiceRateViewResponse.data;
      else {
        _dataServiceRateView.rateRecords
            .addAll(dataServiceRateViewResponse.data.rateRecords ?? []);
      }
      passStar.numberEval=_dataServiceRateView.star.numberEval;
      passStar.star=_dataServiceRateView.star.star;
      passStar.title=_dataServiceRateView.star.title;
      this.pageIndex++;
      setState(() {});
    } else {
      showErrorToast(dataServiceRateViewResponse.messages);
    }
    oldState=state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xem đánh giá"),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_sharp),
            onPressed: _showChoideDialog,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                "Đánh giá và nhận xét",
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${passStar?.star != null ? passStar?.star?.toStringAsFixed(2) : 0}",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      FittedBox(
                        child: RatingBarIndicator(
                          rating: passStar?.star??0.0,
                          itemCount: 5,
                          itemPadding: EdgeInsets.all(0),
                          direction: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                          // ratingWidget: RatingWidget(
                          //   full: Icon(Icons.star,color: Colors.yellow,),
                          //   half: Icon(Icons.star,color: Colors.yellow,),
                          //   empty: Icon(Icons.star,color: Colors.grey,),
                          // ),
                        ),
                      ),
                      Text((passStar?.numberEval??0).toString(),
                          style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildProgress(
                          5, _dataServiceRateView?.rateStars?.elementAt(0)?.percent ?? 0),
                      _buildProgress(
                          4, _dataServiceRateView?.rateStars?.elementAt(1)?.percent ?? 0),
                      _buildProgress(
                          3, _dataServiceRateView?.rateStars?.elementAt(2)?.percent ?? 0),
                      _buildProgress(
                          2, _dataServiceRateView?.rateStars?.elementAt(3)?.percent ?? 0),
                      _buildProgress(
                          1, _dataServiceRateView?.rateStars?.elementAt(4)?.percent ?? 0),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
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
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoadMore,
              child: _buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  _showChoideDialog() async {
    if (_dataServiceRateView == null) {
      showErrorToast("Dữ liệu trống");
      return;
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          var filter = _dataServiceRateView?.filterStyles;
          double padding = 16;
          return Wrap(
            children: [
              Column(
                children: [
                  TitleDialog("Bộ lọc".toUpperCase()),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filter?.length ?? 0,
                      itemBuilder: (context, index) {
                        FilterStyles model = filter[index];
                        return InkWell(
                          onTap: () {
                            state = model.state;
                            loadData(pageIndex: 1);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                Opacity(
                                  opacity: state == model.state ? 1 : 0,
                                  child: Icon(
                                    Icons.check,
                                    size: 24,
                                    color: getColor("#A9CC35"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: padding),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            model.action,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: padding),
                                          ),
                                          Visibility(
                                            visible: index < 5,
                                            child: Container(
                                              height: 24,
                                              width: 80,
                                              child: FittedBox(
                                                child: RatingBarIndicator(
                                                  rating:
                                                      (index + 1).toDouble(),
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.all(0),
                                                  direction: Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: getColor(
                                                  "#ECBB2D",
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            alignment: Alignment.center,
                                            child: Text(
                                                model?.total?.toString() ?? "0",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                            constraints: BoxConstraints(
                                                minWidth: 20, minHeight: 20),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 0.7,
                                        color: getColor("#E4E4E4"),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        });
      },
    );
  }

  _onLoadMore() async {
    await loadData();
    _refreshController.loadComplete();
  }

  _onRefresh() async {
    await loadData(pageIndex: 1);
    _refreshController.refreshCompleted();
  }

  Widget _buildListView() {
    List<RateRecords> rateRecords = _dataServiceRateView?.rateRecords;
    // return Container(height: 100,);
    return ListView.builder(
        itemCount: rateRecords?.length ?? 0,
        itemBuilder: (context, index) {
          RateRecords rateRecord = rateRecords[index];
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: CircleNetworkImage(
                            url: root + (rateRecord?.createdBy?.avatar ?? ""),
                            size: 40,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rateRecord?.createdBy?.name ?? ""),
                            Text(rateRecord?.dept?.name ?? ""),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 20,
                            child: FittedBox(
                              child: RatingBarIndicator(
                                rating:  rateRecord?.star!=null?rateRecord.star.toDouble() :0.0,
                                itemCount: 5,
                                itemPadding: EdgeInsets.all(0),
                                direction: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Text(isNotNullOrEmpty(rateRecord?.dateTimeDisplay)?rateRecord?.dateTimeDisplay?.replaceAll("-", "/"): ""))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    Text(
                      rateRecord?.content ?? "",
                      maxLines: 1000,
                    )
                  ],
                ),
              ),
              Container(
                color: getColor("#E4E4E4"),
                height: 1,
              )
            ],
          );
        });
  }

  Widget _buildProgress(int number, double progress) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              number.toString(),
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: LinearProgressIndicator(
                minHeight: 15,
                value: progress.toDouble() / 100,
                backgroundColor: getColor("#D8D8D8"),
                valueColor: AlwaysStoppedAnimation<Color>(getColor("#77B4EC")),
              ),
            ),
          )
        ],
      ),
    );
  }
}
