//
//  AppiontmentController.m
//  callmec
//  预约
//  Created by sam on 16/7/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppiontmentController.h"

#import <AMapSearchKit/AMapSearchAPI.h>
#import "SearchAddressController.h"
#import "WaitDriverController.h"
#import "ChooseRouteController.h"
#import "WaitingCarPoolingCtrl.h"
#import "BrowerController.h"

#import "CarsChoiceView.h"
#import "TripAdressView.h"
//#import "LeftIconView.h"
#import "LeftInputView.h"
#import "BottomDialogView.h"

#import "CarModel.h"
#import "MyTimePickerView.h"
#import "MyTimeTool.h"

#import "CMSearchManager.h"
#import "CMDriverManager.h"
#import "DriverOrderInfo.h"
#import "AppiontRouteModel.h"
#import "DriverOrderInfo.h"
#import "CarOrderModel.h"
#import "CMLocation.h"


@interface AppiontmentController()<TripViewDelegate,SearchViewControllerDelegate,TargetActionDelegate,CallBackDelegate>
@property (nonatomic,strong) UIScrollView *containerView;
@property (nonatomic,strong) UIButton *buttonCall;
@property (nonatomic,strong) UIView *tripView;
@property (nonatomic,strong) CarsChoiceView *carsView;
@property (nonatomic,strong) AMapPath *amap_path;
@property (nonatomic,strong) TripMode *tmode;
@property (nonatomic,strong) CarModel *cmodel;
@property (nonatomic,strong) NSArray *carArray;
@property (nonatomic,assign) NSInteger locationType;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,strong) AppiontRouteModel *routeModel;
@property (nonatomic,assign) NSInteger peopleNumber;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *aboutMoney;
@property (nonatomic,strong) UIButton *buttonInsurance;

@property (nonatomic,strong) LeftInputView *agreePeopleNumber;
@property (nonatomic,strong) LeftInputView *thankFee;
@property (nonatomic,strong) LeftInputView *feedbackMessage;

@end

@implementation AppiontmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    NSLog(@"%@",_startLocation);
    NSLog(@"%@",_offLocation);
    NSLog(@"%@",_location);
    NSLog(@"%@",_allDatas);
    NSLog(@"%@",_startTime);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   
    [_containerView setContentSize:CGSizeMake(self.view.frame.size.width, 640)];
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.view layoutSubviews];
}

- (void) initView
{
    _containerView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_containerView setContentSize:CGSizeMake(kScreenSize.width, 640)];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    
    [self.view setBackgroundColor:RGBHex(g_gray)];
    [self setTitle:@"发布快车行程"];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    /*
     [self.rightButton setTitle:@"计价说明" forState:UIControlStateNormal];
     [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
     */
    [self setRightButtonText:@"计价说明" withFont:[UIFont systemFontOfSize:14]];
    [self.rightButton setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    
    _tripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_tripView setBackgroundColor:[UIColor redColor]];
//    [_tripView.layer setCornerRadius:5];
//    [_tripView.layer setMasksToBounds:YES];
    [_tripView setBackgroundColor:[UIColor whiteColor]];
    _city = _startLocation.city;
    
    [_containerView addSubview:_tripView];
    
    [_tripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(198);
    }];

    //////1
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"请填写以下快车信息"];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_tripView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tripView).offset(10);
        make.left.equalTo(_tripView).offset(10);
        make.height.mas_equalTo(30);
        make.width.equalTo(_tripView);
    }];
    
    UIView *lineone =[[UIView alloc] init];
    [lineone setBackgroundColor:RGBHex(g_gray)];
    [_tripView addSubview:lineone];
    [lineone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(_tripView).offset(10);
        make.right.equalTo(_tripView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    //选择上车地点6
    _agreePeopleNumber = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_agreePeopleNumber setTitleFont:[UIFont systemFontOfSize:14]];
    [_agreePeopleNumber setTitle:@"1人"];
    _peopleNumber = 1;
    [_agreePeopleNumber setPlaceHolder:@"选择上车人数"];
    [_agreePeopleNumber setTag:3];
    [_agreePeopleNumber setImageUrl:@"2"];
    [_agreePeopleNumber setEnable:NO];
    [_agreePeopleNumber setDelegate:self];
    [_tripView addSubview:_agreePeopleNumber];
    [_agreePeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineone.mas_bottom);
        make.left.equalTo(_tripView);
        make.height.mas_equalTo(50);
        make.width.equalTo(_tripView);
    }];
    
    UIView *linetfive =[[UIView alloc] init];
    [linetfive setBackgroundColor:RGBHex(g_gray)];
    [_tripView addSubview:linetfive];
    [linetfive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreePeopleNumber.mas_bottom).offset(0);
        make.left.equalTo(_tripView).offset(40);
        make.right.equalTo(_tripView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    //thankFee
    //选择上车地点6
    _thankFee = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_thankFee setTitleFont:[UIFont systemFontOfSize:14]];
