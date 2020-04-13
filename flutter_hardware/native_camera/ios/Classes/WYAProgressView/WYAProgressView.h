//
//  WYAProgress.h
//  WYAKit
//
//  Created by 李世航 on 2018/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WYAProgressViewStyle) {
    WYAProgressViewStyleStraight,
    WYAProgressViewStyleCircle,
};

@interface WYAProgressView : UIView
/// 背景图片
@property (nonatomic, strong) UIImage * backgroundImage UI_APPEARANCE_SELECTOR;
/// 背景线的颜色
@property (nonatomic, strong) UIColor * trackTintColor UI_APPEARANCE_SELECTOR;
/// 填充线的颜色
@property (nonatomic, strong) UIColor * progressTintColor UI_APPEARANCE_SELECTOR;
/// 线宽
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
/// 进度（0~1）
@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame progressViewStyle:(WYAProgressViewStyle)style;

/**
 设置进度

 @param progress 进度
 @param animation 是否动画
 */
- (void)wya_setProgress:(CGFloat)progress Animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
