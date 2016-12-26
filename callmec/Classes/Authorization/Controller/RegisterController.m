//
//  RegisterController.m
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "RegisterController.h"
#import "BrowerController.h"

#import "UserInfoModel.h"
#import "GeTuiSdk.h"
@interface RegisterController()

@property (nonatomic,strong) UIImageView *iv_bigicon_view;
@property (nonatomic,strong) UITextField *tf_mobile_view;
@property (nonatomic,strong) UITextField *tf_pwd_view;
@property (nonatomic,strong) UIButton *bt_submit_view;
@property (nonatomic,strong) UIButton *button_license;
//@property (nonatomic,strong) UIButton *bt_forget_view;

@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,assign) BOOL isCanceled;
@property (nonatomic,assign) NSInteger counter;
@property (nonatomic,strong) UIButton *rbtn;
@end

@implementation RegisterController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void) initView
{
    [GlobalData sharedInstance].netStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    [self setTitle:@"用户登录"];
    self.titleLabel.hidden = YES;
    self.bottomHeaderLine.hidden = YES;
    
    UIImageView * backroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"denglubeij"]];
    [backroundView setFrame:self.view.frame];
    [self.view addSubview:backroundView];
    
    
    
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setHidden:YES];
    [self.leftButton setEnabled:NO];
    NSString *rightTitle = @"已有用户";
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setHidden:YES];
    [self.rightButton setEnabled:NO];
    
    CGSize size =[rightTitle sizeFont:15];
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+10);
    }];
    
    _iv_bigicon_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [_iv_bigicon_view.layer setCornerRadius:15];
    [_iv_bigicon_view.layer setMasksToBounds:YES];
    [self.view addSubview:_iv_bigicon_view];
    [_iv_bigicon_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
//        make.height.width.mas_equalTo(180);
    }];
    
    //用户手机号
    _tf_mobile_view = [[UITextField alloc] init];
    _tf_mobile_view.placeholder=@"手机号码";

    _tf_mobile_view.textColor = [UIColor whiteColor];
    _tf_mobile_view.layer.masksToBounds = YES;
    _tf_mobile_view.keyboardType = UIKeyboardTypeNumberPad;
    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanghao"]];
    [phoneLeftView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneLeftView);
        make.centerX.equalTo(phoneLeftView);
    }];
    if ([SandBoxHelper fetchLoginNumber]!=nil) {
        [_tf_mobile_view setText:[SandBoxHelper fetchLoginNumber]];
    }
    _tf_mobile_view.leftView = phoneLeftView;
    _tf_mobile_view.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *underLine = [[UIView alloc]init];
    underLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:underLine];
    
    [self.view addSubview:_tf_mobile_view];
    
    [_tf_mobile_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(_iv_bigicon_view.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-45);
        make.bottom.equalTo(_tf_mobile_view.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    //用户输入密码
    _tf_pwd_view = [[UITextField alloc] init];
    
    UIView *passLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *passView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
    [passLeftView addSubview:passView];
    
    
    
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passLeftView);
        make.centerX.equalTo(passLeftView);
    }];
    _tf_pwd_view.textColor = [UIColor whiteColor];
    _tf_pwd_view.leftView = passLeftView;
    _tf_pwd_view.leftViewMode = UITextFieldViewModeAlways;
    _tf_pwd_view.layer.cornerRadius = 5;
    _tf_pwd_view.layer.masksToBounds = YES;
    _tf_pwd_view.keyboardType = UIKeyboardTypeNumberPad;
    UIView *rightView = [[UIView alloc] init];
    [rightView setFrame:CGRectMake(0, 0, 100, 30)];
    
    _rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView addSubview:_rbtn];
    _rbtn.layer.cornerRadius = 4;
    _rbtn.layer.masksToBounds = YES;
    _rbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _rbtn.layer.borderWidth = 1;
    _rbtn.tag = 1;
    [_rbtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_rbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(rightView);
        make.width.mas_equalTo(80);
    }];
    
    [_rbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_rbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rbtn addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    _tf_pwd_view.rightView = rightView;
    _tf_pwd_view.rightViewMode = UITextFieldViewModeAlways;
    
//    _tf_pwd_view.layer.borderColor = RGBHex(g_gray).CGColor;
//    _tf_pwd_view.layer.borderWidth = 1;
    _tf_pwd_view.secureTextEntry = NO;
    UIView *underLine2 = [[UIView alloc]init];
    underLine2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:underLine2];
    
    
    [self.view addSubview:_tf_pwd_view];
    [_tf_pwd_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(underLine.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    [underLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-45);
        make.bottom.equalTo(_tf_pwd_view.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    _bt_submit_view = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt_submit_view setTitle:@"立即登录" forState:UIControlStateNormal];
    [_bt_submit_view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [_bt_submit_view setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_red)] forState:UIControlStateNormal];
//    [_bt_submit_view setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_gray)] forState:UIControlStateHighlighted];
//    [_bt_submit_view setBackgroundColor:RGBHex(g_red)];
    _bt_submit_view.layer.borderColor = [UIColor whiteColor].CGColor;
    _bt_submit_view.layer.borderWidth = 1;
    [_bt_submit_view.layer setCornerRadius:5];
    [_bt_submit_view.layer setMasksToBounds:YES];
    [self.view addSubview:_bt_submit_view];
    
    [_bt_submit_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underLine2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    [_bt_submit_view addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
//    _bt_forget_view = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_bt_forget_view setTitle:@"忘记密码这里找回" forState:UIControlStateNormal];
//    [_bt_forget_view.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [_bt_forget_view setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
//    [_bt_forget_view setBackgroundColor:[UIColor clearColor]];
//    [_bt_forget_view.layer setCornerRadius:5];
//    [_bt_forget_view.layer setMasksToBounds:YES];
//    [self.view addSubview:_bt_forget_view];
//    
//    [_bt_forget_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bt_submit_view.mas_bottom).offset(20);
//        make.left.equalTo(self.view).offset(30);
//        make.right.equalTo(self.view).offset(-30);
//        make.height.mas_equalTo(50);
//    }];
    
    _button_license = [[UIButton alloc] init];
    [_button_license setTitle:@"版权信息" forState:UIControlStateNormal];
    [_button_license.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_button_license setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_button_license addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button_license];
    [_button_license setHidden:YES];
    [_button_license mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(180);
    }];
}

- (void) startTimer
{
    if (_timer) {
        [self cancelTimer];
    }
    _isCanceled = NO;
    _counter = 60;
    [_rbtn setEnabled:NO];
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_main_queue());
    dispatch_source_set_timer(_timer,
                              DISPATCH_TIME_NOW,
                              1.0*NSEC_PER_SEC,
                              0.0);
    
    dispatch_source_set_event_handler(_timer, ^{
        if (!_isCanceled && _counter>0) {
            _counter--;
            [_rbtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)_counter] forState:UIControlStateNormal];
        }else{
            [self cancelTimer];
        }
    });
    dispatch_resume(_timer);
}
- (void) cancelTimer
{
    _isCanceled = YES;
    _counter =  0;
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [_rbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_rbtn setEnabled:YES];
    NSLog(@"release inteval");
}