//    [_thankFee setTitle:@"选择绕路感谢费"];
    [_thankFee setPlaceHolder:@"选择绕路感谢费"];
    [_thankFee setTag:4];
    [_thankFee setImageUrl:@"30yuan"];
    [_thankFee setDelegate:self];
    [_thankFee setEnable:NO];
    [_tripView addSubview:_thankFee];
    [_thankFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linetfive.mas_bottom);
        make.left.equalTo(_tripView);
        make.height.mas_equalTo(50);
        make.width.equalTo(_tripView);
    }];
    
    UIView *linetsix =[[UIView alloc] init];
    [linetsix setBackgroundColor:RGBHex(g_gray)];
    [_tripView addSubview:linetsix];
    [linetsix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thankFee.mas_bottom).offset(0);
        make.left.equalTo(_tripView).offset(40);
        make.right.equalTo(_tripView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    //LeftInputView
    
    
    _feedbackMessage = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_feedbackMessage setTitleFont:[UIFont systemFontOfSize:14]];
    [_feedbackMessage setPlaceHolder:@"输入备注：例如“携带儿童”"];
    [_feedbackMessage setImageUrl:@"beizhu"];
    [_feedbackMessage setDelegate:self];
    [_feedbackMessage setTag:5];
    [_tripView addSubview:_feedbackMessage];
    [_feedbackMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linetsix.mas_bottom);
        make.left.equalTo(_tripView);
        make.height.mas_equalTo(50);
        make.width.equalTo(_tripView);
    }];
    
    UIView *linetseven =[[UIView alloc] init];
    [linetseven setBackgroundColor:RGBHex(g_gray)];
    [_tripView addSubview:linetseven];
    [linetseven mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feedbackMessage.mas_bottom).offset(0);
        make.left.equalTo(_tripView).offset(40);
        make.right.equalTo(_tripView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _buttonInsurance = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonInsurance setTitle:@"购买保险" forState:UIControlStateNormal];
    [_buttonInsurance.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonInsurance setContentMode:UIViewContentModeBottomLeft];
    [_buttonInsurance setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [_buttonInsurance setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateSelected];
    [_buttonInsurance setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateHighlighted];
    [_buttonInsurance addTarget:self action:@selector(buttonSwitchStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonInsurance setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_buttonInsurance setImageEdgeInsets:UIEdgeInsetsMake(0, -180, 0, 0)];
    [_buttonInsurance setTitleEdgeInsets:UIEdgeInsetsMake(0, -155, 0, 0)];
    [_buttonInsurance setHidden:YES];
//    [_buttonInsurance setBackgroundColor:[UIColor redColor]];
    [_tripView addSubview:_buttonInsurance];
    [_buttonInsurance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linetseven.mas_bottom);
        make.left.equalTo(_tripView).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(260);
    }];
    
    _carsView =[[CarsChoiceView alloc] init];
    CarModel *model1 = [[CarModel alloc] initWithDictionary:@{@"carTitle":@"轿车",
                                                              @"carIcon":@"putonghei",
                                                              @"carIconLight":@"putonglan",
                                                              @"carType":@"4",
                                                              @"isSelected":@"0",
                                                              @"carMoney":@"10.0"} error:nil];
    CarModel *model2 = [[CarModel alloc] initWithDictionary:@{@"carTitle":@"7座商务",
                                                              @"carIcon":@"haohuahei",
                                                              @"carIconLight":@"haohualan",
                                                              @"isSelected":@"1",
                                                              @"carType":@"3",
                                                              @"carMoney":@"10.0"} error:nil];
    CarModel *model3 = [[CarModel alloc] initWithDictionary:@{@"carTitle":@"豪华商务",
                                                              @"carIcon":@"icon_cartype_3",
                                                              @"carIconLight":@"icon_cartype_fcs3",
                                                              @"isSelected":@"0",
                                                              @"carType":@"5",
                                                              @"carMoney":@"10.0"} error:nil];
    _cmodel = model2;
    _carArray =[NSArray arrayWithObjects:model2,model1, nil];
    [_carsView setDataArray:_carArray];
    [_containerView addSubview:_carsView];
    [_carsView.layer setCornerRadius:5];
    [_carsView.layer setMasksToBounds:YES];
    [_carsView setDelegate:self];
    
    [_carsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tripView.mas_bottom).offset(10);
        make.left.equalTo(_containerView);
        make.width.equalTo(_containerView);
        make.height.mas_equalTo(120);
    }];
    
    _buttonCall = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_buttonCall.layer setCornerRadius:5];
