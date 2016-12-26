//
//  ItemView.m
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "ItemView.h"

@interface ItemView()
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *upView;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,strong) UILabel *contentLabel;
@end

@implementation ItemView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView
{
    _leftImageView =[[UIImageView alloc] init];
    [self addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.height.width.mas_equalTo(20);
    }];
    
    _titleLabel =[[UILabel alloc] init];
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_leftImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    _contentLabel =[[UILabel alloc] init];
    [_contentLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
    
    _rightImageView =[[UIImageView alloc] init];
    [self addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
    }];
}

- (void) setBottomLine:(UIColor*)color
{
    if (!_bottomView) {
        _bottomView =[[UIView alloc] init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    [_bottomView setBackgroundColor:color];
}

- (void) setBottomLineEdgeInserts:(UIEdgeInsets)lineEdgeInserts
{
    _bottomLineEdgeInserts = lineEdgeInserts;
    if (!_bottomView) {
        _bottomView =[[UIView alloc] init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.left.equalTo(self).offset(lineEdgeInserts.left);
            make.right.equalTo(self).offset(lineEdgeInserts.right);
            make.height.mas_equalTo(1);
        }];
    }
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.bottomLineEdgeInserts.left);
        make.right.equalTo(self).offset(self.bottomLineEdgeInserts.right);
    }];
}

- (void) setImageEdgeInserts:(UIEdgeInsets)imageEdgeInserts
{
    _imageEdgeInserts= imageEdgeInserts;
    [_leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_imageEdgeInserts.left!=0) {
            make.left.equalTo(self).offset(_imageEdgeInserts.left);
        }
        if (_imageEdgeInserts.top!=0) {
            make.top.equalTo(self).offset(_imageEdgeInserts.top);
        }
        if (_imageEdgeInserts.bottom!=0) {
            make.bottom.equalTo(self).offset(_imageEdgeInserts.bottom);
        }
    }];
}

- (void) setUpLineColor:(UIColor*)color
{
    if (!_upView) {
        _upView = [[UIView alloc] init];
        [self addSubview:_upView];
        [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.centerX.equalTo(_leftImageView);
            make.bottom.equalTo(_leftImageView.mas_top);
            make.width.mas_equalTo(1);
        }];
    }
    [_upView setBackgroundColor:color];
}
- (void) setDownLineColor:(UIColor*)color
{
    if (!_downView) {
        _downView = [[UIView alloc] init];
        [self addSubview:_downView];
        [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftImageView.mas_bottom);
            make.centerX.equalTo(_leftImageView);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }
    [_downView setBackgroundColor:color];
}

- (void) setUpEdgeInserts:(UIEdgeInsets)upEdgeInserts
{
    _upEdgeInserts = upEdgeInserts;
    if (!_upView) {
        _upView = [[UIView alloc] init];
        [self addSubview:_upView];
        [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.centerX.equalTo(_leftImageView);
            make.bottom.equalTo(_leftImageView.mas_top);
            make.width.mas_equalTo(1);
        }];
    }
    
//    [_upView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (_upEdgeInserts.left!=0) {
//            make.left.equalTo(self).offset(_upEdgeInserts.left);
//        }
//        if (_upEdgeInserts.top!=0) {
//            make.top.equalTo(self).offset(_upEdgeInserts.top);
//        }
//        if (_upEdgeInserts.bottom!=0) {
//            make.bottom.equalTo(self).offset(_upEdgeInserts.bottom);
//        }
//    }];
}

- (void) setDownEdgeInserts:(UIEdgeInsets)downEdgeInserts
{
    _downEdgeInserts = downEdgeInserts;
    if (!_downView) {
        _downView = [[UIView alloc] init];
        [self addSubview:_downView];
        [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.centerX.equalTo(_leftImageView);
            make.height.equalTo(_leftImageView.mas_bottom);
            make.width.mas_equalTo(1);
        }];
    }
    
//    [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (_downEdgeInserts.left!=0) {
//            make.left.equalTo(self).offset(_downEdgeInserts.left);
//        }
//        if (_downEdgeInserts.top!=0) {
//            make.top.equalTo(self).offset(_downEdgeInserts.top);
//        }
//        if (_downEdgeInserts.bottom!=0) {
//            make.bottom.equalTo(self).offset(_downEdgeInserts.bottom);
//        }
//    }];
}

- (void) setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    [_titleLabel setText:_placeHolder];
    [_titleLabel setTextColor:RGBHex(g_assit_c)];
}

- (void) setTitle:(NSString *)title{
    _title = title;
    if (!_title || [title length]==0) {
        [_titleLabel setTextColor:RGBHex(g_assit_c)];
        [_titleLabel setText:_placeHolder];

    }else{
        if(_titleColor)[_titleLabel setTextColor:_titleColor];
        [_titleLabel setText:_title];
    }
    
}

- (void) setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
}
@end
