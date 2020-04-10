package com.example.toast;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * @date: 2018/11/23 16:13
 * @author: Chunjiang Mao
 * @classname: LoadingDialog
 * @describe: 加载动画
 */

public class LoadingDialog extends Dialog {
    private AnimationDrawable animationDrawable;
    private View view;
    private ColorDrawable colorDrawable;
    private ImageView imgLoad;
    private TextView hintText;

    /**
     * @param activity
     * @param canceledOnTouch
     * @param cancelable
     * @param status -1 失败， 1 成功 ， 0 加载中
     */
    @SuppressLint("ResourceType")
    public LoadingDialog(Context activity, boolean canceledOnTouch, boolean cancelable, int status) {
        super(activity);
        getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        view = View.inflate(activity, R.layout.dialog_loading, null);
        setContentView(view);
        colorDrawable = new ColorDrawable(0x00000000);
        getWindow().setBackgroundDrawable(colorDrawable);
        imgLoad = view.findViewById(R.id.img_load);
        hintText = view.findViewById(R.id.hintTv);
        if(status == 0){
            imgLoad.setBackground(activity.getResources().getDrawable(R.drawable.loading_dialog_anim));
            animationDrawable = (AnimationDrawable) imgLoad.getBackground();
            animationDrawable.start();
        } else if(status == 1){
            imgLoad.setBackground(activity.getResources().getDrawable(R.drawable.icon_succesful));
            hintText.setText("成功");
            hintText.setVisibility(View.VISIBLE);
        } else if(status == -1){
            imgLoad.setBackground(activity.getResources().getDrawable(R.drawable.icon_fail));
            hintText.setText("失败");
            hintText.setVisibility(View.VISIBLE);
        }

        getWindow().setDimAmount(0);
        //取消dialog空白处点击消失事件
        this.setCanceledOnTouchOutside(canceledOnTouch);
        setCancelable(cancelable);
    }
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    
    public void setText(String text) {
        if (text != null && !"".equals(text)) {
            hintText.setText(text);
            hintText.setVisibility(View.VISIBLE);
        } else {
            hintText.setVisibility(View.GONE);
        }
    }
}