//    [_buttonCall.layer setMasksToBounds:YES];
    [_buttonCall setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateNormal];
    [_buttonCall setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateHighlighted];
    
    //    [_buttonCall setImage:[ImageTools imageWithColor:RGBHex(g_gray)] forState:UIControlStateNormal];
    
    [_buttonCall setTitle:@"发布快车" forState:UIControlStateNormal];
    [_buttonCall.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonCall addTarget:self action:@selector(buttonTargetSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonCall];
    [_buttonCall mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self caculater];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) buttonTargetSubmit:(UIButton*)button
{
    if (!_startTime) {
        [MBProgressHUD showAndHideWithMessage:@"请选择出发时间" forHUD:nil];
        return;
    }
    if (_peopleNumber==0) {
        [MBProgressHUD showAndHideWithMessage:@"请选择搭乘人数" forHUD:nil];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    NSString *userId = [GlobalData sharedInstance].user.userInfo.ids;
    [params setObject:userId?userId:@"" forKey:@"memberId"];
    
    [order setObject:_cmodel.carType forKey:@"carType"];
    [order setObject:_tripTypeModel.tripType forKey:@"type"];
    [order setObject:[_allDatas objectForKey:@"id"] forKey:@"lineId"];
    [order setObject:@"true" forKey:@"appoint"];
    [order setObject:@(_peopleNumber) forKey:@"orderPerson"];
    
    NSMutableDictionary *other = [NSMutableDictionary dictionary];
    [other setObject:_money?_money:@"0" forKey:@"fee"];
    [other setObject:@"绕路费" forKey:@"name"];
    [other setObject:@"10" forKey:@"type"];
    NSArray *array = [NSArray arrayWithObject:other];
    [order setObject:array forKey:@"otherFee"];//array lk_JSONString]
    if (_startTime) {
        [order setObject:[MyTimeTool formatDateTime:_startTime withFormat:@"yyyy-MM-dd HH:mm:00"] forKey:@"appointDate"];
    }else{
        return;
    }
    
    [order setObject:_tmode.distance?_tmode.distance:@"0" forKey:@"distance"];
    
    [order setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.longitude] forKey:@"sLongitude"];
    [order setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.latitude] forKey:@"sLatitude"];
    [order setObject:_startLocation.name?_startLocation.name:@"" forKey:@"sLocation"];
    
    [order setObject:[NSString stringWithFormat:@"%f",_offLocation.coordinate.longitude] forKey:@"eLongitude"];
    [order setObject:[NSString stringWithFormat:@"%f",_offLocation.coordinate.latitude] forKey:@"eLatitude"];
    [order setObject:_offLocation.name?_offLocation.name:@"" forKey:@"eLocation"];
    
    [order setObject:_aboutMoney?_aboutMoney:@"20" forKey:@"fee"];
    [order setObject:_feedbackMessage.title?_feedbackMessage.title:@"" forKey:@"description"];
    if (_buttonInsurance.isSelected) {
        [order setObject:@"true" forKey:@"insurance"];
    }
    //lk_JSONString
    [params setObject:[order lk_JSONString] forKey:@"order"];
    NSLog(@"param:%@",params);
    
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在提交信息..." inView:nil];
    [hud show:YES];
    [button setEnabled:NO];
    [CMDriverManager sendCallCarRequest:params success:^(NSDictionary *resultDictionary) {
        NSLog(@"resultDictionary:%@",resultDictionary);
        [MBProgressHUD showAndHideWithMessage:@"已经为您通知附近的司机！请稍后!" forHUD:nil];
        [self fetchOrderInfo];
        [hud setHidden:YES];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        
        [hud setHidden:YES];
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        
    }];
}

