//
//  BaseController.m
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rightTitle;

@property (nonatomic,strong) UIFont *leftFont;
@property (nonatomic,strong) UIFont *rightFont;

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    // Do any additional setup after loading the view.
}

- (void) setRightButtonText:(NSString*)title withFont:(UIFont*)font
{
    self.rightTitle = title;
    self.rightFont = font;
    
    if (_rightButton) {
        [_rightButton setTitle:title forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:font];
        CGSize size = [title sizeWithFont:font maxSize:CGSizeMake(180, 2000)];
        [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width+10);
        }];
    }
}
- (void) setLeftButtonText:(NSString*)title withFont:(UIFont*)font
{
    self.leftTitle = title;
    self.leftFont = font;
    
    if (_leftButton) {
        [_leftButton setTitle:title forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:font];
        
        CGSize size = [title sizeWithFont:font maxSize:CGSizeMake(180, 2000)];
        [_leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width+10);
        }];
    }
}

- (void) initHeaderView
{
    self.navigationController.navigationBar.hidden = YES;
    _headerView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,KTopbarH)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_headerView];
//    [_headerView setBackgroundColor:RGB(235, 235, 235)];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(KTopbarH);
    }];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_headerView addSubview:_leftButton];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(20);
        make.left.equalTo(_headerView).offset(10);
        make.width.height.mas_equalTo(44);
        make.bottom.equalTo(_headerView).offset(0);
        
    }];
    
    //top_msg
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_headerView addSubview:_rightButton];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(20);
        make.right.equalTo(_headerView).offset(-10);
        make.width.height.mas_equalTo(44);
    }];
    _bottomHeaderLine =[[UIView alloc] init];
    [_bottomHeaderLine setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];//
    [_headerView addSubview:_bottomHeaderLine];
    [_bottomHeaderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerView);
        make.bottom.equalTo(_headerView);
        make.height.mas_equalTo(1);
        make.width.equalTo(_headerView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [_headerView addSubview:_titleLabel];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(20);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(_headerView);
    }];
    
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    CGSize size = [title sizeFont:20];
    [_titleLabel setText:title];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+10);
    }];
}

- (void) initDefaultHeader
{
    [self setTitle:@"用户登录"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightTitle = @"注册用户";
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) buttonTarget:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) callback:(id)sender
{

}

- (void)reloadData
{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void) initLocationConfig
{
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager setLocationTimeout:6];
    [_locationManager setReGeocodeTimeout:3];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self startLocation];
}
- (void) startLocation
{
    NSLog(@"startLocation");
    [_locationManager startUpdatingLocation];
}

- (void)stopLocation
{
    NSLog(@"stopLocation");
    [_locationManager stopUpdatingLocation];
}
- (void) amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"amapLocationManager error:%@",error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"amapLocationManager didUpdateLocation:latitude:%f longitude:%f",
          location.coordinate.latitude,
          location.coordinate.longitude);
    if ([GlobalData sharedInstance].coordinate.latitude!=0) {
//        CLLocation *oLocation = [[CLLocation alloc] initWithLatitude:[GlobalData sharedInstance].coordinate.latitude longitude:[GlobalData sharedInstance].coordinate.longitude];
        [GlobalData sharedInstance].coordinate = location.coordinate;
    }else{
        [GlobalData sharedInstance].coordinate = location.coordinate;
    }
    //[self locateAction];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
