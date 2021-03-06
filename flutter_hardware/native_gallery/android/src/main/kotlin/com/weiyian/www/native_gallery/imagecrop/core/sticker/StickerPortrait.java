package com.weiyian.www.native_gallery.imagecrop.core.sticker;

import android.graphics.Canvas;
import android.graphics.RectF;
import android.view.View;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description :
 */
public interface StickerPortrait {
    
    boolean show();
    
    boolean remove();
    
    boolean dismiss();
    
    boolean isShowing();
    
    RectF getFrame();

//    RectF getAdjustFrame();
//
//    RectF getDeleteFrame();
    
    void onSticker(Canvas canvas);
    
    void registerCallback(Sticker.Callback callback);
    
    void unregisterCallback(Sticker.Callback callback);
    
    interface Callback {
        
        <V extends View & Sticker> void onDismiss(V stickerView);
        
        <V extends View & Sticker> void onShowing(V stickerView);
        
        <V extends View & Sticker> boolean onRemove(V stickerView);
    }
}
