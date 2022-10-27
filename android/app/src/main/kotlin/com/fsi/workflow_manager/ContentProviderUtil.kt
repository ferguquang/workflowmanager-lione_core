package vn.cetech.tpccantho
//
//import android.content.ContentValues
//import android.content.Context
//import android.content.ContextWrapper
//import android.database.Cursor
//import android.util.Log
//import android.widget.Toast
//import java.io.IOException
//
//class ContentProviderUtil {
//
//    private object Holder { val INSTANCE = ContentProviderUtil() }
//
//    companion object {
//        fun getInstance(): ContentProviderUtil {
//            return Holder.INSTANCE
//        }
//    }
//
//    fun getDataFromDoceyeProvider(context: ContextWrapper): AutoLoginUser? {
//        try {
//            val c: Cursor? = context.contentResolver.query(AppStore.CONTENT_URI, null, null, null, null)
//            if (c != null && c.columnCount != 0) {
//                if (c.moveToFirst()) {
//                    var autoLoginUser = AutoLoginUser()
//                    autoLoginUser.userName = c.getString(c.getColumnIndex(AppStore.NAME))
//                    autoLoginUser.userId = c.getString(c.getColumnIndex(AppStore.USER_ID))
//                    autoLoginUser.password = c.getString(c.getColumnIndex(AppStore.PASSWORD))
//                    autoLoginUser.module = c.getString(c.getColumnIndex(AppStore.MODULE))
//                    return autoLoginUser
//                }
//            } else {
//                Log.e("ContentProviderUtil", ">>Không có dữ liệu trong db")
//            }
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//        return null
//    }
//
//    fun logoutQLCVProvider(context: Context) {
//        try {
//            context.contentResolver.delete(QLCVProvider.CONTENT_URI, null, null);
//            val values = ContentValues()
//            // fetching text from user
//            values.put(QLCVProvider.USER_ID, "")
//            values.put(QLCVProvider.NAME, "")
//            values.put(QLCVProvider.PASSWORD, "")
//            // inserting into database through content URI
//            var uri = context.contentResolver.insert(QLCVProvider.CONTENT_URI, values)
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//    }
//
//    fun insertQLCVProvider(context: Context, userId: String, name: String, password: String) {
//        try {
//            context.contentResolver.delete(QLCVProvider.CONTENT_URI, null, null)
//            // class to add values in the database
//            val values = ContentValues()
//            // fetching text from user
//            values.put(QLCVProvider.USER_ID, userId)
//            values.put(QLCVProvider.NAME, name)
//            values.put(QLCVProvider.PASSWORD, password)
////            values.put(QLCVProvider.MODULE, module)
//            // inserting into database through content URI
//            var uri = context.contentResolver.insert(QLCVProvider.CONTENT_URI, values)
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//    }
//
//    //Phải logout cả app Doceye
//    fun logoutDoceyeProvider(context: Context) {
//        try {
//            context.contentResolver.delete(AppStore.CONTENT_URI, null, null);
//            val values = ContentValues()
//            // fetching text from user
//            values.put(AppStore.USER_ID, "")
//            values.put(AppStore.NAME, "")
//            values.put(AppStore.PASSWORD, "")
//            values.put(AppStore.MODULE, "")
//            // inserting into database through content URI
//            var uri = context.contentResolver.insert(AppStore.CONTENT_URI, values)
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//    }
//
//    fun insertDoceyeProvider(context: Context, userId: String, name: String, password: String, module: String) {
//        try {
//            context.contentResolver.delete(AppStore.CONTENT_URI, null, null)
//            // class to add values in the database
//            val values = ContentValues()
//            // fetching text from user
//            values.put(AppStore.USER_ID, userId)
//            values.put(AppStore.NAME, name)
//            values.put(AppStore.PASSWORD, password)
//            values.put(AppStore.MODULE, module)
//            // inserting into database through content URI
//            var uri = context.contentResolver.insert(AppStore.CONTENT_URI, values)
////        Toast.makeText(context, uri.toString(), Toast.LENGTH_LONG).show()
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//    }
//
//}
//
//class AutoLoginUser {
//    var userName: String = ""
//    var password: String = ""
//    var userId: String = ""
//    var module: String = ""
//}