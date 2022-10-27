import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/processed_content/dialog_processed_content.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/processed_content/processed_content_repository.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/models/response/processed_content.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';

import 'procressed_content_item.dart';

class ProcessedContentWidget extends StatefulWidget {
  int taskId;

  ProcessedContentWidget(this.taskId);

  @override
  _ProcessedContentWidgetState createState() => _ProcessedContentWidgetState();
}

class _ProcessedContentWidgetState extends State<ProcessedContentWidget> {
  ProcessedContentRepository processedContentRepository =
      ProcessedContentRepository();

  ScrollController _scrollController = new ScrollController();
  bool _show = true;

  @override
  void initState() {
    super.initState();
    _getListTask();
    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  Future<void> _getListTask() async {
    processedContentRepository.request.idJob = '${widget.taskId}';
    processedContentRepository.getList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return processedContentRepository;
    }, child: Consumer<ProcessedContentRepository>(
      builder: (BuildContext context, ProcessedContentRepository repository,
          Widget child) {
        return Stack(
          // builder: (BuildContext context, ProcessedContentRepository repository, Widget child) {
          //   return Stack(
          children: [
            repository.listProcessed.length == 0
                ? EmptyScreen()
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: repository.listProcessed.length,
                    itemBuilder: (context, index) {
                      return ProcessedContentItem(
                        model: repository.listProcessed[index],
                        position: index,
                        onDelete: (ProcessedContent processContent) {
                          repository.deleteItemProcessed(processContent);
                        },
                        onEdit: (Map<String, dynamic> params, int position) {
                          processedContentRepository.editProcessContent(
                              params, position);
                        },
                      );
                    }),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(bottom: 16, right: 16),
              child: Container(
                width: 40,
                height: 40,
                child: Visibility(
                  visible: _show &&
                      context
                              .findAncestorWidgetOfExactType<
                                  TaskDetailsScreen>()
                              .typeTask ==
                          1,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Colors.blue,
                    elevation: 0,
                    child: Icon(
                      Icons.add,
                      size: 36,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return DialogProcessedContent(
                              isAdd: true,
                              taskId: widget.taskId,
                              onUpdateListDialog:
                                  (Map<String, dynamic> params) {
                                processedContentRepository
                                    .addProcessContent(params);
                              },
                            );
                          });
                    },
                  ),
                ),
              ),
            )
          ],
        );
      },
    ));
  }
}
