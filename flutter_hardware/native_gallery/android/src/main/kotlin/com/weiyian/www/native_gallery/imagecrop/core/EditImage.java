package com.weiyian.www.native_gallery.imagecrop.core;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.CornerPathEffect;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.RectF;
import android.util.Log;

import com.weiyian.www.native_gallery.imagecrop.core.clip.Clip;
import com.weiyian.www.native_gallery.imagecrop.core.clip.ClipWindow;
import com.weiyian.www.native_gallery.imagecrop.core.homing.CropHoming;
import com.weiyian.www.native_gallery.imagecrop.core.sticker.Sticker;
import com.weiyian.www.native_gallery.imagecrop.core.util.Utils;

import java.util.ArrayList;
import java.util.List;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description :
 */
public class EditImage {
    
    private static final String TAG = "EditImage";
    private static final int MIN_SIZE = 500;
    private static final int MAX_SIZE = 10000;
    private static final boolean DEBUG = false;
    private static final Bitmap DEFAULT_IMAGE;
    private static final int COLOR_SHADE = 0xCC000000;
    
    static {
        DEFAULT_IMAGE = Bitmap.createBitmap(100, 100, Bitmap.Config.ARGB_8888);
    }
    
    private Bitmap mImage, mMosaicImage;
    /**
     * 完整图片边框
     */
    private RectF mFrame = new RectF();
    /**
     * 裁剪图片边框（显示的图片区域）
     */
    private RectF mClipFrame = new RectF();
    private RectF mTempClipFrame = new RectF();
    /**
     * 裁剪模式前状态备份
     */
    private RectF mBackupClipFrame = new RectF();
    private float mBackupClipRotate = 0;
    private float mRotate = 0, mTargetRotate = 0;
    private boolean isRequestToBaseFitting = false;
    private boolean isAnimCanceled = false;
    /**
     * 裁剪模式时当前触摸锚点
     */
    private Clip.Anchor mAnchor;
    private boolean isSteady = true;
    private Path mShade = new Path();
    /**
     * 裁剪窗口
     */
    private ClipWindow mClipWin = new ClipWindow();
    private boolean isDrawClip = false;
    /**
     * 编辑模式
     */
    private EditMode mMode = EditMode.NONE;
    private boolean isFreezing = mMode == EditMode.CLIP;
    /**
     * 可视区域，无Scroll 偏移区域
     */
    private RectF mWindow = new RectF();
    /**
     * 是否初始位置
     */
    private boolean isInitialHoming = false;
    /**
     * 当前选中贴片
     */
    private Sticker mForeSticker;
    /**
     * 为被选中贴片
     */
    private List<Sticker> mBackStickers = new ArrayList<>();
    /**
     * 涂鸦路径
     */
    private List<EditPath> mDoodles = new ArrayList<>();
    /**
     * 马赛克路径
     */
    private List<EditPath> mMosaics = new ArrayList<>();
    private Paint mPaint, mMosaicPaint, mShadePaint;
    private Matrix m = new Matrix();
    
    {
        mShade.setFillType(Path.FillType.WINDING);
        
        // Doodle&Mosaic 's paint
        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeWidth(EditPath.BASE_DOODLE_WIDTH);
        mPaint.setColor(Color.RED);
        mPaint.setPathEffect(new CornerPathEffect(EditPath.BASE_DOODLE_WIDTH));
        mPaint.setStrokeCap(Paint.Cap.ROUND);
        mPaint.setStrokeJoin(Paint.Join.ROUND);
    }
    
    public EditImage() {
        mImage = DEFAULT_IMAGE;
        
        if (mMode == EditMode.CLIP) {
            initShadePaint();
        }
    }
    
    public void setBitmap(Bitmap bitmap) {
        if (bitmap == null || bitmap.isRecycled()) {
            return;
        }
        
        mImage = bitmap;
        
        // 清空马赛克图层
        if (mMosaicImage != null) {
            mMosaicImage.recycle();
        }
        mMosaicImage = null;
        
        makeMosaicBitmap();
        
        onImageChanged();
    }
    
    public EditMode getMode() {
        return mMode;
    }
    
