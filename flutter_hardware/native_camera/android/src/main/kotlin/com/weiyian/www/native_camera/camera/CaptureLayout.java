package com.weiyian.www.native_camera.camera;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.res.Configuration;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.weiyian.www.native_camera.R;
import com.weiyian.www.native_camera.camera.listener.CaptureListener;
import com.weiyian.www.native_camera.camera.listener.ClickListener;
import com.weiyian.www.native_camera.camera.listener.ReturnListener;
import com.weiyian.www.native_camera.camera.listener.TypeListener;


/**
 * @date: 2018/12/5 14:17
 * @author: Chunjiang Mao
 * @classname: CaptureLayout
 * @describe: 集成各个控件的布局
 */

public class CaptureLayout extends FrameLayout {
    
    /**
     * 拍照按钮监听
     */
    private CaptureListener captureListener;
    /**
     * 拍照或录制后接结果按钮监听
     */
    private TypeListener typeListener;
    /**
     * 退出按钮监听
     */
    private ReturnListener returnListener;
    /**
     * 左边按钮监听
     */
    private ClickListener leftClickListener;
    /**
     * 右边按钮监听
     */
    private ClickListener rightClickListener;
    /**
     * 拍照按钮
     */
    private CaptureButton btnCapture;
    /**
     * 确认按钮
     */
    private Button btnConfirm;
    /**
     * 取消按钮
     */
    private Button btnCancel;
    /**
     * 返回按钮
     */
    private ReturnButton btnReturn;
    /**
     * 左边自定义按钮
     */
    private ImageView ivCustomLeft;
    /**
     * 右边自定义按钮
     */
    private ImageView ivCustomRight;
    /**
     * 提示文本
     */
    private TextView txtTip;
    private int layoutWidth;
    private int layoutHeight;
    private int buttonSize;
    private int iconLeft = 0;
    private int iconRight = 0;
    private boolean isFirst = true;
    public CaptureLayout(Context context) {
        this(context, null);
    }
    public CaptureLayout(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }
    
