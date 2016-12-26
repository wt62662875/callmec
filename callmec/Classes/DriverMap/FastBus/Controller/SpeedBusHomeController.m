//
//  SpeedBusHomeController.m
//  callmec
//
//  Created by sam on 16/7/30.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "SpeedBusHomeController.h"
#import "SwipeBarCodeViewController.h"
#import "ScanCodeBusController.h"
#import "AppiontBusController.h"
#import "PayOrderController.h"

#import "FastBusCell.h"
#import "CancelView.h"
#import "FastBusOrderCell.h"

#import "CancelModel.h"

@class AppiontBusModel;
@class CancelModel;
@interface SpeedBusHomeController ()<UITableViewDataSource,UITableViewDelegate,TargetActionDelegate,MAMapViewDelegate,CallBackDelegate>
@property (nonatomic,strong) UIButton *buttonScan;
@property (nonatomic,strong) UIView *bottom_container;
@property (nonatomic,strong) UIView *middle_container;
@property (nonatomic, strong) UIButton *btn_left;
@property (nonatomic, strong) UIButton *btn_right;
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation SpeedBusHomeController
{
    NSInteger page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDriverReceivedOrder:) name:NOTICE_ORDER_STATE_UPDATE object:nil];
    [self.headerView setHidden:YES];
    [self initView];
}

- (void) initView
{
    _dataArray =[NSMutableArray array];
    
    if ([GlobalData sharedInstance].fastModel) {
        [_dataArray addObject:[GlobalData sharedInstance].fastModel];
    }
//    [self.view setBackgroundColor:RGBHex(g_assit_gray)];
    [self initTableView];
    
    [self initBottomView];
    
    
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottom_container.mas_top);
    }];
    
