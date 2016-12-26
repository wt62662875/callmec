//
//  BottomPayView.m
//  callmec
//
//  Created by sam on 16/8/13.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BottomPayView.h"
#import "RightTitleLabel.h"

@interface BottomPayView()

@property (nonatomic,strong) RightTitleLabel *moneyLabel;
@property (nonatomic,strong) UIButton *buttonSubmit;
@end

@implementation BottomPayView

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
    [self setBackgroundColor:[UIColor whiteColor]];
    _moneyLabel =[[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_moneyLabel setTitle:@"用车金额"];
    [_moneyLabel setContent:@"40 元"];
    [_moneyLabel setContentColor:[UIColor redColor]];
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setTitle:@"去支付" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_red)] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonSubmit];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(_buttonSubmit.mas_height);
        make.top.equalTo(self);
    }];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [_moneyLabel setTitle:_title];
}

- (void) setContent:(NSString *)content
{
    _content = content;
    [_moneyLabel setContent:_content];
}

- (void) setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [_buttonSubmit setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)buttonTarget:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)]) {
        [_delegate buttonTarget:self];
    }
}
@end
