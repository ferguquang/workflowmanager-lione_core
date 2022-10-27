import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/register/choice_type_procedure/choice_type_procedure_repository.dart';
import 'package:workflow_manager/procedures/screens/register/list_work_follow/list_work_follow_screen.dart';
import 'package:workflow_manager/base/extension/string.dart';

import '../step_widget.dart';

class ChoiceTypeProcedureScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChoiceTypeProcedureScreen();
  }
}

class _ChoiceTypeProcedureScreen extends State<ChoiceTypeProcedureScreen> {
  ChoiceTypeProcedureRepository _choiceTypeProcedureRepository =
      ChoiceTypeProcedureRepository();
  GlobalKey _stepKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _choiceTypeProcedureRepository.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký hồ sơ"),
      ),
      body: ChangeNotifierProvider.value(
        value: _choiceTypeProcedureRepository,
        child: Column(
          children: [
            StepWidget(0, _stepKey),
            Expanded(
              child: Consumer(
                builder: (context,
                    ChoiceTypeProcedureRepository choiceTypeProcedureRepository,
                    child) {
                  return ListView.builder(
                    itemCount:
                        choiceTypeProcedureRepository.listRegisterType.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey.withAlpha(100)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        choiceTypeProcedureRepository
                                                ?.listRegisterType[index]
                                                ?.name ??
                                            "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                      ),
                                      Text(choiceTypeProcedureRepository
                                              ?.listRegisterType[index]
                                              ?.describe ??
                                          ""),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 30,
                                    height: 30,
                                    child: SVGImage(svgName: "register_type"))
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          pushPage(
                              context,
                              ListWorkFollowScreen(choiceTypeProcedureRepository
                                  .listRegisterType[index].iD));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
