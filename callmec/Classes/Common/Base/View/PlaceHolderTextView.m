//
//  PlaceHolderTextView.m
//  callmec
//
//  Created by sam on 16/8/2.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView
{
    UILabel *placeHolderLabel;
    UIColor *placeholderColor;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        [self initView];
    }
    return self;
}

- (void) initView
{
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [placeHolderLabel setTextColor:RGBHex(g_assit_gray)];
    [placeHolderLabel setFont:[UIFont systemFontOfSize:14]];
    [placeHolderLabel setTag:999];
    [self addSubview:placeHolderLabel];
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    [placeHolderLabel setText:_placeHolder];
}

- (void) setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    [placeHolderLabel setTextColor:_placeHolderColor];
}

- (void)textChanged:(UITextView*)view;
{
    if([[self placeHolder] length] == 0)
    {
        return;
    }
    if([[self text] length] == 0)
    {
        
        [[self viewWithTag:999] setAlpha:1];
        
    }else{
        [[self viewWithTag:999] setAlpha:0];
    }
}
@end
