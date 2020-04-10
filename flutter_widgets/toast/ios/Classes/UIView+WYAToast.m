//
//  UIView+WYAToast.m
//  WYAKit
//
//  Created by 李世航 on 2018/11/21.
//

#import "UIView+WYAToast.h"
#import <Masonry/Masonry.h>
//#import <SVGKit/SVGKit.h>
#import <objc/runtime.h>

#define Window                  ([UIApplication sharedApplication].keyWindow)
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SizeAdapter ScreenWidth/375
#define FONT(s) [UIFont systemFontOfSize:s]

@implementation UIView (WYAToast)

+ (void)wya_showBottomToastWithMessage:(NSString *)message
                              showTime:(NSInteger)showTime
                              fontSize:(double)fontSize
                       backgroundColor:(UIColor *)backgroundColor
                             textColor:(UIColor *)textColor
              bgViewUserInteractionUse:(BOOL)use
{
    UIView * tagView = [Window viewWithTag:17858629000];
    if (tagView) {
        [tagView removeFromSuperview];
    }
    UIButton * button             = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame                  = Window.bounds;
    button.userInteractionEnabled = use;
    button.tag                    = 17858629000;
    [button addCallBackAction:^(UIButton * button) { [button removeFromSuperview]; }];
    [Window addSubview:button];

    UIView * view            = [[UIView alloc] init];
    view.backgroundColor     = backgroundColor;
    view.layer.cornerRadius  = 5 * SizeAdapter;
    view.layer.masksToBounds = YES;
    [button addSubview:view];

    UILabel * label     = [[UILabel alloc] init];
    label.font          = FONT(fontSize);
    label.text          = message;
    label.textColor     = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];

    CGFloat width = [UILabel getWidthWithTitle:message font:label.font];
    if (width > ScreenWidth / 2) {
        width = ScreenWidth / 2;
    }
    CGFloat height =
    [UILabel getHeightByWidth:width
                        title:message
                         font:label.font];

    [view mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerX.mas_equalTo(Window.mas_centerX);
        make.bottom.mas_equalTo(Window.mas_bottom).with.offset(-50 * SizeAdapter);
        make.width.mas_equalTo(width + 44 * SizeAdapter);
        if (width < ScreenWidth / 2) {
            make.height.mas_equalTo(30 * SizeAdapter);
        } else {
            make.height.mas_equalTo(height + 10 * SizeAdapter);
        }

    }];
    [label mas_makeConstraints:^(MASConstraintMaker * make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 22 * SizeAdapter, 0, 22 * SizeAdapter));
    }];

    [UIView animateWithDuration:0.3
                          delay:showTime
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        label.alpha = 0;
        view.alpha  = 0;
    }
    completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];
}

+ (void)wya_showCenterToastWithMessage:(NSString *)message
                              showTime:(NSInteger)showTime
                              fontSize:(double)fontSize
                       backgroundColor:(UIColor *)backgroundColor
                             textColor:(UIColor *)textColor
              bgViewUserInteractionUse:(BOOL)use
{
    UIView * tagView = [Window viewWithTag:17858629000];
    if (tagView) {
        [tagView removeFromSuperview];
    }
    UIButton * button             = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame                  = Window.bounds;
    button.userInteractionEnabled = use;
    button.tag                    = 17858629000;
    [button addCallBackAction:^(UIButton * button) { [button removeFromSuperview]; }];
    [Window addSubview:button];

    UIView * view            = [[UIView alloc] init];
    view.backgroundColor     = random(77, 77, 77, 1);
    view.layer.cornerRadius  = 5 * SizeAdapter;
    view.layer.masksToBounds = YES;
    [button addSubview:view];

    UILabel * label     = [[UILabel alloc] init];
    label.font          = [UIFont systemFontOfSize:15 * SizeAdapter];
    label.text          = message;
    label.textColor     = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];

    CGFloat width = [UILabel getWidthWithTitle:message font:label.font];
    if (width > ScreenWidth / 2) {
        width = ScreenWidth / 2;
    }
    CGFloat height =
    [UILabel getHeightByWidth:width
                        title:message
                         font:label.font];
    [view mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerX.mas_equalTo(Window.mas_centerX);
        make.centerY.mas_equalTo(Window.mas_centerY);
        make.width.mas_equalTo(width + 44 * SizeAdapter);
        if (width < ScreenWidth / 2) {
            make.height.mas_equalTo(30 * SizeAdapter);
        } else {
            make.height.mas_equalTo(height + 10 * SizeAdapter);
        }
    }];
    [label mas_makeConstraints:^(MASConstraintMaker * make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 22 * SizeAdapter, 0, 22 * SizeAdapter));
    }];

    [UIView animateWithDuration:0.3
    delay:2
    options:UIViewAnimationOptionAllowUserInteraction
    animations:^{
        label.alpha = 0;
        view.alpha  = 0;
    }
    completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];
}

