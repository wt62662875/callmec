//
//  AppraiseController.m
//  callmec
//
//  Created by sam on 16/8/2.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppraiseController.h"

#import "RightTitleLabel.h"
#import "RateViewBar.h"
#import "PlaceHolderTextView.h"


@interface AppraiseController ()<RateViewBarDelegate>
@property (nonatomic,strong) UIView *bottom_container;
@property (nonatomic,strong) UIView *top_container;
@property (nonatomic,strong) UIImageView *iconView;
//@property (nonatomic,strong) RateViewBar *rateView;
@property (nonatomic,strong) UILabel *rateView;
@property (nonatomic,strong) RateViewBar *rateLevelView;

@property (nonatomic,strong) RightTitleLabel *driverLabel;
@property (nonatomic,strong) RightTitleLabel *carLabel;

@property (nonatomic,strong) UILabel *tipStarLabel;
@property (nonatomic,strong) UILabel *tipMessageLabel;
@property (nonatomic,strong) PlaceHolderTextView *inputText;
@property (nonatomic,strong) UIButton *buttonSubmit;
@end

@implementation AppraiseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getDatas];
}

- (void) initData
{

}

- (void) initView
{
    [self setTitle:@"评论订单"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:RGBHex(g_gray)];
    
    _top_container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_top_container setBackgroundColor:[UIColor whiteColor]];
    [_top_container.layer setCornerRadius:5];
    [_top_container.layer setMasksToBounds:YES];
    
    [self.view addSubview:_top_container];
    [_top_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(150);
    }];
    
    _bottom_container = [[UIView alloc] init];
    [_bottom_container setBackgroundColor:[UIColor whiteColor]];
    [_bottom_container.layer setCornerRadius:5];
    [_bottom_container.layer setMasksToBounds:YES];
    [self.view addSubview:_bottom_container];
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(_top_container.mas_bottom).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    _iconView =[[UIImageView alloc] init];
    [_iconView setImage:[UIImage imageNamed:@"icon_driver"]];
    [_top_container addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_top_container);
        make.top.equalTo(_top_container).offset(15);
        make.height.width.mas_equalTo(50);
    }];
    