- (void) fetchOrderInfo
{
    [CarOrderModel fetchCarPoolingOrderList:1 Succes:^(NSArray *result, int pageCount, int recordCount) {
        
        CarOrderModel *model=nil;
        for (NSDictionary *dict in result) {
            model = [[CarOrderModel alloc] initWithDictionary:dict error:nil];
            break;
        }
        if (model) {
            WaitingCarPoolingCtrl *waiter =[[WaitingCarPoolingCtrl alloc] init];
            waiter.currentLocation = self.location;
            waiter.destinationLocation = self.offLocation;
            waiter.model = model;
            if (_startTime) {
                NSString *time_fromat = [MyTimeTool formatDateTime:_startTime withFormat:nil];
                waiter.startTime = time_fromat;
            }
            //waiter.routPath = self.amap_path;
            [self.navigationController pushViewController:waiter animated:YES];
        }
       
    } failed:^(NSInteger errorCode, NSString *errorMessage)
    {
        
    }];
}

- (void) buttonTarget:(id)sender
{
    if (sender==self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender==self.rightButton){
        BrowerController *webview = [[BrowerController alloc] init];
        webview.urlStr = [CommonUtility getArticalUrl:@"4"];
        webview.titleStr = @"计价说明";
        [self.navigationController pushViewController:webview animated:YES];
    }else if([sender isKindOfClass:[UIView class]])
    {
        NSInteger index = ((UIView*)sender).tag;
        switch (index) {
            case 1:
            {
                ChooseRouteController *route = [[ChooseRouteController alloc] init];
                route.delegateCallback = self;
                [self.navigationController pushViewController:route animated:YES];
            }
                break;
            case 2:
            {
                SearchAddressController *search = [[SearchAddressController alloc] init];
                search.delegateCallback = self;
                search.targetId = 2;
                [self.navigationController pushViewController:search animated:YES];
            }
                break;
            case 6:
            {
                SearchAddressController *search = [[SearchAddressController alloc] init];
                search.delegateCallback = self;
                search.targetId = 6;
                [self.navigationController pushViewController:search animated:YES];
            }
                break;
            case 3:
            {
                BottomDialogView *dialog = [[BottomDialogView alloc] init];
                [dialog setColumnNumber:6];
                [dialog setTitle:@"请点击数字选择乘车人数"];
                [dialog setDesc:@"记得和车主侃大山噢～"];
                [dialog setDelegate:self];
                [dialog setIsNeedExtra:NO];
                [self.view addSubview:dialog];
                [dialog mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                    make.right.equalTo(self.view);
                }];
                
                for (int i=0;i<6;i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    //[btn addTarget:self action:@selector(buttonTagetPeople:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:[NSString stringWithFormat:@"%d人",i+1] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[ImageTools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                    btn.tag = i;
                    [dialog addContainerView:btn];
                }
                
                [dialog updateContainerHeight:140];
                
            }
                break;
            case 4:
            {
                BottomDialogView *dialog = [[BottomDialogView alloc] init];
                [dialog setColumnNumber:7];
                [dialog setIsNeedExtra:YES];
                [dialog setTitle:@"请点击选择绕路感谢费"];
                [dialog setDesc:@"车主平均要多花费20分钟接送乘客，加一些感谢费会更快被接单！"];
                [dialog setDelegate:self];
                [dialog setIsNeedExtra:YES];
                [self.view addSubview:dialog];
                [dialog mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                    make.right.equalTo(self.view);
                }];
                
                for (int i=0;i<3;i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                    [btn addTarget:self action:@selector(buttonTagetMoney:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:[NSString stringWithFormat:@"%d元",(i+1)*5] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[ImageTools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                    btn.tag = i;
                    [dialog addContainerView:btn];
                }
                
                [dialog updateContainerHeight:160];
            }
                break;
            default:
                break;
        }
        
    }
    
}

- (void)buttonSwitchStatus:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (void) buttonSelected:(UIView *)view Index:(NSInteger)index
{
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton*)view;
        NSRange range = [btn.titleLabel.text rangeOfString:@"元"];
        if (range.location !=NSNotFound) {
            _money = [btn.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
            [_thankFee setTitle:btn.titleLabel.text];
            [self caculater];
        }else{
            _peopleNumber = btn.tag+1;
            [_agreePeopleNumber setTitle:btn.titleLabel.text];
            [self caculater];
        }
    }
}

