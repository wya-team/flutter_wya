package com.weiyian.www.native_gallery.imagecrop.core.anim;

import android.animation.ValueAnimator;
import android.view.animation.AccelerateDecelerateInterpolator;

import com.weiyian.www.native_gallery.imagecrop.core.homing.CropHoming;
import com.weiyian.www.native_gallery.imagecrop.core.homing.CropHomingEvaluator;


/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description :
 */
public class CropHomingAnimator extends ValueAnimator {
    
    private boolean isRotate = false;
    
    private CropHomingEvaluator mEvaluator;
    
    public CropHomingAnimator() {
        setInterpolator(new AccelerateDecelerateInterpolator());
    }
    
    @Override
    public void setObjectValues(Object... values) {
        super.setObjectValues(values);
        if (mEvaluator == null) {
            mEvaluator = new CropHomingEvaluator();
        }
        setEvaluator(mEvaluator);
    }
    
    public void setHomingValues(CropHoming sHoming, CropHoming eHoming) {
        setObjectValues(sHoming, eHoming);
        isRotate = CropHoming.isRotate(sHoming, eHoming);
    }
    
    public boolean isRotate() {
        return isRotate;
    }
}
