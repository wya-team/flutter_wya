package com.weiyian.www.native_gallery.imagecrop;

import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;


import com.weiyian.www.native_gallery.R;
import com.weiyian.www.native_gallery.imagecrop.core.EditMode;
import com.weiyian.www.native_gallery.imagecrop.core.util.Utils;
import com.weiyian.www.native_gallery.imagecrop.view.EditView;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description : 裁剪界面
 */
public class CropActivity extends AppCompatActivity implements View.OnClickListener {
    
    public static final String EXTRA_IMAGE_URI = "IMAGE_URI";
    public static final String EXTRA_IMAGE_SAVE_PATH = "IMAGE_SAVE_PATH";
    public static final String EXTRA_IMAGE_SAVE_QUALITY = "EXTRA_IMAGE_SAVE_QUALITY";
    private static final int MAX_HEIGHT = 1024;
    private static final int MAX_WIDTH = 1024;
    private EditView cropView;
    private LinearLayout clipTopLayout;
    private FrameLayout clipBottomLayout;
    private ImageButton ibClipRotate;
    private int quality = 100;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crop);
        setColor();
        initView();
        Bitmap bitmap = getBitmap();
        if (bitmap != null) {
            cropView.setImageBitmap(bitmap);
        } else {
            Toast.makeText(this, "请确认图片是否存在!", Toast.LENGTH_SHORT).show();
            finish();
        }
        
        cropView.postDelayed(new Runnable() {
            @Override
            public void run() {
                cropView.setMode(EditMode.CLIP);
            }
        }, 500);
        
    }
    
    /**
     * 设置状态栏颜色
     */
    
    public void setColor() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            getWindow().setStatusBarColor(getResources().getColor(R.color.black));
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            ViewGroup decorView = (ViewGroup) getWindow().getDecorView();
//            View fakeStatusBarView = decorView.findViewById(R.id
//                    .statusbarutil_fake_status_bar_view);
//            if (fakeStatusBarView != null) {
//                if (fakeStatusBarView.getVisibility() == View.GONE) {
//                    fakeStatusBarView.setVisibility(View.VISIBLE);
//                }
//                fakeStatusBarView.setBackgroundColor(getResources().getColor(R.color.black));
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
    
    private void initView() {
        cropView = findViewById(R.id.crop_view);
        clipTopLayout = findViewById(R.id.clip_top_layout);
        clipBottomLayout = findViewById(R.id.clip_bottom_layout);
        ibClipRotate = findViewById(R.id.ib_clip_rotate);
        findViewById(R.id.clip_reset).setOnClickListener(this);
        findViewById(R.id.clip_sure).setOnClickListener(this);
        findViewById(R.id.ib_clip_rotate).setOnClickListener(this);
        findViewById(R.id.ib_clip_cancel).setOnClickListener(this);
        findViewById(R.id.tv_clip_reset).setOnClickListener(this);
        findViewById(R.id.ib_clip_done).setOnClickListener(this);
        clipTopLayout.setVisibility(View.GONE);
        clipBottomLayout.setVisibility(View.VISIBLE);
        ibClipRotate.setVisibility(View.VISIBLE);
    }
    
    private Bitmap getBitmap() {
        Intent intent = getIntent();
        if (intent == null) {
            return null;
        }
        
        Uri uri = intent.getParcelableExtra(EXTRA_IMAGE_URI);
        if (uri == null) {
            return null;
        }
        
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inSampleSize = 1;
        options.inJustDecodeBounds = true;
        options.inPreferredConfig = Bitmap.Config.RGB_565;
        
        if (options.outWidth > MAX_WIDTH) {
            options.inSampleSize = Utils.inSampleSize(Math.round(1f * options.outWidth /
                    MAX_WIDTH));
        }
        
        if (options.outHeight > MAX_HEIGHT) {
            options.inSampleSize = Math.max(options.inSampleSize,
                    Utils.inSampleSize(Math.round(1f * options.outHeight / MAX_HEIGHT)));
        }
        
        options.inJustDecodeBounds = false;
        
        ContentResolver contentResolver = getContentResolver();
        Bitmap bitmap = null;
        try {
            bitmap = BitmapFactory.decodeStream(contentResolver.openInputStream(uri), null,
                    options);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        if (bitmap == null) {
            return null;
        }
        
        return bitmap;
    }
    
    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.clip_sure) {
            String path = getIntent().getStringExtra(EXTRA_IMAGE_SAVE_PATH);
            if (!TextUtils.isEmpty(path)) {
                quality = getIntent().getIntExtra(EXTRA_IMAGE_SAVE_QUALITY, 80);
                Bitmap bitmap = cropView.saveBitmap();
                if (bitmap != null) {
                    FileOutputStream fout = null;
                    try {
                        fout = new FileOutputStream(path);
                        bitmap.compress(Bitmap.CompressFormat.JPEG, quality, fout);
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    } finally {
                        if (fout != null) {
                            try {
                                fout.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    Intent intent = getIntent();
                    intent.putExtra("path", path);
                    setResult(RESULT_OK, intent);
                    finish();
                    return;
                }
            }
            setResult(RESULT_CANCELED);
            finish();
        }
        
        if (v.getId() == R.id.clip_reset) {
            cropView.setMode(EditMode.CLIP);
            clipTopLayout.setVisibility(View.GONE);
            clipBottomLayout.setVisibility(View.VISIBLE);
            ibClipRotate.setVisibility(View.VISIBLE);
        }
        if (v.getId() == R.id.ib_clip_rotate) {
            cropView.doRotate();
        }
        if (v.getId() == R.id.ib_clip_cancel) {
            setResult(RESULT_CANCELED);
            finish();
        }
        if (v.getId() == R.id.tv_clip_reset) {
            cropView.resetClip();
        }
        if (v.getId() == R.id.ib_clip_done) {
            cropView.doClip();
            clipTopLayout.setVisibility(View.VISIBLE);
            clipBottomLayout.setVisibility(View.GONE);
            ibClipRotate.setVisibility(View.GONE);
        }
    }
}