+ (void)wya_showToastImage:(NSString *)imageString
              autoRotation:(BOOL)autoRotation
                 ImageType:(WYAToastImageType)imageType
               autoDismiss:(BOOL)autoDismiss
{
    [UIView wya_toastWithMessage:@""
                     imageString:imageString
                    autoRotation:autoRotation
                       imageType:imageType
                     autoDismiss:autoDismiss
        bgViewUserInteractionUse:NO];
}

+ (void)wya_successToastWithMessage:(NSString *)message
{
    [UIView wya_toastWithMessage:message
                     imageString:@"icon_succesful"
                    autoRotation:NO
                       imageType:WYAToastImageTypePNG
                     autoDismiss:YES
        bgViewUserInteractionUse:NO];
}

+ (void)wya_failToastWithMessage:(NSString *)message
{
    [UIView wya_toastWithMessage:message
                     imageString:@"icon_fail"
                    autoRotation:NO
                       imageType:WYAToastImageTypePNG
                     autoDismiss:YES
        bgViewUserInteractionUse:NO];
}

+ (void)wya_warningToastWithMessage:(NSString *)message
{
    [UIView wya_toastWithMessage:message
                     imageString:@"icon_waring"
                    autoRotation:NO
                       imageType:WYAToastImageTypePNG
                     autoDismiss:YES
        bgViewUserInteractionUse:NO];
}

