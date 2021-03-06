package com.weiyian.www.native_camera.camera;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.YuvImage;
import android.hardware.Camera;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.WindowManager;
import android.widget.ImageView;

import com.weiyian.www.native_camera.camera.listener.ErrorListener;
import com.weiyian.www.native_camera.camera.util.AngleUtil;
import com.weiyian.www.native_camera.camera.util.CameraParamUtil;
import com.weiyian.www.native_camera.camera.util.CheckPermission;
import com.weiyian.www.native_camera.camera.util.DeviceUtil;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static android.graphics.Bitmap.createBitmap;
import static android.os.Build.VERSION_CODES.JELLY_BEAN_MR1;

/**
 * @date: 2018/12/5 14:09
 * @author: Chunjiang Mao
 * @classname: CameraInterface
 * @describe: camera操作单例
 */

@SuppressWarnings("deprecation")
public class CameraInterface implements Camera.PreviewCallback {
    
    public static final int TYPE_RECORDER = 0x090;
    public static final int TYPE_CAPTURE = 0x091;
    private static final String TAG = "MCJ";
    private volatile static CameraInterface mCameraInterface;
    int handlerTime = 0;
    private Camera mCamera;
    private Camera.Parameters mParams;
    private boolean isPreviewing = false;
    private int selectedCamera = -1;
    private int cameraPostPosition = -1;
    private int cameraFrontPosition = -1;
    private SurfaceHolder mHolder = null;
    private float screenProp = -1.0f;
    private boolean isRecorder = false;
    private MediaRecorder mediaRecorder;
    private String videoFileName;
    private String saveVideoPath;
    private String videoFileAbsPath;
    private Bitmap videoFirstFrame = null;
    private ErrorListener errorListener;
    private ImageView mSwitchView;
    private ImageView mFlashLamp;
    private int previewWidth;
    private int previewHeight;
    private int angle = 0;
    private int cameraAngle = 90;
    private int rotation = 0;
    private byte[] firstframeData;
    private int nowScaleRate = 0;
    private int recordScleRate = 0;
    
    private int angle90 = 90;
    private int angle270 = 90;
    private int handlerTime10 = 10;
    
