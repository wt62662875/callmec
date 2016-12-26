//
//  CarPoolingCancelCtrl.m
//  callmec
//
//  Created by sam on 16/7/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CarPoolingCancelCtrl.h"
#import "CancelModel.h"
#import "CMDriverManager.h"

@interface CarPoolingCancelCtrl ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,strong) UIView *bottom_container;
@end

@implementation CarPoolingCancelCtrl
{
    NSInteger cancelTimes;
    CancelModel *cmodel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void) initData
{
    _dataArray = [NSMutableArray array];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initView
{
    [self setTitle:@"取消行程"];
    
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCancelList];
    }];
    [_mTableView.mj_header beginRefreshing];
    
    [self.view addSubview:_mTableView];
    _bottom_container =[[UIView alloc] init];
    [_bottom_container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottom_container];
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    _buttonSubmit =[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit.layer setCornerRadius:5];
    [_buttonSubmit.layer setMasksToBounds:YES];
    [_buttonSubmit setTitle:@"确定" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_bottom_container addSubview:_buttonSubmit];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottom_container.mas_top);
    }];

    
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottom_container);
        make.centerY.equalTo(_bottom_container);
        make.width.equalTo(_bottom_container).offset(80);
        make.height.mas_equalTo(40);
    }];
}

- (void)buttonTarget:(id)sender
{
    if (self.leftButton == sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.buttonSubmit == sender){
        [self cancelOrder];
    }
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

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    CancelModel *model = _dataArray[indexPath.section];
    [cell.textLabel setText:model.name];
    [cell.imageView setImage:[UIImage imageNamed:@"icon_userss"]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cmodel = _dataArray[indexPath.section];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) cancelOrder
{
    if (!cmodel) {
        [MBProgressHUD showAndHideWithMessage:@"您还没有选择取消的原因！" forHUD:nil];
        return;
    }
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"您的订单已经生成！您确定要取消订单么？" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
    } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"请稍后..." inView:nil];
        hud.completionBlock=^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        [hud show:YES];
        [CMDriverManager cancelCallCarRequest:self.orderId reason:cmodel.name success:^(NSDictionary *resultDictionary) {
            [hud hide:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICE_UPDATE_CARPOOLING_INFO" object:nil];
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            [hud hide:YES];
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
            cancelTimes++;
            if ((int)cancelTimes>=3) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}


- (void) fetchCancelList
{
    [CancelModel fetchCancelReasonListSuccess:^(NSArray *result, int pageCount, int recordCount) {
        [_dataArray removeAllObjects];
        for (NSDictionary *dict in result) {
            CancelModel *model = [[CancelModel alloc] initWithDictionary:dict error:nil];
            if (model) {
                [_dataArray addObject:model];
            }
        }
        [_mTableView reloadData];
        [_mTableView.mj_header endRefreshing];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"result:%@",errorMessage);
        [_mTableView.mj_header endRefreshing];
    }];
}
@end
