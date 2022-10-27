import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_bottom_sheet.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/action_item.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/add_action/add_action_bottom_sheet.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/file_procedure_item.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/rate_action/rate_action_bottom_sheet.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/rating_screen.dart';
import 'package:workflow_manager/workflow/screens/details/flow_chart.dart';
import 'package:workflow_manager/procedures/models/response/star.dart'
as passedStar;
import 'require_action/require_action_bottom_sheet.dart';

class HeaderDetailProcedureScreen extends StatelessWidget {
  DataProcedureDetail dataProcedureDetail;
  int type;
  bool isReject;

  HeaderDetailProcedureScreen({this.dataProcedureDetail, this.type, this.isReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            _infoBasic(context),
            _listFile(dataProcedureDetail?.registerStep),
            Row(
              children: [
                dataProcedureDetail?.actions?.conditions != null
                    ? _actionLayout(
                    dataProcedureDetail.actions?.conditions, context)
                    : SizedBox(),
                dataProcedureDetail?.rateAction != null
                    ? _rateAction(dataProcedureDetail?.rateAction, context)
                    : SizedBox()
              ],
            ),
            _requireActionLayout(context),
            Container(
              margin: EdgeInsets.only(top: 8),
              color: Colors.grey[200],
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget _headerLayout(context, String name) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  Widget _requireActionLayout(context) {
    if (type == DetailProcedureScreen.TYPE_REGISTER) {
      if (dataProcedureDetail.addAction != null) {
        if (dataProcedureDetail.addAction.name != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerLayout(context, "Gửi lại hồ sơ"),
              SizedBox(height: 8,),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: [
                          RequireActionBottomSheet(
                            type: type,
                            addAction: dataProcedureDetail.addAction,
                            idHoSo: dataProcedureDetail.iDServiceRecord,
                          )
                        ],
                      );
                    },
                    context: context,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dataProcedureDetail.addAction.action, style: TextStyle(fontSize: 14),),
                      Card(
                          color: getColor(dataProcedureDetail.addAction.color),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dataProcedureDetail.addAction.name, style: TextStyle(color: Colors.white, fontSize: 12),),
                          )
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[200])
                  ),
                ),
              ),
            ],
          );
        }
      }
    } else {
      if (dataProcedureDetail.requiredAction != null) {
        if (dataProcedureDetail.requiredAction.name != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerLayout(context, "Gửi lại hồ sơ"),
              SizedBox(height: 8,),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: [
                          RequireActionBottomSheet(
                            type: type,
                            addAction: dataProcedureDetail.addAction,
                            idHoSo: dataProcedureDetail.iDServiceRecord,
                            requiredAction: dataProcedureDetail.requiredAction,
                          )
                        ],
                      );
                    },
                    context: context,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dataProcedureDetail.requiredAction.action, style: TextStyle(fontSize: 14),),
                      Card(
                          color: getColor(dataProcedureDetail.requiredAction.color),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dataProcedureDetail.requiredAction.name, style: TextStyle(color: Colors.white, fontSize: 12),),
                          )
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[200])
                  ),
                ),
              ),
            ],
          );
        }
      }
    }
    return Container();
  }

  Widget _infoBasic(context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ImageAssetCircleWidget(
          //   image: "assets/images/qttt.png",
          //   height: 40,
          //   width: 40,
          // ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    dataProcedureDetail?.title ?? "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.only(bottom: 4),
                ),
                _buildRow(
                    Icon(
                      Icons.assignment_outlined,
                      color: Colors.grey,
                      size: 18,
                    ),
                    dataProcedureDetail?.name ?? ""),
                _buildRow(
                    Icon(Icons.account_circle_outlined,
                        color: Colors.grey, size: 18),
                    dataProcedureDetail?.registerStep?.register?.name ?? ""),
                _buildRow(
                    Icon(Icons.access_time_outlined,
                        color: Colors.grey, size: 18),
                    convertTimeStampToHumanDate(
                        dataProcedureDetail?.registerStep?.registerDate ?? 0,
                        "dd/MM/yyyy HH:mm")),
                dataProcedureDetail?.registerStep?.priority == 0 ?
                _buildRow(Icon(Icons.check_box_outline_blank, color: Colors.grey, size: 18), "Thông thường") :
                _buildRow(Icon(Icons.check_box_outlined, color: Colors.blue, size: 18), "Quan trọng"),
                InkWell(
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                          size: 18,
                        ),
                        const Text(" Lưu đồ",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onTap: () async {
                    if (isNullOrEmpty(dataProcedureDetail?.urlFlowChart))
                      return;
                    String root = await SharedPreferencesClass.get(
                        SharedPreferencesClass.ROOT_KEY);
                    String token = await SharedPreferencesClass.getToken();
                    String url =
                        "$root${dataProcedureDetail?.urlFlowChart}&Token=$token";
                    pushPage(context, FlowChart(url));
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: FittedBox(
              child: InkWell(
                onTap: () {
                  if (dataProcedureDetail?.iDService == null) return;
                  passedStar.Star star = passedStar.Star(
                      iDService: dataProcedureDetail?.iDService ?? 0,
                      iDServiceRecord:
                      dataProcedureDetail?.iDServiceRecord ?? 0,
                      isRegisterView: 1,
                      star: dataProcedureDetail?.star?.star);

                  pushPage(context, RatingScreen(star));
                },
                child: RatingBarIndicator(
                  rating: dataProcedureDetail?.star?.star ?? 0.0,
                  physics: NeverScrollableScrollPhysics(),
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
          ),
        ],
      ),
    );
  }

  Widget _listFile(RegisterStep registerStep) {
    return isNullOrEmpty(registerStep)
        ? Container()
        : Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: registerStep?.registerAttachedFiles?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    RegisterAttachedFiles file =
                    registerStep.registerAttachedFiles[index];
                    // String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
                    FileUtils.instance.downloadFileAndOpen(
                        file.name, "${file.path}", context);
                  },
                  child: FileProcedureItem(
                    registerAttachedFiles:
                    registerStep.registerAttachedFiles[index],
                  ),
                );
              },
          ),
         );
  }

  Widget _rateAction(RateAction rateAction, context) {
    if (isNullOrEmpty(rateAction)) return Container();
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  RateActionBottomSheet(
                    idServiceRecord: dataProcedureDetail.iDServiceRecord,
                    rateAction: rateAction,
                  )
                ],
              ),
            );
          },
          context: context,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerLayout(context, "Xử lý hồ sơ"),
          Container(
            margin: EdgeInsets.only(top: 8, left: 16),
            height: 70,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rateAction?.action ?? "",
                    style: TextStyle(fontSize: 14),
                  ),
                  Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          rateAction?.name ?? "",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ))
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionLayout(List<Conditions> conditions, context) {
    if (isNullOrEmpty(conditions) && isNullOrEmpty(dataProcedureDetail.addAction.name)) {
      return SizedBox();
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Xử lý hồ sơ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  // Icon(Icons.arrow_circle_down, color: Colors.grey)
                ],
              ),
            ),
            decoration: BoxDecoration(color: Colors.grey[200]),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: dataProcedureDetail.addAction == null /*&& dataProcedureDetail.addAction.name.isNotEmpty */? conditions.length : conditions.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == conditions.length) {
                  return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (_) {
                              return Wrap(
                                children: [
                                  AddActionBottomSheet(
                                    idServiceRecord: dataProcedureDetail.iDServiceRecord,
                                    addAction: dataProcedureDetail.addAction,
                                  )
                                ],
                              );
                            }
                        );
                      },
                      child: dataProcedureDetail.addAction.name != null ? _addActionWidget(dataProcedureDetail.addAction) : Container()
                  );
                }
                return InkWell(
                  child: ActionItem(
                    model: conditions[index],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          conditions[index].titleHoSo = dataProcedureDetail.title;
                          return ActionBottomSheet(
                            conditions: conditions[index],
                            idServiceRecord:
                            dataProcedureDetail.iDServiceRecord,
                            isReject: isReject,
                            isFinish: true,
                          );
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _addActionWidget(AddAction addAction) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(addAction.action, style: TextStyle(fontSize: 14),),
          Card(
              color: getColor(addAction.color),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(addAction.name, style: TextStyle(color: Colors.white, fontSize: 12),),
              )
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[200])
      ),
    );
  }

  Widget _buildRow(Icon icon, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          Padding(padding: EdgeInsets.only(right: 4)),
          Expanded(child: Text("$value"))
        ],
      ),
    );
  }
}