//    _middle_container = [[UIView alloc] initWithFrame:_mTableView.bounds];
//    [_middle_container setBackgroundColor:[UIColor clearColor]];
//    _mTableView.backgroundView = _middle_container;
//    UIImageView *busImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_buss"]];
//    [_middle_container addSubview:busImageView];
//    [busImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_middle_container);
//        make.centerY.equalTo(_middle_container);
//    }];
//    
//    UILabel *busTitle = [[UILabel alloc] init];
//    [busTitle setText:@"尊敬的用户"];
//    [busTitle setFont:[UIFont systemFontOfSize:15]];
//    [busTitle setContentMode:UIViewContentModeCenter];
//    [busTitle setTextColor:[UIColor blackColor]];
//    [_middle_container addSubview:busTitle];
//    [busTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_middle_container);
//        make.top.equalTo(busImageView.mas_bottom);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(80);
//    }];
//    
//    UILabel *busDesc = [[UILabel alloc] init];
//    [busDesc setText:@"点击底部一键用车呼叫快巴\n上车扫一扫立即开始快巴行程"];
//    [busDesc setFont:[UIFont systemFontOfSize:13]];
//    [busDesc setTextColor:RGBHex(g_assit_c)];//RGBHex(g_assit_c)
//    [busDesc setLineBreakMode:NSLineBreakByWordWrapping];
//    [busDesc setTextAlignment:NSTextAlignmentCenter];
//    [busDesc setNumberOfLines:0];
//    [_middle_container addSubview:busDesc];
//    [busDesc mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_middle_container);
//        make.top.equalTo(busTitle.mas_bottom);
//        //make.height.mas_equalTo(30);
//        make.width.mas_equalTo(180);
//    }];
    [self initTableCenterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonTarget:(id)sender
{
    if (_btn_right == sender) {
        SwipeBarCodeViewController *scaner = [[SwipeBarCodeViewController alloc] init];
        scaner.delegateCallback = self;
        [self.navigationController pushViewController:scaner animated:YES];
    }else if(_btn_left== sender)
    {
        AppiontBusController *appiont = [[AppiontBusController alloc] init];
        appiont.delegateCallback = self;
        [self.navigationController pushViewController:appiont animated:YES];
    }else if([sender isKindOfClass:[UIButton class]]){
        
        UIButton *btn = sender;
        if ([btn.titleLabel.text hasPrefix:@"取消"]) {
            CancelView *mcancel = [[CancelView alloc] initWithFrame:self.view.window.bounds];
            CarOrderModel *model = [GlobalData sharedInstance].fastModel;
            mcancel.orderId = model.ids;
            __weak __typeof(&*self) weakSelf = self;
            [self.view.window addSubview:mcancel];
            mcancel.processBlock =^(NSObject *obj){
                CancelModel *cd = (CancelModel*)obj;
                [AppiontBusModel appiontBusCancel:model.ids reason:cd.name succes:^(NSDictionary *resultDictionary) {
                    [MBProgressHUD showAndHideWithMessage:@"取消成功" forHUD:nil];
                    [GlobalData sharedInstance].fastModel = nil;
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf reloadData];
                } failed:^(NSInteger errorCode, NSString *errorMessage) {
                    [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
                }];
            };
        }else if ([btn.titleLabel.text hasPrefix:@"支付"]) {
            PayOrderController *payview = [[PayOrderController alloc] init];
            CarOrderModel *model = _dataArray[0];
            if (!model) {
                NSLog(@"oder cann't not extis");
                return;
            }
            payview.orderId = model.ids;
            [self.navigationController pushViewController:payview animated:YES];
        }
    }
}

#pragma mark - 

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
    CarOrderModel *model = _dataArray[indexPath.section];
    if ([@"10" isEqualToString:model.type] || [@"1" isEqualToString:model.state]) {
        FastBusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[FastBusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.delegate = self;
        cell.model = model;
        return cell;
    }else{//([@"5" isEqualToString:model.state])
        static NSString *cellid1 = @"cellid1";
        FastBusOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid1];
        if (!cell) {
            cell = [[FastBusOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
        }
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    return nil;
}
#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppiontBusModel *model = _dataArray[indexPath.section];
    if ([@"1" isEqualToString:model.state]) {
        return 80;
    }
    return 130;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AppiontBusModel *model = _dataArray[indexPath.section];
//    if (![@"6" isEqualToString:model.state]) {
//        WaitingGoodsCarController *waiting = [[WaitingGoodsCarController alloc] init];
//        waiting.model_dict = self.model_dict;
//        waiting.model = model;
//        waiting.orderId = model.ids;
//        [self.navigationController pushViewController:waiting animated:YES];
//    }else{
//        PayOrderController *pay = [[PayOrderController alloc] init];
//        pay.orderId = model.ids;
//        [self.navigationController pushViewController:pay animated:YES];
//    }
}


#pragma mark - 获取 Data

- (void) fetchData
{
     [_dataArray removeAllObjects];
    if ([GlobalData sharedInstance].fastModel) {
        [_dataArray addObject:[GlobalData sharedInstance].fastModel];
        [_mTableView setHidden:NO];
        [_middle_container setHidden:YES];
    }else{
        [_mTableView setHidden:YES];
        [_middle_container setHidden:NO];
    }
    [self endRefresh];
    /*page = 1;
    [CarOrderModel fetchOrderList:page withType:@"3" Succes:^(NSArray *result, int pageCount, int recordCount) {
        
        [_dataArray removeAllObjects];
        for (NSDictionary *dict in result)
        {
            CarOrderModel *model = [[CarOrderModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        page++;
        [self endRefresh];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
        [self endRefresh];
    }];*/
}

- (void) fetchMoreData
{
    /*[CarOrderModel fetchOrderList:page withType:@"3" Succes:^(NSArray *result, int pageCount, int recordCount) {
        for (NSDictionary *dict in result)
        {
            CarOrderModel *model = [[CarOrderModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        if (result.count>0) {
            page++;
        }
        [self endRefresh];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
        [self endRefresh];
    }];
    page++; */
    [self endRefresh];
}

- (void) endRefresh
{
    [_mTableView.mj_header endRefreshing];
    [_mTableView.mj_footer endRefreshing];
    [_mTableView reloadData];
}

- (void) reloadData
{
    [self fetchData];
}

- (void) callback:(id)sender
{
//    if ([sender isKindOfClass:[NSString class]]) {
//        AppiontBusController *bus = [[AppiontBusController alloc] init];
//        [bus setCarNo:(NSString*)sender];
//        [self.navigationController pushViewController:bus animated:YES];
//    }
    //AppiontBusController
    [self fetchData];
}

- (void) initTableView
{
    _mTableView = [[UITableView alloc] init];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self fetchData];
    }];
    _mTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
