//
//  PayOrderController.m
//  callmec
//
//  Created by sam on 16/7/17.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "PayOrderController.h"
#import "RightTitleLabel.h"
#import "DriverOrderInfo.h"
#import "CellView.h"
#import "PayModel.h"
#import "Pay.h"
#import "OrderModel.h"
#import "PayCollectionView.h"
#import "AppraiseController.h"

static BOOL PayOrderController_HAS_VISIABLE  =  NO;
@interface PayOrderController ()<TargetActionDelegate,CallBackDelegate>
{
    UIView *backview;
    UIView *finishView;
}

@property (nonatomic,strong) UIView *top_container;
@property (nonatomic,strong) UIView *mid_container;
@property (nonatomic,strong) UIView *bottom_container;

@property (nonatomic,strong) UIView *scrollContainer;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) PayCollectionView *pay_container;

@property (nonatomic,strong) RightTitleLabel *orderIdLabel;         //订单ID
@property (nonatomic,strong) RightTitleLabel *passengerLabel;       //乘客
@property (nonatomic,strong) RightTitleLabel *orderTimeLabel;       //下单时间
@property (nonatomic,strong) RightTitleLabel *aboardLocaLabel;      //上车
@property (nonatomic,strong) RightTitleLabel *debusLocalLabel;      //下车

@property (nonatomic,strong) RightTitleLabel *moneyLabel;

@property (nonatomic,strong) RightTitleLabel *payLabel;           //支付金额

@property (nonatomic,strong) UILabel *fareLabel;                    //车费
@property (nonatomic,strong) UILabel *pointsDeLabel;                //积分抵扣
@property (nonatomic,strong) UILabel *payFareLabel;                   //实付车费


@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,strong) UIButton *buttonCall;
@property (nonatomic,strong) OrderModel *order_model;
@property (nonatomic,assign) BOOL isFinishController;
@end

@implementation PayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self fetchOrderInfo];
    _isFinishController = NO;
}

- (void) viewDidDisappear:(BOOL)animated
{
    PayOrderController_HAS_VISIABLE = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    PayOrderController_HAS_VISIABLE = YES;
    if (_isFinishController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillLayoutSubviews
{
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    [_scrollContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.top.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.bottom.equalTo(_scrollView);
        make.height.mas_equalTo(_scrollView.contentSize.height);
        make.width.mas_equalTo(_scrollView.contentSize.width);
    }];
}


- (void) initView
{
    if (_isCanback) {
        [self.leftButton setHidden:NO];
        [self.leftButton setEnabled:YES];
    }else{
        [self.leftButton setHidden:YES];
        [self.leftButton setEnabled:NO];
    }
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"行程详情"];
//    [self.leftButton setHidden:YES];
//    [self.leftButton setEnabled:NO];
    _scrollView  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width,600)];
    _scrollView.contentSize = CGSizeMake(kScreenSize.width,600);
    [_scrollView setBackgroundColor:RGBHex(g_gray)];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _scrollContainer = [[UIView alloc] init];
    [_scrollView addSubview:_scrollContainer];
    [_scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.top.equalTo(_scrollView);
        make.bottom.equalTo(_scrollView);
        
        make.height.mas_equalTo(_scrollView.contentSize.height);
        make.width.mas_equalTo(_scrollView.contentSize.width);
    }];
    
    
    _top_container = [[UIView alloc] init];
    [_top_container setBackgroundColor:[UIColor whiteColor]];

    [_scrollContainer addSubview:_top_container];
    
    [_top_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollContainer).offset(10);
        make.left.equalTo(_scrollContainer);
        make.right.equalTo(_scrollContainer);
        make.height.mas_equalTo(180);
    }];
    
    _mid_container = [[UIView alloc] init];
    [_mid_container setBackgroundColor:[UIColor whiteColor]];
