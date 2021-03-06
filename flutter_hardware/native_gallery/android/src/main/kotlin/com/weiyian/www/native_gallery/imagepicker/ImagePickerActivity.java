package com.weiyian.www.native_gallery.imagepicker;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.ColorInt;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.SimpleItemAnimator;

import com.bumptech.glide.Glide;
import com.tbruyelle.rxpermissions.RxPermissions;
import com.weiyian.www.native_gallery.R;
import com.weiyian.www.native_gallery.gallery.DataHelper;
import com.weiyian.www.native_gallery.gallery.GalleryConfig;
import com.weiyian.www.native_gallery.gallery.GalleryCreator;
import com.weiyian.www.native_gallery.gallery.GalleryUtils;
import com.weiyian.www.native_gallery.optionmenu.BaseOptionMenu;
import com.weiyian.www.native_gallery.optionmenu.OptionMenuViewHolder;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description : 图片选择类
 */
@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
public class ImagePickerActivity extends AppCompatActivity implements View.OnClickListener,
                                                                      ImageGridAdapter.OnImageSelectedChangedListener {
    private static final String TAG = "ImagePickerActivity";
    private static final int PERMISSION_CAMERA = 1001;
    private ImageView pictureLeftBack;
    private TextView pictureTitle;
    private RecyclerView pictureRecycler;
    private LinearLayout pictureBottomLayout;
    private TextView tvPreview;
    private TextView tvCommit;
    private RelativeLayout pickerTitleLayout;
    private TableRow tabOriginal;
    private CheckBox checkOriginal;

    private ImageGridAdapter mGridAdapter;
    private BaseOptionMenu<LocalMediaFolder> mBaseOptionMenu;
    private List<LocalMediaFolder> mFolders = new ArrayList<>();
    private List<String> mCropList = new ArrayList<>();
    private Drawable mDrawableUp;
    private Drawable mDrawableDown;
    private boolean isDown;
    private List<LocalMedia> mSelected = new ArrayList<>();
    private List<LocalMedia> mLocalMedia = new ArrayList<>();
    private int maxNum;
    private String imagePath;
    private LocalMediaFolder mCurrentFolder;
    private int mediaType;
    private boolean hasPhoto = true;
    private boolean allowSelectOriginal;
    private boolean allowEditImage;
    private boolean allowChoosePhotoAndVideo;
    private int textColor;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_picker);
        setColor(getResources().getColor(R.color.black));
        
        mediaType = getIntent().getIntExtra(PickerConfig.MEDIA_TYPE, PickerConfig.MEDIA_DEFAULT);
        maxNum = getIntent().getIntExtra(PickerConfig.IMAGE_NUMBER, 1);
        hasPhoto = getIntent().getBooleanExtra(PickerConfig.HAS_PHOTO_FUTURE, true);
        allowSelectOriginal = getIntent().getBooleanExtra(PickerConfig.AllOW_SELECT_ORIGINAL, true);
        allowEditImage = getIntent().getBooleanExtra(PickerConfig.AllOW_EDIT_IMAGE, true);
        allowChoosePhotoAndVideo = getIntent().getBooleanExtra(PickerConfig.AllOW_CHOSE_PHOTO_AND_VIDEO, true);

        textColor = getIntent().getIntExtra(PickerConfig.TEXT_COLOR, R.color.color_orange);
        
        checkStoragePermissions();
        
        initView();
        initChoiceMenu();
    }
    
    @SuppressLint("CheckResult")
    private void checkCameraPermissions() {
        new RxPermissions(this).request(Manifest.permission.CAMERA)
                .subscribe(aBoolean -> {
                            if (aBoolean) {
                                takePhoto();
                            } else {
                                Toast.makeText(this, "拍照权限被拒绝", Toast.LENGTH_SHORT).show();
                            }
                        }
                );
    }
    
    @SuppressLint("CheckResult")
    private void checkStoragePermissions() {
        new RxPermissions(this).request(Manifest.permission.READ_EXTERNAL_STORAGE)
                .subscribe(aBoolean -> {
                            if (aBoolean) {
                                readLocalImage();
                            } else {
                                Toast.makeText(this, "读取内存卡权限被拒绝", Toast.LENGTH_SHORT).show();
                            }
                        }
                );
    }
    
    /**
     * 设置状态栏颜色
     */
    
    public void setColor(@ColorInt int color) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            getWindow().setStatusBarColor(color);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
