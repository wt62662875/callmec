//
//  IntegrationController.m
//  callmec
//
//  Created by sam on 16/8/17.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "IntegrationController.h"
#import "IntegrateModel.h"
#import "IntegrationCell.h"

@interface IntegrationController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,assign) NSInteger page;
@end

@implementation IntegrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    _page = 1;
}

- (void) initData
{
    _dataArray = [NSMutableArray array];
}

- (void) initView
{
    [self setTitle:@"积分明细"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_tipLabel setTextAlignment:NSTextAlignmentCenter];
    [_tipLabel setTextColor:RGBHex(g_black)];
    [_tipLabel setBackgroundColor:RGBHex(g_assit_gray)];
    [_tipLabel setFont:[UIFont systemFontOfSize:13]];
    [_tipLabel setText:@"温馨提示:您可以查看最近3个月的账户纪录"];
    
    [self.view addSubview:_tipLabel];
    [_tipLabel setHidden:YES];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;

    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchData];
    }];
    [_mTableView.mj_header beginRefreshing];
    _mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
}

- (void) buttonTarget:(id)sender
{
    if (self.leftButton == sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    static NSString *cellid = @"cellid";
    
    IntegrationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[IntegrationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    IntegrateModel *model = _dataArray[indexPath.section];
    [cell setModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getData

- (void) fetchData
{
    _page = 1;
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }else{
        _dataArray =[NSMutableArray array];
    }
    [IntegrateModel fetchIntegrateList:_page type:1 accountId:_accountId success:^(NSArray *result, int pageCount, int recordCount) {
        NSLog(@"result:%@",result);
        for (NSDictionary *dict in result) {
            IntegrateModel *model = [[IntegrateModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        _page++;
        [self refreshTable:YES];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [self refreshTable:NO];
    }];
    
}

- (void) fetchMoreData
{
    [IntegrateModel fetchIntegrateList:_page type:1 accountId:_accountId success:^(NSArray *result, int pageCount, int recordCount) {
        NSLog(@"result:%@",result);
        for (NSDictionary *dict in result) {
            IntegrateModel *model = [[IntegrateModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        _page++;
        [self refreshTable:YES];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [self refreshTable:NO];
    }];
    
}

- (void) refreshTable:(BOOL)refresh
{
    [self.mTableView.mj_header endRefreshing];
    [self.mTableView.mj_footer endRefreshing];
    if (refresh) {
        [self.mTableView reloadData];
    }

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
