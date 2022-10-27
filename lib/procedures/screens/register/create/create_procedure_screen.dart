import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/procedures/screens/register/create/create_procedure_repository.dart';

class CreateProcedureScreen extends StatefulWidget {
  @override
  _CreateProcedureScreenState createState() => _CreateProcedureScreenState();
}

class _CreateProcedureScreenState extends State<CreateProcedureScreen> {
  CreateProcedureRepository _createProcedureRepository =
      CreateProcedureRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _createProcedureRepository,
      child: Consumer(
        builder: (BuildContext context, CreateProcedureRepository repository,
            Widget widget) {
          return Container();
        },
      ),
    );
  }
}
