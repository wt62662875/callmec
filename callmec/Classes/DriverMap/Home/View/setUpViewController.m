//
//  setUpViewController.m
//  callmec
//
//  Created by wt on 2017/2/10.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "setUpViewController.h"
#import "SearchAddressController.h"

@interface setUpViewController ()<SearchViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *homeAddress;
@property (weak, nonatomic) IBOutlet UIButton *unitAddress;

@property (weak, nonatomic) IBOutlet UISwitch *swichButton;
@property (nonatomic,assign) NSInteger addressType;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@end

@implementation setUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
    self.view.backgroundColor = RGBHex(g_assit_gray);
    self.headerView.backgroundColor = [UIColor whiteColor];
    _exitButton.layer.cornerRadius = 5;
    [_swichButton setOn:[SandBoxHelper getVoiceStatus] animated:NO];
    if ([GlobalData sharedInstance].user.userInfo.address) {
        [_homeAddress setTitle:[GlobalData sharedInstance].user.userInfo.address forState:UIControlStateNormal];
    }
    if ([GlobalData sharedInstance].user.userInfo.company) {
        [_unitAddress setTitle:[GlobalData sharedInstance].user.userInfo.company forState:UIControlStateNormal];
    }

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)addressClick:(UIButton *)sender {
    SearchAddressController *search = [[SearchAddressController alloc] init];
    search.city = [GlobalData sharedInstance].city;
    search.delegate =self;
    if (sender.tag == 0) {
        _addressType = 0;
    }else{
        _addressType = 1;
    }
    [self.navigationController pushViewController:search animated:YES];

}
- (IBAction)exitClick:(id)sender {
    [[GlobalData sharedInstance].user logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)searchViewController:(SearchAddressController*)searchViewController didSelectLocation:(CMLocation *)locations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([GlobalData sharedInstance].user.isLogin) {
        [params setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"id"];
    }
    
    if (_addressType==0) {
        [params setObject:locations.name forKey:@"usualStart"];
        [params setObject:locations.name forKey:@"address"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.latitude] forKey:@"slatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.longitude] forKey:@"slongitude"];
        [params setObject:locations.name forKey:@"slocation"];
        
    }else if(_addressType==1)
    {
        [params setObject:locations.name forKey:@"usualEnd"];
        [params setObject:locations.name forKey:@"company"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.latitude] forKey:@"elatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.longitude] forKey:@"elongitude"];
        [params setObject:locations.name forKey:@"elocation"];
        
    }else{
        [params setObject:locations.name forKey:@"usualStart"];
        [params setObject:locations.name forKey:@"address"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.latitude] forKey:@"slatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.longitude] forKey:@"slongitude"];
        [params setObject:locations.name forKey:@"slocation"];
    }
    
    [UserInfoModel commitEditUserInfo:params succ:^(NSDictionary *resultDictionary) {
        NSLog(@"result:%@",resultDictionary);
        NSDictionary *data = resultDictionary[@"data"];
        UserInfoModel *user = [[UserInfoModel alloc] initWithDictionary:data error:nil];
        [GlobalData sharedInstance].user.userInfo = user;
        [[GlobalData sharedInstance].user save];
        
        
        if (_addressType==0) {
            [_homeAddress setTitle:[GlobalData sharedInstance].user.userInfo.address forState:UIControlStateNormal];
        }else{
            [_unitAddress setTitle:[GlobalData sharedInstance].user.userInfo.company forState:UIControlStateNormal];

        }
        [MBProgressHUD showAndHideWithMessage:@"保存成功" forHUD:nil];
        //[];
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"%ld %@",(long)errorCode,errorMessage);
        //[MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)swichButton:(id)sender {
    [SandBoxHelper setVoiceStatus:_swichButton.on];
}
- (IBAction)callButton:(id)sender {
    [CommonUtility callTelphone:@"400-0885-855"];
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
