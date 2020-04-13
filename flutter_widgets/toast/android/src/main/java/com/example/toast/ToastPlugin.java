package com.example.toast;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ToastPlugin
 */
public class ToastPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    private Context mContext;
    private Toast mToast;
    private LoadingDialog mLoading;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "toast");
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
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "toast");
        channel.setMethodCallHandler(new ToastPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "showToast":
                String mMessage = call.argument("msg").toString();
                int time = call.argument("time");
                String gravity = call.argument("gravity").toString();
                Number bgcolor = call.argument("bgcolor");
                Number textcolor = call.argument("textcolor");
                Number textSize = call.argument("fontSize");

                int mGravity;
                switch (gravity) {
                    case "top":
                        mGravity = Gravity.TOP;
                        break;
                    case "center":
                        mGravity = Gravity.CENTER;
                        break;
                    default:
                        mGravity = Gravity.BOTTOM;
                        break;
                }
                int mDuration;
                if (time > 2) {
                    mDuration = Toast.LENGTH_LONG;
                } else {
                    mDuration = Toast.LENGTH_SHORT;
                }

                if (bgcolor != null && textcolor != null && textSize != null) {
                    LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                    View layout = inflater.inflate(R.layout.toast_custom, null);
                    TextView text = layout.findViewById(R.id.text);
                    text.setText(mMessage);

                    // Custom style
                    GradientDrawable gradientDrawable = new GradientDrawable();
                    gradientDrawable.setColor(bgcolor.intValue());
                    gradientDrawable.setCornerRadius(dp2px(5.0f));
                    text.setBackground(gradientDrawable);
                    text.setTextSize(textSize.floatValue());
                    text.setTextColor(textcolor.intValue());

                    mToast = new Toast(mContext);
                    mToast.setDuration(mDuration);
                    mToast.setView(layout);
                } else {
                    mToast = Toast.makeText(mContext, mMessage, mDuration);
                }

                if (mGravity == Gravity.CENTER) {
                    mToast.setGravity(mGravity, 0, 0);
                } else if (mGravity == Gravity.TOP) {
                    mToast.setGravity(mGravity, 0, 100);
                } else {
                    mToast.setGravity(mGravity, 0, 100);
                }
                mToast.show();

                result.success(true);
                break;
            case "cancelToast":
                if (mToast != null) {
                    mToast.cancel();
                }
                result.success(true);
                break;
            case "cancelLoading":
                if (mLoading != null) {
                    mLoading.dismiss();
                }
                result.success(true);
                break;
            case "showLoading":
                boolean canceledOnTouchOutside = call.argument("canceledOnTouchOutside");
                boolean cancelable = call.argument("cancelable");
                int status = call.argument("status");
                String msg = call.argument("msg").toString();
                mLoading = new LoadingDialog(mContext, canceledOnTouchOutside, cancelable, status);
                if (msg != null && !msg.equals("")) {
                    mLoading.setText(msg);
                }
                mLoading.show();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private float dp2px(float dp) {
        final float scale = mContext.getResources().getDisplayMetrics().density;
        return dp * scale + 0.5f;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(new ToastPlugin());
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mContext = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
