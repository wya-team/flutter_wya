//
//  WYACameraPreviewImageView.m
//  WYAKit
//
//  Created by 李世航 on 2018/12/8.
//

#import "WYACameraPreviewImageView.h"
#import <Masonry/Masonry.h>

@interface WYACameraPreviewImageView ()
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * finishButton;
@property (nonatomic, strong) UIButton * editButton;
@end

@implementation WYACameraPreviewImageView
#pragma mark ======= LifeCircle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.editButton mas_remakeConstraints:^(MASConstraintMaker * make) {
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(230);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker * make) {
        make.centerY.mas_equalTo(self.editButton.mas_centerY);
        make.right.mas_equalTo(self.editButton.mas_left)
        .with.offset(-(self.frame.size.width - 180) / 4);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    [self.finishButton mas_remakeConstraints:^(MASConstraintMaker * make) {
        make.centerY.mas_equalTo(self.editButton.mas_centerY);
        make.left.mas_equalTo(self.editButton.mas_right)
        .with.offset((self.frame.size.width - 180) / 4);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark - Private Method -
- (void)setup
{
    [self addSubview:self.cancelButton];
    [self addSubview:self.editButton];
    [self addSubview:self.finishButton];
}

- (void)cancelClick{
    if (self.cancelHandle) {
        self.cancelHandle();
    }
}

- (void)finishClick{
    if (self.finishHandle) {
        self.finishHandle(self.image);
    }
}

- (void)editClick{
    if (self.editHandle) {
        self.editHandle(self.image);
    }
}

#pragma mark - Getter -
- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton * object = [[UIButton alloc] init];
            [object setImage:[UIImage imageNamed:@"icon_camera_back"]
                    forState:UIControlStateNormal];
            [object addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
            object;
        });
    }
    return _cancelButton;
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = ({
            UIButton * object = [[UIButton alloc] init];
            [object setImage:[UIImage imageNamed:@"icon_camera_save"]
                    forState:UIControlStateNormal];
            [object addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
            object;
        });
    }
    return _finishButton;
}

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = ({
            UIButton * object = [[UIButton alloc] init];
            [object setImage:[UIImage imageNamed:@"icon_camera_list"]
                    forState:UIControlStateNormal];
            [object addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
            object;
        });
    }
    return _editButton;
}

@end
