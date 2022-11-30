import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_repository.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/detail_procedure_tab_controller.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/eventAutoSave.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/header_detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_screen.dart';

class DetailProcedureScreen extends StatefulWidget {
  static final int TYPE_REGISTER = 1;
  static final int TYPE_RESOLVE = 2;

  int type;
  int idServiceRecord;
  int state;
  String idShare;

  DetailProcedureScreen(
      {this.type, this.idServiceRecord, this.state, this.idShare});

  @override
  DetailProcedureScreenState createState() => DetailProcedureScreenState();
}

class DetailProcedureScreenState extends State<DetailProcedureScreen> {
  DetailProcedureRepository _procedureRepository = DetailProcedureRepository();
  bool isVisible = false;
  bool isCheckReLoad = false;
  StreamSubscription _detailEventBusStream;

  @override
  void initState() {
    super.initState();
    reloadDetail();
    eventBus.on<NotiData>().listen((event) {
      if (isVisible) {
        Navigator.pop(context);
      }
      pushPage(
          context,
          DetailProcedureScreen(
            idShare: event.idShare,
            idServiceRecord: event.id,
            type: event.typeInt,
            state: null,
          ));
    });

    if (_detailEventBusStream != null) _detailEventBusStream.cancel();
    _detailEventBusStream =
        eventBus.on<EventReloadDetailProcedure>().listen((event) {
      // khi giải quyết hồ sơ thành công
      if (event.isFinish) {
        Navigator.pop(context);
        return;
      }
      if (event.schemaConditionType == 0) {
        eventBus.fire(EventAutoSave());
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        isCheckReLoad = true;
        reloadDetail();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    removeScreenName(widget);
    if (_detailEventBusStream != null) _detailEventBusStream.cancel();
  }

  Future<void> reloadDetail() async {
    int status = await _procedureRepository.getDataDetail(
        widget.idServiceRecord, widget.type,idShare: widget.idShare);
    if (isCheckReLoad = true) {
      if (_procedureRepository.dataProcedureDetail.currentStep != null)
        _procedureRepository
            .dataProcedureDetail.currentStep.isCheckReLoadModel = true;
      isCheckReLoad = false;
    }
    if (status != 1) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("detailprocedure"),
      onVisibilityChanged: (info) {
        isVisible = info.visibleFraction == 1;
      },
      child: ChangeNotifierProvider.value(
        value: _procedureRepository,
        child: Consumer(
          builder: (BuildContext context, DetailProcedureRepository repository,
              Widget child) {
            return _mainScreen(repository);
          },
        ),
      ),
    );
  }

  Widget _mainScreen(DetailProcedureRepository repository) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết hồ sơ"),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                HeaderDetailProcedureScreen(
                  dataProcedureDetail: repository.dataProcedureDetail,
                  type: widget.type,
                  isReject: widget.state == ListRegisterScreen.TYPE_REJECTED,
                )
              ]),
            ),
            DetailProcedureTabController(
                repository.dataProcedureDetail, widget.type, widget.state)
          ],
        ),
      ),
    );
  }
}
