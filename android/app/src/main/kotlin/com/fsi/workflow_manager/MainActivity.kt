package vn.cetech.evngenco2

import android.net.Uri
import android.os.Bundle
import android.util.Log
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.annotation.NonNull;

import android.content.Intent


class MainActivity : FlutterFragmentActivity() {

    private var CHANNEL = "flutter.native/helper"

    private var URL_DOCEYE = "workflowManager"

    private var DOCEYE_PARAM_KEY = "helloFromNativeCode" //open app QLCV from app Doceye

    private var QLCV_PARAM_KEY = "helloFromQLCV" // oepn app Doceye from app QLCV

    private var SAVE_USER_KEY = "saveUserQLCV"

    private var LOGOUT_KEY = "logout_event_key"

    private var GET_DIRECTORY = "getDirectory"

    private var GET_DATA_FROM_DOCEYE = "checkCurrentUserNameKey"

    private var APP_LINK_KEY = "applink"
    private var OPEN_OTHER_APP = "open_other_app"
    private val CHECK_APP_AVAILABLE = "check_app_available";

    private var PACKAGE_NAME = "package_name"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(application, "17657df6-4893-4572-a0c0-0732130af8a0",
                Analytics::class.java, Crashes::class.java)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
//        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // get data url from app Doceye
        val url = intent.getStringExtra(URL_DOCEYE)
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == DOCEYE_PARAM_KEY) {
                result.success(url)
            } else if (call.method == QLCV_PARAM_KEY) { //Mở app Doceye
                openDoceyeApp()
            }
//            else if (call.method == GET_DATA_FROM_DOCEYE) {
//                val user: AutoLoginUser? = ContentProviderUtil.getInstance().getDataFromDoceyeProvider(this)
//                if (user != null) {
//                    var params = HashMap<String, Any>()
//                    params["userId"] = user.userId
//                    params["name"] = user.userName
//                    params["password"] = user.password
//                    params["module"] = user.module
//                    result.success(params)
//                    ContentProviderUtil.getInstance().insertDoceyeProvider(applicationContext, user.userId, user.userName, user.password, "");
//                } else {
//                    result.error("Empty", "No message", null)
//                }
//            } else if (call.method == LOGOUT_KEY) {
//                ContentProviderUtil.getInstance().logoutQLCVProvider(this)
//                ContentProviderUtil.getInstance().logoutDoceyeProvider(this)
//            } else if (call.method == SAVE_USER_KEY) {
//                if (call.arguments != null) {
//                    val params = call.arguments as java.util.HashMap<String, Any>
//                    if (params["userId"] is Int && params["name"] is String && params["password"] is String) {
//                        ContentProviderUtil.getInstance().insertQLCVProvider(applicationContext, params["userId"].toString(), params["name"] as String, params["password"] as String)
//                        ContentProviderUtil.getInstance().insertDoceyeProvider(applicationContext, params["userId"].toString(), params["name"] as String, params["password"] as String, "")
//                    }
//                }
//            }
            else if (call.method == OPEN_OTHER_APP) {
                openApp(call.argument<String>(PACKAGE_NAME)!!)
            } else if (call.method == CHECK_APP_AVAILABLE) {
                result.success(checkAppAvailable(call.argument<String>(PACKAGE_NAME)!!))
            } else if (call.method == GET_DIRECTORY) {
                result.success(android.os.Environment.getExternalStorageDirectory().getAbsolutePath())
            } else if (call.method == APP_LINK_KEY) {
                if (intent == null || intent.dataString == null) {
                    result.error("Empty", "No message", null)
                }
                val url = intent.dataString
                val uri = Uri.parse(url)
                val type: String? = uri.getQueryParameter("Type")
                val iDContent: String? = uri.getQueryParameter("IDContent")
                val iDNotify: String? = uri.getQueryParameter("IDNotify")
                var params = HashMap<String, Any?>()
                params["type"] = type
                params["iDContent"] = iDContent
                params["iDNotify"] = iDNotify
                result.success(params)
                params["iDNotify"] = null
            } else {
                result.error("Empty", "No message", null)
            }
        }
    }

    private fun openDoceyeApp() {
        var intent = packageManager.getLaunchIntentForPackage("vn.com.fsivietnam.docpro.docpro")
        startActivity(intent)
    }

    private fun openApp(packageName: String) {
        var intent = packageManager.getLaunchIntentForPackage(packageName)
        if (intent != null) {
            startActivity(intent)
        } else {
            try {
                val intent = Intent(Intent.ACTION_VIEW)
                intent.setData(Uri.parse("market://details?id=${packageName}"))
                startActivity(intent)
            } catch (ex: Exception) {
                val webIntent: Intent = Intent(Intent.ACTION_VIEW,
                        Uri.parse("https://play.google.com/store/apps/details?id=" + packageName))
                startActivity(webIntent)
            }

        }
    }

    private fun checkAppAvailable(packageName: String): Boolean {
        var intent = packageManager.getLaunchIntentForPackage(packageName)
        return intent != null
    }
}