    /**
     * 视频质量
     */
    private int mediaQuality = WYACameraView.MEDIA_QUALITY_MIDDLE;
    private SensorManager sm = null;
    private SensorEventListener sensorEventListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            if (Sensor.TYPE_ACCELEROMETER != event.sensor.getType()) {
                return;
            }
            float[] values = event.values;
            angle = AngleUtil.getSensorAngle(values[0], values[1]);
            rotationAnimation();
        }
        
        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {
        }
    };
    /**
     * 拍照
     */
    private int nowAngle;
    
    private CameraInterface() {
        findAvailableCameras();
        selectedCamera = cameraPostPosition;
        saveVideoPath = "";
    }
    
    public static void destroyCameraInterface() {
        if (mCameraInterface != null) {
            mCameraInterface = null;
        }
    }
    
    /**
     * 获取CameraInterface单例
     */
    public static synchronized CameraInterface getInstance() {
        if (mCameraInterface == null) {
            synchronized (CameraInterface.class) {
                if (mCameraInterface == null) {
                    mCameraInterface = new CameraInterface();
                }
            }
        }
        return mCameraInterface;
    }
    
    /**
     * 删除文件
     *
     * @param url
     * @return
     */
    private static boolean deleteFile(String url) {
        boolean result = false;
        File file = new File(url);
        if (file.exists()) {
            result = file.delete();
        }
        return result;
    }
    
    private static Rect calculateTapArea(float x, float y, float coefficient, Context context) {
        float focusAreaSize = 300;
        int areaSize = Float.valueOf(focusAreaSize * coefficient).intValue();
        int centerX = (int) (x / getScreenWidth(context) * 2000 - 1000);
        int centerY = (int) (y / getScreenHeight(context) * 2000 - 1000);
        int left = clamp(centerX - areaSize / 2, -1000, 1000);
        int top = clamp(centerY - areaSize / 2, -1000, 1000);
        RectF rectF = new RectF(left, top, left + areaSize, top + areaSize);
        return new Rect(Math.round(rectF.left), Math.round(rectF.top), Math.round(rectF.right),
                Math.round(rectF
                        .bottom));
    }
    
    /**
     * 获取屏幕高
     *
     * @param context
     * @return
     */
    private static int getScreenHeight(Context context) {
        DisplayMetrics metric = new DisplayMetrics();
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getMetrics(metric);
        return metric.heightPixels;
    }
    
    /**
     * 获取屏幕宽
     *
     * @param context
     * @return
     */
    private static int getScreenWidth(Context context) {
        DisplayMetrics metric = new DisplayMetrics();
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getMetrics(metric);
        return metric.widthPixels;
    }
    
    private static int clamp(int x, int min, int max) {
        if (x > max) {
            return max;
        }
        if (x < min) {
            return min;
        }
        return x;
    }
    
    public void setSwitchView(ImageView mSwitchView, ImageView mFlashLamp) {
        this.mSwitchView = mSwitchView;
        this.mFlashLamp = mFlashLamp;
        if (mSwitchView != null) {
            cameraAngle = CameraParamUtil.getInstance().getCameraDisplayOrientation(mSwitchView
                            .getContext(),
                    selectedCamera);
        }
    }
    
    /**
     * 切换摄像头icon跟随手机角度进行旋转
     */
    private void rotationAnimation() {
        if (mSwitchView == null) {
            return;
        }
        if (rotation != angle) {
            int startRotaion = 0;
            int endRotation = 0;
            switch (rotation) {
                case 0:
                    startRotaion = 0;
                    switch (angle) {
                        case 90:
                            endRotation = -90;
                            break;
                        case 270:
                            endRotation = 90;
                            break;
                        default:
                            break;
                    }
                    break;
                case 90:
                    startRotaion = -90;
                    switch (angle) {
                        case 0:
                            endRotation = 0;
                            break;
                        case 180:
                            endRotation = -180;
                            break;
                        default:
                            break;
                    }
                    break;
                case 180:
                    startRotaion = 180;
                    switch (angle) {
                        case 90:
                            endRotation = 270;
                            break;
                        case 270:
                            endRotation = 90;
                            break;
                        default:
                            break;
                    }
                    break;
                case 270:
                    startRotaion = 90;
                    switch (angle) {
                        case 0:
                            endRotation = 0;
                            break;
                        case 180:
                            endRotation = 180;
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            ObjectAnimator animC = ObjectAnimator.ofFloat(mSwitchView, "rotation", startRotaion,
                    endRotation);
            ObjectAnimator animF = ObjectAnimator.ofFloat(mFlashLamp, "rotation", startRotaion,
                    endRotation);
            AnimatorSet set = new AnimatorSet();
            set.playTogether(animC, animF);
            set.setDuration(500);
            set.start();
            rotation = angle;
        }
    }
    
    @SuppressWarnings("ResultOfMethodCallIgnored")
    void setSaveVideoPath(String saveVideoPath) {
        this.saveVideoPath = saveVideoPath;
        File file = new File(saveVideoPath);
        if (!file.exists()) {
            file.mkdirs();
        }
    }
    
    public void setZoom(float zoom, int type) {
        if (mCamera == null) {
            return;
        }
        if (mParams == null) {
            mParams = mCamera.getParameters();
        }
        if (!mParams.isZoomSupported() || !mParams.isSmoothZoomSupported()) {
            return;
        }
        switch (type) {
            case TYPE_RECORDER:
                //如果不是录制视频中，上滑不会缩放
                if (!isRecorder) {
                    return;
                }
                if (zoom >= 0) {
                    //每移动50个像素缩放一个级别
                    int scaleRate = (int) (zoom / 40);
                    if (scaleRate <= mParams.getMaxZoom() && scaleRate >= nowScaleRate &&
                            recordScleRate != scaleRate) {
                        mParams.setZoom(scaleRate);
                        mCamera.setParameters(mParams);
                        recordScleRate = scaleRate;
                    }
                }
                break;
            case TYPE_CAPTURE:
                if (isRecorder) {
                    return;
                }
                //每移动50个像素缩放一个级别
                int scaleRate = (int) (zoom / 50);
                if (scaleRate < mParams.getMaxZoom()) {
                    nowScaleRate += scaleRate;
                    if (nowScaleRate < 0) {
                        nowScaleRate = 0;
                    } else if (nowScaleRate > mParams.getMaxZoom()) {
                        nowScaleRate = mParams.getMaxZoom();
                    }
                    mParams.setZoom(nowScaleRate);
                    mCamera.setParameters(mParams);
                }
                break;
            default:
                break;
        }
        
    }
    
    void setMediaQuality(int quality) {
        mediaQuality = quality;
    }
    
    @Override
    public void onPreviewFrame(byte[] data, Camera camera) {
        firstframeData = data;
    }
    
    public void setFlashMode(String flashMode) {
        if (mCamera == null) {
            return;
        }
        Camera.Parameters params = mCamera.getParameters();
        params.setFlashMode(flashMode);
        mCamera.setParameters(params);
    }
    
    /**
     * open Camera
     */
    void doOpenCamera(CameraOpenOverCallback callback) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            if (!CheckPermission.isCameraUseable(selectedCamera) && errorListener != null) {
                errorListener.onError();
                return;
            }
        }
        if (mCamera == null) {
            openCamera(selectedCamera);
        }
        callback.cameraHasOpened();
    }
    
    private void setFlashModel() {
        mParams = mCamera.getParameters();
        //设置camera参数为Torch模式
        mParams.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
        mCamera.setParameters(mParams);
    }
    
    private synchronized void openCamera(int id) {
        try {
            mCamera = Camera.open(id);
        } catch (Exception var3) {
            var3.printStackTrace();
            if (errorListener != null) {
                errorListener.onError();
            }
        }
    
        if (Build.VERSION.SDK_INT > JELLY_BEAN_MR1 && mCamera != null) {
            try {
                mCamera.enableShutterSound(false);
            } catch (Exception e) {
                e.printStackTrace();
                Log.e(TAG, "enable shutter sound fail");
            }
        }
    }
    
    public synchronized void switchCamera(SurfaceHolder holder, float screenProp) {
        if (selectedCamera == cameraPostPosition) {
            selectedCamera = cameraFrontPosition;
        } else {
            selectedCamera = cameraPostPosition;
        }
        doDestroyCamera();
        openCamera(selectedCamera);
        if (Build.VERSION.SDK_INT > JELLY_BEAN_MR1 && mCamera != null) {
            try {
                mCamera.enableShutterSound(false);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        doStartPreview(holder, screenProp);
    }
    
    /**
     * doStartPreview
     */
    public void doStartPreview(SurfaceHolder holder, float screenProp) {
        if (this.screenProp < 0) {
            this.screenProp = screenProp;
        }
        if (holder == null) {
            return;
        }
        mHolder = holder;
        if (mCamera != null) {
            try {
                mParams = mCamera.getParameters();
                Camera.Size previewSize = CameraParamUtil.getInstance().getPreviewSize(mParams
                        .getSupportedPreviewSizes(), 1000, screenProp);
                Camera.Size pictureSize = CameraParamUtil.getInstance().getPictureSize(mParams
                        .getSupportedPictureSizes(), 1200, screenProp);
                
                mParams.setPreviewSize(previewSize.width, previewSize.height);
                
                previewWidth = previewSize.width;
                previewHeight = previewSize.height;
                
                mParams.setPictureSize(pictureSize.width, pictureSize.height);
                
                if (CameraParamUtil.getInstance().isSupportedFocusMode(
                        mParams.getSupportedFocusModes(),
                        Camera.Parameters.FOCUS_MODE_AUTO)) {
                    mParams.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
                }
                if (CameraParamUtil.getInstance().isSupportedPictureFormats(mParams
                                .getSupportedPictureFormats(),
                        ImageFormat.JPEG)) {
                    mParams.setPictureFormat(ImageFormat.JPEG);
                    mParams.setJpegQuality(100);
                }
                mCamera.setParameters(mParams);
                mParams = mCamera.getParameters();
                //SurfaceView
                mCamera.setPreviewDisplay(holder);
                //浏览角度
                mCamera.setDisplayOrientation(cameraAngle);
                //每一帧回调
                mCamera.setPreviewCallback(this);
                //启动浏览
                mCamera.startPreview();
                isPreviewing = true;
                Log.i(TAG, "=== Start Preview ===");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 停止预览
     */
    public void doStopPreview() {
        if (null != mCamera) {
            try {
                mCamera.setPreviewCallback(null);
                mCamera.stopPreview();
                //这句要在stopPreview后执行，不然会卡顿或者花屏
                mCamera.setPreviewDisplay(null);
                isPreviewing = false;
                Log.i(TAG, "=== Stop Preview ===");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 销毁Camera
     */
    void doDestroyCamera() {
        errorListener = null;
        if (null != mCamera) {
            try {
                mCamera.setPreviewCallback(null);
                mSwitchView = null;
                mFlashLamp = null;
                mCamera.stopPreview();
                //这句要在stopPreview后执行，不然会卡顿或者花屏
                mCamera.setPreviewDisplay(null);
                mHolder = null;
                isPreviewing = false;
                mCamera.release();
                mCamera = null;
                //                destroyCameraInterface();
                Log.i(TAG, "=== Destroy Camera ===");
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            Log.i(TAG, "=== Camera  Null===");
        }
        sm = null;
    }
    
    public void takePicture(final TakePictureCallback callback) {
        if (mCamera == null) {
            return;
        }
        switch (cameraAngle) {
            case 90:
                nowAngle = Math.abs(angle + cameraAngle) % 360;
                break;
            case 270:
                nowAngle = Math.abs(cameraAngle - angle);
                break;
            default:
                break;
        }
        //
        Log.i(TAG, angle + " = " + cameraAngle + " = " + nowAngle);
        mCamera.takePicture(null, null, new Camera.PictureCallback() {
            @Override
            public void onPictureTaken(byte[] data, Camera camera) {
                Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
                Matrix matrix = new Matrix();
                if (selectedCamera == cameraPostPosition) {
                    matrix.setRotate(nowAngle);
                } else if (selectedCamera == cameraFrontPosition) {
                    matrix.setRotate(360 - nowAngle);
                    matrix.postScale(-1, 1);
                }
                
                bitmap = createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(),
                        matrix, true);
                if (callback != null) {
                    if (nowAngle == angle90 || nowAngle == angle270) {
                        callback.captureResult(bitmap, true);
                    } else {
                        callback.captureResult(bitmap, false);
                    }
                }
            }
        });
    }
    
    /**
     * 启动录像
     *
     * @param surface
     * @param screenProp
     * @param callback
     */
    public void startRecord(Surface surface, float screenProp, ErrorCallback callback) {
        mCamera.setPreviewCallback(null);
        final int nowAngle = (angle + 90) % 360;
        //获取第一帧图片
        Camera.Parameters parameters = mCamera.getParameters();
        int width = parameters.getPreviewSize().width;
        int height = parameters.getPreviewSize().height;
        YuvImage yuv = new YuvImage(firstframeData, parameters.getPreviewFormat(), width,
                height, null);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        yuv.compressToJpeg(new Rect(0, 0, width, height), 50, out);
        byte[] bytes = out.toByteArray();
        videoFirstFrame = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
        Matrix matrix = new Matrix();
        if (selectedCamera == cameraPostPosition) {
            matrix.setRotate(nowAngle);
        } else if (selectedCamera == cameraFrontPosition) {
            matrix.setRotate(270);
        }
        videoFirstFrame = createBitmap(videoFirstFrame, 0, 0, videoFirstFrame.getWidth(),
                videoFirstFrame
                        .getHeight(), matrix, true);
        
        if (isRecorder) {
            return;
        }
        if (mCamera == null) {
            openCamera(selectedCamera);
        }
        if (mediaRecorder == null) {
            mediaRecorder = new MediaRecorder();
        }
        if (mParams == null) {
            mParams = mCamera.getParameters();
        }
        List<String> focusModes = mParams.getSupportedFocusModes();
        if (focusModes.contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO)) {
            mParams.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO);
        }
        mCamera.setParameters(mParams);
        mCamera.unlock();
        mediaRecorder.reset();
        mediaRecorder.setCamera(mCamera);
        mediaRecorder.setVideoSource(MediaRecorder.VideoSource.CAMERA);
        
        mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        
        mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
        mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264);
        mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
        
        Camera.Size videoSize;
        if (mParams.getSupportedVideoSizes() == null) {
            videoSize = CameraParamUtil.getInstance().getPreviewSize(mParams
                            .getSupportedPreviewSizes(), 600,
                    screenProp);
        } else {
            videoSize = CameraParamUtil.getInstance().getPreviewSize(mParams
                            .getSupportedVideoSizes(), 600,
                    screenProp);
        }
        Log.i(TAG, "setVideoSize    width = " + videoSize.width + "height = " + videoSize.height);
        if (videoSize.width == videoSize.height) {
            mediaRecorder.setVideoSize(previewWidth, previewHeight);
        } else {
            mediaRecorder.setVideoSize(videoSize.width, videoSize.height);
        }
        
        if (selectedCamera == cameraFrontPosition) {
            //手机预览倒立的处理
            if (cameraAngle == angle270) {
                //横屏
                if (nowAngle == 0) {
                    mediaRecorder.setOrientationHint(180);
                } else if (nowAngle == angle270) {
                    mediaRecorder.setOrientationHint(270);
                } else {
                    mediaRecorder.setOrientationHint(90);
                }
            } else {
                if (nowAngle == angle90) {
                    mediaRecorder.setOrientationHint(270);
                } else if (nowAngle == angle270) {
                    mediaRecorder.setOrientationHint(90);
                } else {
                    mediaRecorder.setOrientationHint(nowAngle);
                }
            }
        } else {
            mediaRecorder.setOrientationHint(nowAngle);
        }
        
        if (DeviceUtil.isHuaWeiRongyao()) {
            mediaRecorder.setVideoEncodingBitRate(4 * 100000);
        } else {
            mediaRecorder.setVideoEncodingBitRate(mediaQuality);
        }
        mediaRecorder.setPreviewDisplay(surface);
        
        videoFileName = "video_" + System.currentTimeMillis() + ".mp4";
        if ("".equals(saveVideoPath)) {
            saveVideoPath = Environment.getExternalStorageDirectory().getPath();
        }
        videoFileAbsPath = saveVideoPath + File.separator + videoFileName;
        mediaRecorder.setOutputFile(videoFileAbsPath);
        try {
            mediaRecorder.prepare();
            mediaRecorder.start();
            isRecorder = true;
        } catch (IllegalStateException e) {
            e.printStackTrace();
            Log.i(TAG, "startRecord IllegalStateException");
            if (errorListener != null) {
                errorListener.onError();
            }
        } catch (IOException e) {
            e.printStackTrace();
            Log.i(TAG, "startRecord IOException");
            if (errorListener != null) {
                errorListener.onError();
            }
        } catch (RuntimeException e) {
            Log.i(TAG, "startRecord RuntimeException");
        }
    }
    
    /**
     * 停止录像
     *
     * @param isShort
     * @param callback
     */
    public void stopRecord(boolean isShort, StopRecordCallback callback) {
        if (!isRecorder) {
            return;
        }
        if (mediaRecorder != null) {
            mediaRecorder.setOnErrorListener(null);
            mediaRecorder.setOnInfoListener(null);
            mediaRecorder.setPreviewDisplay(null);
            try {
                mediaRecorder.stop();
            } catch (RuntimeException e) {
                e.printStackTrace();
                mediaRecorder = null;
                mediaRecorder = new MediaRecorder();
            } finally {
                if (mediaRecorder != null) {
                    mediaRecorder.release();
                }
                mediaRecorder = null;
                isRecorder = false;
            }
            if (isShort) {
                if (deleteFile(videoFileAbsPath)) {
                    callback.recordResult(null, null);
                }
                return;
            }
            doStopPreview();
            String fileName = saveVideoPath + File.separator + videoFileName;
            callback.recordResult(fileName, videoFirstFrame);
        }
    }
    
    private void findAvailableCameras() {
        Camera.CameraInfo info = new Camera.CameraInfo();
        int cameraNum = Camera.getNumberOfCameras();
        for (int i = 0; i < cameraNum; i++) {
            Camera.getCameraInfo(i, info);
            switch (info.facing) {
                case Camera.CameraInfo.CAMERA_FACING_FRONT:
                    cameraFrontPosition = info.facing;
                    break;
                case Camera.CameraInfo.CAMERA_FACING_BACK:
                    cameraPostPosition = info.facing;
                    break;
                default:
                    break;
            }
        }
    }
    
    public void handleFocus(final Context context, final float x, final float y, final
    FocusCallback callback) {
        if (mCamera == null) {
            return;
        }
        final Camera.Parameters params = mCamera.getParameters();
        Rect focusRect = calculateTapArea(x, y, 1f, context);
        mCamera.cancelAutoFocus();
        if (params.getMaxNumFocusAreas() > 0) {
            List<Camera.Area> focusAreas = new ArrayList<>();
            focusAreas.add(new Camera.Area(focusRect, 800));
            params.setFocusAreas(focusAreas);
        } else {
            Log.i(TAG, "focus areas not supported");
            callback.focusSuccess();
            return;
        }
        final String currentFocusMode = params.getFocusMode();
        try {
            params.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
            mCamera.setParameters(params);
            mCamera.autoFocus(new Camera.AutoFocusCallback() {
                @Override
                public void onAutoFocus(boolean success, Camera camera) {
                    if (success || handlerTime > handlerTime10) {
                        Camera.Parameters params = camera.getParameters();
                        params.setFocusMode(currentFocusMode);
                        camera.setParameters(params);
                        handlerTime = 0;
                        callback.focusSuccess();
                    } else {
                        handlerTime++;
                        handleFocus(context, x, y, callback);
                    }
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "autoFocus failer");
        }
    }
    
    void setErrorListener(ErrorListener errorListener) {
        this.errorListener = errorListener;
    }
    
    void registerSensorManager(Context context) {
        if (sm == null) {
            sm = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        }
        sm.registerListener(sensorEventListener, sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
                SensorManager
                        .SENSOR_DELAY_NORMAL);
    }
    
    void unregisterSensorManager(Context context) {
        if (sm == null) {
            sm = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        }
        sm.unregisterListener(sensorEventListener);
    }
    
    void isPreview(boolean res) {
        isPreviewing = res;
    }
    
    public interface CameraOpenOverCallback {
        /**
         * cameraHasOpened
         */
        void cameraHasOpened();
    }
    
    public interface StopRecordCallback {
        /**
         * recordResult
         *
         * @param url
         * @param firstFrame
         */
        void recordResult(String url, Bitmap firstFrame);
    }
    
    interface ErrorCallback {
        /**
         * onError
         */
        void onError();
    }
    
    public interface TakePictureCallback {
        /**
         * captureResult
         *
         * @param bitmap
         * @param isVertical
         */
        void captureResult(Bitmap bitmap, boolean isVertical);
    }
    
    public interface FocusCallback {
        /**
         * focusSuccess
         */
        void focusSuccess();
    }
}
