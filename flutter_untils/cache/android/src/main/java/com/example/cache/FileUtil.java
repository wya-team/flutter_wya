package com.example.cache;

import android.graphics.Bitmap;
import android.os.Environment;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * @date: 2018/12/5 14:04
 * @author: Chunjiang Mao
 * @classname: FileUtil
 * @describe: 文件工具类
 */

public class FileUtil {
    private static final File PARENT_PATH = Environment.getExternalStorageDirectory();
    private static String storagePath = "";
    private static String DST_FOLDER_NAME = "mcj";

    /**
     * 初始化路径,创建文件
     *
     * @return
     */
    private static String initPath(String dir) {
        File f = new File(dir);
        if (!f.exists()) {
            f.mkdir();
        }
        return dir;
    }

    /**
     * 保存图片
     *
     * @param dir
     * @param b
     * @return
     */
    public static String saveBitmap(String dir, Bitmap b) {
        String path = initPath(dir);
        long dataTake = System.currentTimeMillis();
        String jpegName = path + File.separator + "picture_" + dataTake + ".jpg";
        try {
            FileOutputStream fout = new FileOutputStream(jpegName);
            BufferedOutputStream bos = new BufferedOutputStream(fout);
            b.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bos.flush();
            bos.close();
            return jpegName;
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 删除文件
     *
     * @param path
     * @return
     */
    public static boolean deleteFile(String path) {
        boolean result = false;
        File file = new File(path);
        if (file.exists()) {
            result = file.delete();
        }
        return result;
    }

    /**
     * 判断是否存在SD卡
     *
     * @return
     */
    public static boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        }
        return false;
    }

}
