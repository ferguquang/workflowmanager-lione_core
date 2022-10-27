import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
import 'package:workflow_manager/procedures/widgets/pick_signal/pick_signal_repository.dart';

class PickSignalScreen extends StatefulWidget {
  int totalPage;
  int currentPage;
  void Function(int) goToPage;
  DataSignatureList dataSignatureList;

  PickSignalScreen(
      this.dataSignatureList, this.totalPage, this.currentPage, this.goToPage);

  @override
  _PickSignalScreenState createState() => _PickSignalScreenState();
}

class _PickSignalScreenState extends State<PickSignalScreen>
    with AutomaticKeepAliveClientMixin {
  PickSignalRepository _pickSignalRepository;

  TextEditingController _controller = TextEditingController();
  String root = "";

  @override
  void initState() {
    super.initState();
    _pickSignalRepository = PickSignalRepository(widget.dataSignatureList);
    _controller.text = widget.currentPage.toString();
    SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY).then((value) {
      root = value;
      _pickSignalRepository.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn chữ ký"),
      ),
      body: ChangeNotifierProvider.value(
          value: _pickSignalRepository,
          child: Consumer(
            builder:
                (context, PickSignalRepository pickSignalRepository, child) {
              List<Signatures> signatures =
                  pickSignalRepository?.dataSignatureList?.signatures;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.blue,
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          "Trang:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: 3),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                controller: _controller,
                                onChanged: (value) {
                                  if ((int.tryParse(value) ?? 0) >
                                      widget.totalPage)
                                    _controller.text =
                                        widget.totalPage.toString();
                                  _controller.selection =
                                      TextSelection.collapsed(
                                          offset: _controller.text.length);
                                },
                                // inputFormatters: [ BlacklistingTextInputFormatter(RegExp("[\.,]")) ],
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: false, decimal: false),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          " /${widget.totalPage}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          color: Colors.white,
                          width: 1.5,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            if (widget.goToPage != null)
                              widget.goToPage(int.parse(
                                  isNotNullOrEmpty(_controller.text)
                                      ? _controller.text
                                      : 1));
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    color: Colors.grey.withAlpha(100),
                    child: Text("${signatures?.length ?? 0} chữ ký điện tử"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: signatures?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if(signatures[index].isError){
                              showErrorToast("Không thể chọn chữ ký này.");
                              return;
                            }
                            _pickSignalRepository.dataSignatureList.pickIndex =
                                index;
                            Navigator.pop(context,
                                _pickSignalRepository.dataSignatureList);
                          },
                          child: isNullOrEmpty(root)
                              ? Container()
                              : Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(24),
                                        child: CachedNetworkImage(
                                          imageUrl: root +
                                              (signatures[index]?.filePath ??
                                                  ""),
                                          height: 100,
                                        errorWidget: (context, url, error) {
                                          signatures[index].isError=true;
                                          return Icon(Icons.no_photography_outlined,size: 100,);
                                        },)),
                                    Container(
                                      color: Colors.grey,
                                      height: 1,
                                    )
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
