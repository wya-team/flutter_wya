

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WYACameraOrientation) {
    WYACameraOrientationBack,  //后置摄像头
    WYACameraOrientationFront, //前置摄像头
};

typedef void (^SaveMediaBlock)(BOOL isSuccess, NSString * result, NSString * imagePath, NSString * videoPath);

@interface WYACameraTool : NSObject
/// 拍摄模式, 默认AVCaptureSessionPresetMedium
@property (nonatomic, assign) AVCaptureSessionPreset videoPreset;
/// 是否保存至相册
@property (nonatomic, assign) BOOL saveAblum;
/// 自定义相册名
@property (nonatomic, copy) NSString * albumName;
/// 只有在录制完成后才能获取到视频地址,后缀默认为MP4（如果需要保存本地相册，就对应返回系统相册路径）
@property (readonly, nonatomic) NSString * videoPath;
/// 保存图片或视频时的回调
@property (nonatomic, copy) SaveMediaBlock saveMediaBlock;

/**
 初始化

 @param cameraOrientation 相机前置还是后置(init方法默认设置为后置)
 @return self
 */
- (instancetype)initWithCameraOrientation:(WYACameraOrientation)cameraOrientation;

/**
 捕获到的视频呈现的layer

 @return 视频layer
 */
- (AVCaptureVideoPreviewLayer *)previewLayer;

/**
 启动摄影功能
 */
- (void)startRecordFunction;

/**
 关闭摄影功能
 */
- (void)stopRecordFunction;

/**
 开始录制
 */
- (void)startCapture;

/**
 停止录制
 */
- (void)stopCapture;

/**
 开启手电筒
 */
- (void)openFlashLight;

/**
 关闭手电筒
 */
- (void)closeFlashLight;

/**
 开启闪光灯
 */
- (void)openFlash;

/**
 关闭闪光灯
 */
- (void)closeFlash;

/**
 切换前后置摄像头

 @param isFront YES:前置
 */
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;

/**
 拍照

 @param image 回调
 */
- (void)startTakingPhoto:(void (^)(UIImage * image))image;

/**
 获取视频存储本地的路径

 @return 路径
 */
- (NSString *)getVideoPathCache;

/**
 保存图片或本地视频到相册，如果saveAblum为YES，albumName没有值则保存到系统相册

 @param image 图片
 @param videoUrl 本地视频url
 */
- (void)savePhtotsWithImage:(UIImage *)image
                   videoUrl:(NSURL *)videoUrl
                   callBack:(SaveMediaBlock)callback;

@end

@interface WYACameraTool (Authorization)

/**
 相机是否可以用
 */
- (BOOL)isAvailableWithCamera;

/**
 麦克风是否可以用
 */
- (BOOL)isAvailableWithMic;
@end