- (void) buttonTarget:(UIButton*)sender
{
    if (sender ==self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender== self.button_license){
        BrowerController *browers = [[BrowerController alloc] init];
        browers.urlStr = @"";
        browers.titleStr = @"";
        [self.navigationController pushViewController:browers animated:YES];
    }else if(sender== self.bt_submit_view){
        if (!_tf_mobile_view.text ||[_tf_mobile_view.text length]==0||![CommonUtility validatePhoneNumber:_tf_mobile_view.text])
        {
            [MBProgressHUD showAndHideWithMessage:@"非法的手机号" forHUD:nil];
            return;
        }
//        if ([GlobalData sharedInstance].netStatus == AFNetworkReachabilityStatusNotReachable) {
//            [MBProgressHUD showAndHideWithMessage:@"没有网络连接!" forHUD:nil];
//            return;
//        }
        [UserInfoModel login:_tf_mobile_view.text withPwd:_tf_pwd_view.text succ:^(NSDictionary *resultDictionary) {
             NSLog(@"succes:%@",resultDictionary);
            UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:[resultDictionary objectForKey:@"data"] error:nil];
            if (userInfo) {
                NSString *token = [resultDictionary objectForKey:@"token"];
                [GlobalData sharedInstance].user.session = token;
                [GlobalData sharedInstance].user.isLogin = YES;
                [GlobalData sharedInstance].user.userInfo = userInfo;
                [[GlobalData sharedInstance].user save];
                [self.navigationController popViewControllerAnimated:YES];
                //[GeTuiSdk bindAlias:userInfo.phoneNo];
                [MBProgressHUD showAndHideWithMessage:@"登录成功" forHUD:nil];
                [SandBoxHelper saveLoginParams:_tf_mobile_view.text random:_tf_pwd_view.text];
                //[GeTuiSdk bindAlias:[GlobalData sharedInstance].user.userInfo.phoneNo];
            }else{
                [MBProgressHUD showAndHideWithMessage:@"解析失败" forHUD:nil];
            }
            
        } fail:^(NSInteger errorCode, NSString *errorMessage) {
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        }];
    }else {
        if (sender.tag==1) {
            
            if (!_tf_mobile_view.text||[_tf_mobile_view.text length]==0||![CommonUtility validatePhoneNumber:_tf_mobile_view.text]) {
                [MBProgressHUD showAndHideWithMessage:@"非法的手机号" forHUD:nil];
                return;
            }
//            if ([GlobalData sharedInstance].netStatus == AFNetworkReachabilityStatusNotReachable) {
//                [MBProgressHUD showAndHideWithMessage:@"没有网络连接!" forHUD:nil];
//                return;
//            }
            [self startTimer];
            [UserInfoModel fetchValidateCode:_tf_mobile_view.text succ:^(NSDictionary *resultDictionary) {
                NSLog(@"resultDictionary:%@",resultDictionary);
                [MBProgressHUD showAndHideWithMessage:@"动态密码已通过短信发给您！" forHUD:nil];
            } fail:^(NSInteger errorCode, NSString *errorMessage) {
                
                [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
            }];
        }else if(sender.tag==2)
        {
            
        }
    }
}
@end
