package com.weiyian.www.native_gallery

import android.app.Activity
import android.text.TextUtils
import android.util.Base64
import androidx.annotation.NonNull
import com.weiyian.www.native_gallery.imagepicker.ImagePickerCreator
import com.weiyian.www.native_gallery.imagepicker.PickerConfig
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
import kotlin.collections.ArrayList
import kotlin.collections.set

/** NativeGalleryPlugin */
class NativeGalleryPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var mResult: Result? = null

    private var mMaxImages: Int = 0
    private var mediaType: Int = PickerConfig.MEDIA_DEFAULT
    private var canTakePicture: Boolean = false
    private var allowSelectOriginal: Boolean = false
    private var allowEditImage: Boolean = false
    private var allowSelectImage: Boolean = false
    private var allowSelectVideo: Boolean = false
    private var allowChoosePhotoAndVideo: Boolean = false

    val PHOTO = 100
    private val mAllList = ArrayList<String>()


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "native_gallery")
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
            val channel = MethodChannel(registrar.messenger(), "native_gallery")
            channel.setMethodCallHandler(NativeGalleryPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        mResult = result
        val hashMap = call.arguments as HashMap<String, Any>
        mMaxImages = hashMap["maxSelectCount"] as Int
        canTakePicture = hashMap["canTakePicture"] as Boolean
        allowSelectOriginal = hashMap["allowSelectOriginal"] as Boolean
        allowEditImage = hashMap["allowEditImage"] as Boolean
        allowSelectImage = hashMap["allowSelectImage"] as Boolean
        allowSelectVideo = hashMap["allowSelectVideo"] as Boolean
        allowChoosePhotoAndVideo = hashMap["allowChoosePhotoAndVideo"] as Boolean
        if (allowSelectImage && allowSelectVideo) {
            mediaType = PickerConfig.MEDIA_DEFAULT
        } else if (allowSelectImage) {
            mediaType = PickerConfig.MEDIA_IMAGE
        } else if (allowSelectVideo) {
            mediaType = PickerConfig.MEDIA_VIDEO
        }

        if (call.method == "native_gallery") {
            ImagePickerCreator.create(activity)
                    .maxImages(mMaxImages - mAllList.size)
                    .hasTakePhotoMenu(canTakePicture)
                    .allowSelectOriginal(allowSelectOriginal)
                    .allowEditImage(allowEditImage)
                    .allowChoosePhotoAndVideo(allowChoosePhotoAndVideo)
                    .setMediaType(mediaType)
                    .forResult(PHOTO)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(NativeGalleryPlugin())
    }

    override fun onDetachedFromActivity() {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity

        binding.addActivityResultListener { requestCode, resultCode, data ->

            when (requestCode) {
                PHOTO -> when (resultCode) {
                    Activity.RESULT_OK ->
                        when {
                            data != null && data.hasExtra(PickerConfig.IMAGE_SELECTED) -> {
                                val extras = data.extras
                                val list = extras?.getStringArrayList(PickerConfig.IMAGE_SELECTED)
                                val hashMap = HashMap<String, ArrayList<String>>()
                                val images = ArrayList<String>()
                                for (i in 0 until list!!.size) {
                                    imageToBase64(list[i])?.let { images.add(it) }
                                }
                                hashMap["images"] = images
                                mResult?.success(hashMap)
                            }
                        }
                }
            }
            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
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
            result = Base64.encodeToString(data, Base64.NO_CLOSE)
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
