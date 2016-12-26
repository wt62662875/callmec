//
//  AccountDetailController.m
//  callmec
//
//  Created by sam on 16/7/30.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AccountDetailController.h"

@interface AccountDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation AccountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void) initData
{
    _dataArray = [NSMutableArray array];
}

- (void) initView
{
    [self setTitle:@"账户明细"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_tipLabel setTextAlignment:NSTextAlignmentCenter];
    [_tipLabel setTextColor:RGBHex(g_gray)];
    [_tipLabel setBackgroundColor:RGBHex(g_assit_c1)];
    [_tipLabel setFont:[UIFont systemFontOfSize:13]];
    [_tipLabel setText:@"温馨提示:您可以查看最近3个月的账户纪录"];
    
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchData];
    }];
    
    _mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipLabel.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
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
    return nil;
}

#pragma mark - UITableViewDelegate



#pragma mark - getData

- (void) fetchData
{
    [self.mTableView.mj_header endRefreshing];
}

- (void) fetchMoreData
{
    [self.mTableView.mj_footer endRefreshing];
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
