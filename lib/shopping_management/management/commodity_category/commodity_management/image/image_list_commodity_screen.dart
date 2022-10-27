import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class ImageListCommodityScreen extends StatefulWidget {
  List<ImageCommodity> list = [];
  bool isUpdate;

  void Function(List<ImageCommodity>) onUpdateList;

  ImageListCommodityScreen({this.list, this.onUpdateList, this.isUpdate});

  @override
  _ImageListCommodityScreenState createState() => _ImageListCommodityScreenState();
}

class _ImageListCommodityScreenState extends State<ImageListCommodityScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.list == null) {
      widget.list = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hình ảnh"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text("${widget.list.length} hình ảnh"),
                  ),
                  Visibility(
                    visible: widget.isUpdate != null,
                    child: InkWell(
                      child: Container(
                        width: 140,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        child:
                        Text("Thêm hình ảnh +", style: TextStyle(color: Colors.black)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      onTap: () async {
                        var file = await FileUtils.instance.uploadFileFromSdcard(context, fileType: FileType.image);
                        setState(() {
                          widget.list.add(new ImageCommodity(
                              fileName: file.fileName,
                              filePath: file.filePath
                          ));
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, int index) {
                  ImageCommodity item = widget.list[index];
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Text("${item.fileName}"),
                            onTap: () async {
                              String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
                              print("IMAGEURL: $root/storage/files/${item.filePath}");
                              pushPage(context, DetailImageScreen("$root/storage/files/${item.filePath}"));
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.isUpdate != null,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.list.removeWhere((element) => element.fileName == item.fileName);
                              });
                            },
                            child: Icon(Icons.close_outlined, color: Colors.grey,),
                          ),
                        )
                      ],
                    ),
                  );
               },
              ),
            ),
            Visibility(
              visible: widget.isUpdate != null,
              child: SaveButton(
                title: "Lưu",
                margin: EdgeInsets.all(16),
                onTap: () {
                  widget.onUpdateList(widget.list);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


class DetailImageScreen extends StatelessWidget {
  String url;

  DetailImageScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'url',
            child: CachedNetworkImage(
              imageUrl: url,
              errorWidget: (context, url, error) {
                // ToastMessage.show("Lỗi đường dẫn!!!", error);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 32,),
                    Text("Lỗi đường dẫn!!!")
                  ],
                );
              },
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}