    public void setMode(EditMode mode) {
        
        if (mMode == mode) {
            return;
        }
        
        moveToBackground(mForeSticker);
        
        if (mode == EditMode.CLIP) {
            setFreezing(true);
        }
        
        mMode = mode;
        
        if (mMode == EditMode.CLIP) {
    
            // 初始化Shade 画刷
            initShadePaint();
    
            // 备份裁剪前Clip 区域
            mBackupClipRotate = getRotate();
            mBackupClipFrame.set(mClipFrame);
    
            float scale = 1 / getScale();
            m.setTranslate(-mFrame.left, -mFrame.top);
            m.postScale(scale, scale);
            m.mapRect(mBackupClipFrame);
    
            // 重置裁剪区域
            mClipWin.reset(mClipFrame, getTargetRotate());
        } else {
    
            if (mMode == EditMode.MOSAIC) {
                makeMosaicBitmap();
            }
    
            mClipWin.setClipping(false);
        }
    }
    
    private void rotateStickers(float rotate) {
        m.setRotate(rotate, mClipFrame.centerX(), mClipFrame.centerY());
        for (Sticker sticker : mBackStickers) {
            m.mapRect(sticker.getFrame());
            sticker.setRotation(sticker.getRotation() + rotate);
            sticker.setX(sticker.getFrame().centerX() - sticker.getPivotX());
            sticker.setY(sticker.getFrame().centerY() - sticker.getPivotY());
        }
    }
    
    private void initShadePaint() {
        if (mShadePaint == null) {
            mShadePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
            mShadePaint.setColor(COLOR_SHADE);
            mShadePaint.setStyle(Paint.Style.FILL);
        }
    }
    
    public boolean isMosaicEmpty() {
        return mMosaics.isEmpty();
    }
    
    public boolean isDoodleEmpty() {
        return mDoodles.isEmpty();
    }
    
    public void undoDoodle() {
        if (!mDoodles.isEmpty()) {
            mDoodles.remove(mDoodles.size() - 1);
        }
    }
    
    public void undoMosaic() {
        if (!mMosaics.isEmpty()) {
            mMosaics.remove(mMosaics.size() - 1);
        }
    }
    
    public RectF getClipFrame() {
        return mClipFrame;
    }
    
    /**
     * 裁剪区域旋转回原始角度后形成新的裁剪区域，旋转中心发生变化，
     * 因此需要将视图窗口平移到新的旋转中心位置。
     */
    public CropHoming clip(float scrollX, float scrollY) {
        RectF frame = mClipWin.getOffsetFrame(scrollX, scrollY);
    
        m.setRotate(-getRotate(), mClipFrame.centerX(), mClipFrame.centerY());
        m.mapRect(mClipFrame, frame);
    
        return new CropHoming(
                scrollX + (mClipFrame.centerX() - frame.centerX()),
                scrollY + (mClipFrame.centerY() - frame.centerY()),
                getScale(), getRotate()
        );
    }
    
    public void toBackupClip() {
        m.setScale(getScale(), getScale());
        m.postTranslate(mFrame.left, mFrame.top);
        m.mapRect(mClipFrame, mBackupClipFrame);
        setTargetRotate(mBackupClipRotate);
        isRequestToBaseFitting = true;
    }
    
    public void resetClip() {
        //  就近旋转
        setTargetRotate(getRotate() - getRotate() % 360);
        mClipFrame.set(mFrame);
        mClipWin.reset(mClipFrame, getTargetRotate());
    }
    
    private void makeMosaicBitmap() {
        if (mMosaicImage != null || mImage == null) {
            return;
        }
        
        if (mMode == EditMode.MOSAIC) {
            
            int w = Math.round(mImage.getWidth() / 64f);
            int h = Math.round(mImage.getHeight() / 64f);
            
            w = Math.max(w, 8);
            h = Math.max(h, 8);
            
            // 马赛克画刷
            if (mMosaicPaint == null) {
                mMosaicPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
                mMosaicPaint.setFilterBitmap(false);
                mMosaicPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
            }
            
            mMosaicImage = Bitmap.createScaledBitmap(mImage, w, h, false);
        }
    }
    
    private void onImageChanged() {
        isInitialHoming = false;
        onWindowChanged(mWindow.width(), mWindow.height());
        
        if (mMode == EditMode.CLIP) {
            mClipWin.reset(mClipFrame, getTargetRotate());
        }
    }
    
    public RectF getFrame() {
        return mFrame;
    }
    
    public boolean onClipHoming() {
        return mClipWin.homing();
    }
    
    public CropHoming getStartHoming(float scrollX, float scrollY) {
        return new CropHoming(scrollX, scrollY, getScale(), getRotate());
    }
    
