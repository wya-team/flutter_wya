package com.weiyian.www.native_gallery.gallery;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;
import androidx.viewpager.widget.PagerAdapter;

import com.bumptech.glide.Glide;
import com.weiyian.www.native_gallery.R;
import com.weiyian.www.native_gallery.gallery.photoview.PhotoView;

import java.io.File;
import java.util.List;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description :
 */
public class PreviewPagerAdapter extends PagerAdapter {
    private static final String TYPE = "MPEG/MPG/DAT/AVI/MOV/ASF/WMV/NAVI/3GP/MKV/FLV/F4V/RMVB/WEBM/MP4";
    private List<String> mList;
    private Context mContext;
    private int changePosition = -1;
    
    public PreviewPagerAdapter(List<String> list, Context context) {
        mList = list;
        mContext = context;
    }
    
    public void updateData(int position) {
        changePosition = position;
        notifyDataSetChanged();
    }
    
    @Override
    public int getCount() {
        if (mList != null) {
            return mList.size();
        }
        return 0;
    }
    
    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }
    
    @Override
    public int getItemPosition(@NonNull Object object) {
        View view = (View) object;
        int tag = (int) view.getTag();
        if (tag == changePosition) {
            return POSITION_NONE;
        } else {
            return POSITION_UNCHANGED;
        }
    }
    
    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }
    
    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        final View contentView = LayoutInflater.from(container.getContext())
                .inflate(R.layout.preview_item, container, false);
        final PhotoView imageView = contentView.findViewById(R.id.preview_image);
        ImageView play = contentView.findViewById(R.id.preview_video_play);
        String imageUrl = mList.get(position);
        Glide.with(mContext).load(imageUrl).into(imageView);
        
        contentView.setTag(position);
        
        String[] split = imageUrl.split("[.]");
        String mediaType = split[split.length - 1];
        play.setVisibility(isVideo(mediaType) ? View.VISIBLE : View.INVISIBLE);
        play.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                File file = new File(imageUrl);
                Uri uri;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    uri = FileProvider.getUriForFile(mContext, mContext.getPackageName() + ".fileprovider", file);
                } else {
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    uri = Uri.fromFile(file);
                }
                
                intent.setDataAndType(uri, "video/" + mediaType);
                if (intent.resolveActivity(mContext.getPackageManager()) != null) {
                    mContext.startActivity(intent);
                } else {
                    Toast.makeText(mContext, "没有播放器可以播放视频", Toast.LENGTH_SHORT).show();
                }
            }
        });
        container.addView(contentView, 0);
        return contentView;
    }
    
    private boolean isVideo(String mediaType) {
        return TYPE.contains(mediaType.toUpperCase());
    }
}
