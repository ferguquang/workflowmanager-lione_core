import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/data_register_save_response.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
import 'package:workflow_manager/procedures/models/response/data_signed_pdf_response.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';
import 'package:workflow_manager/procedures/widgets/pdf/action_signature_screen.dart';
import 'package:workflow_manager/procedures/widgets/pdf/pdf_provider.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_widget/signal_info.dart';
import 'package:workflow_manager/procedures/widgets/photoview/photo_view_gallery.dart';
import 'package:workflow_manager/procedures/widgets/photoview/src/controller/photo_view_controller.dart';
import 'package:workflow_manager/procedures/widgets/photoview/src/photo_view_computed_scale.dart';
import 'package:workflow_manager/procedures/widgets/photoview/src/utils/photo_view_hero_attributes.dart';
import 'package:workflow_manager/procedures/widgets/pick_signal/pick_signal_screen.dart';

import '../../../base/utils/common_function.dart';
import '../../models/response/data_signature_list_response.dart';
import 'lazy_image_provider.dart';
import 'signal_widget/signal_widget.dart';

class SignalScreen extends StatefulWidget {
  FileTemplate signalFile;
  int idHoso;
  String title;
  List<Signatures> signatures; // ký file đính kèm sẽ không có dữ liệu
  Map<String, dynamic> paramsRegitster; // ký file đính kèm sẽ không có dữ liệu
  bool isTypeRegister;
  SignatureLocation signatureLocation;
  String iDGroupPdfForm;
  String action; // endpoint API
  String isDoneInfoDATA;

  SignalScreen(this.signalFile, this.idHoso, this.title,
      {this.signatures,
      this.signatureLocation,
      this.paramsRegitster,
      this.iDGroupPdfForm,
      this.action,
      this.isDoneInfoDATA,
      this.isTypeRegister = true})
      : super(key: GlobalKey());

  @override
  SignalScreenState createState() => SignalScreenState();
}

class SignalScreenState extends State<SignalScreen> {
  FileTemplate signalFile;
  PdfDocument _pdfDocument;
  var defaultProvider = AssetImage("assets/images/test.png");
  PdfRepository _pdfRepository = PdfRepository();
  double startX, startY;
  double top, left, bottom, right;
  double topPdf, leftPdf, bottomPdf, rightPdf;
  double width, height;
  double wrapperWidth = 30;
  double wrapperHeight = 30;
  IconData squareIcon = Icons.crop_square;

  static const int FLAG_NONE = -1;
  static const int FLAG_MOVE = 0;
  static const int FLAG_TOP_LEFT = 1;
  static const int FLAG_TOP_RIGHT = 2;
  static const int FLAG_BOTTOM_LEFT = 3;
  static const int FLAG_BOTTOM_RIGHT = 4;
  int flag = 0;
  GlobalKey photoKey;
  GlobalKey _changingPhotoKey;
  GlobalKey _keyWrapper = GlobalKey();
  bool _isPageChanging;
  double ratioWidthHeight = 0;
  PageController _pageController = PageController();
  PhotoViewController photoViewController;
  PhotoViewController _changingPhotoViewController;
  double previewPage = -1;
  Signatures _signatures;
  double _pickImageX = 0;
  double _pickImageY = 0;
  String localFile;
  List<SignalWidget> signalWidgets = [];
  bool isFirst = true;

  bool isShowPassword = false;
  bool isSavePassword = true;
  TextEditingController _passwordController = TextEditingController();
  int _currentPage;
  List<int> dontCallScale = [];
  Map<int, SaveKey> saveKeys = Map();

