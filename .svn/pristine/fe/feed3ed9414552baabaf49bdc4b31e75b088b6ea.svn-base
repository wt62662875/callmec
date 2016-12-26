//
//  chooseEndAddressViewController.m
//  callmec
//
//  Created by wt on 2016/12/20.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "chooseEndAddressViewController.h"
#import "CMSearchManager.h"

@interface chooseEndAddressViewController ()
{
    NSArray *nameArray;
    NSArray *latArray;
    NSArray *lonArray;
    NSArray *distanceArray;

}
@property (weak, nonatomic) IBOutlet UIView *serchView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *recommendedView;
@property (weak, nonatomic) IBOutlet UILabel *recommendedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendedLine;
@property (weak, nonatomic) IBOutlet UITableView *serchTableView;
@property (nonatomic, strong) NSMutableArray *locations;

@end

@implementation chooseEndAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serchView.layer.borderColor = RGB(222, 222, 222).CGColor;
    _serchView.layer.borderWidth = 1;
    _serchView.layer.cornerRadius = 5;
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"下车地点"];
    
    _serchTableView.hidden = YES;
    nameArray = [_addressDic objectForKey:@"nameArray"];
    latArray = [_addressDic objectForKey:@"latArray"];
    lonArray = [_addressDic objectForKey:@"lonArray"];
    distanceArray = [_addressDic objectForKey:@"distanceArray"];
    _locations = [NSMutableArray array];
    _recommendedView.hidden = YES;
    _recommendedLine.constant = 0;
    [_tableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SEND_END_ADDRESS" object:nil];
}
- (IBAction)textFieldChange:(id)sender {
    NSLog(@"11");
    if (_serchTableView.hidden == YES) {
        _serchTableView.hidden = NO;
    }
    [self searchTipsWithKey:_textField.text];
}
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.requireExtension = YES;
    request.keywords = key;
    
    
    if ([GlobalData sharedInstance].city.length > 0)
    {
        NSString *citys = [GlobalData sharedInstance].city;
        request.city = citys?[citys stringByReplacingOccurrencesOfString:@"市" withString:@""]:@"";
    }
    
    __weak __typeof(&*self) weakSelf = self;
    [[CMSearchManager sharedInstance] searchForRequest:request completionBlock:^(id request, id response, NSError *error) {
        if (error)
        {
            NSLog(@"error :%@", error);
        }
        else
        {
            [weakSelf.locations removeAllObjects];
            
            AMapPOISearchResponse *aResponse = (AMapPOISearchResponse *)response;
            [aResponse.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop)
             {
                 CMLocation *location = [[CMLocation alloc] init];
                 location.name = obj.name;
                 location.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
                 location.address = obj.address;
                 location.cityCode = obj.citycode;
                 location.city = obj.city;
                 NSLog(@"%@",location);
                 [weakSelf.locations addObject:location];
             }];
            
            [_serchTableView reloadData];
        }
    }];
}
- (IBAction)textFieldFirst:(id)sender {
    [_textField resignFirstResponder];
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _serchTableView) {
        return _locations.count;
    }
    return nameArray.count;
    
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _serchTableView) {
        return 60;
    }
    return 44;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _serchTableView) {
        static NSString *cellIdentifier = @"cellIdentifierL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CMLocation *location = self.locations[indexPath.row];
        
        cell.textLabel.text = location.name;
        cell.detailTextLabel.text = location.address;
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:RGBHex(g_black)];
        [cell.detailTextLabel setTextColor:RGBHex(g_assit_c)];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        return cell;
    }
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = nameArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _serchTableView) {
        [_textField resignFirstResponder];
        _serchTableView.hidden = YES;
        _recommendedView.hidden = NO;
        _recommendedLine.constant = 44;
        CMLocation *location = self.locations[indexPath.row];
        
        NSMutableArray *distanceTemp = [[NSMutableArray alloc]init];
        for (int i = 0; i<nameArray.count; i++) {
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([latArray[i] floatValue],[lonArray[i] floatValue]));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude));
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            //                    CGFloat dis = distance;
            [distanceTemp addObject:[NSString stringWithFormat:@"%f",distance]];
        }
        NSLog(@"%@",nameArray);

        NSLog(@"%@",latArray);
        NSLog(@"%@",distanceTemp);

        NSComparator cmptr = ^(id obj1, id obj2){
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 floatValue] < [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *tempDis = [distanceTemp sortedArrayUsingComparator:cmptr];
        NSMutableArray *tempName = [[NSMutableArray alloc]init];
        NSMutableArray *tempLat = [[NSMutableArray alloc]init];
        NSMutableArray *tempLon = [[NSMutableArray alloc]init];
        NSLog(@"%@",tempDis);

        for (int i = 0; i<tempDis.count; i++) {
            for (int n = 0; n<distanceTemp.count; n++) {
                if ([tempDis[i]isEqualToString:distanceTemp[n]]) {
                    [tempName addObject:nameArray[n]];
                    [tempLat addObject:latArray[n]];
                    [tempLon addObject:lonArray[n]];
                    
                }
            }
        }
        NSLog(@"%@",tempName);

        nameArray = tempName ;
        latArray = tempLat;
        lonArray = tempLon;
        distanceArray =tempDis;
        _recommendedLabel.text = [NSString stringWithFormat:@"为您推荐距离最近下车地点：%@",nameArray[0]];
        [_tableView reloadData];
        
        NSLog(@"%@",distanceArray);
    }else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:nameArray[indexPath.row] forKey:@"name"];
        [dic setValue:latArray[indexPath.row] forKey:@"lat"];
        [dic setValue:lonArray[indexPath.row] forKey:@"lon"];
        [dic setValue:distanceArray[indexPath.row] forKey:@"distance"];
        [dic setValue:[_addressDic objectForKey:@"allDatas"] forKey:@"allDatas"];
        [dic setValue:[_addressDic objectForKey:@"endShortName"] forKey:@"endShortName"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"SEND_END_ADDRESS" object:dic];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
