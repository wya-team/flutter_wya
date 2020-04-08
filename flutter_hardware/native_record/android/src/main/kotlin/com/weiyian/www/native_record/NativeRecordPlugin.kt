package com.weiyian.www.native_record

import android.Manifest
import android.app.Activity
import android.media.MediaPlayer
import android.util.Log
import androidx.annotation.NonNull
import com.tbruyelle.rxpermissions.RxPermissions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.IOException


/** NativeRecordPlugin */
class NativeRecordPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var mMediaPlayer: MediaPlayer? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "native_record")
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
            val channel = MethodChannel(registrar.messenger(), "native_record")
            channel.setMethodCallHandler(NativeRecordPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val rxPermissions = activity?.let { RxPermissions(it) }
        rxPermissions?.request(Manifest.permission.WRITE_EXTERNAL_STORAGE)?.subscribe { granted ->
            if (granted) {
                when {
                    call.method == "recordPlay" -> run {
                        Log.i("NativeRecord:", "recordPlay")
                        val list = call.arguments as List<Any>
                        val path = list[0].toString()
                        try {
                            // 重置MediaPlayer对象，使之处于空闲状态
                            mMediaPlayer?.reset()
                            // 设置要播放的文件的路径
                            mMediaPlayer?.setDataSource(path)
                            // 准备播放
                            mMediaPlayer?.prepare()
                            // 开始播放
                            mMediaPlayer?.start()
                        } catch (e: IOException) {
                            result.notImplemented()
                        }
                    }
                    call.method == "recordPause" -> run {
                        Log.i("NativeRecord:", "recordPause")
                        if (mMediaPlayer?.isPlaying!!) run {
                            // 暂停
                            mMediaPlayer?.pause()
                        }
                    }
                    call.method == "recordResume" -> run {
                        Log.i("NativeRecord:", "recordResume")
                        if (!mMediaPlayer?.isPlaying!!) run {
                            // 开始播放
                            mMediaPlayer?.start()
                        }
                    }
                    call.method == "recordStop" -> run {
                        Log.i("NativeRecord:", "recordStop")
                        // 是否正在播放
                        if (mMediaPlayer?.isPlaying!!) {
                            //重置MediaPlayer到初始状态
                            mMediaPlayer?.reset()
                            mMediaPlayer?.release()
                        }
                    }
                    else -> {
                        result.notImplemented()
                        Log.i("NativeRecord:", "无SD卡访问权限")
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(NativeRecordPlugin())
    }

    override fun onDetachedFromActivity() {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        if (mMediaPlayer == null) {
            mMediaPlayer = MediaPlayer()
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }


}
