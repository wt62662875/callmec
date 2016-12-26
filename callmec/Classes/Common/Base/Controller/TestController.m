//
//  TestController.m
//  callmec
//
//  Created by sam on 16/7/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TestController.h"
#import "DriverOrderView.h"
#import "CarPoolingCancelCtrl.h"
#import "DriverNoticeView.h"

@interface TestController ()
//@property (nonatomic,strong) DriverOrderView *order_view;
@property (nonatomic,strong) DriverNoticeView *order_view;
@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _order_view = [[DriverOrderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.view addSubview:_order_view];
//    
//    [_order_view mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
//    [_order_view.top_container mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerView.mas_bottom);
//    }];
    
    NSDictionary *dd = @{
                         @"carDesc":@"",
                         @"carNo":@"AA8888",
                         @"driverId":@(9),
                         @"driverName":@"张三",
                         @"gender":@(0),
                         @"id":@"613",
                         @"level":@"3",
                         @"oType":@"1",
                         @"phoneNo":@"13560360291",
                         @"rate":@"100%",
                         @"serviceNum":@"48",
                         @"type":@"3"
                         };
    
    DriverOrderInfo *order = [[DriverOrderInfo alloc] initWithDictionary:dd error:nil];
        _order_view = [[DriverNoticeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_order_view setModel:order];
        [self.view addSubview:_order_view];
    
        [_order_view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    //DriverNoticeView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
//    CarPoolingCancelCtrl *cancel = [[CarPoolingCancelCtrl alloc] init];
//    [self.navigationController pushViewController:cancel animated:YES];
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