+ (void)wya_toastWithMessage:(NSString *)message
                 imageString:(NSString *)imageString
                autoRotation:(BOOL)autoRotation
                   imageType:(WYAToastImageType)imageType
                 autoDismiss:(BOOL)autoDismiss
    bgViewUserInteractionUse:(BOOL)use
{
    UIButton * button;
    if (autoDismiss) {
        button                        = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame                  = Window.bounds;
        button.userInteractionEnabled = use;
        [Window addSubview:button];
        [button addCallBackAction:^(UIButton * button) { [button removeFromSuperview]; }];
    }
    UIView * view            = [[UIView alloc] init];
    view.backgroundColor     = random(77, 77, 77, 1);
    view.layer.cornerRadius  = 5 * SizeAdapter;
    view.layer.masksToBounds = YES;
    view.tag                 = 1080;
    if (button) {
        [button addSubview:view];
    } else {
        [Window addSubview:view];
    }

    UIView * iview;
    switch (imageType) {
        case WYAToastImageTypePNG: {
            UIImage * image = [UIImage imageNamed:imageString];

            iview = [[UIImageView alloc] initWithImage:image];
            if (autoRotation) {
                [iview wya_setRotationAnimation:360 time:1 repeatCount:0];
            }
        } break;
        case WYAToastImageTypeJPEG: {
            UIImage * image = [UIImage imageNamed:imageString];
            iview = [[UIImageView alloc] initWithImage:image];

        } break;
        case WYAToastImageTypeSVG: {
//            UIImage * image;
//            image = [UIImage wya_svgImageName:imageString
//            size:CGSizeMake(30 * SizeAdapter, 30 * SizeAdapter)];
//            iview = [[UIImageView alloc] initWithImage:image];
//            if (autoRotation) {
//                [iview wya_setRotationAnimation:360 time:1 repeatCount:0];
//            }
        } break;
        case WYAToastImageTypeGIF: {
//            NSLog(@"%d", isSource);
//            NSAssert(isSource == NO, @"只加载项目中的gif图片");
//            UIImage * image = [YYImage imageNamed:imageString];
//            iview           = [[YYAnimatedImageView alloc] initWithImage:image];
        } break;
        default:
            break;
    }
    [view addSubview:iview];

    UILabel * label           = [[UILabel alloc] init];
    label.font                = FONT(13);
    label.text                = message;
    label.textColor           = [UIColor whiteColor];
    label.textAlignment       = NSTextAlignmentCenter;
    label.layer.cornerRadius  = 5 * SizeAdapter;
    label.layer.masksToBounds = YES;

    [view addSubview:label];
    CGFloat width = [UILabel getWidthWithTitle:message font:FONT(13)];
    if (width > 90 * SizeAdapter) {
        label.numberOfLines = 0;
    } else {
        label.numberOfLines = 1;
    }
    CGFloat height = [UILabel getHeightByWidth:90 * SizeAdapter title:label.text font:label.font];
    if (message.length < 1) {
        height = 0;
    }
    CGFloat hei = 50 * SizeAdapter + height;

    CGFloat view_X      = (ScreenWidth - 100 * SizeAdapter) / 2;
    CGFloat view_Y      = (ScreenHeight - hei) / 2;
    CGFloat view_Width  = 100 * SizeAdapter;
    CGFloat view_Height = hei;
    view.frame          = CGRectMake(view_X, view_Y, view_Width, view_Height);

    CGFloat iview_X      = (view.frame.size.width - 30 * SizeAdapter) / 2;
    CGFloat iview_Y      = 10 * SizeAdapter;
    CGFloat iview_Width  = 30 * SizeAdapter;
    CGFloat iview_Height = 30 * SizeAdapter;
    iview.frame          = CGRectMake(iview_X, iview_Y, iview_Width, iview_Height);

    CGFloat label_X      = 5 * SizeAdapter;
    CGFloat label_Y      = CGRectGetMaxY(iview.frame) + 5 * SizeAdapter;
    CGFloat label_Width  = view.frame.size.width - 10 * SizeAdapter;
    CGFloat label_Height = height;
    label.frame          = CGRectMake(label_X, label_Y, label_Width, label_Height);

    if (autoDismiss) {
        [UIView animateWithDuration:0.3
        delay:2
        options:UIViewAnimationOptionAllowUserInteraction
        animations:^{ view.alpha = 0; }
        completion:^(BOOL finished) { [button removeFromSuperview]; }];
    } else {
        Window.userInteractionEnabled = NO;
    }
}

+ (void)wya_dismissToast
{
    UIView * view = (UIView *)[Window viewWithTag:1080];
    [view removeFromSuperview];
    Window.userInteractionEnabled = YES;
}

- (void)wya_setRotationAnimation:(CGFloat)angle time:(CGFloat)time repeatCount:(NSUInteger)repeat
{
    CABasicAnimation * rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue    = [NSNumber numberWithFloat:(M_PI / 180.f) * angle];
    rotationAnimation.duration   = time;
    rotationAnimation.cumulative = (NSInteger)angle % 360 ? NO : YES;
    if (repeat) {
        rotationAnimation.repeatCount = repeat;
    } else {
        rotationAnimation.repeatCount = MAXFLOAT;
    }

    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end


@implementation UILabel (toast)

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text      = title;
    label.font      = font;
    [label sizeToFit];
    return label.frame.size.width;
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text          = title;
    label.font          = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

@end


@implementation UIButton (toast)

- (void)addCallBackAction:(ButtonActionCallBack)action
         forControlEvents:(UIControlEvents)controlEvents
{
    objc_setAssociatedObject(self, @selector(addCallBackAction:forControlEvents:), action,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(blockActionTouched:) forControlEvents:controlEvents];
}

- (void)addCallBackAction:(ButtonActionCallBack)action
{
    [self addCallBackAction:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)blockActionTouched:(UIButton *)btn
{
    ButtonActionCallBack block =
    objc_getAssociatedObject(self, @selector(addCallBackAction:forControlEvents:));
    if (block) {
        block(btn);
    }
}

@end
