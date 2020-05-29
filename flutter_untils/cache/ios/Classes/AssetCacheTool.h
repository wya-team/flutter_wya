

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>


typedef void (^SaveMediaBlock)(BOOL isSuccess, NSString * result, NSString * imagePath, NSString * videoPath);

@interface AssetCacheTool : NSObject
/// 是否保存至自定义相册，默认为bundle_name
@property (nonatomic, assign) BOOL saveAblum;
/// 自定义相册名
@property (nonatomic, copy) NSString * albumName;
/// 保存图片或视频时的回调
@property (nonatomic, copy) SaveMediaBlock saveMediaBlock;

/**
 保存图片或本地视频到相册，如果saveAblum为YES，albumName没有值则保存到系统相册

 @param image 图片
 @param videoUrl 本地视频url
 */
- (void)savePhtots:(UIImage * _Nullable)image videoUrl:(NSURL * _Nullable)videoUrl callBack:(SaveMediaBlock)callback;

@end
