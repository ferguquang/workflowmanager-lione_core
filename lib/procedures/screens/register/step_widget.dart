import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';

class StepWidget extends StatefulWidget {
  int currentStep;
  Color activeColor;
  Color deactiveColor;
  bool isUpdate;
  void Function(int) onMoveToStep;
  List<StepInfo> steps = [
    StepInfo(0, "Chọn loại thủ tục"),
    StepInfo(1, "Danh sách thủ tục"),
    StepInfo(2, "Thông tin thủ tục")
  ];

  StepWidget(this.currentStep, GlobalKey key,
      {List<StepInfo> steps,
      this.onMoveToStep,
      this.activeColor = Colors.blue,
      this.deactiveColor = Colors.grey,
      this.isUpdate = false})
      : super(key: key ?? GlobalKey()) {
    if (steps != null) this.steps = steps;
  }

  @override
  State<StatefulWidget> createState() {
    return StepWidgetState();
  }
}

class StepWidgetState extends State<StepWidget> {
  Map<int, GlobalKey> _mapKeys = Map();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GlobalKey key = _mapKeys[widget.currentStep];
      RenderBox renderBox = key.currentContext.findRenderObject();
      RenderBox stepRenderBox =
          (widget.key as GlobalKey).currentContext.findRenderObject();
      double scrollX =
          (renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width) -
              stepRenderBox.size.width;
      if (scrollX < 0) scrollX = 0;
      _controller.jumpTo(scrollX);
    });
  }

  backAll(data) {
    for (int i = -1; i < widget.currentStep; i++) {
      Navigator.pop(context, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListView(
            controller: _controller,
            children: getStepWidget(),
            scrollDirection: Axis.horizontal,
          ),
          height: 60,
        ),
        Divider(
          color: Colors.grey,
          height: 1,
        ),
      ],
    );
  }

  List<Widget> getStepWidget() {
    List<Widget> list = [];
    for (int i = 0; i < widget.steps.length; i++) {
      GlobalKey key = GlobalKey();
      _mapKeys[i] = key;
      list.add(_buildItem(widget.steps[i], key, i));
    }
    return list;
  }

  Widget _buildItem(StepInfo stepInfo, GlobalKey key, int index) {
    bool isCurrent = stepInfo.step == widget.currentStep;
    Color color;
    if (isCurrent || widget.currentStep > stepInfo.step) {
      color = widget.activeColor;
    } else {
      color = widget.deactiveColor;
    }
    return InkWell(
      onTap: () {
        if (index >= widget.currentStep) return;

        for (int i = index; i < widget.currentStep; i++) {
          Navigator.pop(context);
          if (widget.onMoveToStep != null) {
            widget.onMoveToStep(index);
          }
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(right: 8,left: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: color),
              child: widget.currentStep > stepInfo.step
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  : Text(
                      (stepInfo.step + 1).toString(),
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            Text(
              stepInfo.content,
              style: TextStyle(
                  color: isCurrent ? widget.activeColor : widget.deactiveColor),
            ),
            Container(
              key: key,
              margin: const EdgeInsets.only(right: 0),
              child: Transform.scale(
                scale: 1.5,
                child: SVGImage(svgName: "step_separator"),
                alignment: FractionalOffset.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StepInfo {
  int step;
  String content;

  StepInfo(this.step, this.content);
}