  @override
  void initState() {
    super.initState();
    _currentPage = _pageController.initialPage;
    signalFile = widget.signalFile;
    openPdf();
    _pageController.addListener(() {
      int firstPage = _pageController.page.floor();
      int secondPage = _pageController.page.ceil();
      RenderBox wrapperRenderBox =
          _keyWrapper.currentContext.findRenderObject();
      double wrapperWidth = wrapperRenderBox.size.width;
      signalWidgets
          .where((element) =>
              element.pageNum == firstPage || element.pageNum == secondPage)
          .toList()
          .forEach((element) {
        double addX = 0;
        if (element.pageNum < _currentPage) {
          addX = -wrapperWidth;
        } else if (element.pageNum > _currentPage) {
          addX = wrapperWidth;
        }
        getSignalWidgetState(element).addPosition(
            -(_pageController.offset -
                wrapperWidth * _currentPage -
                addX),
            0);
      });

      for (SignalWidget signalWidget in signalWidgets) {
        if (signalWidget.pageNum == firstPage ||
            signalWidget.pageNum == secondPage) {
          getSignalWidgetState(signalWidget)?.show();
        } else {
          getSignalWidgetState(signalWidget)?.hide();
        }
      }
      if ((_pageController.page == _pageController.page.toInt() &&
              _pageController.page != _pdfDocument.pagesCount - 1 &&
              (_pageController.page > 0 ||
                  (_pageController.page == 0 &&
                      _pageController.offset == 0))) ||
          ((_pageController.page - _currentPage).abs() > 1)) {
        signalWidgets
            .where((element) => element.pageNum == _pageController.page.toInt())
            .forEach((element) {
          getSignalWidgetState(element).clearBackUpXY();
        });
      }
    });
    if (widget.signatures == null)
      _pdfRepository.loadAllSignals(widget.idHoso, signalFile.iD);
    else {
      _pdfRepository.dataSignatureList = DataSignatureList();
      _pdfRepository.dataSignatureList.signatures = widget.signatures;
      _pdfRepository.dataSignatureList.signatureLocation =
          widget.signatureLocation;
      _pdfRepository.notifyListeners();
    }
  }

  SignalWidgetState getSignalWidgetState(SignalWidget signalWidget) {
    return (signalWidget.key as GlobalKey).currentState as SignalWidgetState;
  }

  onPositionChanged(
      GlobalKey newPhotoKey, PhotoViewController controller, int index) {
    saveKeys[index] = SaveKey(newPhotoKey, controller);
    if (saveKeys[_currentPage] == null) return;
    photoKey = saveKeys[_currentPage].photoKey;
    photoViewController = saveKeys[_currentPage].photoViewController;
    double scale = photoViewController?.scale;
    signalWidgets
        .where((element) => element.pageNum == _currentPage)
        .forEach((element) {
      getSignalWidgetState(element).scale(scale);
    });
    signalWidgets
        .where((element) => element.pageNum == index)
        .forEach((element) {
      element.photoKey = newPhotoKey;
      element.photoViewController = controller;
    });
  }

  loadSignal(Signatures signatures, bool isDefaultSignal) async {
    if (isDefaultSignal) {
      _signatures = signatures;
      _pageController.jumpToPage(
          _pdfRepository.dataSignatureList.signatureLocation.page - 1);
      await Future.delayed(Duration(milliseconds: 200));
    }
    SignalWidget signalInfo = SignalWidget(
        signatures: signatures,
        keyWrapper: _keyWrapper,
        location: _pdfRepository.dataSignatureList.signatureLocation,
        isDefaultSignal: isDefaultSignal,
        pickImageX: _pickImageX,
        pickImageY: _pickImageY,
        pageNum: isDefaultSignal
            ? (isNotNullOrEmpty(
                    _pdfRepository?.dataSignatureList?.signatureLocation?.page)
                ? _pdfRepository.dataSignatureList.signatureLocation.page - 1
                : _currentPage)
            : _currentPage,
        photoViewController: photoViewController,
        photoKey: photoKey,
        scale: photoViewController.scale,
        signPageFixPos: 0,
        pdfDocument: _pdfDocument,
        pageController: _pageController,
        deleteSignal: (signal) {
          signalWidgets.remove(signal);
          _pdfRepository.notifyListeners();
        },
        onTap: (signal) {
          signalWidgets.remove(signal);
          signalWidgets.add(signal);
          _pdfRepository.notifyListeners();
        },
        key: GlobalKey());
    signalWidgets.add(signalInfo);
    _pdfRepository.notifyListeners();
  }

  Size getLocalPdfSize() {
    if (photoKey?.currentContext == null) {
      RenderBox wrapperRenderBox = _keyWrapper.currentContext.findRenderObject();
      return Size(wrapperRenderBox.size.width,
          wrapperRenderBox.size.height);
    }
    RenderBox renderBoxPdf = photoKey.currentContext.findRenderObject();
    return Size(renderBoxPdf.size.width * photoViewController.scale,
        renderBoxPdf.size.height * photoViewController.scale);
  }

