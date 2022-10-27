import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';

class SelectStepDialog extends StatelessWidget {
  List<SelectSteps> selectSteps;

  void Function(SelectSteps) onItemSelected;

  SelectStepDialog({this.selectSteps, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Center(child: Text("Bước", style: TextStyle(color: Colors.white, fontSize: 18))),
        ),
        SizedBox(height: 8,),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: InkWell(
                child: Text(selectSteps[index].name),
                onTap: () {
                  onItemSelected(selectSteps[index]);
                  Navigator.pop(context);
                },
              ),
            );
          },
        )
      ],
    );
  }
}