//            ViewGroup decorView = (ViewGroup) getWindow().getDecorView();
//            View fakeStatusBarView = decorView.findViewById(R.id
//                    .statusbarutil_fake_status_bar_view);
//            if (fakeStatusBarView != null) {
//                if (fakeStatusBarView.getVisibility() == View.GONE) {
//                    fakeStatusBarView.setVisibility(View.VISIBLE);
//                }
//                fakeStatusBarView.setBackgroundColor(color);
//            }
            ViewGroup parent = findViewById(android.R.id.content);
            for (int i = 0, count = parent.getChildCount(); i < count; i++) {
                View childView = parent.getChildAt(i);
                if (childView instanceof ViewGroup) {
                    childView.setFitsSystemWindows(true);
                    ((ViewGroup) childView).setClipToPadding(true);
                }
            }
        }
    }
    
    /**
     * init folder menu
     */
    private void initChoiceMenu() {
        mBaseOptionMenu = new BaseOptionMenu<LocalMediaFolder>(this, mFolders, R.layout
                .folder_choice_item) {
            @Override
            public void setValueFirst(final OptionMenuViewHolder helper, final LocalMediaFolder
                    item) {
                helper.setText(R.id.folder_name, item.getName())
                        .setText(R.id.folder_image_num, item.getImageNum() + "");
                ImageView imageView = helper.getView(R.id.folder_first_image);
                Glide.with(ImagePickerActivity.this).load(item.getFirstImagePath())
                        .into(imageView);
            }
            
            @Override
            public void setValueSecond(OptionMenuViewHolder helper, LocalMediaFolder item) {
            
            }
        };
        mBaseOptionMenu.setShadow(false);
        mBaseOptionMenu.setFocusable(false);
        mBaseOptionMenu.setOnFirstAdapterItemClickListener(
                new BaseOptionMenu.OnFirstAdapterItemClickListener() {
                    @Override
                    public void onClick(int position, View v, BaseOptionMenu menu) {
                        changeTitleImageAndStatus();
                        mCurrentFolder = mFolders.get(position);
                        mLocalMedia = mCurrentFolder.getImages();
                        pictureTitle.setText(mCurrentFolder.getName());
                        mGridAdapter.bindData((position == 0) && hasPhoto, mLocalMedia);
                    }
                });
    }
    
    /**
     * init view
     */
    private void initView() {
        pictureLeftBack = findViewById(R.id.picture_left_back);
        pictureTitle = findViewById(R.id.picture_title);
        pictureRecycler = findViewById(R.id.picture_recycler);
        pictureBottomLayout = findViewById(R.id.picture_bottom_layout);
        tvPreview = findViewById(R.id.tv_preview);
        tvCommit = findViewById(R.id.tv_commit);
        pickerTitleLayout = findViewById(R.id.picker_title_layout);
        tabOriginal = findViewById(R.id.tab_original);
        checkOriginal = findViewById(R.id.check_original);


        
        pictureTitle.setOnClickListener(this);
        pictureLeftBack.setOnClickListener(this);
        tvPreview.setOnClickListener(this);
        tvCommit.setOnClickListener(this);

        if(allowSelectOriginal){
            tabOriginal.setVisibility(View.VISIBLE);
        } else {
            tabOriginal.setVisibility(View.GONE);
        }
        
        initAdapter();
        
        mDrawableUp = getResources().getDrawable(R.drawable.icon_up);
        mDrawableDown = getResources().getDrawable(R.drawable.icon_down);
        mDrawableUp.setBounds(0, 0, mDrawableUp.getMinimumWidth(), mDrawableUp.getMinimumHeight());
        mDrawableDown.setBounds(0, 0, mDrawableDown.getMinimumWidth(), mDrawableDown
                .getMinimumHeight());
        
    }
    
    /**
     * init recyclerView adapter
     */
    private void initAdapter() {
        mGridAdapter = new ImageGridAdapter(this, this, maxNum, allowChoosePhotoAndVideo);
        pictureRecycler.setLayoutManager(new GridLayoutManager(this, 4));
        pictureRecycler.addItemDecoration(new SpaceDecoration(4, (int) dp2px(3), false));
        pictureRecycler.setItemAnimator(new DefaultItemAnimator());
        mGridAdapter.setHasStableIds (true);
        ((SimpleItemAnimator) pictureRecycler.getItemAnimator()).setSupportsChangeAnimations(false);
        pictureRecycler.setAdapter(mGridAdapter);
        mGridAdapter.setImageClickListener(new ImageGridAdapter.OnImageClickListener() {
            @Override
            public void onClick(int position, List<LocalMedia> mImages, List<LocalMedia>
                    mImageSelected) {
                GalleryCreator.create(ImagePickerActivity.this).openPreviewImagePicker
                        (position, mImages, mImageSelected, mCropList, PickerConfig
                                .PICKER_GALLERY_RESULT, maxNum, allowSelectOriginal, allowEditImage);
            }
        });
        
        mGridAdapter.setPhotoClickListener(this::checkCameraPermissions);
    }
    
    /**
     * takePhoto
     * folder :/DCIM/UIkit/
     */
    private void takePhoto() {
        Uri uri;
        File file = new File(Environment.getExternalStorageDirectory(),
                "/DCIM/UIkit/" + "UIKit_" + System.currentTimeMillis() + ".jpg");
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        imagePath = file.getAbsolutePath();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(this, getPackageName() + ".fileprovider", file);
        } else {
            uri = Uri.fromFile(file);
        }
        
        Intent intent = new Intent();
        intent.setAction(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        startActivityForResult(intent, PickerConfig.REQUEST_CAMERA);
    }
    
    /**
     * load images
     */
    private void readLocalImage() {
        LocalMediaLoader.create(this).loadImage(new LocalMediaLoader.OnLoadImageListener() {
            @Override
            public void completed(List<LocalMediaFolder> localMediaFolders) {
                if (localMediaFolders.size() > 0) {
                    LocalMediaFolder localMediaFolder = localMediaFolders.get(0);
                    //数据没有变化（拍照返回或直接返回）
                    if (mLocalMedia.size() != localMediaFolder.getImages().size()) {
                        mLocalMedia.clear();
                        mLocalMedia.addAll(localMediaFolder.getImages());
                        pictureTitle.setText(localMediaFolder.getName());
                        mGridAdapter.bindData(hasPhoto, mLocalMedia);
                        mFolders.clear();
                        mFolders.addAll(localMediaFolders);
                        mBaseOptionMenu.notifyAdapterData();
                        mCurrentFolder = mFolders.get(0);
                    }
                    
                } else {
                    pictureTitle.setText("相册");
                }
            }
        }, mediaType);
    }
    
    public float dp2px(int dp) {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, getResources()
                .getDisplayMetrics());
    }
    
    @Override
    public void onClick(View v) {
        //show choice menu
        if (v.getId() == R.id.picture_title) {
            changeTitleImageAndStatus();
        }
        
        //back
        if (v.getId() == R.id.picture_left_back) {
            onBackPressed();
        }
        
        //commit
        if (v.getId() == R.id.tv_commit) {
            
            if (mSelected.size() > 0) {
                //移除没被选中的编辑过的图片
                for (int i = 0; i < mSelected.size(); i++) {
                    mCropList.remove(mSelected.get(i).getCropPath());
                }
                GalleryUtils.removeAllFile(mCropList);
                
                Intent intent = getIntent();
                Bundle bundle = new Bundle();
                
                //                bundle.putSerializable(PickerConfig.IMAGE_SELECTED,
                // (Serializable) mSelected);
                bundle.putStringArrayList(PickerConfig.IMAGE_SELECTED, returnImagePaths(mSelected));
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                finish();
            }
        }
        
        //to galley
        if (v.getId() == R.id.tv_preview) {
            if (mSelected.size() > 0) {
                GalleryCreator.create(this).openPreviewImagePicker(0, mSelected, mSelected,
                        mCropList, PickerConfig.PICKER_GALLERY_PREVIEW, maxNum, allowSelectOriginal, allowEditImage);
            }
        }
        
    }
    
    @Override
    public void onBackPressed() {
        for (int i = 0; i < mCropList.size(); i++) {
            GalleryUtils.deleteFile(mCropList.get(i));
        }
        finish();
    }
    
    /**
     * change title image status
     */
    private void changeTitleImageAndStatus() {
        if (!isDown) {
            mBaseOptionMenu.showAsDropDown(pickerTitleLayout);
            pictureTitle.setCompoundDrawables(null, null, mDrawableUp, null);
        } else {
            pictureTitle.setCompoundDrawables(null, null, mDrawableDown, null);
            mBaseOptionMenu.dismiss();
        }
        isDown = !isDown;
    }
    
    /**
     * select image changed
     *
     * @param mSelectedImages selected images
     */
    @Override
    public void change(List<LocalMedia> mSelectedImages) {
        if (mSelectedImages.size() > 0) {
            tvCommit.setText("完成"+ "(" + mSelectedImages.size() + ")" );
            tvCommit.setEnabled(true);
            tvPreview.setEnabled(true);
            tvCommit.setBackground(getResources().getDrawable(R.drawable.sure_chose_bg));
            tvPreview.setTextColor(getResources().getColor(R.color.white));
        } else {
            tvCommit.setText("完成");
            tvCommit.setEnabled(false);
            tvPreview.setEnabled(false);
            tvCommit.setBackground(getResources().getDrawable(R.drawable.sure_normal_bg));
            tvPreview.setTextColor(getResources().getColor(R.color.color_666));
        }
        mSelected = mSelectedImages;
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        //click item to gallery
        if (requestCode == PickerConfig.PICKER_GALLERY_RESULT) {
            if (resultCode == RESULT_CANCELED) {
                mSelected = DataHelper.getInstance().getImageSelected();
                mCropList = DataHelper.getInstance().getCropList();
                change(mSelected);
                mGridAdapter.notifySelectedData(mSelected);
            }
            
            if (resultCode == RESULT_OK && data != null && data.hasExtra(GalleryConfig
                    .IMAGE_LIST_SELECTED)) {
                Bundle extras = data.getExtras();
                mSelected = (List<LocalMedia>) extras.getSerializable
                        (GalleryConfig.IMAGE_LIST_SELECTED);
                Intent intent = getIntent();
                Bundle bundle = new Bundle();
                bundle.putStringArrayList(PickerConfig.IMAGE_SELECTED, returnImagePaths(mSelected));
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                finish();
            }
        }
        
        //click to gallery button
        if (requestCode == PickerConfig.PICKER_GALLERY_PREVIEW) {
            if (resultCode == RESULT_CANCELED) {
                mSelected = DataHelper.getInstance().getImageSelected();
                mCropList = DataHelper.getInstance().getCropList();
                List<LocalMedia> images = DataHelper.getInstance().getImages();
                for (int i = 0; i < images.size(); i++) {
                    int index = mLocalMedia.indexOf(images.get(i));
                    mLocalMedia.set(index, images.get(i));
                }
                change(mSelected);
                mGridAdapter.bindData(mLocalMedia);
                mGridAdapter.notifySelectedData(mSelected);
            }
            
            if (resultCode == RESULT_OK && data != null && data.hasExtra(GalleryConfig
                    .IMAGE_LIST_SELECTED)) {
                Bundle extras = data.getExtras();
                mSelected = (List<LocalMedia>) extras.getSerializable
                        (GalleryConfig.IMAGE_LIST_SELECTED);
                Intent intent = getIntent();
                Bundle bundle = new Bundle();
                bundle.putStringArrayList(PickerConfig.IMAGE_SELECTED, returnImagePaths(mSelected));
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                finish();
            }
        }
        
        if (requestCode == PickerConfig.REQUEST_CAMERA && resultCode == RESULT_OK) {
            final File file = new File(imagePath);
            sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(file)));
            
            LocalMedia localMedia = new LocalMedia(imagePath, "image/jpg");
            //add all folder
            LocalMediaFolder firstFolder = mFolders.get(0);
            List<LocalMedia> firstImages = firstFolder.getImages();
            firstImages.add(localMedia);
            firstFolder.setFirstImagePath(imagePath);
            firstFolder.setImageNum(firstFolder.getImageNum() + 1);
            mLocalMedia = firstImages;
            
            //add or new folder's item
            LocalMediaFolder imageFolder = getImageFolder(imagePath, mFolders);
            List<LocalMedia> images = imageFolder.getImages();
            images.add(localMedia);
            imageFolder.setImageNum(imageFolder.getImageNum() + 1);
            
            //updateIsShow
            mGridAdapter.bindData(hasPhoto, mLocalMedia);
            mBaseOptionMenu.notifyAdapterData();
            
        }
        
    }
    
    /**
     * create LocalMediaFolder to save LocalMedia
     *
     * @param path         image path
     * @param imageFolders folder list
     * @return
     */
    private LocalMediaFolder getImageFolder(String path, List<LocalMediaFolder> imageFolders) {
        File imageFile = new File(path);
        File folderFile = imageFile.getParentFile();
        for (LocalMediaFolder folder : imageFolders) {
            if (folder.getName().equals(folderFile.getName())) {
                return folder;
            }
        }
        //create new folder and set the first image's path
        LocalMediaFolder newFolder = new LocalMediaFolder();
        newFolder.setName(folderFile.getName());
        newFolder.setFirstImagePath(path);
        imageFolders.add(newFolder);
        return newFolder;
    }
    
    /**
     * return path
     *
     * @param selected
     * @return
     */
    private ArrayList<String> returnImagePaths(List<LocalMedia> selected) {
        ArrayList<String> mPathList = new ArrayList<>();
        for (LocalMedia local : selected) {
            String path = local.getPath();
            String cropPath = local.getCropPath();
            if (TextUtils.isEmpty(cropPath)) {
                mPathList.add(path);
            } else {
                mPathList.add(cropPath);
            }
        }
        return mPathList;
    }
    
}