  Offset getLocalPdfLocation() {
    if (photoKey?.currentContext == null) return Offset.zero;
    RenderBox renderBoxPdf = photoKey.currentContext.findRenderObject();
    RenderBox renderBoxWrapper = _keyWrapper.currentContext.findRenderObject();
    Offset topLeftWrapper = renderBoxWrapper.localToGlobal(Offset.zero);
    Offset topLeftPdf = renderBoxPdf.localToGlobal(Offset.zero);
    return Offset(
        topLeftPdf.dx - topLeftWrapper.dx, topLeftPdf.dy - topLeftWrapper.dy);
  }

  bool isLoadCompleted = false;

  void onLoadImageState(int index, bool isComplete) {
    if (index == _pageController.page) {
      isLoadCompleted = isComplete;
    }
  }

  openPdf() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      await Permission.storage.request();
    }
    String path =
        await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY) +
            signalFile.signPath;
    localFile = await FileUtils.instance.downloadFileAndOpen(
        signalFile.iD.toString() + signalFile.extension, path, context,
        isOpenFile: false, isShowSuccess: false);

    if (localFile != null) {
      _pdfDocument = await PdfDocument.openFile(localFile);
    } else {
      showErrorToast("Download $path error");
    }
    setState(() {});
  }

  goToPage(int page) {
    if (_pdfDocument != null) _pageController.jumpToPage(page - 1);
  }

  pickSignal(bool isDefaultSignal) async {
    if (_pdfDocument?.pagesCount == null) {
      showErrorToast("Chưa mở xong file!");
      return;
    }
    DataSignatureList data = await pushPage(
        context,
        PickSignalScreen(
            _pdfRepository.dataSignatureList,
            _pdfDocument.pagesCount,
            isDefaultSignal
                ? _pdfRepository.dataSignatureList.signatureLocation.page
                : _pageController.page.toInt() + 1,
            goToPage));
    if (data == null) {
      return;
    }
    _pdfRepository.dataSignatureList = data;

    if (_pdfRepository?.dataSignatureList?.pickIndex != null) {
      _signatures = _pdfRepository?.dataSignatureList
          ?.signatures[_pdfRepository?.dataSignatureList?.pickIndex];
      await loadSignal(_signatures, isDefaultSignal);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (localFile != null) {
      File file = File(localFile);
      file.exists().then((value) => file.delete());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: _pdfRepository)],
        child: Scaffold(
            appBar: AppBar(
              title: InkWell(
                child: Text("Chữ ký"),
                onTap: () {
                  photoViewController.scale = 1.1;
                },
              ),
              actions: [
                InkWell(
                    onTap: () {
                      pickSignal(true);
                    },
                    child: Visibility(
                      visible: isNotNullOrEmpty(
                          _pdfRepository?.dataSignatureList?.signatureLocation),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit),
                      ),
                    ))
              ],
            ),
            body: Stack(key: _keyWrapper, children: [
              _pdfDocument == null
                  ? Center(child: Text("Loading"))
                  : InkWell(
                      onTap: () {
                        pickSignal(false);
                      },
                      onTapDown: (details) {
                        _pickImageX = details.localPosition.dx;
                        _pickImageY = details.localPosition.dy;
                      },
                      child: PhotoViewGallery.builder(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        pageController: _pageController,
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          if (_isPageChanging == null)
                            _isPageChanging = false;
                          else
                            _isPageChanging = true;
                          return PhotoViewGalleryPageOptions(
                            index: index,
                            imageProvider: LazyImageProvider(index + 1,
                                _pdfDocument, context, onLoadImageState),
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 5.0,
                            heroAttributes: PhotoViewHeroAttributes(tag: index),
                          );
                        },
                        onPageChanged: (index) {
                          photoKey = saveKeys[_currentPage].photoKey;
                          photoViewController =
                              saveKeys[_currentPage].photoViewController;
                          signalWidgets
                              .where((element) => element.pageNum == index)
                              .forEach((element) {
                            element.photoKey = saveKeys[index].photoKey;
                            element.photoViewController =
                                saveKeys[index].photoViewController;
                          });
                          signalWidgets.forEach((element) {
                            SignalWidgetState state =
                                getSignalWidgetState(element);
                            if (element.pageNum == _currentPage &&
                                _currentPage != index) {
                              state.hide();
                              state.addPosition(null, null);
                              Future.delayed(Duration(milliseconds: 200))
                                  .then((value) {
                                getSignalWidgetState(element).fitScreen();
                              });
                            }
                            if (element.pageNum == index) {
                              getSignalWidgetState(element).show();
                            }
                          });
                          _currentPage = index;
                        },
                        itemCount: _pdfDocument.pagesCount,
                        loadingBuilder: (context, progress) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
              Consumer(
                builder: (context, PdfRepository pdfRepository, child) {
                  return Stack(
                    children: getWidgets(),
                  );
                },
              )
            ]),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: donePress,
            )));
  }

  List<Widget> getWidgets() {
    List<Widget> list = [];
    list.add(Container());
    list.addAll(signalWidgets);
    return list;
  }

  donePress() async {
    if (isNullOrEmpty(signalWidgets)) {
      showErrorToast("Bạn chưa chọn chữ ký");
      return;
    }
    String password = await SharedPreferencesClass.get(
        SharedPreferencesClass.PASSWORD_SIGNAL);
    if (isNotNullOrEmpty(password)) {
      var isSuccess = await savePdf(password, widget.idHoso);
      if (isSuccess) Navigator.pop(context);
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Nhập mật khẩu",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: !isShowPassword,
                          decoration: InputDecoration(
                              hintText: "Mật khẩu",
                              suffixIcon: InkWell(
                                onTap: () {
                                  isShowPassword = !isShowPassword;
                                  setState(() {});
                                },
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(isShowPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            isSavePassword = !isSavePassword;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  "Nhớ mật khẩu",
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Checkbox(
                                value: isSavePassword,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                child: Text("Quay lại"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Xác nhận"),
                onPressed: () async {
                  // FocusScopeNode focus = FocusScope.of(context);
                  // focus.unfocus();
                  if (isNullOrEmpty(_passwordController.text)) {
                    showErrorToast("Bạn chưa điền mật khẩu");
                    return;
                  }
                  bool isValid = await _pdfRepository.checkPassword(_passwordController.text);
                  if (isValid) {
                    if (isSavePassword) {
                      String paswordSignal = _passwordController.text;
                      SharedPreferencesClass.save(SharedPreferencesClass.PASSWORD_SIGNAL, paswordSignal);
                    }
                    var isSuccess = await savePdf(_passwordController.text, widget.idHoso);
                    if (isSuccess) {
                      Navigator.pop(context, widget.signatures != null ? isSuccess : null);
                    }
                  } else {
                    showErrorToast("Mật khẩu sai");
                  }
                },
              )
            ],
          );
        },
      );

      Navigator.pop(context);
    }
  }

  Future<bool> savePdf(String password, int idHoSo) async {
    Map<String, dynamic> params = Map();
    params["ID"] = signalFile.iD;
    List<SignalInfo> list = signalWidgets
        .map((e) => getSignalWidgetState(e).getSignalInfo())
        .toList();
    List<int> idSignal = [];
    List<int> pageSignal = [];
    List<double> bottomSignal = [];
    List<double> leftSignal = [];
    List<int> heightPdf = [];
    List<int> widthPdf = [];
    List<double> imageHeightSignal = [];
    List<double> imageWidthSignal = [];
    List<int> signPageFixPos = [];
    for (SignalInfo signalInfo in list) {
      idSignal.add(signalInfo.id);
      pageSignal.add(signalInfo.pageNum + 1);
      bottomSignal.add(signalInfo.bottom);
      leftSignal.add(signalInfo.left);
      heightPdf.add(signalInfo.pdfHeight);
      widthPdf.add(signalInfo.pdfWidth);
      imageHeightSignal.add(signalInfo.signalHeight);
      imageWidthSignal.add(signalInfo.signalWidth);
      signPageFixPos.add(signalInfo.signPageFixPos);
    }
    params["IDSignature"] = idSignal.toList().toString();
    params["Page"] = pageSignal.toList().toString();
    params["Bottom"] = bottomSignal.toList().toString();
    params["Left"] = leftSignal.toList().toString();
    params["Height"] = heightPdf.toList().toString();
    params["Width"] = widthPdf.toList().toString();
    params["ImgHeight"] = imageHeightSignal.toList().toString();
    params["ImgWidth"] = imageWidthSignal.toList().toString();
    params["Password"] = password.toString();
    params["SignPageFixPos"] = signPageFixPos.toList().toString();
    params["IDGroupPdfForm"] = widget.iDGroupPdfForm;
    if (isNotNullOrEmpty(widget.action)) {
      params["IDServiceRecord"] = widget.idHoso;
      params["PdfPath"] = widget.paramsRegitster["PdfPath"];
      params["IsDoneInfoDATA"] = widget.isDoneInfoDATA;
      var json = await ApiCaller.instance
          .postFormData(widget.action, params);
      BaseResponse response = BaseResponse.fromJson(json);
      if (response.status == 1) {
        ToastMessage.show(response.messages, ToastStyle.success);
        String password = await SharedPreferencesClass.get(
            SharedPreferencesClass.PASSWORD_SIGNAL);
        if (!isNullOrEmpty(password)) {
          Navigator.pop(context);
        }

        eventBus.fire(EventReloadDetailProcedure());
        return true;
      }
      showErrorToast(response, defaultMessage: "Lưu chữ ký thất bại");
      return false;
    } else if (widget.signatures != null) {
      if (signalWidgets.length > 0)
        params["Path"] = signalWidgets[0]
            .signatures
            .filePath
            .replaceAll("/Storage/Files/", "");
      if (widget.paramsRegitster != null) params.addAll(widget.paramsRegitster);
      if (widget.isTypeRegister == true) {
        var json = await ApiCaller.instance
            .postFormData(AppUrl.getQTTTRegisterSavePdfForm, params);
        DataRegisterSaveResponse response =
            DataRegisterSaveResponse.fromJson(json);
        if (response.status == 1) {
          // Navigator.pop(context, response);
          eventBus.fire(
              EventReloadDetailProcedure(response: response, isFinish: true));
          return true;
        }

        return false;
      } else {
        params["IDGroup "] = 0;

        var json = await ApiCaller.instance
            .postFormData(AppUrl.getQTTTRecordSavePdfForm, params);
        BaseResponse response = BaseResponse.fromJson(json);
        if (response.status == 1) {
          ToastMessage.show(response.messages, ToastStyle.success);
          Navigator.pop(context);
          eventBus.fire(EventReloadDetailProcedure());
          return true;
        }
        showErrorToast(response, defaultMessage: "Lưu chữ ký thất bại");
        return false;
      }
    } else {
      var json = await ApiCaller.instance.postFormData(AppUrl.getQTTTSignatureSavePDF, params);
      DataSignedPdfResponse response = DataSignedPdfResponse.fromJson(json);
      if (response.status == 1) {
        showSuccessToast("Ký file thành công!");
        // var json = await ApiCaller.instance
        //     .postFormData(AppUrl.getQTTTSignatureSavePDF, params);
        DataSignedPdfResponse response = DataSignedPdfResponse.fromJson(json);
        if (response.status == 1) {
          // showSuccessToast("Ký file thành công!");
          if (isNotNullOrEmpty(response?.data?.signFile?.actions)) {
            await showModalBottomSheet(
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    ActionSignatureScreen(
                      response?.data?.signFile?.actions,
                      idHoSo,
                      widget.title,
                      onDismiss: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
              context: context,
            );
            // await pushPage(context, ActionSignatureScreen(response?.data?.signFile?.actions, idHoSo, widget.title));
            eventBus.fire(EventReloadDetailProcedure());
            // Navigator.pop(context);
          } else {
            eventBus.fire(EventReloadDetailProcedure());
            // Navigator.pop(context);
          }

          return true;
        }
        showErrorToast(response, defaultMessage: "Lưu chữ ký thất bại");
        return false;
      }
    }
  }
}

log(List<dynamic> params) {
  StringBuffer sb = StringBuffer();
  for (dynamic obj in params) {
    sb.write(obj?.toString());
    sb.write("|");
  }
  print("signal  ${sb.toString()}");
}

class SaveKey {
  GlobalKey photoKey;
  PhotoViewController photoViewController;

  SaveKey(this.photoKey, this.photoViewController);
}
