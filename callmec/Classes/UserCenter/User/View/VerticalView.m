//
//  VerticalView.m
//  callmec
//
//  Created by sam on 16/6/26.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "VerticalView.h"

@interface VerticalView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@end

@implementation VerticalView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        _container =[[UIView alloc] init];
//        [self addSubview:_container];
//        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self).offset(10);
//        }];
        _imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        CGSize size = [@"我" sizeFont:[UIFont systemFontSize]];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
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
//-(void)setMake:(NSString *)make{
////    if ([make isEqualToString:@"userCenter"]) {
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.centerY.equalTo(self).offset(20);
//        }];
////    }
//    
//}

- (void) setTitleFont:(UIFont *)titleFont
{
    [_titleLabel setFont:titleFont];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:title];
}

- (void) setImageBackgroudColor:(UIColor *)imageBackgroudColor
{
    [_container setBackgroundColor:imageBackgroudColor];
}


- (void) setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    UIImage *img = [UIImage imageNamed:imageUrl];
    if (img) {
        [_container setBackgroundColor:[UIColor redColor]];
        [_container setClipsToBounds:YES];
        [_container.layer setCornerRadius:(img.size.height+15)*0.5];
        [_container.layer setMasksToBounds:YES];
        [_container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(img.size.width+15);
            make.height.mas_equalTo(img.size.height+15);
        }];
    }
    [_imageView setImage:img];
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(img.size.height);
        make.width.mas_equalTo(img.size.width);
    }];
}

- (void) gesture:(UITapGestureRecognizer*)recognizer
{
    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {

        if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
        {
            [_delegate buttonTarget:self];
        }
    }else  if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        UILongPressGestureRecognizer *gs = (UILongPressGestureRecognizer*)recognizer;
        if (gs.state == UIGestureRecognizerStateBegan) {
            self.alpha =0.5;
        }else{
            self.alpha = 1.0;
        }
    }
}

- (void) setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        if (_selectColor) {
            NSLog(@"%@",_selectImageUrl);
            [_imageView setImage:[UIImage imageNamed:_selectImageUrl]];
            _imageView.hidden = NO;

            self.titleLabel.textColor = _selectColor;
            self.backgroundColor = _selectedBackgroundColor;
        }        
    }else{
        [_imageView setImage:[UIImage imageNamed:_imageUrl]];
        _imageView.hidden = YES;

        self.titleLabel.textColor = RGBHex(@"7E8589");
        self.backgroundColor =RGBHex(g_white);
    }
}

@end
