//
//  CellView.m
//  callmec
//
//  Created by sam on 16/7/17.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CellView.h"
@interface CellView ()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIImageView *indicatorView;
@property (nonatomic,strong) UIView *grayLine;
@end

@implementation CellView


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView
{
    _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pay_1"]];
    [self addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.width.equalTo(self.mas_height).multipliedBy(0.7);
    }];
    
    _indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrpw"]];
    _indicatorView.contentMode = UIViewContentModeCenter;
    [self addSubview:_indicatorView];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.height.width.mas_equalTo(15);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.right.equalTo(_indicatorView.mas_left);
    }];
    
    _descLabel = [[UILabel alloc] init];
    [_descLabel setFont:[UIFont systemFontOfSize:12]];
    [_descLabel setTextColor:RGBHex(@"B8B8B8")];
    [self addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.right.equalTo(_indicatorView.mas_left);
    }];
    
    _grayLine =[[UIView alloc] init];
    [_grayLine setBackgroundColor:RGBHex(g_gray)];
    [self addSubview:_grayLine];
    [_grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.numberOfTapsRequired = 1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:gesture];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:title];
}

- (void) setDesc:(NSString *)desc
{
    _desc = desc;
    [_descLabel setText:_desc];
}

- (void) setIconUrl:(NSString *)iconUrl
{
    _iconUrl = iconUrl;
    if (_iconUrl && [_iconUrl hasPrefix:@"https"]) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_iconUrl] placeholderImage:[UIImage imageNamed:@"icon_pay_1"]];
    }else{
        [_iconView setImage:[UIImage imageNamed:_iconUrl]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) gesture:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [_delegate buttonTarget:self];
    }
}

@end
