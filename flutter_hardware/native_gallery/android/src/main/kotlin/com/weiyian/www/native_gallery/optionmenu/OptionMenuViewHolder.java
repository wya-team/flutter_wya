package com.weiyian.www.native_gallery.optionmenu;

import android.util.SparseArray;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.IdRes;
import androidx.annotation.StringRes;
import androidx.recyclerview.widget.RecyclerView;

/**
 * @author : XuDonglin
 * @time : 2019-01-10
 * @description :
 */
public class OptionMenuViewHolder extends RecyclerView.ViewHolder {
    private SparseArray<View> mView;
    
    public OptionMenuViewHolder(View itemView) {
        super(itemView);
        mView = new SparseArray<>();
    }
    
    public <T extends View> T getView(@IdRes int viewId) {
        View view = mView.get(viewId);
        if (view == null) {
            view = itemView.findViewById(viewId);
            mView.put(viewId, view);
        }
        return (T) view;
    }
    
    public OptionMenuViewHolder setText(@IdRes int id, String value) {
        TextView view = getView(id);
        view.setText(value);
        return this;
    }
    
    public OptionMenuViewHolder setText(@IdRes int id, @StringRes int value) {
        TextView view = getView(id);
        view.setText(value);
        return this;
    }
    
}