//    [_mTableView setBackgroundColor:[UIColor clearColor]];
    
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initBottomView
{
    _bottom_container =[[UIView alloc] init];
    _btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_left setImage:[UIImage imageNamed:@"index_icon_now"] forState:UIControlStateNormal];
    [_btn_left setTitle:@"一键发布用车" forState:UIControlStateNormal];
    [_btn_left setTitleColor:RGBHex(g_white) forState:UIControlStateNormal];
    [_btn_left.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btn_left setBackgroundColor:RGBHex(g_blue)];
    [_btn_left setTag:1];
    [_btn_left addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_right setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    [_btn_right setTitle:@"上车扫一扫" forState:UIControlStateNormal];
    [_btn_right setTitleColor:RGBHex(g_white) forState:UIControlStateNormal];
    [_btn_right.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btn_right setBackgroundColor:RGBHex(g_blue)];
    
    [_btn_right setTag:2];
    [_btn_right addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *grayline = [[UIView alloc] init];
    [grayline setBackgroundColor:RGBHex(g_assit_gray)];
    [_bottom_container addSubview:grayline];

    
    [_bottom_container setBackgroundColor:RGBHex(g_gray)];
    [_bottom_container addSubview:_btn_left];
    [_bottom_container addSubview:_btn_right];
    
    [grayline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottom_container);
        make.left.equalTo(_bottom_container);
        make.right.equalTo(_bottom_container);
        make.height.mas_equalTo(1);
    }];
    
    [_btn_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayline.mas_bottom);
        make.left.equalTo(_bottom_container);
        make.height.equalTo(_bottom_container);
        //        make.width.equalTo(_bottom_container.mas_width).multipliedBy(0.5);
        make.width.equalTo(_bottom_container).dividedBy(2);
    }];
    
    [_btn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayline.mas_bottom);
        make.left.equalTo(_btn_left.mas_right).offset(1);
        make.height.equalTo(_bottom_container);
        //        make.width.equalTo(_bottom_container.mas_width).multipliedBy(0.5);
        make.width.equalTo(_bottom_container).dividedBy(2);
    }];
    //    [_btn_left setTitle:@"一键发布用车" forState:UIControlStateNormal];
    //    [_btn_left setImage:[UIImage imageNamed:@"icon_index_huodi"] forState:UIControlStateNormal];
    //    [_btn_left setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,10)];
    //    [_btn_left mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_bottom_container);
    //        make.left.equalTo(_bottom_container);
    //        make.height.equalTo(_bottom_container);
    //        make.width.equalTo(_bottom_container.mas_width);
    //    }];
    
    [self.view addSubview:_bottom_container];
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}

- (void) initTableCenterView
{
    _middle_container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    [_middle_container setUserInteractionEnabled:YES];
    UITapGestureRecognizer *g1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
    g1.numberOfTapsRequired =1;
    g1.numberOfTouchesRequired=1;
    [_middle_container addGestureRecognizer:g1];
    [_middle_container setBackgroundColor:[UIColor clearColor]];
    //    _mTableView.backgroundView = _middle_container;
    [self.view addSubview:_middle_container];
    [_middle_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-80);
        make.width.height.mas_equalTo(200);
    }];
    UIImageView *busImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dianjizhongjian"]];
    [_middle_container addSubview:busImageView];
    [busImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middle_container);
        make.centerY.equalTo(_middle_container);
    }];
    
    UILabel *busTitle = [[UILabel alloc] init];
    [busTitle setText:@"尊敬的用户"];
    [busTitle setFont:[UIFont systemFontOfSize:15]];
    [busTitle setContentMode:UIViewContentModeCenter];
    [busTitle setTextColor:[UIColor blackColor]];
    [_middle_container addSubview:busTitle];
    [busTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middle_container);
        make.top.equalTo(busImageView.mas_bottom);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    UILabel *busDesc = [[UILabel alloc] init];
    [busDesc setText:@"点击底部一键用车呼叫快巴\n上车扫一扫立即开始快巴行程"];
    [busDesc setFont:[UIFont systemFontOfSize:13]];
    [busDesc setTextColor:RGBHex(g_assit_c)];//RGBHex(g_assit_c)
    [busDesc setLineBreakMode:NSLineBreakByWordWrapping];
    [busDesc setTextAlignment:NSTextAlignmentCenter];
    [busDesc setNumberOfLines:0];
    [_middle_container addSubview:busDesc];
    [busDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middle_container);
        make.top.equalTo(busTitle.mas_bottom);
        make.width.mas_equalTo(180);
    }];
}

- (void) gesture:(UITapGestureRecognizer*)g
{
//    AppiontmentController *special = [[AppiontmentController alloc] init];
//    special.startLocation = self.currentLocation;
//    special.isNowUseCar = YES;
//    special.tripTypeModel = _tripModel;
//    [self.navigationController pushViewController:special animated:YES];
}

- (void) showDriverReceivedOrder:(NSNotification *)oderinfo
{
    DriverOrderInfo *order =nil;
    @try {
        NSError *error;
        order = [[DriverOrderInfo alloc] initWithDictionary:oderinfo.userInfo error:&error];
        
        NSLog(@"push oderinfo:%@",oderinfo.userInfo);
        if (error) {
            NSLog(@"push exception parse: %@",error);
        }
    }
    @catch (NSException *exception){
        NSLog(@"push exception:%@",exception);
    }
    @finally{
        CarOrderModel *_model;
        if (order && [@"4" isEqualToString:order.oType]) {
            if (_model &&([order.state integerValue]>[_model.state integerValue])) {
                _model = [CarOrderModel convertDriverModel:order];

            }else if([@"10" isEqualToString:order.type]){
                _model = [CarOrderModel convertDriverModel:order];
                if ([GlobalData sharedInstance].fastModel) {
                    [GlobalData sharedInstance].fastModel.type = @"10";
                }
                ((CarOrderModel*)_dataArray[0]).type=@"10";
                [self fetchData];
            }
        }
    }
}
@end
