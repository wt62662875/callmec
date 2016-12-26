//
//  MessageController.m
//  callmec
//
//  Created by sam on 16/7/6.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "MessageController.h"
#import "MessageModel.h"
#import "BrowerController.h"

@interface MessageController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation MessageController
{
    NSInteger page;
}
- (void) viewDidLoad
{
    page = 1;
    [super viewDidLoad];
    [self initData];
    [self initView];
}


- (void) initView
{
    [self setTitle:@"我的消息"];
    [self initTableView];
    
}

- (void) dataMore
{
    [MessageModel fetchMessageListWithPage:page success:^(NSArray *result, int pageCount, int recordCount) {
        for (NSDictionary *dict in result) {
            MessageModel *model = [[MessageModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        if (result.count>0) {
             page++;
        }
        [self endRefresh:YES];
    }failed:^(NSInteger errorCode, NSString *errorMessage) {
        [self endRefresh:NO];
    }];
}

- (void) initData
{
    page = 1;
    _dataArray = [NSMutableArray array];
    [MessageModel fetchMessageListWithPage:page success:^(NSArray *result, int pageCount, int recordCount) {
        NSLog(@"result:%@",result);
        for (NSDictionary *dict in result) {
            MessageModel *model = [[MessageModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        if (result.count>0) {
            page++;
        }
        [self endRefresh:YES];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        
        NSLog(@"errorMessage:%@",errorMessage);
        [self endRefresh:NO];
    }];
}

- (void) endRefresh:(BOOL)reload
{
    [_mTableView.mj_header endRefreshing];
    [_mTableView.mj_footer endRefreshing];
    
    if (reload) {
        [_mTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{

    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *msgId = @"messageId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msgId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgId];
    }
    
    MessageModel *model = _dataArray[indexPath.section];
    [cell.textLabel setText:model.title];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:RGBHex(g_black)];
    if ([@"0" isEqualToString:model.state]) {
        [cell.imageView setImage:[UIImage imageNamed:@"icon_msg_yidu"]];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"icon_msg"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageModel *model = _dataArray[indexPath.section];
    
    BrowerController *brower = [[BrowerController alloc] init];
    [brower setTitleStr:model.title];
    brower.urlStr =[NSString stringWithFormat:@"%@getMessage?id=%@&token=%@",
                    kserviceURL,
                    model.ids,
                    [GlobalData sharedInstance].user.session];
    [self.navigationController pushViewController:brower animated:YES];
    /**
    [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:model.title ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"确定" Click:^{
        
    }];
     */
}

- (void) openUrlById:(NSString*)ids
{
    //BrowerController
    BrowerController *brower = [[BrowerController alloc] init];
    brower.urlStr = [NSString stringWithFormat:@"%@",ids];
    [self.navigationController pushViewController:brower animated:YES];
}

- (void) initTableView
{
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    _mTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self dataMore];
    }];
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
@end