    public CaptureLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        
        WindowManager manager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) {
            layoutWidth = outMetrics.widthPixels;
        } else {
            layoutWidth = outMetrics.widthPixels / 2;
        }
        buttonSize = (int) (layoutWidth / 5.0f);
        layoutHeight = buttonSize + (buttonSize / 5) * 2 + 100;
        
        initView();
        initEvent();
    }
    
    public void setTypeListener(TypeListener typeListener) {
        this.typeListener = typeListener;
    }
    
    public void setCaptureListener(CaptureListener captureListener) {
        this.captureListener = captureListener;
    }
    
    public void setReturnListener(ReturnListener returnListener) {
        this.returnListener = returnListener;
    }
    
    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        setMeasuredDimension(layoutWidth, layoutHeight);
    }
    
    public void initEvent() {
        //默认Typebutton为隐藏
        ivCustomRight.setVisibility(GONE);
        btnCancel.setVisibility(GONE);
        btnConfirm.setVisibility(GONE);
    }
    
    public void startTypeBtnAnimator() {
        //拍照录制结果后的动画
        if (iconLeft != 0) {
            ivCustomLeft.setVisibility(GONE);
        } else {
            btnReturn.setVisibility(GONE);
        }
        if (iconRight != 0) {
            ivCustomRight.setVisibility(GONE);
        }
        btnCapture.setVisibility(GONE);
        btnCancel.setVisibility(VISIBLE);
        btnConfirm.setVisibility(VISIBLE);
        btnCancel.setClickable(false);
        btnConfirm.setClickable(false);
        ObjectAnimator animatorCancel = ObjectAnimator.ofFloat(btnCancel, "translationX", layoutWidth / 4, 0);
        ObjectAnimator animatorConfirm = ObjectAnimator.ofFloat(btnConfirm, "translationX", -layoutWidth / 4, 0);
        
        AnimatorSet set = new AnimatorSet();
        set.playTogether(animatorCancel, animatorConfirm);
        set.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                btnCancel.setClickable(true);
                btnConfirm.setClickable(true);
            }
        });
        set.setDuration(200);
        set.start();
    }
    
    private void initView() {
        setWillNotDraw(false);
        //拍照按钮
        btnCapture = new CaptureButton(getContext(), buttonSize);
        LayoutParams btncaptureParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        btncaptureParam.gravity = Gravity.CENTER;
        btnCapture.setLayoutParams(btncaptureParam);
        btnCapture.setCaptureListener(new CaptureListener() {
            @Override
            public void takePictures() {
                if (captureListener != null) {
                    captureListener.takePictures();
                }
            }
    
            @Override
            public void recordShort(long time) {
                if (captureListener != null) {
                    captureListener.recordShort(time);
                }
                startAlphaAnimation();
            }
    
            @Override
            public void recordStart() {
                if (captureListener != null) {
                    captureListener.recordStart();
                }
                startAlphaAnimation();
            }
    
            @Override
            public void recordEnd(long time) {
                if (captureListener != null) {
                    captureListener.recordEnd(time);
                }
                startAlphaAnimation();
                startTypeBtnAnimator();
            }
    
            @Override
            public void recordZoom(float zoom) {
                if (captureListener != null) {
                    captureListener.recordZoom(zoom);
                }
            }
    
            @Override
            public void recordError() {
                if (captureListener != null) {
                    captureListener.recordError();
                }
            }
        });
        
        //取消按钮
        btnCancel = new Button(getContext());
        btnCancel.setBackgroundDrawable(getContext().getResources().getDrawable(R.drawable.icon_camera_back));
//                TypeButton(getContext(), TypeButton.TYPE_CANCEL, buttonSize);
        final LayoutParams btnCancelParam = new LayoutParams(buttonSize, buttonSize);
        btnCancelParam.gravity = Gravity.CENTER_VERTICAL;
        btnCancelParam.setMargins((layoutWidth / 4) - buttonSize / 2, 0, 0, 0);
        btnCancel.setLayoutParams(btnCancelParam);
        btnCancel.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (typeListener != null) {
                    typeListener.cancel();
                }
                startAlphaAnimation();
//                resetCaptureLayout();
            }
        });
        
        //确认按钮
        btnConfirm = new Button(getContext());
        btnConfirm.setBackgroundResource(R.drawable.icon_camera_save);
//                = new TypeButton(getContext(), TypeButton.TYPE_CONFIRM, buttonSize);
        LayoutParams btnConfirmParam = new LayoutParams(buttonSize, buttonSize);
        btnConfirmParam.gravity = Gravity.CENTER_VERTICAL | Gravity.RIGHT;
        btnConfirmParam.setMargins(0, 0, (layoutWidth / 4) - buttonSize / 2, 0);
        btnConfirm.setLayoutParams(btnConfirmParam);
        btnConfirm.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (typeListener != null) {
                    typeListener.confirm();
                }
                startAlphaAnimation();
