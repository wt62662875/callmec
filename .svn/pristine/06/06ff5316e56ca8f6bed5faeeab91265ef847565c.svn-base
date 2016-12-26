//
//  TripAdressView.m
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TripAdressView.h"
#import "ItemView.h"

@interface TripAdressView ()

//@property (nonatomic,strong) ItemView *userView;
@property (nonatomic,strong) ItemView *timeView;
@property (nonatomic,strong) ItemView *startView;
@property (nonatomic,strong) ItemView *endView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation TripAdressView

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
    /*
    _userView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_userView setTag:0];
    [_userView.leftImageView setImage:[UIImage imageNamed:@"icon_userss"]];
    [_userView setBottomLine:RGBHex(g_gray)];
    [_userView.titleLabel setText:@"本人用车"];
    [_userView.titleLabel setTextColor:RGBHex(g_black)];
    [_userView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_userView.rightImageView setImage:[UIImage imageNamed:@"icon_arrpw"]];
    [_userView setUserInteractionEnabled:YES];
    [_userView setHidden:YES];
     
    UITapGestureRecognizer *h1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripClick:)];
    h1.numberOfTapsRequired = 1;
    h1.numberOfTouchesRequired = 1;
    
    [_userView addGestureRecognizer:h1];
    
    [self addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(self);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    */
    
    _timeView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_timeView setTag:1];
    [_timeView setPlaceHolder:@"请选择出发时间"];
    [_timeView.leftImageView setImage:[UIImage imageNamed:@"icon_time"]];
    [_timeView setBottomLine:RGBHex(g_gray)];
    if (_time) {
        [_timeView.titleLabel setText:_time];
    }
    
    [_timeView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_timeView setImageEdgeInserts:UIEdgeInsetsMake(0, 7, 0, 0)];
    [_timeView setHidden:_isHiddenTime];
    [_timeView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *h2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripClick:)];
    h2.numberOfTapsRequired = 1;
    h2.numberOfTouchesRequired = 1;
    [_timeView addGestureRecognizer:h2];
    [self addSubview:_timeView];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (_userView.hidden) {
//            make.top.equalTo(self);
//        }else{
//            make.top.equalTo(_userView.mas_bottom);
//        }
        make.top.equalTo(self);
        make.height.mas_equalTo(50);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    
    
    _startView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_startView setTag:2];
    [_startView.leftImageView setImage:[UIImage imageNamed:@"icon_qidian_dot_3"]];
    [_startView setBottomLine:RGBHex(g_gray)];
    [_startView setBottomLineEdgeInserts:UIEdgeInsetsMake(0, 35, 0, 0)];
    [_startView setImageEdgeInserts:UIEdgeInsetsMake(0, 7, 0, 0)];
    [_startView setPlaceHolder:@"点击选择开始地点"];
    [_startView setTitleColor:RGBHex(g_black)];
    [_startView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_startView setDownLineColor:RGBHex(g_gray)];
    [_startView setDownEdgeInserts:UIEdgeInsetsMake(0, 14.5, 0, 0)];
    UITapGestureRecognizer *h3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripClick:)];
    h3.numberOfTapsRequired = 1;
    h3.numberOfTouchesRequired = 1;
    [_startView addGestureRecognizer:h3];
    [_startView setUserInteractionEnabled:YES];
    [self addSubview:_startView];
    [_startView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!_isHiddenTime) {
//            if (_userView.hidden) {
                make.top.equalTo(self);
//            }else{
//                make.top.equalTo(_userView.mas_bottom);
//            }
        }else{
            make.top.equalTo(_timeView.mas_bottom);
        }
        make.height.mas_equalTo(50);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    
    _endView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_endView setTag:3];
    [_endView.leftImageView setImage:[UIImage imageNamed:@"icon_qidian_dot_4"]];
    [_endView setImageEdgeInserts:UIEdgeInsetsMake(0, 7, 0, 0)];
//    [_endView.titleLabel setText:@"点击选择目的地"];
    [_endView setPlaceHolder:@"点击选择目的地"];
    [_endView setTitleColor:RGBHex(g_black)];
    [_endView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_endView setUpLineColor:RGBHex(g_gray)];
    [_endView setBottomLine:RGBHex(g_gray)];
    [_endView setBottomLineEdgeInserts:UIEdgeInsetsMake(0, 35, 0, 0)];
    [_endView setUpEdgeInserts:UIEdgeInsetsMake(0, 14.5, 0, 0)];
    UITapGestureRecognizer *h4=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripClick:)];
    h4.numberOfTapsRequired = 1;
    h4.numberOfTouchesRequired = 1;
    [_endView addGestureRecognizer:h4];
    [_endView setUserInteractionEnabled:YES];
    [self addSubview:_endView];
    [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startView.mas_bottom);
        make.height.mas_equalTo(50);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
}

- (void) setEndLocation:(CMLocation *)endLocation
{
    _endLocation = endLocation;
    if (_endLocation.name) {
        [_endView setTitle:_endLocation.name];
    }
    
}

- (void) setStartLocation:(CMLocation *)startLocation
{
    _startLocation = startLocation;
    if (_startLocation.name) {
        [_startView setTitle:_startLocation.name];
    }
    
}

- (void) setIsHiddenTime:(BOOL)isHiddenTime
{
    _isHiddenTime = isHiddenTime;
    [_timeView setHidden:_isHiddenTime];
    if (_isHiddenTime) {
        [_startView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_userView.mas_bottom);
            make.top.equalTo(self);
            make.height.mas_equalTo(50);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
    }else{
        [_startView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_timeView.mas_bottom);
            make.height.mas_equalTo(50);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
        [self layoutIfNeeded];
        [_startView layoutIfNeeded];
    }
}

- (void) tripClick:(UITapGestureRecognizer*)sender
{
    if (_delegate) {
        [_delegate tripViewClick:sender.view];
    }
}

- (void) setTime:(NSString *)time
{
    _time = time;
    [_timeView.titleLabel setText:time];
    [_timeView.titleLabel setTextColor:RGBHex(g_red)];
}

- (void) setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
//    [_userView.titleLabel setText:_headerTitle];
}

- (void) appendView:(UIView*)view
{
    if (_bottomView !=view) {
        _bottomView = view;
    }
    
    [self addSubview:_bottomView];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endView.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(40);
//        make.width.equalTo(self);
        make.width.mas_equalTo(250);
    }];
}
@end
