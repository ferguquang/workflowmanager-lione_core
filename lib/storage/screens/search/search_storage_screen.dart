import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/storage/repository/search_storage_model.dart';
import 'package:workflow_manager/storage/screens/tabs/main_tab_storage_screen.dart';
import 'package:workflow_manager/base/utils/palette.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'search_storage_repository.dart';

class SearchStorageScreen extends StatefulWidget {
  StorageTopTabType typeStorage;

  StorageBottomTabType type;

  SearchStorageScreen(this.typeStorage, this.type);

  @override
  State<StatefulWidget> createState() {
    return SearchStorageState();
  }
}

class SearchStorageState extends State<SearchStorageScreen> {
  SearchStorageRepository auth;
  TextEditingController searchController = TextEditingController();

  _login() async {
    auth = SearchStorageRepository();
    await auth.login();
  }

  @override
  void initState() {
    super.initState();
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => auth,
      child: Consumer(
        builder: (context, SearchStorageRepository auth, child) {
          return Scaffold(
            appBar: AppBar(
              leading: BackIconButton(),
              title: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                  auth.clickScreen(context, null, searchController.text,
                      widget.typeStorage, widget.type);
                },
                controller: searchController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(color: Colors.white60),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.borderEditText.toColor())),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: auth.listModel?.length ?? 0,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    SearchStorageModel item = auth?.listModel[index];
                    switch (item.type) {
                      case SearchStorageRepository.FILE:
                      case SearchStorageRepository.TIME:
                      case SearchStorageRepository.DOC:
                        return _imageBuilderWidget(item, index);

                      case SearchStorageRepository.TITLE:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.text,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // loại tệp
  Widget _imageBuilderWidget(SearchStorageModel item, int index) {
    return InkWell(
      onTap: () {
        auth.clickScreen(context, index, searchController.text,
            widget.typeStorage, widget.type);
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              item.image,
              height: 20,
              width: 20,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Visibility(
              visible: item.isCheck,
              child: Image.asset(
                'assets/images/selected.png',
                height: 20,
                width: 20,
              ),
            ),
          ],
        ),
      ),
      onLongPress: () {
        setState(() {
          item.isCheck = !item.isCheck;
        });
      },
    );
  }
}
