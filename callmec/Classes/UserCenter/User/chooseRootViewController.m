//
//  chooseRootViewController.m
//  callmec
//
//  Created by wt on 2016/11/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "chooseRootViewController.h"
#import "HomeMapController.h"

@interface chooseRootViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewHeight;

@end

@implementation chooseRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftButton.hidden = YES;
    self.view.backgroundColor = RGB(238, 249, 255);
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"选择用途"];
    
    float height = ((SCREENWIDTH/2-33)/172)*139;
    _leftViewHeight.constant = height;
    _rightViewHeight.constant = height;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(UIButton *)sender {
    HomeMapController *homemapCtr = [[HomeMapController alloc]init];
    switch (sender.tag) {
        case 901:
            [USERDEFAULTS setObject:@"1" forKey:@"selectHomeButton"];
            break;
        case 902:
            [USERDEFAULTS setObject:@"2" forKey:@"selectHomeButton"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:homemapCtr animated:YES];
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
