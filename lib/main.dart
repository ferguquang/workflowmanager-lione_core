import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/check_version_app.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/base/utils/socket_manager.dart';
import 'package:workflow_manager/manager/auth/auth_repository.dart';
import 'package:workflow_manager/manager/auth/login_screen.dart';
import 'package:workflow_manager/manager/home/manager_screen.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';

import 'base/network/api_caller.dart';
import 'base/ui/loading_dialog.dart';
import 'base/ui/toast_view.dart';
import 'base/utils/app_store.dart';
import 'borrowPayDocument/screen/statistic/statistic_tab_borrow_docments.dart';
import 'borrowPayDocument/tab_borrow_pay_document_screen.dart';
import 'common/utils/screen_utils.dart';
import 'manager/home/manager_repository.dart';
import 'models/account_model.dart';
import 'models/reception_contracts_model.dart';
import 'models/reception_no_contracts_model.dart';
import 'workflow/screens/main/splash_screen.dart';

/*
  procedures: Quy trình thủ tục
  storage: Kho lưu trữ - Quản lý tài liệu
  workflow: Quản lý công việc
 */

LoadingDialog loadingDialog;

EventBus eventBus = EventBus();

StreamSubscription loginSubscription;
bool isResumed = false;
IO.Socket socket;
const platform = const MethodChannel(Constant.CHANNEL);
GlobalKey mainGlobalKey = GlobalKey<NavigatorState>();
BuildContext homeContext;
List<String> screenStacks = [];
AppLifecycleState appState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  Do not to shows message check invalid type during debugging
  Provider.debugCheckInvalidValueType = null;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runZonedGuarded(() async {
    /// Checks if shared preference exist
    try {
      await SharedPreferencesClass.getValue(SharedPreferencesClass.INITIALIZE);
    } catch (err) {
      /// setMockInitialValues initiates shared preference
      /// Adds app-name
      // SharedPreferences.setMockInitialValues({});
      // SharedPreferencesClass.saveValue(SharedPreferencesClass.INITIALIZE, 'true');
    }
    /// enable network traffic logging
    HttpClient.enableTimelineLogging = true;
    /// Lock portrait mode.shared_preferences: ^
    // unawaited(
    //     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
    // SystemChrome.setSystemUIOverlayStyle(
    //   // change status bar color
    //   SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    // );
    runApp(MyApp());
  }, (e, stack) {
  });
}

class MyApp extends StatelessWidget with NavigatorObserver {
  // This widget is the root of your application.
  String nameToPop;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: mainGlobalKey,
        theme: ThemeData(
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(
            centerTitle: true,
            textTheme: TextTheme(
              headline6: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        home: HomePage());
  }
  @override
  void afterFirstLayout(BuildContext context) {
    ScreenUtil.init(context);
  }
// @override
// void didPop(Route route, Route previousRoute) {
//   super.didPop(route, previousRoute);
//   if(nameToPop==null)
//     return;
//   if (hasScreen(nameToPop)) {
//     Navigator.pop(mainGlobalKey.currentContext);
//   } else if (isNotNullOrEmpty(nameToPop)) {
//     nameToPop = null;
//     eventBus.fire(PopToName("name", isForPop: false));
//   }
// }
}

class HomePage extends StatefulWidget {
  CurrentStatus status;

  HomePage({this.status});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AuthRepository authRepository = AuthRepository();
  ManagerRepository _managerRepository = ManagerRepository();

  // Sự kiên lắng nghe user chuyển đến từ Doceye
  Future<void> checkDoceyeUser() async {
    User user = await SharedPreferencesClass.getUser();
    var result =
        await platform.invokeMethod(Constant.CHECK_CURRENT_USERNAME_KEY);
    if (isNullOrEmpty(result)) return;
    if (isNullOrEmpty(result["userId"])) {
      //Nếu app Doceye đã logoout => logout
      if (isNotNullOrEmpty(user)) {
        AuthRepository.logout();
      } else {
        // Khi logout app QLCV phải logout cả app Doceye để code chạy vào đây
      }
      return;
    }
    try {
      String userId = result["userId"];
      String name = result["name"];
      String password = result["password"];
      if (isNullOrEmpty(user) || userId != user.iDUserDocPro.toString()) {
        //Nếu chưa đăng nhập hoặc nếu 2 user đang khác nhau => thực hiện login
        await authRepository.login(context, name, password);
        if (authRepository.loggedInStatus == CurrentStatus.Authenticated) {
          if (isNotNullOrEmpty(result["module"])) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _managerRepository.navigationModules(context, result["module"]);
            });
          }
        }
      } else {
        if (isNotNullOrEmpty(result["module"])) {
          _managerRepository.navigationModules(context, result["module"]);
        }
        //Còn đăng nhập mà user_id giống nhau thi không cần làm gì cả
      }
    } on PlatformException catch (e) {
      print("Failed to Inoke: '${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    appState = AppLifecycleState.resumed;
    homeContext = context;
    if (widget.status != null) {
      authRepository.loggedInStatus = widget.status;
    }
    Firebase.initializeApp().then((value) {
      FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kReleaseMode);
      Function originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
        originalOnError(errorDetails);
      };
    });
    WidgetsBinding.instance.addObserver(this);
    loadingDialog = LoadingDialog.getInstance(context);
    // checkDoceyeUser();
    checkSocket();
    CheckVersionApp().checkVersion(context).then((value) {
      authRepository.checkApplink(context);
      authRepository.getConfigApp();
    });
  }

  Future<void> checkSocket() async {
    String deviceID = await SharedPreferencesClass.get(
        SharedPreferencesClass.ONESIGNAL_ID_KEY);
    String token = await SharedPreferencesClass.getToken();
    if (deviceID != null && isNotNullOrEmpty(token)) {
      SocketManager().connect();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: authRepository,
        child: Consumer(
          builder: (context, AuthRepository auth, _) {
            switch (auth.loggedInStatus) {
              case CurrentStatus.Uninitialized:
                return SplashScreen();
              case CurrentStatus.Unauthenticated:
              case CurrentStatus.Authenticating:
                return LoginScreen();
              case CurrentStatus.Authenticated:
                return ManagerScreen();
              default:
                {
                  return EmptyScreen();
                }
            }
          },
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    appState = state;
    switch (state) {
      case AppLifecycleState.resumed:
        SharedPreferencesClass.get(SharedPreferencesClass.UNREADNOTIFICATION)
            .then((value) {
          if (value == null) value = 0;
          FlutterAppBadger.updateBadgeCount(value);
        });
        SharedPreferencesClass.getToken().then((value) {
          if (isNotNullOrEmpty(value))
            _managerRepository
                .getHomeIndex(isShowLoading: false, isRunBackground: true)
                .then((value) {
              AppStore.countNotify =
                  _managerRepository?.homeIndexData?.unreadNotification ?? 0;
            });
        });
        eventBus.fire(OnAppResumed());
        // checkDoceyeUser();
        authRepository.checkApplink(context, isNavigation: true);
        CheckVersionApp().checkVersion(context);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (OneSignalManager.lateNotificationInfos != null) {
            OneSignalManager.instance.navigationTargetScreen(
                context, OneSignalManager.lateNotificationInfos);
            OneSignalManager.lateNotificationInfos = null;
          }
          if (SharedPreferencesClass.getUser() != null) {
            OneSignalManager.instance.initOneSignal(context);
          }
          AuthRepository.unregitryOldPlayerID();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}

class OnAppResumed {}