//    [_mid_container setHidden:YES];
    [_scrollContainer addSubview:_mid_container];
    
    [_mid_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top_container.mas_bottom).offset(20);
        make.left.equalTo(_scrollContainer);
        make.right.equalTo(_scrollContainer);
        make.height.mas_equalTo(110);
    }];
    
    _bottom_container = [[UIView alloc] init];
    [_bottom_container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottom_container];
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];

    [self initTopContainer];
    [self initMidContainer];
    [self initBottomContainer];
}


- (void) initBottomContainer
{
    _moneyLabel =[[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_moneyLabel setTitle:@"用车金额"];
    [_moneyLabel setContent:@"0 元"];
    [_moneyLabel setContentColor:RGBHex(g_blue)];
    [_bottom_container addSubview:_moneyLabel];
    [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottom_container).offset(20);
        make.centerY.equalTo(_bottom_container);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setTitle:@"去支付" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateNormal];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_bottom_container addSubview:_buttonSubmit];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottom_container);
        make.height.equalTo(_bottom_container);
        make.width.mas_equalTo(100);
        make.top.equalTo(_bottom_container);
    }];
}

- (void) initMidContainer
{
    UILabel *fareLabel1 = [[UILabel alloc]init];
    fareLabel1.font = [UIFont systemFontOfSize:12];
    fareLabel1.text = @"车费：";
    [_mid_container addSubview:fareLabel1];
    [fareLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_container).offset(20);
        make.top.equalTo(_mid_container).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *pointsDeLabel1 = [[UILabel alloc]init];
    pointsDeLabel1.font = [UIFont systemFontOfSize:12];
    pointsDeLabel1.text = @"积分抵扣：";
    [_mid_container addSubview:pointsDeLabel1];
    [pointsDeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_container).offset(20);
        make.top.equalTo(fareLabel1.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *payFareLabel1 = [[UILabel alloc]init];
    payFareLabel1.font = [UIFont systemFontOfSize:12];
    payFareLabel1.text = @"实付车费：";
    [_mid_container addSubview:payFareLabel1];
    [payFareLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mid_container).offset(20);
        make.top.equalTo(pointsDeLabel1.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    _fareLabel = [[UILabel alloc]init];
    _fareLabel.font = [UIFont systemFontOfSize:14];
    _fareLabel.text = @"0元";
    [_mid_container addSubview:_fareLabel];
    [_fareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_mid_container.mas_right).offset(-10);
        make.centerY.equalTo(fareLabel1);
        make.height.mas_equalTo(30);
    }];

    _pointsDeLabel = [[UILabel alloc]init];
    _pointsDeLabel.font = [UIFont systemFontOfSize:14];
    _pointsDeLabel.text = @"0积分";
    [_mid_container addSubview:_pointsDeLabel];
    [_pointsDeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_mid_container.mas_right).offset(-10);
        make.centerY.equalTo(pointsDeLabel1);
        make.height.mas_equalTo(30);
    }];
    
    _payFareLabel = [[UILabel alloc]init];
    _payFareLabel.font = [UIFont systemFontOfSize:14];
    _payFareLabel.text = @"0元";
    [_mid_container addSubview:_payFareLabel];
    [_payFareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_mid_container.mas_right).offset(-10);
        make.centerY.equalTo(payFareLabel1);
        make.height.mas_equalTo(30);
    }];
}


