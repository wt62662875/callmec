//
//  helpViewController.m
//  callmec
//
//  Created by wt on 2017/2/10.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "helpViewController.h"
#import "BrowerController.h"

@interface helpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation helpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"设置"];
    self.view.backgroundColor = RGBHex(g_assit_gray);
    self.headerView.backgroundColor = [UIColor whiteColor];
    _versionLabel.text = [NSString stringWithFormat:@"当前版本：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(UIButton *)sender {
    BrowerController *brower = [[BrowerController alloc] init];

    switch (sender.tag) {
        case 0:
            [brower setTitleStr:@"使用指南"];
            brower.urlStr =[NSString stringWithFormat:@"%@getArticle?id=1&token=%@",
                            kserviceURL,
                            [GlobalData sharedInstance].user.session];
            [self.navigationController pushViewController:brower animated:YES];
            break;
        case 1:
            [brower setTitleStr:@"法律条款"];
            brower.urlStr =[NSString stringWithFormat:@"%@getArticle?id=2&token=%@",
                            kserviceURL,
                            [GlobalData sharedInstance].user.session];
            [self.navigationController pushViewController:brower animated:YES];
            break;
        case 2:
            [brower setTitleStr:@"版本信息"];
            brower.urlStr =[NSString stringWithFormat:@"%@getArticle?id=3&token=%@&version=%@",
                            kserviceURL,
                            [GlobalData sharedInstance].user.session,
                            [CommonUtility versions]];
            [self.navigationController pushViewController:brower animated:YES];
            break;
        default:
            break;
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

@end
