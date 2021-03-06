package com.weiyian.www.native_gallery.imagepicker;

import android.app.Activity;
import android.content.Intent;

import androidx.fragment.app.Fragment;

import java.lang.ref.WeakReference;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description : 图片选择调用类
 */
public class ImagePickerCreator {
    private WeakReference<Activity> mActivity;
    private WeakReference<Fragment> mFragment;
    private Intent intent;


    private ImagePickerCreator(Activity activity) {
        this(activity, null);
    }

    private ImagePickerCreator(Fragment fragment) {
        this(fragment.getActivity(), fragment);
    }

    private ImagePickerCreator(Activity activity, Fragment fragment) {
        mActivity = new WeakReference<>(activity);
        mFragment = new WeakReference<>(fragment);
        intent = new Intent(getActivity(), ImagePickerActivity.class);
    }

    public static ImagePickerCreator create(Activity activity) {
        return new ImagePickerCreator(activity);
    }

    public static ImagePickerCreator create(Fragment fragment) {
        return new ImagePickerCreator(fragment);
    }

    public ImagePickerCreator setMediaType(int mediaType) {
        intent.putExtra(PickerConfig.MEDIA_TYPE, mediaType);
        return this;
    }

    public ImagePickerCreator forResult(int requestCode) {
        getActivity().startActivityForResult(intent, requestCode);
        return this;
    }

    public ImagePickerCreator maxImages(int num) {
        intent.putExtra(PickerConfig.IMAGE_NUMBER, num);
        return this;
    }

    public ImagePickerCreator hasTakePhotoMenu(boolean hasTakePhotoMenu) {
        intent.putExtra(PickerConfig.HAS_PHOTO_FUTURE, hasTakePhotoMenu);
        return this;
    }

    public ImagePickerCreator allowSelectOriginal(boolean allowSelectOriginal) {
        intent.putExtra(PickerConfig.AllOW_SELECT_ORIGINAL, allowSelectOriginal);
        return this;
    }

    public ImagePickerCreator allowEditImage(boolean allowEditImage) {
        intent.putExtra(PickerConfig.AllOW_EDIT_IMAGE, allowEditImage);
        return this;
    }

    public ImagePickerCreator allowChoosePhotoAndVideo(boolean allowChoosePhotoAndVideo) {
        intent.putExtra(PickerConfig.AllOW_CHOSE_PHOTO_AND_VIDEO, allowChoosePhotoAndVideo);
        return this;
    }

    public ImagePickerCreator textColor(int color) {
        intent.putExtra(PickerConfig.TEXT_COLOR, color);
        return this;
    }

    private Activity getActivity() {
        return mActivity.get();
    }

    private Fragment getFragment() {
        return mFragment.get();
    }
}
