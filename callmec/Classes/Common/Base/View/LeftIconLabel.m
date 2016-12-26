//
//  LeftIconLabel.m
//  callmec
//
//  Created by sam on 16/7/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "LeftIconLabel.h"

@interface LeftIconLabel()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation LeftIconLabel


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
    _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    [self addSubview:_iconView];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.width.height.mas_equalTo(15);
        
    }];
    
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    if (_imageUrl && [_imageUrl hasPrefix:@"http://"]) {
        [_iconView sd_setCircleImageWithURL:_imageUrl placeholderImage:[UIImage imageNamed:@"icon_userss"]];
    }else{
        [_iconView setImage:[UIImage imageNamed:_imageUrl]];
    }
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    CGSize size = [title sizeFont:15];
    [_titleLabel setText:_title];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(size.height+10);
    }];
}

- (void) setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [_titleLabel setFont:_titleFont];
}

- (void) setImageH:(CGFloat)imageH
{

    _imageH = imageH;
    if (imageH>0 && imageH <1.0) {
        [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.width.height.equalTo(self.mas_height).multipliedBy(_imageH);
        }];
    }else{
        [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.width.height.mas_equalTo(_imageH);
        }];
    }
}

- (void) setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    [self addSubview:_lineView];
    [_lineView setBackgroundColor:RGBHex(g_assit_gray)];
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(_iconView);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(1);
    }];
}

- (void) setImageW:(CGFloat)w withH:(CGFloat)h
{
    [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
        make.width.mas_equalTo(w);
    }];
}

@end
