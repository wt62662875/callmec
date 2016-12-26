//
//  WalletController.m
//  callmec
//
//  Created by sam on 16/6/27.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "WalletController.h"
#import "WalletInfoCell.h"
#import "WalletInfoModel.h"

#import "RechargeController.h"
#import "AccountDetailController.h"
#import "IntegrationController.h"

@interface WalletController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) WalletInfoModel *walletModel;
@property (nonatomic,strong) UILabel *integralLabel;
@end

@implementation WalletController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self fetchWalletInfo];
    [self initData];
    [self initView];
}

- (void) initData
{
    
    /**
     @property (nonatomic,copy) NSString *title;
     @property (nonatomic,copy) NSString *money;
     @property (nonatomic,copy) NSString *icons;
     @property (nonatomic,copy) NSString *type;
     @property (nonatomic,assign) CGFloat height;
     */
    NSString *money =@"0.00";
    if ([GlobalData sharedInstance].wallet) {
        money =[GlobalData sharedInstance].wallet.cmoney;
    }else{
        money =@"0.00";
    }
    _dataArray = [NSMutableArray arrayWithObjects:/*[[WalletModel alloc] initWithDictionary:@{@"title":@"账户余额(元)",
                                                                                     @"money":money,
                                                                                     @"icons":@"",
                                                                                     @"type":@"0",
                                                                                     @"height":@(80)} error:nil],
                  [[WalletModel alloc] initWithDictionary:@{@"title":@"充值呼我币",
                                                            @"money":@"100",
                                                            @"icons":@"qianbao1",
                                                            @"type":@"1",
                                                            @"height":@(50)} error:nil],
                  [[WalletModel alloc] initWithDictionary:@{@"title":@"账户明细",
                                                            @"money":@"100",
                                                            @"icons":@"qianbao2",
                                                            @"type":@"2",
                                                            @"height":@(50)} error:nil],*/
                  [[WalletModel alloc] initWithDictionary:@{@"title":@"积分明细",
                                                            @"money":@"",
                                                            @"icons":@"jifenmingxi",
                                                            @"type":@"3",
                                                            @"height":@(50)} error:nil], nil];
}

- (void) initView
{
    [self setTitle:@"我的钱包"];
    _mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    [self.view addSubview:_mTableView];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(90);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIImageView *topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"touxiangbeij"]];
    [topView setFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    
    _integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _integralLabel.backgroundColor = [UIColor clearColor];
    _integralLabel.textColor = [UIColor whiteColor];
    _integralLabel.text = @"999";
    _integralLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:_integralLabel];
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(10);
    }];
    
    UILabel *allIntegralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    allIntegralLabel.backgroundColor = [UIColor clearColor];
    allIntegralLabel.textColor = [UIColor whiteColor];
    allIntegralLabel.text = @"积分总额";
    allIntegralLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:allIntegralLabel];
    [allIntegralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_integralLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
    }];
    
    _mTableView.mj_header =[MJRefreshHeader headerWithRefreshingBlock:^{
        [self fetchWalletInfo];
    }];
    [_mTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cellid";
    WalletInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[WalletInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell setModel:_dataArray[indexPath.section]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((WalletModel*)_dataArray[indexPath.section]).height;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WalletModel *model = _dataArray[indexPath.section];
    if ([@"1" isEqualToString:model.type])
    {
        RechargeController *charge = [[RechargeController alloc] init];
        [self.navigationController pushViewController:charge animated:YES];
    }else if([@"2" isEqualToString:model.type])
    {
        AccountDetailController *account= [[AccountDetailController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    }else if([@"3" isEqualToString:model.type])
    {
        IntegrationController *account= [[IntegrationController alloc] init];
        if (_walletModel) {
            account.accountId = _walletModel.accountId;
            [self.navigationController pushViewController:account animated:YES];
        }
    }
}


- (void) fetchWalletInfo
{
    [WalletInfoModel fetchWalletInfoSuccess:^(NSDictionary *resultDictionary) {
        NSLog(@"resultDictionary:%@",resultDictionary);
        NSDictionary *data = resultDictionary[@"data"];
        WalletInfoModel *model = [[WalletInfoModel alloc] initWithDictionary:data error:nil];
        if (model) {
            [GlobalData sharedInstance].wallet = model;
        }
        _walletModel = model;
        ((WalletModel*)_dataArray[0]).money = model.grade;
        _integralLabel.text = model.grade;
        [self endRefresh:YES];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
        [self endRefresh:NO];
    }];
}
- (void) endRefresh:(BOOL)reload
{
    [self.mTableView.mj_header endRefreshing];
    if (reload) {
        [self.mTableView reloadData];
    }
}
@end
