import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let CHANNEL = "flutter.native/helper"
    
    lazy var methodChannel: FlutterMethodChannel = {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
        return FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
    }()
    
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
            print("open universal link")
        } else {
            print("open normal")
        }
//        AppCenter.start(withAppSecret: "b2703aca-3545-4612-a26f-a23f6a149407", services:[
//          Analytics.self,
//          Crashes.self
//        ])
        GeneratedPluginRegistrant.register(with: self)
//        methodChannel.setMethodCallHandler { (call, result) in
//            if "checkCurrentUserNameKey" == call.method {
//                var params = [String: Any]()
//                params["userId"] = KeychainUtils.shared.getUserID()
//                params["name"] = KeychainUtils.shared.getUsername()
//                params["password"] = KeychainUtils.shared.getPassword()
//                params["module"] = KeychainUtils.shared.getModule()
//                result(params)
//                KeychainUtils.shared.saveModule(module: "")
//            } else if "logout_event_key" == call.method {
//                KeychainUtils.shared.saveIsLogout()
//            } else if "saveUserQLCV" == call.method {
//                let params = call.arguments as! [String: Any]
//                if let userId = params["userId"] as? Int, let name = params["name"] as? String, let password = params["password"] as? String {
//                    KeychainUtils.shared.saveUser(userId: String(userId), name: name, password: password)
//                }
//            } else {
//                result(false)
//            }
//        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        let queryItems = components.queryItems
        var params: [String: Any] = [:]
        var type: String?
        var iDContent: String?
        var iDNotify: String?
        
        if queryItems != nil && components.queryItems!.count > 0 {
            for item in components.queryItems! {
                if item.name == "Type", let val = item.value {
                    type = val
                }
                if item.name == "IDContent", let val = item.value {
                    iDContent = val
                }
                if item.name == "IDNotify", let val = item.value {
                    iDNotify = val
                }
            }
        }
        params["type"] = type
        params["iDContent"] = iDContent
        params["iDNotify"] = iDNotify
        
        methodChannel.setMethodCallHandler { (call, result) in
            if "applink" == call.method {
                result(params)
                params["iDNotify"] = nil
            }
        }
        return false
    }
}
