//
//  DriverInfoController.m
//  callmec
//
//  Created by sam on 16/6/27.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "DriverInfoController.h"
#import "DriverInfoCell.h"
#import "DriverCommentCell.h"

@interface DriverInfoController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end


@implementation DriverInfoController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void) initData
{
    _dataArray= [NSMutableArray array];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
}

- (void) initView
{
    [self setTitle:@"司机详情"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
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

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellid = @"dirver_cellid";
        DriverInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell =[[DriverInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }else{
        static NSString *cellid1 = @"dirver_cellid1";
        DriverCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid1];
        if (!cell) {
            cell =[[DriverCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
        }
    
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 350;
    }
    return 50;
}
#pragma mark - UITableViewDelegate


@end
