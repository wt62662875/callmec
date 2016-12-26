//
//  RightTitleLabel.m
//  callmec
//
//  Created by sam on 16/7/16.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "RightTitleLabel.h"



@interface RightTitleLabel ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *bottomLine;
@end

@implementation RightTitleLabel


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
    _titleLabel =[[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(50);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    [_contentLabel setFont:[UIFont systemFontOfSize:15]];
    [_contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_contentLabel setNumberOfLines:0];
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];
    
    _bottomLine =[[UIView alloc] init];
    [_bottomLine setBackgroundColor:RGBHex(g_gray)];
    [_bottomLine setHidden:YES];
    [self addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
}


- (void) setTitle:(NSString *)title
{
    [_titleLabel setText:title];
    CGSize size;
    if (_titleFont) {
        size =[title sizeWithFont:_titleFont maxSize:CGSizeMake(180, 3000)];
    }else{
        size = [title sizeFont:12];
    }
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(size.height+10);
        make.width.mas_equalTo(size.width+10);
    }];
}

- (void) setContent:(NSString *)content
{
    [_contentLabel setText:content];
    CGSize size;
    if (_contentFont) {
        size =[content sizeWithFont:_contentFont maxSize:CGSizeMake(180, 3000)];
    }else{
        size = [content sizeFont:15];
    }
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self);
//        make.right.equalTo(self);
        make.height.mas_equalTo(size.height+10);
        make.width.mas_equalTo(size.width+10);
        make.width.mas_lessThanOrEqualTo(self);
    }];
}

- (void) setContentColor:(UIColor *)contentColor
{
    _contentColor = contentColor;
    [_contentLabel setTextColor:_contentColor];
}

- (void) setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    [_bottomLine setHidden:hiddenLine];
}

- (void) setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    [_titleLabel setFont:_titleFont];
}

- (void) setContentFont:(UIFont *)contentFont
{
    _contentFont = contentFont;
     [_contentLabel setFont:_contentFont];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
