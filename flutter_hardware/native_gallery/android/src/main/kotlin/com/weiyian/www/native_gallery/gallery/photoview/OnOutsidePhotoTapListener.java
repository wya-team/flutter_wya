package com.weiyian.www.native_gallery.gallery.photoview;

import android.widget.ImageView;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description :
 */
public interface OnOutsidePhotoTapListener {
    
    /**
     * The outside of the photo has been tapped
     *
     * @param imageView
     */
    void onOutsidePhotoTap(ImageView imageView);
}