//                resetCaptureLayout();
            }
        });
        
        //返回按钮
        btnReturn = new ReturnButton(getContext(), (int) (buttonSize / 2.5f));
        LayoutParams btnReturnParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
        btnReturnParam.gravity = Gravity.CENTER_VERTICAL;
        btnReturnParam.setMargins(layoutWidth / 6, 0, 0, 0);
        btnReturn.setLayoutParams(btnReturnParam);
        btnReturn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (leftClickListener != null) {
                    leftClickListener.onClick();
                }
            }
        });
        //左边自定义按钮
        ivCustomLeft = new ImageView(getContext());
        LayoutParams ivCustomParamLeft = new LayoutParams((int) (buttonSize / 2.5f), (int) (buttonSize / 2.5f));
        ivCustomParamLeft.gravity = Gravity.CENTER_VERTICAL;
        ivCustomParamLeft.setMargins(layoutWidth / 6, 0, 0, 0);
        ivCustomLeft.setLayoutParams(ivCustomParamLeft);
        ivCustomLeft.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (leftClickListener != null) {
                    leftClickListener.onClick();
                }
            }
        });
        
        //右边自定义按钮
        ivCustomRight = new ImageView(getContext());
        LayoutParams ivCustomParamRight = new LayoutParams((int) (buttonSize / 2.5f), (int) (buttonSize / 2.5f));
        ivCustomParamRight.gravity = Gravity.CENTER_VERTICAL | Gravity.RIGHT;
        ivCustomParamRight.setMargins(0, 0, layoutWidth / 6, 0);
        ivCustomRight.setLayoutParams(ivCustomParamRight);
        ivCustomRight.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (rightClickListener != null) {
                    rightClickListener.onClick();
                }
            }
        });
        
        txtTip = new TextView(getContext());
        LayoutParams txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
        txtParam.gravity = Gravity.CENTER_HORIZONTAL;
        txtParam.setMargins(0, 0, 0, 0);
        txtTip.setText("轻触拍照，长按摄像");
        txtTip.setTextColor(0xFFFFFFFF);
        txtTip.setGravity(Gravity.CENTER);
        txtTip.setLayoutParams(txtParam);
        
        addView(btnCapture);
        addView(btnCancel);
        addView(btnConfirm);
        addView(btnReturn);
        addView(ivCustomLeft);
        addView(ivCustomRight);
        addView(txtTip);
        
    }
    
    /**
     * dp转px
     *
     * @param dp
     * @return
     */
    public int dip2px(Context context, int dp) {
        float density = context.getResources().getDisplayMetrics().density;
        return (int) (dp * density + 0.5);
    }
    
    /**************************************************
     * 对外提供的API                      *
     **************************************************/
    public void resetCaptureLayout() {
        btnCapture.resetState();
        btnCancel.setVisibility(GONE);
        btnConfirm.setVisibility(GONE);
        btnCapture.setVisibility(VISIBLE);
        if (iconLeft != 0) {
            ivCustomLeft.setVisibility(VISIBLE);
        } else {
            btnReturn.setVisibility(VISIBLE);
        }
        if (iconRight != 0) {
            ivCustomRight.setVisibility(VISIBLE);
        }
    }
    
    public void startAlphaAnimation() {
        if (isFirst) {
            ObjectAnimator animatorTxtTip = ObjectAnimator.ofFloat(txtTip, "alpha", 1f, 0f);
            animatorTxtTip.setDuration(500);
            animatorTxtTip.start();
            isFirst = false;
        }
    }
    
    public void setTextWithAnimation(String tip) {
        txtTip.setText(tip);
        ObjectAnimator animatorTxtTip = ObjectAnimator.ofFloat(txtTip, "alpha", 0f, 1f, 1f, 0f);
        animatorTxtTip.setDuration(2500);
        animatorTxtTip.start();
    }
    
    public void setDuration(int duration) {
        btnCapture.setDuration(duration);
    }
    
    public void setButtonFeatures(int state) {
        btnCapture.setButtonFeatures(state);
    }
    
    public void setTip(String tip) {
        txtTip.setText(tip);
    }
    
    public void showTip() {
        txtTip.setVisibility(VISIBLE);
    }
    
    public void setIconSrc(int iconLeft, int iconRight) {
        this.iconLeft = iconLeft;
        this.iconRight = iconRight;
        if (this.iconLeft != 0) {
            ivCustomLeft.setImageResource(iconLeft);
            ivCustomLeft.setVisibility(VISIBLE);
            btnReturn.setVisibility(GONE);
        } else {
            ivCustomLeft.setVisibility(GONE);
            btnReturn.setVisibility(VISIBLE);
        }
        if (this.iconRight != 0) {
            ivCustomRight.setImageResource(iconRight);
            ivCustomRight.setVisibility(VISIBLE);
        } else {
            ivCustomRight.setVisibility(GONE);
        }
    }
    
    public void setLeftClickListener(ClickListener leftClickListener) {
        this.leftClickListener = leftClickListener;
    }
    
    public void setRightClickListener(ClickListener rightClickListener) {
        this.rightClickListener = rightClickListener;
    }
}