- (void) initTopContainer
{
    _orderIdLabel = [[RightTitleLabel  alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_orderIdLabel setTitle:@"订单号"];
    [_top_container addSubview:_orderIdLabel];
    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top_container).offset(10);
        make.left.equalTo(_top_container).offset(20);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    _passengerLabel = [[RightTitleLabel  alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_passengerLabel setTitle:@"乘车人"];
    [_top_container addSubview:_passengerLabel];
    [_passengerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderIdLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(20);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    _orderTimeLabel = [[RightTitleLabel  alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_orderTimeLabel setTitle:@"下单时间"];
    [_top_container addSubview:_orderTimeLabel];
    [_orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passengerLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(20);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    _aboardLocaLabel = [[RightTitleLabel  alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_aboardLocaLabel setTitle:@"上车地点"];
    [_top_container addSubview:_aboardLocaLabel];
    [_aboardLocaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderTimeLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(20);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    _debusLocalLabel = [[RightTitleLabel  alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_debusLocalLabel setTitle:@"下车地点"];
    [_top_container addSubview:_debusLocalLabel];
    [_debusLocalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_aboardLocaLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(20);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(30);
    }];

}


- (void) fetchOrderInfo
{
    [DriverOrderInfo fetchOrderDetail:self.orderId success:^(NSDictionary *resultDictionary) {
        
        NSLog(@"resultDictionary:%@",resultDictionary);
        NSDictionary *data = [resultDictionary objectForKey:@"data"];
        _order_model = [[OrderModel alloc] initWithDictionary:data error:nil];
        
        if (data){
            [_orderIdLabel setContent:_order_model.no];
            [_passengerLabel setContent:data[@"mRealName"]];
            [_orderTimeLabel setContent:data[@"createDate"]];
            [_aboardLocaLabel setContent:data[@"slocation"]];
            [_debusLocalLabel setContent:data[@"elocation"]];
            [_moneyLabel setContent:[NSString stringWithFormat:@" %@ 元",data[@"cost"]]];
            _fareLabel.text = [NSString stringWithFormat:@"%@元",data[@"actFee"]];
            _pointsDeLabel.text = [NSString stringWithFormat:@"%@积分",data[@"discount"]];
            _payFareLabel.text = [NSString stringWithFormat:@"%@元",data[@"cost"]];
            [[NSUserDefaults standardUserDefaults] setObject:data[@"cost"] forKey:@"PayMoney"];

//            [_moneyLabel setContent:[NSString stringWithFormat:@" %@ 元",data[@"actFee"]]];

//            NSArray *feeDetail = data[@"details"];
//            if (feeDetail && feeDetail.count>0) {
//                [_mid_container setHidden:NO];
//                for (UIView *view in _mid_container.subviews) {
//                    [view removeFromSuperview];
//                }
//            }
//
//            RightTitleLabel *oldview;
//            for (NSDictionary *dict in feeDetail) {
//                RightTitleLabel *feelabel = [[RightTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//                [feelabel setTitle:dict[@"name"]];
//                [feelabel setContent:dict[@"fee"]];
//                
//                [_mid_container addSubview:feelabel];
//                
//                [feelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    if (oldview) {
//                        make.top.equalTo(oldview.mas_bottom);
//                    }else{
//                        make.top.equalTo(_mid_container).offset(10);
//                    }
//                    make.left.equalTo(_mid_container).offset(20);
//                    make.right.equalTo(_mid_container).offset(-10);
//                    make.height.mas_equalTo(30);
//                }];
//                oldview = feelabel;
//            }
        }
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

- (void) buttonTarget:(UIButton*)button
{
    if (button == self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([button isKindOfClass:[CellView class]]){
        CellView *cell = (CellView*)button;
        if (cell.index==1) {
            [Pay payWithAmount:0.01 orderId:_orderId type:PayTypeAlipay success:^(id object)
            {
                [MBProgressHUD showAndHideWithMessage:@"支付宝支付完成" forHUD:nil];
                AppraiseController *comments = [[AppraiseController alloc] init];
//                comments.delegateCallback = self;
                comments.orderId = self.orderId;
                comments.orderModel = _order_model;
                comments.isNeedToRoot = YES;
                [self.navigationController pushViewController:comments animated:YES];
            } failure:^(NSInteger errorCode, NSString *errorMessage) {
                [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
            }];
        }else if(cell.index==2)
        {
            [Pay payWithAmount:0.01 orderId:_orderId type:PayTypeWechat success:^(id object) {
                [MBProgressHUD showAndHideWithMessage:@"微信支付完成" forHUD:nil];
                AppraiseController *comments = [[AppraiseController alloc] init];
                comments.orderId = self.orderId;
                comments.orderModel = _order_model;
//                comments.delegateCallback = self;
                comments.isNeedToRoot = YES;
                [self.navigationController pushViewController:comments animated:YES];
            } failure:^(NSInteger errorCode, NSString *errorMessage) {
                [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
            }];
        }
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PayMoney"] isEqualToString:@"0"]) {
            backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
            [backview setBackgroundColor:[UIColor blackColor]];
            backview.alpha = 0.5;
            [self.navigationController.view addSubview:backview];
            [backview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.navigationController.view);
                make.left.equalTo(self.navigationController.view);
                make.right.equalTo(self.navigationController.view);
                make.bottom.equalTo(self.navigationController.view);
            }];
            
            finishView = [[UIView alloc]init];
            finishView.backgroundColor = [UIColor whiteColor];
            [self.navigationController.view addSubview:finishView];
            [finishView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.navigationController.view);
                make.right.equalTo(self.navigationController.view);
                make.bottom.equalTo(self.navigationController.view);
                make.height.offset(200);
            }];
            
            UIButton *cha = [UIButton buttonWithType:UIButtonTypeCustom];
            [cha setBackgroundImage:[UIImage imageNamed:@"chacha"] forState:UIControlStateNormal];
            [cha addTarget:self action:@selector(chaClick:) forControlEvents:UIControlEventTouchUpInside];
            [finishView addSubview:cha];
            [cha mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(finishView).offset(-10);
                make.top.equalTo(finishView).offset(10);
            }];
            
            UILabel *finishlbael = [[UILabel alloc]init];
            finishlbael.text = @"订单已完成";
            [finishView addSubview:finishlbael];
            [finishlbael mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(finishView);
                make.top.equalTo(finishView).offset(30);
            }];
            
            UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"changxian"]];
            [finishView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(finishView);
                make.top.equalTo(finishlbael.mas_bottom).offset(10);
            }];
            
            UILabel *label2 = [[UILabel alloc]init];
            label2.text = @"消费10积分，本次应支付0元。";
            label2.textColor = RGB(112, 112, 112);
            [finishView addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(finishView);
                make.top.equalTo(line).offset(30);
            }];
            
            UIButton *evaluation = [UIButton buttonWithType:UIButtonTypeCustom];
            [evaluation setBackgroundColor:RGBHex(g_blue)];
            [evaluation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [evaluation setTitle:@"去评价" forState:UIControlStateNormal];
            [evaluation addTarget:self action:@selector(evaluationClick:) forControlEvents:UIControlEventTouchUpInside];
            evaluation.layer.cornerRadius = 5;
            evaluation.layer.masksToBounds = YES;
            [finishView addSubview:evaluation];
            [evaluation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(finishView);
                make.bottom.equalTo(finishView).offset(-30);
                make.width.offset(120);
                make.height.offset(40);
            }];

            
        }else{
            [self showPayDialog];
        }
    }
}
-(void)chaClick:(id)sender{
    if (backview) {
        [backview removeFromSuperview];
    }
    if (finishView) {
        [finishView removeFromSuperview];
    }
}
-(void)evaluationClick:(id)sender{
    if (backview) {
        [backview removeFromSuperview];
    }
    if (finishView) {
        [finishView removeFromSuperview];
    }
    
    AppraiseController *comments = [[AppraiseController alloc] init];
    //                comments.delegateCallback = self;
    comments.orderId = self.orderId;
    comments.orderModel = _order_model;
    comments.isNeedToRoot = YES;
    [self.navigationController pushViewController:comments animated:YES];
}

- (void) gesture:(UITapGestureRecognizer*)gesture
{
    [_pay_container removeFromSuperview];
}

- (void) showPayDialog
{
    if (!_pay_container) {
        _pay_container = [[PayCollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_pay_container setBackgroundColor:RGBHexa(g_black, 0.5)];
        [self.view addSubview:_pay_container];
        [_pay_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.height.equalTo(self.view);
        }];
        _pay_container.delegate = self;
    }else{
        [self.view addSubview:_pay_container];
        [_pay_container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.height.equalTo(self.view);
        }];
        _pay_container.delegate = self;
    }

}

- (void) callback:(id)sender
{
    NSLog(@"sender");
    _isFinishController = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+ (BOOL) hasVisiabled
{
    return PayOrderController_HAS_VISIABLE;
}

@end
