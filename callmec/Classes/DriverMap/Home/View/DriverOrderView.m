//
//  DriverOrderView.m
//  callmec
//
//  Created by sam on 16/7/16.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "DriverOrderView.h"
#import "RightTitleLabel.h"
#import "RateViewBar.h"

@interface DriverOrderView()

@property (nonatomic,strong) UIView *bottom_container;

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) RateViewBar *rateView;

@property (nonatomic,strong) RightTitleLabel *driverLabel;
@property (nonatomic,strong) RightTitleLabel *carLabel;
@property (nonatomic,strong) RightTitleLabel *serviceLabel;
@property (nonatomic,strong) RightTitleLabel *moneyLabel;

@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,strong) UIButton *buttonCall;

@end

@implementation DriverOrderView


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
    
//    [self setBackgroundColor:RGBHexa(g_black, 0.5)];
    _top_container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_top_container setBackgroundColor:[UIColor whiteColor]];
    [_top_container setUserInteractionEnabled:YES];
    [self addSubview:_top_container];
    [_top_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(210);
    }];
    
    _bottom_container = [[UIView alloc] init];
    [_bottom_container setBackgroundColor:[UIColor whiteColor]];
    [_bottom_container setUserInteractionEnabled:YES];
    [self addSubview:_bottom_container];
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(60);
    }];
    
    _iconView =[[UIImageView alloc] init];
    [_iconView setImage:[UIImage imageNamed:@"icon_driver"]];
    [_top_container addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_top_container);
        make.top.equalTo(_top_container).offset(20);
    }];
    
    _rateView = [[RateViewBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _rateView.rateNumber = 3;
    [_top_container addSubview:_rateView];
    
    [_rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(_top_container);
    }];
    
    //司机信息
    _driverLabel = [[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_driverLabel setTitle:@"称    呼"];
    [_driverLabel setContent:@" "];
    [_top_container addSubview:_driverLabel];
    [_driverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
        make.centerX.mas_equalTo(_rateView).offset(-14);
        make.top.equalTo(_rateView.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    //卡信息
    _carLabel =[[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_carLabel setTitle:@"车牌号"];
    [_carLabel setContent:@""];
    [_top_container addSubview:_carLabel];
    [_carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
        make.centerX.mas_equalTo(_rateView).offset(-15);
        make.top.equalTo(_driverLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    
    _serviceLabel =[[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_serviceLabel setTitle:@"出车次"];
    [_serviceLabel setContent:@"666 单"];
    [_top_container addSubview:_serviceLabel];
    [_serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
        make.centerX.mas_equalTo(_rateView).offset(-14);
        make.top.equalTo(_carLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    
//    _buttonCall = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_buttonCall setBackgroundImage:[UIImage imageNamed:@"icon_call"] forState:UIControlStateNormal];
//    [_buttonCall addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
//    [_top_container addSubview:_buttonCall];
//    [_buttonCall mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_top_container).offset(-20);
//        make.height.width.equalTo(_top_container.mas_width).multipliedBy(0.13);
//        make.centerY.equalTo(_carLabel);
//    }];
    //moenyLabel
    
    _moneyLabel =[[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_moneyLabel setTitle:@"用车金额"];
    [_moneyLabel setContent:@"40 元"];
    [_moneyLabel setContentColor:[UIColor redColor]];
    [_bottom_container addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottom_container).offset(20);
        make.centerY.equalTo(_bottom_container);
        make.height.mas_equalTo(30);
    }];
    
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setTitle:@"去支付" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_red)] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_bottom_container addSubview:_buttonSubmit];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottom_container);
        make.height.equalTo(_bottom_container);
        make.width.equalTo(_bottom_container.mas_height);
        make.top.equalTo(_bottom_container);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setModel:(CarOrderModel *)model
{
    _model  = model;
    [_moneyLabel setContent:_model.actFee];
    [_carLabel setContent:[NSString stringWithFormat:@"%@   %@",_model.carNo,_model.carDesc]];
//    [_driverLabel setContent:[NSString stringWithFormat:@"%@ %@",_model.dRealName,_model.bizType]];
    [_serviceLabel setContent:[NSString stringWithFormat:@"%@ 单",_model.dServiceNum?_model.dServiceNum:@"0"]];
    if ([@"5" isEqualToString:_model.state]) {
        [_bottom_container setHidden:YES];
    }else if([@"6" isEqualToString:_model.state]){
        [_bottom_container setHidden:NO];
    }else{
        [_bottom_container setHidden:YES];
    }
    [_driverLabel setContent:[NSString stringWithFormat:@"%@",
                              _model.dRealName]];
    [_rateView setRateNumber:[_model.dLevel floatValue]];
}

- (void) buttonTarget:(UIButton*)btn
{
    if (btn == _buttonCall) {
        if (!_model.dPhoneNo || [_model.dPhoneNo length]==0) {
            [MBProgressHUD showAndHideWithMessage:@"司机号码为空!" forHUD:nil];
            return;
        }
        [CommonUtility callTelphone:_model.dPhoneNo];
        return;
    }
    if (_handel) {
       _handel(btn.titleLabel.text);
    }
}



- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (_dismissWhenTouchOutside) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:_top_container];
        if (point.y<0) {
            NSLog(@"touchesBegan point:%@",NSStringFromCGPoint(point));
            [self removeFromSuperview];
        }
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}


@end