    public CropHoming getEndHoming(float scrollX, float scrollY) {
        CropHoming homing = new CropHoming(scrollX, scrollY, getScale(), getTargetRotate());
        
        if (mMode == EditMode.CLIP) {
            RectF frame = new RectF(mClipWin.getTargetFrame());
            frame.offset(scrollX, scrollY);
            if (mClipWin.isResetting()) {
    
                RectF clipFrame = new RectF();
                m.setRotate(getTargetRotate(), mClipFrame.centerX(), mClipFrame.centerY());
                m.mapRect(clipFrame, mClipFrame);
    
                homing.rConcat(Utils.fill(frame, clipFrame));
            } else {
                RectF cFrame = new RectF();
    
                // cFrame要是一个暂时clipFrame
                if (mClipWin.isHoming()) {
                    // 偏移中心
                    m.setRotate(getTargetRotate() - getRotate(), mClipFrame.centerX(), mClipFrame.centerY());
                    m.mapRect(cFrame, mClipWin.getOffsetFrame(scrollX, scrollY));
    
                    homing.rConcat(Utils.fitHoming(frame, cFrame, mClipFrame.centerX(), mClipFrame.centerY()));
    
                } else {
                    m.setRotate(getTargetRotate(), mClipFrame.centerX(), mClipFrame.centerY());
                    m.mapRect(cFrame, mFrame);
                    homing.rConcat(Utils.fillHoming(frame, cFrame, mClipFrame.centerX(), mClipFrame.centerY()));
                }
    
            }
        } else {
            RectF clipFrame = new RectF();
            m.setRotate(getTargetRotate(), mClipFrame.centerX(), mClipFrame.centerY());
            m.mapRect(clipFrame, mClipFrame);
            
            RectF win = new RectF(mWindow);
            win.offset(scrollX, scrollY);
            homing.rConcat(Utils.fitHoming(win, clipFrame, isRequestToBaseFitting));
            isRequestToBaseFitting = false;
        }
        
        return homing;
    }
    
    public <S extends Sticker> void addSticker(S sticker) {
        if (sticker != null) {
            moveToForeground(sticker);
        }
    }
    
    public void addPath(EditPath path, float sx, float sy) {
        if (path == null) {
            return;
        }
        
        float scale = 1f / getScale();
        
        m.setTranslate(sx, sy);
        m.postRotate(-getRotate(), mClipFrame.centerX(), mClipFrame.centerY());
        m.postTranslate(-mFrame.left, -mFrame.top);
        m.postScale(scale, scale);
        path.transform(m);
        
        switch (path.getMode()) {
            case DOODLE:
                mDoodles.add(path);
                break;
            case MOSAIC:
                path.setWidth(path.getWidth() * scale);
                mMosaics.add(path);
                break;
            default:
                break;
        }
    }
    
    private void moveToForeground(Sticker sticker) {
        if (sticker == null) {
            return;
        }
        
        moveToBackground(mForeSticker);
        
        if (sticker.isShowing()) {
            mForeSticker = sticker;
            // 从BackStickers中移除
            mBackStickers.remove(sticker);
        } else {
            sticker.show();
        }
    }
    
    private void moveToBackground(Sticker sticker) {
        if (sticker == null) {
            return;
        }
        
        if (!sticker.isShowing()) {
            // 加入BackStickers中
            if (!mBackStickers.contains(sticker)) {
                mBackStickers.add(sticker);
            }
            
            if (mForeSticker == sticker) {
                mForeSticker = null;
            }
        } else {
            sticker.dismiss();
        }
    }
    
    public void stickAll() {
        moveToBackground(mForeSticker);
    }
    
    public void onDismiss(Sticker sticker) {
        moveToBackground(sticker);
    }
    
    public void onShowing(Sticker sticker) {
        if (mForeSticker != sticker) {
            moveToForeground(sticker);
        }
    }
    
    public void onRemoveSticker(Sticker sticker) {
        if (mForeSticker == sticker) {
            mForeSticker = null;
        } else {
            mBackStickers.remove(sticker);
        }
    }
    
    public void onWindowChanged(float width, float height) {
        if (width == 0 || height == 0) {
            return;
        }
        
        mWindow.set(0, 0, width, height);
        
        if (!isInitialHoming) {
            onInitialHoming(width, height);
        } else {
            
            // Pivot to fit window.
            m.setTranslate(mWindow.centerX() - mClipFrame.centerX(), mWindow.centerY() - mClipFrame.centerY());
            m.mapRect(mFrame);
            m.mapRect(mClipFrame);
        }
        
        mClipWin.setClipWinSize(width, height);
    }
    
    private void onInitialHoming(float width, float height) {
        mFrame.set(0, 0, mImage.getWidth(), mImage.getHeight());
        mClipFrame.set(mFrame);
        mClipWin.setClipWinSize(width, height);
        
        if (mClipFrame.isEmpty()) {
            return;
        }
        
        toBaseHoming();
        
        isInitialHoming = true;
        onInitialHomingDone();
    }
    