//    _rateView = [[RateViewBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) light:@"icon_s_light_big" gray:@"icon_s_gray_big"];
//    _rateView.rateNumber = 3;
    _rateView = [[UILabel alloc] init];
    [_rateView setText:@"星级:"];
    [_rateView setFont:[UIFont systemFontOfSize:15]];
    [_rateView setTextAlignment:NSTextAlignmentCenter];
    [_top_container addSubview:_rateView];
    
    [_rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom).offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(_top_container);
    }];
    
    //司机信息
    _driverLabel = [[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_driverLabel setTitle:@"称    呼"];
    [_driverLabel setContent:@" "];
    [_driverLabel setContentFont:[UIFont systemFontOfSize:15]];
    [_top_container addSubview:_driverLabel];
    [_driverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_top_container).offset(20);
        make.top.equalTo(_rateView.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    //卡信息
    _carLabel =[[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_carLabel setTitle:@"车牌号"];
    [_carLabel setContent:@" "];
    [_carLabel setContentFont:[UIFont systemFontOfSize:15]];
    [_top_container addSubview:_carLabel];
    [_carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_top_container).offset(20);
        make.top.equalTo(_driverLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    
    //bottom_container content View
    _tipStarLabel = [[UILabel alloc] init];
    [_tipStarLabel setText:@"拖动评星:"];
    [_tipStarLabel setFont:[UIFont systemFontOfSize:14]];
    [_bottom_container addSubview:_tipStarLabel];
    [_tipStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottom_container).offset(10);
        make.left.equalTo(_bottom_container).offset(20);
    }];
    
    _rateLevelView = [[RateViewBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) light:@"huang1" gray:@"hui1"];
    [_rateLevelView setRateNumber:5];
    [_rateLevelView setDragEnabled:YES];
    [_rateLevelView setDelegate:self];
    [_rateLevelView setImageSize:CGSizeMake(50, 50)];
    [_bottom_container addSubview:_rateLevelView];
    [_rateLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipStarLabel.mas_bottom).offset(5);
        make.left.equalTo(_bottom_container).offset(20);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(50);
    }];
    
    
    [_tipStarLabel setText:[NSString stringWithFormat:@"拖动评星:%0.1f",_rateLevelView.rateNumber]];
    
    _tipMessageLabel = [[UILabel alloc] init];
    [_tipMessageLabel setText:@"说点什么:"];
    [_tipMessageLabel setFont:[UIFont systemFontOfSize:14]];
    [_bottom_container addSubview:_tipMessageLabel];
    [_tipMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rateLevelView.mas_bottom).offset(5);
        make.left.equalTo(_bottom_container).offset(20);
    }];
    
    _inputText = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _inputText.layer.cornerRadius = 5;
    _inputText.layer.masksToBounds = YES;
    _inputText.layer.borderWidth = 1;
    _inputText.layer.borderColor = RGBHex(g_assit_gray).CGColor;
    _inputText.placeHolder = @"输入内容";
    _inputText.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_bottom_container addSubview:_inputText];
    
    
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setTitle:@"提交" forState:UIControlStateNormal];
    _buttonSubmit.layer.cornerRadius = 5;
    _buttonSubmit.layer.masksToBounds = YES;
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(buttonTargetSumbit:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_bottom_container addSubview:_buttonSubmit];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottom_container).offset(-10);
        make.left.equalTo(_bottom_container).offset(30);
        make.right.equalTo(_bottom_container).offset(-30);
        make.height.mas_equalTo(35);
    }];
    [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipMessageLabel.mas_bottom).offset(5);
        make.left.equalTo(_bottom_container).offset(20);
        make.right.equalTo(_bottom_container).offset(-20);
        make.bottom.equalTo(_buttonSubmit.mas_top).offset(-10);
    }];
    
    if (_orderModel) {
        [_driverLabel setContent:[NSString stringWithFormat:@"%@",_orderModel.dRealName]];
        [_iconView sd_setCircleImageWithURL:[CommonUtility driverHeaderImageUrl:_orderModel.driverId] placeholderImage:[UIImage imageNamed:@"icon_driver"]];
        [_carLabel setContent:[NSString stringWithFormat:@"%@ %@",_orderModel.carNo,_orderModel.carDesc]];
        //[_rateView setRateNumber:[_orderModel.level floatValue]];
        [_rateView setText:[NSString stringWithFormat:@"星级:%@",_orderModel.level?_orderModel.level:@""]];
    }
}
-(void)getDatas{
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:@"34",@"typeId", nil];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listCancelReason" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *arr = [resultDictionary objectForKey:@"rows"];
        
        
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) buttonTarget:(id)sender
{
    if (sender==self.leftButton) {
        if (self.delegateCallback&&[self.delegateCallback respondsToSelector:@selector(callback:)]) {
            [self.delegateCallback callback:@"reload"];
        }
        if (_isNeedToRoot) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void) buttonTargetSumbit:(UIButton*)button
{
    if (!_orderModel) {
        [MBProgressHUD showAndHideWithMessage:@"缺少相关参数!" forHUD:nil];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_orderModel.ids forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%0.1f",_rateLevelView.rateNumber] forKey:@"level"];
    [params setObject:_inputText.text forKey:@"description"];
    
//    NSLog(@"%@",params);
//    return;
    [HttpShareEngine callWithFormParams:params withMethod:@"commentOrder" succ:^(NSDictionary *resultDictionary) {
        [MBProgressHUD showAndHideWithMessage:@"评论成功" forHUD:nil];
        
        if (self.delegateCallback && [self.delegateCallback respondsToSelector:@selector(callback:)]) {
            [self.delegateCallback callback:@"评论成功"];
        }
        if (_isNeedToRoot) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
    //description
}

- (void) rateChangeValue:(CGFloat)value view:(UIView *)view
{
    [_tipStarLabel setText:[NSString stringWithFormat:@"拖动评星:%0.1f",value]];
}

@end