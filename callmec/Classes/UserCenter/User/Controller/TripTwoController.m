//
//  TripTwoController.m
//  callmec
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TripTwoController.h"
#import "OrderViewCell.h"
#import "OrderModel.h"
#import "AppraiseController.h"
#import "PayOrderController.h"
#import "WaitingCarPoolingCtrl.h"

@interface TripTwoController()<UITableViewDataSource,UITableViewDelegate,CallBackDelegate,CellTargetDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger page;
@end

@implementation TripTwoController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void) initView
{
    _page = 1;
    _mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        [self fetchData];
    }];
    
    _mTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _page++;
        [self fetchMoreData];
    }];
    
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];//UITableViewCellSeparatorStyle
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_mTableView reloadData];
}

- (void) initData
{
    _dataArray =[NSMutableArray array];
    [self fetchData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld row:%ld",(long)indexPath.section,(long)indexPath.row);
    static NSString *cellid = @"orderviewcell";
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[OrderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.section==0) {
        [cell setTopLineHidden:YES];
        [cell setBottomLineHidden:NO];
    }else if(indexPath.section==(_dataArray.count-1))
    {
        [cell setTopLineHidden:NO];
        [cell setBottomLineHidden:YES];
    }else{
        [cell setTopLineHidden:NO];
        [cell setBottomLineHidden:NO];
    }
    OrderModel *model = _dataArray[indexPath.section];
    [cell setModel:model];
    [cell setDelegateCell:self];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) fetchData
{
    if (![GlobalData sharedInstance].user.isLogin) {
        [MBProgressHUD showAndHideWithMessage:@"您还没有登录或者登录已经失效！请重新登录." forHUD:nil];
        return;
    }
    [OrderModel fetchOrderListById:[GlobalData sharedInstance].user.userInfo.ids types:@"2" page:1 succes:^(NSArray *result, int pageCount, int recordCount) {
        NSLog(@"%@",result);
        
        if (result) {
            [_dataArray removeAllObjects];
            for (NSDictionary *dict in result) {
                OrderModel *model = [[OrderModel alloc] initWithDictionary:dict error:nil];
                if (model) {
                    [_dataArray addObject:model];
                }
            }
            [self.mTableView.mj_header endRefreshing];
            [self.mTableView reloadData];
        }
        
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [self.mTableView.mj_header endRefreshing];
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        NSLog(@"%@",errorMessage);
    }];
}

- (void) fetchMoreData
{
    if (![GlobalData sharedInstance].user.isLogin) {
        [MBProgressHUD showAndHideWithMessage:@"您还没有登录或者登录已经失效！请重新登录." forHUD:nil];
        return;
    }
    [OrderModel fetchOrderListById:[GlobalData sharedInstance].user.userInfo.ids types:@"2" page:_page succes:^(NSArray *result, int pageCount, int recordCount) {
        NSLog(@"%@",result);
        if (result) {
            for (NSDictionary *dict in result) {
                OrderModel *model = [[OrderModel alloc] initWithDictionary:dict error:nil];
                if (model) {
                    [_dataArray addObject:model];
                }
            }
            
            [self.mTableView reloadData];
        }
        [self.mTableView.mj_footer endRefreshing];
        
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [self.mTableView.mj_footer endRefreshing];
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        NSLog(@"%@",errorMessage);
    }];
}

- (void) cellTarget:(id)sender
{
    if ([sender isKindOfClass:[OrderModel class]]) {
        OrderModel *order = (OrderModel*)sender;
        if ([@"6" isEqualToString:order.state]) {
            PayOrderController *mPayController = [[PayOrderController alloc] init];
            mPayController.orderId = order.ids;
            [self.navigationController pushViewController:mPayController animated:YES];
        }else if ([@"7" isEqualToString:order.state]) {
            AppraiseController *praise = [[AppraiseController alloc] init];
            praise.orderModel = sender;
            praise.delegateCallback = self;
            [self.navigationController pushViewController:praise animated:YES];
        }else if ([@"1" isEqualToString:order.state]||[@"2" isEqualToString:order.state]||[@"3" isEqualToString:order.state]||[@"4" isEqualToString:order.state]||[@"5" isEqualToString:order.state])
        {
            WaitingCarPoolingCtrl *order_ctrl = [[WaitingCarPoolingCtrl alloc] init];
            order_ctrl.orderId = order.ids;
            [order_ctrl setModel:[[CarOrderModel alloc] initWithDictionary:[order toDictionary] error:nil]];

            [self.navigationController pushViewController:order_ctrl animated:YES];
        }
    }
    NSLog(@"sender%@",sender);
}

- (void) callback:(id)sender
{
    [self.mTableView.mj_header beginRefreshing];
}
@end
