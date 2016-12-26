//
//  RechargeController.m
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "RechargeController.h"
@interface RechargeController()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,strong) NSArray *moneyArray;
@property (nonatomic,strong) NSMutableArray<UIButton*> *buttonViews;
@end

@implementation RechargeController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void) initView
{
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"充值呼我币"];
    _headerLabel = [[UILabel alloc] init];
    [self.view setBackgroundColor:RGBHex(g_assit_gray)];
    [_headerLabel setText:@"选择充值金额"];
    [_headerLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:_headerLabel];
    
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
    }];
    _moneyArray = [NSArray arrayWithObjects:@"50",@"100",@"200",@"500",@"1000",@"2000",@"其他金额", nil];
    _buttonViews = [NSMutableArray array];
    for (int i=0;i<_moneyArray.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor redColor].CGColor;
        [btn setTitle:[NSString stringWithFormat:@"%@元",_moneyArray[i]] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setBackgroundImage:scaleImage(@"kuang",5,5,25,25) forState:UIControlStateNormal];
        [btn setBackgroundImage:scaleImage(@"kuang_fcs",5,5,25,25) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonViews addObject:btn];
    }
    UIButton *btn0 = _buttonViews[0];
    UIButton *btn1 = _buttonViews[1];
    UIButton *btn2 = _buttonViews[2];
    UIButton *btn3 = _buttonViews[3];
    UIButton *btn4 = _buttonViews[4];
    UIButton *btn5 = _buttonViews[5];
    UIButton *btn6 = _buttonViews[6];
    
    [self.view addSubview:btn0];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [btn0 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(_headerLabel.mas_bottom).offset(10);
        make.width.equalTo(self.view).multipliedBy(0.29);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    
    [btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn0.mas_right).offset(10);
        make.top.equalTo(_headerLabel.mas_bottom).offset(10);
        make.width.equalTo(self.view).multipliedBy(0.29);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    
    [btn2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right).offset(10);
        make.top.equalTo(_headerLabel.mas_bottom).offset(10);
        make.width.equalTo(self.view).multipliedBy(0.29);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
    
    [btn3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(btn0.mas_bottom).offset(10);
        make.width.equalTo(self.view).multipliedBy(0.29);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    
    [btn4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn0.mas_right).offset(10);
        make.top.equalTo(btn0.mas_bottom).offset(10);
        make.width.equalTo(self.view).multipliedBy(0.29);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    
    [btn5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right).offset(10);
        make.top.equalTo(btn0.mas_bottom).offset(10);
        make.width.equalTo(self.view).multipliedBy(0.29);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    
    [self.view addSubview:btn6];
    
    [btn6 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(btn3.mas_bottom).offset(10);
        make.height.equalTo(self.view).multipliedBy(0.08);
    }];
    /*
    _collectionView = [[UICollectionView alloc] init];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    */
    
    _buttonSubmit = [[UIButton alloc] init];
    _buttonSubmit.layer.cornerRadius = 5.0;
    _buttonSubmit.layer.masksToBounds = YES;
    _buttonSubmit.layer.borderWidth = 1;
    _buttonSubmit.layer.borderColor = [UIColor redColor].CGColor;
    [_buttonSubmit setTitle:@"马上充值" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_red)] forState:UIControlStateNormal];
    [self.view addSubview:_buttonSubmit];
    [_buttonSubmit addTarget:self action:@selector(buttonTargetSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

- (void) buttonTarget:(UIButton*)sender
{
    if (sender == self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    for (UIButton *button in _buttonViews) {
        if (sender==button) {
            button.selected = !button.selected;
        }else{
            button.selected = NO;
        }
    }
}

- (void) buttonTargetSubmit:(UIButton*)sender
{
    NSString *money=nil;
    for (UIButton *btn in _buttonViews) {
        if (btn.selected) {
            money = _moneyArray[btn.tag];
            break;
        }
    }
    if (!money) {
        money =@"未选择充值金额!";
    }else{
        money = [NSString stringWithFormat:@"%@ 元",money];
    }
    [MBProgressHUD showAndHideWithMessage:money forHUD:nil];
}

@end
