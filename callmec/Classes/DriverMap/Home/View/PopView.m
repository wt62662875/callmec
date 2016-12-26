//
//  PopView.m
//  callmec
//
//  Created by sam on 16/6/30.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "PopView.h"

@interface PopView()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *leftTimeLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation PopView

- (instancetype) initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
    }
    return  self;
}

- (instancetype) init
{
    self =[super init];
    if ( self) {
        [self initView];
    }
    
    return self;
}

- (void) initView
{
    
    NSLog(@"initViewinitView");
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhelishangche"]];
    [self addSubview:imageView];
    _titleLabel = [[UILabel alloc] init];
    _leftTimeLabel = [[UILabel alloc] init];
    _lineView = [[UIView alloc] init];

    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_leftTimeLabel setTextColor:[UIColor whiteColor]];
    [_leftTimeLabel setFont:[UIFont systemFontOfSize:13]];
    [_titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [self addSubview:_leftTimeLabel];
    [self addSubview:_lineView];
    [self addSubview:_titleLabel];
    [_lineView setBackgroundColor:RGBHex(g_gray)];//RGBHex(g_gray)
    
    [_leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
//        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(3);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
//        make.bottom.equalTo(self);
        make.left.equalTo(_lineView.mas_right).offset(2);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-28);
        make.left.equalTo(_leftTimeLabel.mas_right).offset(3);
        make.width.mas_equalTo(1);
    }];
}

-(void) setTitle:(NSString *)title
{
    [_titleLabel setText:title];
}

- (void) setLeftTime:(NSString *)leftTime
{
    [_leftTimeLabel setText:leftTime];
}

- (void) setCornerRadius:(CGFloat)f
{
    self.layer.cornerRadius = f;
    self.layer.masksToBounds = YES;
}

@end
