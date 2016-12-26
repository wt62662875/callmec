//
//  TXRateViewBar.m
//  crownbee
//
//  Created by sam on 16/5/19.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "RateViewBar.h"

//@property (nonatomic,strong) UIImageView *starImageView;
@implementation RateViewBar
{
    NSMutableArray *dataLightArray;
    NSMutableArray *dataGrayArray;
    UIView *lightView;
    CGFloat pX;
    CGPoint point;
    CGRect  lightRect;
    CGRect  parentRect;
}

- (instancetype) initWithFrame:(CGRect)frame light:(NSString*)str_img_light gray:(NSString*)str_img_gray
{
    _grayLight = str_img_gray;
    _starLight = str_img_light;
    return [self initWithFrame:frame];
}
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dataLightArray = [NSMutableArray array];
        dataGrayArray  = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:_grayLight?_grayLight:@"1huixing4"];
        
        lightView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [lightView setClipsToBounds:YES];
        [self addSubview:lightView];
//        [lightView setBackgroundColor:[UIColor redColor]];
        [lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        
        UIImageView *lView,*gView;
        for (int i=0; i<5; i++) {
            
            UIImageView *star_gray = [[UIImageView alloc] initWithImage:image];
            star_gray.contentMode = UIViewContentModeCenter;
            [dataLightArray addObject:star_gray];
            [self addSubview:star_gray];
            [star_gray mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (gView) {
                    make.left.equalTo(gView.mas_right);
                }else{
                    make.left.equalTo(self);
                }
                make.width.equalTo(self.mas_height);
                make.height.equalTo(self.mas_height);
                make.centerY.equalTo(self);
            }];
            gView = star_gray;
            
            UIImageView *star_light=[[UIImageView alloc] initWithImage:[UIImage imageNamed:_starLight?_starLight:@"1huangxing3"]];
            star_light.contentMode = UIViewContentModeCenter;
            [lightView addSubview:star_light];
            
            [star_light mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (lView) {
                    make.left.equalTo(lView.mas_right);
                }else{
                    make.left.equalTo(lightView);
                }
                make.centerY.equalTo(lightView);
                make.width.equalTo(self.mas_height);
                make.height.equalTo(self);
            }];
            lView = star_light;
        }
        [self bringSubviewToFront:lightView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        [self addGestureRecognizer:pan];
    }
    return  self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setRateNumber:(CGFloat)rateNumber
{
    _rateNumber = rateNumber;
    [lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(rateNumber==0)
        {
            make.width.mas_equalTo(1);
        }else{
            make.width.equalTo(self).multipliedBy(rateNumber*0.2);
//            make.width.mas_equalTo(self.frame.size.height*rateNumber);
        }
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(self);
    }];
    
    if (_delegate &&[_delegate respondsToSelector:@selector(rateChangeValue:view:)])
    {
        [_delegate rateChangeValue:_rateNumber view:self];
    }
}

- (void) updateRateNumber:(CGFloat)ratenumber
{
    [lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(ratenumber==0)
        {
            make.width.mas_equalTo(1);
        }else{
            make.width.equalTo(self).multipliedBy(ratenumber);
        }
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(self);
    }];
    
    _rateNumber = ratenumber*5;
    if (_delegate &&[_delegate respondsToSelector:@selector(rateChangeValue:view:)])
    {
        [_delegate rateChangeValue:_rateNumber view:self];
    }
}

- (void) gesture:(UIPanGestureRecognizer*)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            point = [sender locationInView:self.superview];
            parentRect = self.frame;
            lightRect = lightView.frame;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            point =CGPointMake(0,0);
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [sender locationInView:self.superview];
            if (p.x>parentRect.origin.x) {
                pX = p.x - parentRect.origin.x;
                if (pX>parentRect.size.width) {
                    pX = parentRect.size.width;
                }
            }else{
                pX = 0;
            }
            CGFloat rate = pX/parentRect.size.width;
            if (_dragEnabled) {
                [self updateRateNumber:rate];
            }
        }
            break;
        default:
            break;
    }
}

- (void) setDragEnabled:(BOOL)touchEnabled
{
    _dragEnabled = touchEnabled;
}

- (void) setStarLight:(NSString *)starLight
{
    _starLight = starLight;
}

- (void) setGrayLight:(NSString *)grayLight
{
    _starLight = grayLight;
}

- (void) setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    
    for (UIView *view in self.subviews) {
        if ([view  isKindOfClass:[UIImageView class]])
        {
            [view setContentMode:UIViewContentModeScaleAspectFit];
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_imageSize.width);
                make.height.mas_equalTo(_imageSize.height);
            }];
        }
    }
    
    for (UIView *view in lightView.subviews) {
        if ([view  isKindOfClass:[UIImageView class]])
        {
            [view setContentMode:UIViewContentModeScaleAspectFit];
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_imageSize.width);
                make.height.mas_equalTo(_imageSize.height);
            }];
        }
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (_dragEnabled) {
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self];        
        CGFloat rate = p.x/self.frame.size.width;
        [self setRateNumber:[self convertRate:rate*5]];
    }
}

- (CGFloat) convertRate:(CGFloat)rt
{
    CGFloat rate = [[NSString stringWithFormat:@"%0.2f",rt] floatValue];
    if (rate>0.0f && rate < 1.1f) {
        return 1.0f;
    }else if (rate>1.0f&& rate < 2.0f) {
        return 2.0f;
    }else if (rate>2.0f&& rate < 3.0f) {
        return 3.0f;
    }else if (rate>3.0f&& rate < 4.0f) {
        return 4.0f;
    }else if (rate>4.0f) {
        return 5.0f;
    }
    return rt;
}

@end
