//
//  chooseAddressViewController.m
//  callmec
//
//  Created by wt on 2016/11/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "chooseAddressViewController.h"
#import "chooseAddressTableViewCell.h"
@interface chooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *nameArray;
    NSMutableArray *latArray;          //维度  短的
    NSMutableArray *lonArray;          //经度  长的
    NSMutableArray *distanceArray;          //经度  长的

    NSDictionary *allDatas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation chooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"上车地点"];
    

    // Do any additional setup after loading the view from its nib.
    nameArray = [_addressDic objectForKey:@"nameArray"];
    latArray = [_addressDic objectForKey:@"latArray"];
    lonArray = [_addressDic objectForKey:@"lonArray"];
    allDatas = [_addressDic objectForKey:@"allDatas"];
    distanceArray = [_addressDic objectForKey:@"distanceArray"];

}


#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArray.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"chooseAddressTableViewCell";
    chooseAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"chooseAddressTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.label.text = nameArray[indexPath.row];
    cell.distabceLabel.text = [NSString stringWithFormat:@"%.1f公里",[distanceArray[indexPath.row] floatValue]/1000];
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    [headView setBackgroundColor:RGB(235, 235, 235)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 100, 30)];
    label.text = @"选择地点";
    label.textColor = RGB(120, 120, 120);
    label.font = [UIFont systemFontOfSize:15];
    [headView addSubview:label];
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate sendDatas:nameArray[indexPath.row] lat:latArray[indexPath.row] lon:lonArray[indexPath.row] where:@"0" startDatas:allDatas endDatas:nil ];

    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:distanceArray[indexPath.row],@"distance",nameArray[indexPath.row],@"name",latArray[indexPath.row],@"lat",lonArray[indexPath.row],@"lon",allDatas,@"allDatas",[_addressDic objectForKey:@"startShortLine"],@"startShortLine",nil];
    NSLog(@"%@",dic);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SEND_START_ADDRESS" object:dic];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
