package vn.cetech.tpccantho

import android.net.Uri

object AppStore {
    val PROVIDER_NAME = "vn.com.fsivietnam.docpro.docpro"
    val CONTENT_PATH = "users"
    val URL = "content://$PROVIDER_NAME/$CONTENT_PATH"
    val CONTENT_URI: Uri = Uri.parse(URL)
    val USER_ID = "user_id"
    val NAME = "name"
    val PASSWORD = "password"
    val MODULE = "module"
}