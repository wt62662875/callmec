//
//  CancelView.m
//  callmec
//
//  Created by sam on 16/8/14.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CancelView.h"

#import "CancelModel.h"
#import "CMDriverManager.h"
@interface CancelView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,strong) UIView *bottom_container;

@end

@implementation CancelView
{
    NSInteger cancelTimes;
    CancelModel *cmodel;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void) initData
{
    _dataArray = [NSMutableArray array];
}

- (void) initView
{
    [self setBackgroundColor:RGBHexa(g_black, 0.5)];//[ImageTools imageWithColor:RGBHexa(g_assit_gray, 0.5)]
    _containerView = [[UIView alloc]  init];
    [_containerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(300);
        make.bottom.equalTo(self);
    }];
    
    _titleLabel =[[UILabel alloc] init];
    [_titleLabel setText:@"请选择取消订单原因"];
    [_containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView);
        make.centerX.equalTo(_containerView);
        make.height.mas_equalTo(30);
    }];
    
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCancelList];
    }];
    [_mTableView.mj_header beginRefreshing];
    
    [_containerView addSubview:_mTableView];
    _bottom_container =[[UIView alloc] init];
    [_bottom_container setBackgroundColor:RGBHex(g_blue)];
    [_containerView addSubview:_bottom_container];
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.right.equalTo(_containerView);
        make.bottom.equalTo(_containerView);
        make.height.mas_equalTo(50);
    }];
    
    _buttonSubmit =[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit.layer setCornerRadius:5];
    [_buttonSubmit.layer setMasksToBounds:YES];
    [_buttonSubmit setTitle:@"确定" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateNormal];
    [_bottom_container addSubview:_buttonSubmit];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(_bottom_container.mas_top);
    }];
    
    
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_bottom_container);
        make.bottom.equalTo(_bottom_container.mas_bottom);
//        make.width.mas_equalTo(256);
        make.left.equalTo(_bottom_container.mas_left);
        make.right.equalTo(_bottom_container.mas_right);

        make.height.mas_equalTo(50);
    }];
    
    [self tranlateAnimation:_containerView];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_containerView];
    if (point.y<0) {
        [self removeFromSuperview];
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void) tranlateAnimation:(UIView *)views
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;   //时间间隔
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillRuleEvenOdd;//kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;         //动画效果
    animation.subtype = kCATransitionFromTop;   //动画方向
    [views.layer addAnimation:animation forKey:@"animation"];
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


- (void)buttonTarget:(id)sender
{
    if(self.buttonSubmit == sender){
        if (_processBlock) {
            _processBlock(cmodel);
            [self removeFromSuperview];
        }else{
            [self cancelOrder];
        }
        
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
- (void) cancelOrder
{
    if (!cmodel) {
        [MBProgressHUD showAndHideWithMessage:@"您还没有选择取消的原因！" forHUD:nil];
        return;
    }
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"您的订单已经生成！您确定要取消订单么？" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
    } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
        if (_order && [@"10" isEqualToString:_order.type]) {
            if (_block) {
                _block(0,YES);
                [self removeFromSuperview];
            }
        }else{
        
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"请稍后..." inView:nil];
        hud.completionBlock=^{
            //[self.navigationController popToRootViewControllerAnimated:YES];
            if (_block) {
                _block(0,YES);
                [self removeFromSuperview];
                
            }
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
                //[self.navigationController popViewControllerAnimated:YES];
                if (_block) {
                    _block(0,YES);
                    [self removeFromSuperview];
                }
            }
        }];
            }
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

- (void) dealloc
{
    NSLog(@"CancelView dealloc");
}
@end