    private void toBaseHoming() {
        if (mClipFrame.isEmpty()) {
            // Bitmap invalidate.
            return;
        }
        
        float scale = Math.min(
                mWindow.width() / mClipFrame.width(),
                mWindow.height() / mClipFrame.height()
        );
        
        // Scale to fit window.
        m.setScale(scale, scale, mClipFrame.centerX(), mClipFrame.centerY());
        m.postTranslate(mWindow.centerX() - mClipFrame.centerX(), mWindow.centerY() - mClipFrame.centerY());
        m.mapRect(mFrame);
        m.mapRect(mClipFrame);
    }
    
    private void onInitialHomingDone() {
        if (mMode == EditMode.CLIP) {
            mClipWin.reset(mClipFrame, getTargetRotate());
        }
    }
    
    public void onDrawImage(Canvas canvas) {
        
        // 裁剪区域
        canvas.clipRect(mClipWin.isClipping() ? mFrame : mClipFrame);
        
        // 绘制图片
        canvas.drawBitmap(mImage, null, mFrame, null);
        
        if (DEBUG) {
            // Clip 区域
            mPaint.setColor(Color.RED);
            mPaint.setStrokeWidth(6);
            canvas.drawRect(mFrame, mPaint);
            canvas.drawRect(mClipFrame, mPaint);
        }
    }
    
    public int onDrawMosaicsPath(Canvas canvas) {
        int layerCount = canvas.saveLayer(mFrame, null, Canvas.ALL_SAVE_FLAG);
        
        if (!isMosaicEmpty()) {
            canvas.save();
            float scale = getScale();
            canvas.translate(mFrame.left, mFrame.top);
            canvas.scale(scale, scale);
            for (EditPath path : mMosaics) {
                path.onDrawMosaic(canvas, mPaint);
            }
            canvas.restore();
        }
        
        return layerCount;
    }
    
    public void onDrawMosaic(Canvas canvas, int layerCount) {
        canvas.drawBitmap(mMosaicImage, null, mFrame, mMosaicPaint);
        canvas.restoreToCount(layerCount);
    }
    
    public void onDrawDoodles(Canvas canvas) {
        if (!isDoodleEmpty()) {
            canvas.save();
            float scale = getScale();
            canvas.translate(mFrame.left, mFrame.top);
            canvas.scale(scale, scale);
            for (EditPath path : mDoodles) {
                path.onDrawDoodle(canvas, mPaint);
            }
            canvas.restore();
        }
    }
    
    public void onDrawStickerClip(Canvas canvas) {
        m.setRotate(getRotate(), mClipFrame.centerX(), mClipFrame.centerY());
        m.mapRect(mTempClipFrame, mClipWin.isClipping() ? mFrame : mClipFrame);
        canvas.clipRect(mTempClipFrame);
    }
    
    public void onDrawStickers(Canvas canvas) {
        if (mBackStickers.isEmpty()) {
            return;
        }
        canvas.save();
        for (Sticker sticker : mBackStickers) {
            if (!sticker.isShowing()) {
                float tPivotX = sticker.getX() + sticker.getPivotX();
                float tPivotY = sticker.getY() + sticker.getPivotY();
    
                canvas.save();
                m.setTranslate(sticker.getX(), sticker.getY());
                m.postScale(sticker.getScale(), sticker.getScale(), tPivotX, tPivotY);
                m.postRotate(sticker.getRotation(), tPivotX, tPivotY);
    
                canvas.concat(m);
                sticker.onSticker(canvas);
                canvas.restore();
            }
        }
        canvas.restore();
    }
    
    public void onDrawShade(Canvas canvas) {
        if (mMode == EditMode.CLIP && isSteady) {
            mShade.reset();
            mShade.addRect(mFrame.left - 2, mFrame.top - 2, mFrame.right + 2, mFrame.bottom + 2, Path.Direction.CW);
            mShade.addRect(mClipFrame, Path.Direction.CCW);
            canvas.drawPath(mShade, mShadePaint);
        }
    }
    
    public void onDrawClip(Canvas canvas, float scrollX, float scrollY) {
        if (mMode == EditMode.CLIP) {
            mClipWin.onDraw(canvas);
        }
    }
    
    public void onTouchDown(float x, float y) {
        isSteady = false;
        moveToBackground(mForeSticker);
        if (mMode == EditMode.CLIP) {
            mAnchor = mClipWin.getAnchor(x, y);
        }
    }
    
