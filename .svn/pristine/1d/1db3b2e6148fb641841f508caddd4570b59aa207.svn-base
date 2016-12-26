//
//  LoginController.m
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"

@interface LoginController()

@property (nonatomic,strong) UIImageView *iv_bigicon_view;
@property (nonatomic,strong) UITextField *tf_mobile_view;
@property (nonatomic,strong) UITextField *tf_pwd_view;
@property (nonatomic,strong) UIButton *bt_submit_view;
@property (nonatomic,strong) UIButton *bt_forget_view;
@end

@implementation LoginController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initView];

}

- (void) initView
{
    [self setTitle:@"用户登录"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightTitle = @"注册用户";
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size =[rightTitle sizeFont:15];
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+10);
    }];
    
    _iv_bigicon_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-512"]];
    [self.view addSubview:_iv_bigicon_view];
    [_iv_bigicon_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(40);
    }];
    
    //用户手机号
    _tf_mobile_view = [[UITextField alloc] init];
    _tf_mobile_view.placeholder=@"手机号码";
    _tf_mobile_view.layer.borderColor = RGBHex(g_gray).CGColor;
    _tf_mobile_view.layer.borderWidth = 1;
    _tf_mobile_view.layer.cornerRadius = 5;
    _tf_mobile_view.layer.masksToBounds = YES;
    
    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone"]];
    [phoneLeftView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneLeftView);
        make.centerX.equalTo(phoneLeftView);
    }];
    
    _tf_mobile_view.leftView = phoneLeftView;
    _tf_mobile_view.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_tf_mobile_view];
    [_tf_mobile_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(_iv_bigicon_view.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    //用户输入密码
    _tf_pwd_view = [[UITextField alloc] init];
    UIView *passLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *passView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pass"]];
    [passLeftView addSubview:passView];
    
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passLeftView);
        make.centerX.equalTo(passLeftView);
    }];
    
    _tf_pwd_view.leftView = passLeftView;
    _tf_pwd_view.leftViewMode = UITextFieldViewModeAlways;
    _tf_pwd_view.layer.borderColor = RGBHex(g_gray).CGColor;
    _tf_pwd_view.layer.borderWidth = 1;
    _tf_pwd_view.secureTextEntry = YES;
    _tf_pwd_view.layer.cornerRadius = 5;
    _tf_pwd_view.layer.masksToBounds = YES;
    [self.view addSubview:_tf_pwd_view];
    [_tf_pwd_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(_tf_mobile_view.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    _bt_submit_view = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt_submit_view setTitle:@"立即登录" forState:UIControlStateNormal];
    [_bt_submit_view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bt_submit_view setBackgroundColor:RGBHex(g_red)];
    [_bt_submit_view.layer setCornerRadius:5];
    [_bt_submit_view.layer setMasksToBounds:YES];
    [_bt_submit_view setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_red)] forState:UIControlStateNormal];
    [_bt_submit_view setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_gray)] forState:UIControlStateHighlighted];
    [self.view addSubview:_bt_submit_view];
    
    [_bt_submit_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tf_pwd_view.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    _bt_forget_view = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bt_forget_view setTitle:@"忘记密码这里找回" forState:UIControlStateNormal];
    [_bt_forget_view.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_bt_forget_view setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_bt_forget_view setBackgroundColor:[UIColor clearColor]];
    [_bt_forget_view.layer setCornerRadius:5];
    [_bt_forget_view.layer setMasksToBounds:YES];
    [self.view addSubview:_bt_forget_view];
    
    [_bt_forget_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bt_submit_view.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
}

- (void) buttonTarget:(id)sender
{
    if (sender ==self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        RegisterController *registers = [[RegisterController alloc] init];
        [self.navigationController pushViewController:registers animated:YES];
    }
}
@end
