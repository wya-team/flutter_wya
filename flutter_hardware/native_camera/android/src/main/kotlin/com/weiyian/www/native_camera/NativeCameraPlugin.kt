package com.weiyian.www.native_camera

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.text.TextUtils
import android.util.Base64
import android.util.Base64.NO_CLOSE
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.tbruyelle.rxpermissions.RxPermissions
import com.weiyian.www.native_camera.camera.CameraExampleActivity
import com.weiyian.www.native_camera.camera.WYACameraView.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.FileInputStream
import java.io.IOException
import java.io.InputStream
import java.util.*


/** NativeCameraPlugin */
class NativeCameraPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {


    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var mResult: Result? = null


    val TAKE_PHOTO = 101
    val VIDEO = 102
    val NO_PERMISSIONS_CAMEAR = 103


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "native_camera")
        channel.setMethodCallHandler(this)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native_camera")
            channel.setMethodCallHandler(NativeCameraPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        mResult = result
        val hashMap = call.arguments as HashMap<String, Any>
        val cameraType = hashMap["cameraType"] as Int
        val time = hashMap["time"] as Int

        val rxPermissions = activity?.let { RxPermissions(it) }
        if (cameraType == 0 || cameraType == 2) {
            rxPermissions?.request(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)?.subscribe { granted ->
                if (granted) {
                    if (call.method == "openCamera") {
                        val intent = Intent(activity, CameraExampleActivity::class.java)
                        if (cameraType == 0) {
                            intent.putExtra("state", BUTTON_STATE_BOTH)
                        } else {
                            intent.putExtra("state", BUTTON_STATE_ONLY_RECORDER)
                        }
                        intent.putExtra("duration", time * 1000)
                        activity?.startActivityForResult(intent, 100)
                    }
                } else {
                    result.notImplemented()
                    Log.i("NativeRecord:", "访问权限未同意")
                }
            }
        } else {
            rxPermissions?.request(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA)?.subscribe { granted ->
                if (granted) {
                    if (call.method == "openCamera") {
                        val intent = Intent(activity, CameraExampleActivity::class.java)
                        intent.putExtra("state", cameraType)
                        intent.putExtra("duration", time * 1000)
                        intent.putExtra("state", BUTTON_STATE_ONLY_CAPTURE)
                        activity?.startActivityForResult(intent, 100)
                    }
                } else {
                    result.notImplemented()
                    Log.i("NativeRecord:", "访问权限未同意")
                }
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(NativeCameraPlugin())
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity

        binding.addActivityResultListener { requestCode, resultCode, data ->
            if (resultCode == TAKE_PHOTO) {
                val path = data.getStringExtra("path")
                val hashMap = HashMap<String, String?>()
                hashMap["imageBase64"] = imageToBase64(path)
                hashMap["imagePath"] = path
                mResult?.success(hashMap)
            }
            if (resultCode == VIDEO) {
                Log.i("MCJ", "video")
                val path = data.getStringExtra("path")
                val url = data.getStringExtra("url")
                val hashMap = HashMap<String, String?>()
                hashMap["imageBase64"] = imageToBase64(path)
                hashMap["imagePath"] = path
                hashMap["videoPath"] = url
                mResult?.success(hashMap)
            }
            if (resultCode == NO_PERMISSIONS_CAMEAR) {
                Toast.makeText(activity, "请检查相机权限~", Toast.LENGTH_SHORT).show()
            }
            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    /**
     * 将图片转换成Base64编码的字符串
     */
    private fun imageToBase64(path: String): String? {
        if (TextUtils.isEmpty(path)) {
            return null
        }
        var `is`: InputStream? = null
        var data: ByteArray? = null
        var result: String? = null
        try {
            `is` = FileInputStream(path)
            //创建一个字符流大小的数组。
            data = ByteArray(`is`.available())
            //写入数组
            `is`.read(data)
            //用默认的编码格式进行编码
            result = Base64.encodeToString(data, NO_CLOSE)
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            if (null != `is`) {
                try {
                    `is`.close()
                } catch (e: IOException) {
                    e.printStackTrace()
                }

            }

        }
        return result?.replace("\n", "")
    }
}
