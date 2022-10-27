import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/ratingbar_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/procedures/models/params/rate_action_request.dart';
import 'package:workflow_manager/procedures/models/response/is_rate_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/rate_action/rate_action_repository.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/rate_action/rate_levels_layout.dart';

class RateActionBottomSheet extends StatefulWidget {
  RateAction rateAction;
  int idServiceRecord;

  RateActionBottomSheet({this.rateAction, this.idServiceRecord});

  @override
  _RateActionBottomSheetState createState() => _RateActionBottomSheetState();
}

class _RateActionBottomSheetState extends State<RateActionBottomSheet> {
  RateActionRepository _repository = RateActionRepository();

  TextEditingController contentController = TextEditingController();

  double starValue;

  @override
  void initState() {
    super.initState();
    _repository.ratingIsRateServiceRecord(widget.idServiceRecord);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, RateActionRepository repository, Widget child) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: _mainScreen(repository),
          );
        },
      ),
    );
  }

  Widget _mainScreen(RateActionRepository repository) {
    DataIsRateService dataIsRateService = repository.dataIsRateService;
    if (dataIsRateService == null) {
      return SizedBox();
    }

    starValue = dataIsRateService.star.toDouble();
    contentController.text = dataIsRateService.content;
    dataIsRateService.rateLevels.forEach((element) {
      if (dataIsRateService.content == element.action) {
        element.isSelected = true;
      }
    });

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text("Đánh giá thủ tục", style: TextStyle(color: Colors.white, fontSize: 18),),
        ),
        SizedBox(height: 16),
        RatingBarWidget(
          value: dataIsRateService.star.toDouble() ?? 0,
          onCountChange: (value) {
            starValue = value;
          }
        ),
        SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: contentController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 16),
              hintText: "Đánh giá của bạn",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              // fillColor: "F5F6FA".toColor(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(color: Colors.white),
              )
          )
        ),
        SizedBox(height: 16),
        RateLevelsLayout(
          rateLevels: dataIsRateService.rateLevels,
          onSelected: (RateLevels selected) {
            contentController.text = selected.action;
          },
        ),
        SaveButton(
          margin: EdgeInsets.all(16),
          onTap: () {
            SaveRateServiceRequest request = SaveRateServiceRequest();
            request.content = contentController.text;
            request.idService = dataIsRateService.iDService;
            request.idServiceRecord = dataIsRateService.iDServiceRecord;
            request.idServiceRecordRate = dataIsRateService.iDServiceRecordRate;
            request.star = starValue.toInt();
            _repository.ratingSaveRateServiceRecord(request);

            Navigator.pop(context);
          },
          title: "XONG",
        )
      ],
    );
  }
}
