package com.weiyian.www.native_gallery.imagepicker;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description : 本地媒体文件夹类
 */
public class LocalMediaFolder implements Parcelable {
    public static final Creator<LocalMediaFolder> CREATOR = new Creator<LocalMediaFolder>() {
        @Override
        public LocalMediaFolder createFromParcel(Parcel in) {
            return new LocalMediaFolder(in);
        }
        
        @Override
        public LocalMediaFolder[] newArray(int size) {
            return new LocalMediaFolder[size];
        }
    };
    private String name;
    private List<LocalMedia> mImages;
    private int imageNum;
    private String firstImagePath;
    
    public LocalMediaFolder() {
    }
    
    protected LocalMediaFolder(Parcel in) {
        name = in.readString();
        mImages = in.createTypedArrayList(LocalMedia.CREATOR);
        imageNum = in.readInt();
        firstImagePath = in.readString();
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public List<LocalMedia> getImages() {
        if (mImages == null) {
            mImages = new ArrayList<>();
        }
        return mImages;
    }
    
    public void setImages(List<LocalMedia> images) {
        mImages = images;
    }
    
    public int getImageNum() {
        return imageNum;
    }
    
    public void setImageNum(int imageNum) {
        this.imageNum = imageNum;
    }
    
    public String getFirstImagePath() {
        return firstImagePath;
    }
    
    public void setFirstImagePath(String firstImagePath) {
        this.firstImagePath = firstImagePath;
    }
    
    @Override
    public int describeContents() {
        return 0;
    }
    
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(name);
        dest.writeString(firstImagePath);
        dest.writeList(mImages);
        dest.writeInt(imageNum);
    }
}
