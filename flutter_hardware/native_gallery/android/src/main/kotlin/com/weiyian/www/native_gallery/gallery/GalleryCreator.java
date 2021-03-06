package com.weiyian.www.native_gallery.gallery;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.weiyian.www.native_gallery.imagepicker.LocalMedia;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description : 图片浏览调用类
 */
public class GalleryCreator {
    private final WeakReference<Activity> mActivity;
    private final WeakReference<Fragment> mFragment;
    
    private GalleryCreator(Activity activity) {
        this(activity, null);
    }
    
    private GalleryCreator(Fragment fragment) {
        this(fragment.getActivity(), fragment);
    }
    
    private GalleryCreator(Activity activity, Fragment fragment) {
        mActivity = new WeakReference<>(activity);
        mFragment = new WeakReference<>(fragment);
    }
    
    public static GalleryCreator create(Activity activity) {
        return new GalleryCreator(activity);
    }
    
    public static GalleryCreator create(Fragment fragment) {
        return new GalleryCreator(fragment);
    }
    
    public void openPreviewGallery(int position, ArrayList<String> images) {
        Intent intent = new Intent();
        intent.setClass(getActivity(), PicturePreviewActivity.class);
        intent.putExtra(GalleryConfig.POSITION, position);
        intent.putStringArrayListExtra(GalleryConfig.IMAGE_LIST, images);
        intent.putExtra(GalleryConfig.TYPE, GalleryConfig.GALLERY);
        getActivity().startActivity(intent);
    }
    
    public void openPreviewImagePicker(int position, List<LocalMedia> images, List<LocalMedia>
            imagesSelected, List<String> cropList, int result, int max, boolean allowSelectOriginal, boolean canImageEdit) {
        
        Intent intent = new Intent();
        intent.setClass(getActivity(), PicturePreviewActivity.class);
        intent.putExtra(GalleryConfig.POSITION, position);
        DataHelper.getInstance().setImages(images);
        DataHelper.getInstance().setImageSelected(imagesSelected);
        DataHelper.getInstance().setCropList(cropList);
        intent.putExtra(GalleryConfig.TYPE, GalleryConfig.IMAGE_PICKER);
        intent.putExtra(GalleryConfig.PICKER_FOR_RESULT, result);
        intent.putExtra(GalleryConfig.MAX_NUM, max);
        intent.putExtra(GalleryConfig.ALLOW_SELECT_ORIGINAL, allowSelectOriginal);
        intent.putExtra(GalleryConfig.CAN_IMAGE_EDIT, canImageEdit);
        getActivity().startActivityForResult(intent, result);
    }
    
    @Nullable
    private Fragment getFragment() {
        return mFragment.get();
    }
    
    public Activity getActivity() {
        return mActivity.get();
    }
}
