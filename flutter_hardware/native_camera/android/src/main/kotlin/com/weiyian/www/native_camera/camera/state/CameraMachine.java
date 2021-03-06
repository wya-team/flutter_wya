package com.weiyian.www.native_camera.camera.state;

import android.content.Context;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;

import com.weiyian.www.native_camera.camera.CameraInterface;
import com.weiyian.www.native_camera.camera.view.CameraView;


/**
 * @date: 2018/12/5 13:52
 * @author: Chunjiang Mao
 * @classname: CameraMachine
 * @describe:
 */

public class CameraMachine implements State {
    
    private Context context;
    private State state;
    private CameraView view;
    /**
     * 浏览状态(空闲)
     */
    private State previewState;
    /**
     * 浏览图片
     */
    private State borrowPictureState;
    /**
     * 浏览视频
     */
    private State borrowVideoState;
    
    public CameraMachine(Context context, CameraView view, CameraInterface.CameraOpenOverCallback
            cameraOpenOverCallback) {
        this.context = context;
        previewState = new PreviewState(this);
        borrowPictureState = new BorrowPictureState(this);
        borrowVideoState = new BorrowVideoState(this);
        //默认设置为空闲状态
        state = previewState;
//        this.cameraOpenOverCallback = cameraOpenOverCallback;
        this.view = view;
    }
    
    public CameraView getView() {
        return view;
    }
    
    public Context getContext() {
        return context;
    }
    
    /**
     * 获取浏览图片状态
     *
     * @return
     */
    State getBorrowPictureState() {
        return borrowPictureState;
    }
    
    /**
     * 获取浏览视频状态
     *
     * @return
     */
    State getBorrowVideoState() {
        return borrowVideoState;
    }
    
    /**
     * 获取空闲状态
     *
     * @return
     */
    State getPreviewState() {
        return previewState;
    }
    
    @Override
    public void start(SurfaceHolder holder, float screenProp) {
        state.start(holder, screenProp);
    }
    
    @Override
    public void stop() {
        state.stop();
    }
    
    @Override
    public void focus(float x, float y, CameraInterface.FocusCallback callback) {
        state.focus(x, y, callback);
    }
    
    @Override
    public void mySwitch(SurfaceHolder holder, float screenProp) {
        state.mySwitch(holder, screenProp);
    }
    
    @Override
    public void restart() {
        state.restart();
    }
    
    @Override
    public void capture() {
        state.capture();
    }
    
    @Override
    public void record(Surface surface, float screenProp) {
        state.record(surface, screenProp);
    }
    
    @Override
    public void stopRecord(boolean isShort, long time) {
        state.stopRecord(isShort, time);
    }
    
    @Override
    public void cancel(SurfaceHolder holder, float screenProp) {
        state.cancel(holder, screenProp);
    }
    
    @Override
    public void confirm() {
        state.confirm();
    }
    
    @Override
    public void zoom(float zoom, int type) {
        state.zoom(zoom, type);
    }
    
    @Override
    public void flash(String mode) {
        Log.i("mode-----------", mode);
        state.flash(mode);
    }
    
    public State getState() {
        return state;
    }
    
    public void setState(State state) {
        this.state = state;
    }
}
