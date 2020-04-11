//
//  UIView+WYAToast.h
//  WYAKit
//
//  Created by 李世航 on 2018/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WYAToastImageType) {
    WYAToastImageTypePNG,
    WYAToastImageTypeJPEG,
    WYAToastImageTypeSVG,
    WYAToastImageTypeGIF,
};

@interface UIView (WYAToast)

/// 位于底部的toast提示框
/// @param message 信息
/// @param showTime 展示时间
/// @param fontSize 字体大小
/// @param backgroundColor 背景颜色
/// @param textColor 字体颜色
/// @param use 底部视图用户交互是否打开
+ (void)wya_showBottomToastWithMessage:(NSString *)message
                showTime:(NSInteger)showTime
                fontSize:(double)fontSize
         backgroundColor:(UIColor *)backgroundColor
               textColor:(UIColor *)textColor
bgViewUserInteractionUse:(BOOL)use;


/// 位于屏幕中心的提示框
/// @param message 信息
/// @param showTime 展示时间
/// @param fontSize 字体大小
/// @param backgroundColor 背景颜色
/// @param textColor 字体颜色
/// @param use 底部视图用户交互是否打开
+ (void)wya_showCenterToastWithMessage:(NSString *)message
                showTime:(NSInteger)showTime
                fontSize:(double)fontSize
         backgroundColor:(UIColor *)backgroundColor
               textColor:(UIColor *)textColor
bgViewUserInteractionUse:(BOOL)use;

/**
 图片提示框

 @param imageString 图片名
 @param autoRotation 是否自动旋转
 @param imageType 图片类型
 @param autoDismiss 是否自动隐藏
 */
+ (void)wya_showToastImage:(NSString *)imageString
              autoRotation:(BOOL)autoRotation
                 ImageType:(WYAToastImageType)imageType
               autoDismiss:(BOOL)autoDismiss;

/**
 显示成功的提示框

 @param message 信息
 */
+ (void)wya_successToastWithMessage:(NSString *)message;

/**
 显示失败的提示框

 @param message 信息
 */
+ (void)wya_failToastWithMessage:(NSString *)message;

/**
 显示警告的提示框

 @param message 信息
 */
+ (void)wya_warningToastWithMessage:(NSString *)message;

/**
 图片加文字的提示框

 @param message 信息
 @param imageString 图片名
 @param autoRotation 自动旋转（仅在WYAToastImageTypePNG有效）
 @param imageType 图片类型
 @param autoDismiss 是否需要自动消失
 */
+ (void)wya_toastWithMessage:(NSString *)message
                 imageString:(NSString *)imageString
                autoRotation:(BOOL)autoRotation
                   imageType:(WYAToastImageType)imageType
                 autoDismiss:(BOOL)autoDismiss
    bgViewUserInteractionUse:(BOOL)use;

/**
 请和wya_toastWithMessage配合使用
 */
+ (void)wya_dismissToast;
- (void)wya_setRotationAnimation:(CGFloat)angle time:(CGFloat)time repeatCount:(NSUInteger)repeat;
@end

@interface UILabel (toast)
/**
 获得UILabel宽度

 @param title title
 @param font fon
 @return 返回宽度
 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;
@end

typedef void (^ButtonActionCallBack)(UIButton * button);
@interface UIButton (toast)
- (void)addCallBackAction:(ButtonActionCallBack)action
         forControlEvents:(UIControlEvents)controlEvents;

- (void)addCallBackAction:(ButtonActionCallBack)action;
@end

@interface UIImage (toast)
+ (UIImage *)wya_svgImageName:(NSString *)name size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