- (void) buttonSelectedIndex:(NSInteger)index
{
    _cmodel = _carArray[index];
    [self caculater];
}

- (void) caculater
{
    @try {
        _buttonCall.userInteractionEnabled = NO;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_cmodel.carType forKey:@"carType"];
        [params setObject:_tripTypeModel.tripType forKey:@"type"];
        [params setObject:[_allDatas objectForKey:@"id"] forKey:@"lineId"];
        [params setObject:@"true" forKey:@"appoint"];
        [params setObject:@(_peopleNumber) forKey:@"orderPerson"];
        [params setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.latitude]forKey:@"sLatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.longitude] forKey:@"sLongitude"];
        
        NSMutableDictionary *other = [NSMutableDictionary dictionary];
        [other setObject:_money?_money:@"0" forKey:@"fee"];
        [other setObject:@"绕路费" forKey:@"name"];
        [other setObject:@"10" forKey:@"type"];
        NSArray *array = [NSArray arrayWithObject:other];
        [params setObject:[array lk_JSONString] forKey:@"otherFee"];
        if (_startTime) {
            [params setObject:[MyTimeTool formatDateTime:_startTime withFormat:@"yyyy-MM-dd HH:mm:00"] forKey:@"appointDate"];
        }else{
            return;
        }
        NSLog(@"%@",params);
        [DriverOrderInfo fetchOrderFee:params success:^(NSDictionary *resultDictionary) {
            NSLog(@"resultDictionary:%@",resultDictionary);
            _buttonCall.userInteractionEnabled = YES;
            NSDictionary *data = resultDictionary[@"data"];
            _aboutMoney = data[@"totalFee"];
            [_carsView setAboutMoney:_aboutMoney];
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            NSLog(@"errorMessage:%@",errorMessage);
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }

}

- (void) callback:(id)sender
{
    if ([sender isKindOfClass:[AppiontRouteModel class]]) {
        _routeModel = (AppiontRouteModel*)sender;
    }else if([sender isKindOfClass:[CMLocation class]]){
       CMLocation *loction =  (CMLocation*)sender;
        if (loction.targetIndex==2) {
            _location = loction;
        }else if (loction.targetIndex==6) {
            _offLocation = loction;
        }
    }
}
@end
