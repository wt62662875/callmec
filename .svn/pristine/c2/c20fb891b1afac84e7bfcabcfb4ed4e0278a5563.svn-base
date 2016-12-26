//
//  CommonVerticalView.m
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CommonVerticalView.h"


@interface CommonVerticalView ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *highlightColor;
@end

@implementation CommonVerticalView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelected = NO;
        _container =[[UIView alloc] init];
        [self addSubview:_container];
        
        
        _imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [_container addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_container);
            //make.centerY.equalTo(_container);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        CGSize size = [@"我" sizeFont:[UIFont systemFontSize]];
        
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(_titleLabel.mas_top).offset(5);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.mas_equalTo(size.height);
            make.bottom.equalTo(self).offset(-5);
        }];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        gesture.numberOfTapsRequired = 1;
        gesture.numberOfTouchesRequired=1;
        
        UILongPressGestureRecognizer *lPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        
        [self addGestureRecognizer:gesture];
        [self addGestureRecognizer:lPress];
        _isSelected = NO;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void) setTitleFont:(UIFont *)titleFont
{
    [_titleLabel setFont:titleFont];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:title];
//    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(-10);
//    }];
}

- (void) setTitleColor:(UIColor*)color state:(UIControlState)state
{
    if (UIControlStateNormal == state) {
        _normalColor = color;
        [_titleLabel setTextColor:color];
    }else{
        _highlightColor = color;
    }
    
}

- (void) setImageBackgroudColor:(UIColor *)imageBackgroudColor
{
    [_container setBackgroundColor:imageBackgroudColor];
}

- (void) setImageUrl:(NSString *)imageUrl
{
    NSLog(@"imageUrl:%@",imageUrl);
    _imageUrl = imageUrl;
    UIImage *img = [UIImage imageNamed:imageUrl];
    if (img) {
        [_container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(img.size.width+15);
        }];
    }
    [_imageView setImage:img];
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.height.mas_equalTo(img.size.height);
        make.width.mas_equalTo(img.size.width);
    }];
}

- (void) setHightLightImage:(NSString *)hightLightImage
{
    _hightLightImage = hightLightImage;
}

- (void) setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        if (_hightLightImage==nil || [_hightLightImage length]==0) {
            return;
        }
        [_imageView setImage:[UIImage imageNamed:_hightLightImage]];
        if (_highlightColor) {
            [_titleLabel setTextColor:_highlightColor];
        }
    }else{
        if (_imageUrl==nil || [_imageUrl length]==0) {
            return;
        }
        UIImage *img = [UIImage imageNamed:_imageUrl];
        if (img) {
            [_imageView setImage:[UIImage imageNamed:_imageUrl]];
        }
        if (_normalColor) {
            [_titleLabel setTextColor:_normalColor];
        }
    }
}

- (void) gesture:(UITapGestureRecognizer*)recognizer
{
    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        self.isSelected = !self.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
        {
            [_delegate buttonTarget:self];
        }
        NSLog(@"click");
    }else  if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        UILongPressGestureRecognizer *gs = (UILongPressGestureRecognizer*)recognizer;
        if (gs.state == UIGestureRecognizerStateBegan) {
            self.alpha =0.5;
        }else{
            self.alpha = 1.0;
        }
    }
}

@end