    public void onTouchUp(float scrollX, float scrollY) {
        if (mAnchor != null) {
            mAnchor = null;
        }
    }
    
    public void onSteady(float scrollX, float scrollY) {
        isSteady = true;
        onClipHoming();
        mClipWin.setShowShade(true);
    }
    
    public void onScaleBegin() {
    
    }
    
    public CropHoming onScroll(float scrollX, float scrollY, float dx, float dy) {
        if (mMode == EditMode.CLIP) {
            mClipWin.setShowShade(false);
            if (mAnchor != null) {
                mClipWin.onScroll(mAnchor, dx, dy);
    
                RectF clipFrame = new RectF();
                m.setRotate(getRotate(), mClipFrame.centerX(), mClipFrame.centerY());
                m.mapRect(clipFrame, mFrame);
    
                RectF frame = mClipWin.getOffsetFrame(scrollX, scrollY);
                CropHoming homing = new CropHoming(scrollX, scrollY, getScale(), getTargetRotate());
                homing.rConcat(Utils.fillHoming(frame, clipFrame, mClipFrame.centerX(), mClipFrame.centerY()));
                return homing;
            }
        }
        return null;
    }
    
    public float getTargetRotate() {
        return mTargetRotate;
    }
    
    public void setTargetRotate(float targetRotate) {
        mTargetRotate = targetRotate;
    }
    
    /**
     * 在当前基础上旋转
     */
    public void rotate(int rotate) {
        mTargetRotate = Math.round((mRotate + rotate) / 90f) * 90;
        mClipWin.reset(mClipFrame, getTargetRotate());
    }
    
    public float getRotate() {
        return mRotate;
    }
    
    public void setRotate(float rotate) {
        mRotate = rotate;
    }
    
    public float getScale() {
        return 1f * mFrame.width() / mImage.getWidth();
    }
    
    public void setScale(float scale) {
        setScale(scale, mClipFrame.centerX(), mClipFrame.centerY());
    }
    
    public void setScale(float scale, float focusX, float focusY) {
        onScale(scale / getScale(), focusX, focusY);
    }
    
    public void onScale(float factor, float focusX, float focusY) {
        
        if (factor == 1f) {
            return;
        }
        
        if (Math.max(mClipFrame.width(), mClipFrame.height()) >= MAX_SIZE
                || Math.min(mClipFrame.width(), mClipFrame.height()) <= MIN_SIZE) {
            factor += (1 - factor) / 2;
        }
        
        m.setScale(factor, factor, focusX, focusY);
        m.mapRect(mFrame);
        m.mapRect(mClipFrame);
        
        // 修正clip 窗口
        if (!mFrame.contains(mClipFrame)) {
        }
        
        for (Sticker sticker : mBackStickers) {
            m.mapRect(sticker.getFrame());
            float tPivotX = sticker.getX() + sticker.getPivotX();
            float tPivotY = sticker.getY() + sticker.getPivotY();
            sticker.addScale(factor);
            sticker.setX(sticker.getX() + sticker.getFrame().centerX() - tPivotX);
            sticker.setY(sticker.getY() + sticker.getFrame().centerY() - tPivotY);
        }
    }
    
    public void onScaleEnd() {
    
    }
    
    public void onHomingStart(boolean isRotate) {
        isAnimCanceled = false;
        isDrawClip = true;
    }
    
    public void onHoming(float fraction) {
        mClipWin.homing(fraction);
    }
    
    public boolean onHomingEnd(float scrollX, float scrollY, boolean isRotate) {
        isDrawClip = true;
        if (mMode == EditMode.CLIP) {
            // 开启裁剪模式
    
            boolean clip = !isAnimCanceled;
    
            mClipWin.setHoming(false);
            mClipWin.setClipping(true);
            mClipWin.setResetting(false);
    
            return clip;
        } else {
            if (isFreezing && !isAnimCanceled) {
                setFreezing(false);
            }
        }
        return false;
    }
    
    public boolean isFreezing() {
        return isFreezing;
    }
    
    private void setFreezing(boolean freezing) {
        if (freezing != isFreezing) {
            rotateStickers(freezing ? -getRotate() : getTargetRotate());
            isFreezing = freezing;
        }
    }
    
    public void onHomingCancel(boolean isRotate) {
        isAnimCanceled = true;
        Log.d(TAG, "Homing cancel");
    }
    
    public void release() {
        if (mImage != null && !mImage.isRecycled()) {
            mImage.recycle();
        }
    }
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        if (DEFAULT_IMAGE != null) {
            DEFAULT_IMAGE.recycle();
        }
    }
}
