//
//  CityOptionsView.m
//  callmec
//
//  Created by sam on 16/7/2.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CityOptionsView.h"

@interface CityOptionsView()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation CityOptionsView


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
    [_titleLabel setText:@""];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(2);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(self);
    }];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_downs"]];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right);
        make.centerY.equalTo(self);
    }];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:_title];
    CGSize size = [_title sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(180, 2000)];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(2);
        make.width.mas_equalTo(size.width+10);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(self);
    }];
    if (size.width<60) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width+10);
        }];
    }
   
}

@end
