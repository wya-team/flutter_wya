package com.example.cache;

import android.Manifest;
import android.app.Activity;
import android.util.Log;
import android.src.main.java.com.example.cache.PhoneUtil;

import androidx.annotation.NonNull;

import com.tbruyelle.rxpermissions.RxPermissions;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * CachePlugin
 */
public class CachePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Activity activity;


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "cache");

        channel.setMethodCallHandler(this);
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
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "cache");
        channel.setMethodCallHandler(new CachePlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getSystemCache")) {
            try {
                result.success(DataCleanUtil.getTotalCacheSize(activity));
            } catch (Exception e) {
                e.printStackTrace();
                result.success(e.toString());
            }
        } else if (call.method.equals("clearCache")) {
            DataCleanUtil.cleanTotalCache(activity);
            result.success(true);
        } else if (call.method.equals("availableSpace")) {
            RxPermissions rxPermissions = new RxPermissions(activity);
            rxPermissions
                    .request(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    .subscribe(granted -> {
                        if (granted) {
                            result.success(PhoneUtil.getInstance().getSDFreeSize()+"MB");
                        } else {
                            result.success("无访问权限");
                        }
                    });
        }  else if (call.method.equals("deviceCacheSpace")) {
            RxPermissions rxPermissions = new RxPermissions(activity);
            rxPermissions
                    .request(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    .subscribe(granted -> {
                        if (granted) {
                            result.success(PhoneUtil.getInstance().getSDAllSize()+"MB");
                        } else {
                            result.success("无访问权限");
                        }
                    });
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(new CachePlugin());
        Log.d("onDetachedFromEngine", "onDetachedFromEngine");
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        Log.d("onAttachedToActivity", "onAttachedToActivity" + (activity != null));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d("onDetachedFromEngine", "onDetachedFromEngine");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d("onDetachedFromActivity", "onDetachedFromActivity");
    }

}
