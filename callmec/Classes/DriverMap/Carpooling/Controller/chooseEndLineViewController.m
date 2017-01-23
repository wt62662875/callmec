//
//  chooseEndLineViewController.m
//  callmec
//
//  Created by wt on 2017/1/10.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "chooseEndLineViewController.h"
#import "collectionCell.h"
#import "headCollectionReusableView.h"
#import "chooseEndAddressViewController.h"

@interface chooseEndLineViewController ()
{
    NSMutableArray *datasArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *serchBtn;
@property (weak, nonatomic) IBOutlet UIView *serchView;
@property (weak, nonatomic) IBOutlet UITextField *serchTextField;
@end

@implementation chooseEndLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serchBtn.layer.cornerRadius = 5;
    _serchBtn.layer.masksToBounds = YES;
    _serchView.layer.borderColor = RGB(230, 230, 230).CGColor;
    _serchView.layer.borderWidth = 1;
    _serchView.layer.cornerRadius = 5;
    [self setTitle:@"目的地"];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];

    [_collectionView registerNib:[UINib nibWithNibName:@"collectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"headCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCollectionReusableView"];
    // Do any additional setup after loading the view from its nib.
    [self getdatas];
    
    // 下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        datasArray = [[NSMutableArray alloc]init];
        [self getdatas];
    }];
//    [USERDEFAULTS setObject:nil forKey:@"SearchEndHistory"];

}
-(void)getdatas{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@-",_startLine] forKey:@"name"];

    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *resultArray = [resultDictionary objectForKey:@"rows"];
        datasArray = [[NSMutableArray alloc]init];
        NSMutableArray *shortNameArray = [[NSMutableArray alloc]init];
        if ([USERDEFAULTS objectForKey:@"SearchEndHistory"]) {
            [datasArray addObject:[USERDEFAULTS objectForKey:@"SearchEndHistory"]];
        }
        for (int i = 0; i<resultArray.count; i++) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[self getString:[resultArray[i] objectForKey:@"name"]],@"shortName", nil];
            [shortNameArray addObject:tempDic];
        }
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"热门城镇"],@"shortName",shortNameArray ,@"children",nil];
        [datasArray addObject:tempDic];

        NSLog(@"%@",datasArray);
        
        [_collectionView reloadData];
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];

}
-(void)checkLine:(NSString *)startLine endLine:(NSString *)endLine{
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"加载中..." inView:nil];
    [hud show:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@-%@",startLine,endLine] forKey:@"name"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *tempArray = [resultDictionary objectForKey:@"rows"];
        
        if (tempArray.count != 0) {
            NSMutableArray *allDatas = tempArray[0];
            NSString *str = [tempArray[0] objectForKey:@"points"];
            str = [str substringToIndex:[str length]-1];
            NSArray *array = [self getArray:str symbol:@";"]; //从字符A中分隔成2个元素的数组
            
            NSMutableArray *nameArray = [[NSMutableArray alloc]init];
            NSMutableArray *latArray = [[NSMutableArray alloc]init];
            NSMutableArray *lonArray = [[NSMutableArray alloc]init];
            NSMutableArray *tempMutableArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<array.count; i++) {
                [nameArray addObject:[self getArray:array[i] symbol:@":"][0]];
                [tempMutableArray addObject:[self getArray:array[i] symbol:@":"][1]];
            }
            for (int i = 0; i<tempMutableArray.count; i++) {
                [lonArray addObject:[self getArray:tempMutableArray[i] symbol:@","][0]];
                [latArray addObject:[self getArray:tempMutableArray[i] symbol:@","][1]];
            }
            
            NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<latArray.count; i++) {
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([latArray[i] doubleValue],[lonArray[i] doubleValue]));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([GlobalData sharedInstance].coordinate.latitude,[GlobalData sharedInstance].coordinate.longitude));
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                //                    CGFloat dis = distance;
                [distanceArray addObject:[NSString stringWithFormat:@"%f",distance]];
            }
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([obj1 floatValue] > [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *tempDis = [distanceArray sortedArrayUsingComparator:cmptr];
            NSMutableArray *tempName = [[NSMutableArray alloc]init];
            NSMutableArray *tempLat = [[NSMutableArray alloc]init];
            NSMutableArray *tempLon = [[NSMutableArray alloc]init];
            
            for (int i = 0; i<tempDis.count; i++) {
                for (int n = 0; n<distanceArray.count; n++) {
                    if ([tempDis[i]isEqualToString:distanceArray[n]]) {
                        [tempName addObject:nameArray[n]];
                        [tempLat addObject:latArray[n]];
                        [tempLon addObject:lonArray[n]];
                    }
                }
            }
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:tempDis[0],@"distance",tempName[0],@"name",tempLat[0],@"lat",tempLon[0],@"lon",allDatas,@"allDatas",startLine,@"startShortLine",nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SEND_START_ADDRESS" object:dic];
            [self theCheckLine:startLine endLine:endLine];
            [hud hide:YES];
            
        }else{
            [MBProgressHUD showAndHideWithMessage:@"抱歉,你搜索的地点没有车辆···" forHUD:nil];
            [hud hide:YES];
            
        }
        
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud hide:YES];
        
    }];
}
-(void)theCheckLine:(NSString *)startLine endLine:(NSString *)endLine{
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"加载中..." inView:nil];
    [hud show:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@-%@",endLine,startLine] forKey:@"name"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *tempArray = [resultDictionary objectForKey:@"rows"];
        
        if (tempArray.count != 0) {
            [self serchAdd:endLine];

            NSMutableArray *allDatas = tempArray[0];
            NSString *str = [tempArray[0] objectForKey:@"points"];
            str = [str substringToIndex:[str length]-1];
            NSArray *array = [self getArray:str symbol:@";"]; //从字符A中分隔成2个元素的数组
            
            NSMutableArray *nameArray = [[NSMutableArray alloc]init];
            NSMutableArray *latArray = [[NSMutableArray alloc]init];
            NSMutableArray *lonArray = [[NSMutableArray alloc]init];
            NSMutableArray *tempMutableArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<array.count; i++) {
                [nameArray addObject:[self getArray:array[i] symbol:@":"][0]];
                [tempMutableArray addObject:[self getArray:array[i] symbol:@":"][1]];
            }
            for (int i = 0; i<tempMutableArray.count; i++) {
                [lonArray addObject:[self getArray:tempMutableArray[i] symbol:@","][0]];
                [latArray addObject:[self getArray:tempMutableArray[i] symbol:@","][1]];
            }
            NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<latArray.count; i++) {
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([latArray[i] doubleValue],[lonArray[i] doubleValue]));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([GlobalData sharedInstance].coordinate.latitude,[GlobalData sharedInstance].coordinate.longitude));
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                //                    CGFloat dis = distance;
                [distanceArray addObject:[NSString stringWithFormat:@"%f",distance]];
            }
            NSLog(@"%@",distanceArray);
            NSLog(@"%@",nameArray);
            NSLog(@"%@",latArray);
            
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([obj1 floatValue] > [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *tempDis = [distanceArray sortedArrayUsingComparator:cmptr];
            NSMutableArray *tempName = [[NSMutableArray alloc]init];
            NSMutableArray *tempLat = [[NSMutableArray alloc]init];
            NSMutableArray *tempLon = [[NSMutableArray alloc]init];
            
            for (int i = 0; i<tempDis.count; i++) {
                for (int n = 0; n<distanceArray.count; n++) {
                    if ([tempDis[i]isEqualToString:distanceArray[n]]) {
                        [tempName addObject:nameArray[n]];
                        [tempLat addObject:latArray[n]];
                        [tempLon addObject:lonArray[n]];
                    }
                }
            }
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:tempDis,@"distanceArray",tempName,@"nameArray",tempLat,@"latArray",tempLon,@"lonArray",allDatas,@"allDatas",endLine,@"endShortName",nil];
            chooseEndAddressViewController *endAdd= [[chooseEndAddressViewController alloc]initWithNibName:@"chooseEndAddressViewController" bundle:nil];
            [endAdd setAddressDic:dic];
            [self.navigationController pushViewController:endAdd animated:YES];
            [hud hide:YES];
            
        }else{
            [MBProgressHUD showAndHideWithMessage:@"抱歉,你搜索的地点没有车辆···" forHUD:nil];
            [hud hide:YES];
            
        }
        
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud hide:YES];
        
    }];
}
//搜索记录增加变更
-(void)serchAdd:(NSString *)sender{
    if (![USERDEFAULTS objectForKey:@"SearchEndHistory"]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"历史搜索",@"shortName",[[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc] initWithObjectsAndKeys:sender,@"shortName", nil], nil],@"children", nil];
        [USERDEFAULTS setObject:dic forKey:@"SearchEndHistory"];
    }else{
        NSMutableArray *tempArr = [[[USERDEFAULTS objectForKey:@"SearchEndHistory"] objectForKey:@"children"] mutableCopy];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (int n = 0; n<tempArr.count; n++) {
            [temp addObject:[tempArr[n] objectForKey:@"shortName"]];
        }
        if ([temp containsObject:sender]) {
            [temp removeObject:sender];
            [temp insertObject:sender atIndex:0];
        }else{
            [temp insertObject:sender atIndex:0];
        }
        if (temp.count >6) {
            [temp removeLastObject];
        }
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 0; i<temp.count; i++) {
            [array addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:temp[i],@"shortName", nil]];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"历史搜索",@"shortName",array,@"children", nil];
        NSLog(@"%@",dic);
        [USERDEFAULTS setObject:dic forKey:@"SearchEndHistory"];
    }
}
- (IBAction)serchClick:(id)sender {
    [_serchTextField resignFirstResponder];
    if (_serchTextField.text.length<=1) {
        [MBProgressHUD showAndHideWithMessage:@"抱歉,你搜索的地点没有车辆···" forHUD:nil];
    }else{
        [self checkLine:_startLine endLine:_serchTextField.text];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *tempArr =[datasArray[section] objectForKey:@"children"];
    return tempArr.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"collectionCell";
    collectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.label.text = [[datasArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"shortName"];
    
    return  cell;
}
//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self serchAdd:[[datasArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"shortName"]];
    [self checkLine:_startLine endLine:[[datasArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"shortName"]];

}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(95, 50);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 7, 8, 7);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return datasArray.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *collectionReusableView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        headCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCollectionReusableView" forIndexPath:indexPath];
        
        
        headView.label.text = [datasArray[indexPath.section] objectForKey:@"shortName"];
        
        
        
        collectionReusableView = headView;
    }
    
    return collectionReusableView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {SCREENWIDTH,44};
    return size;
}
-(NSString*)getString:(NSString *)str{
    NSRange range = [str rangeOfString:@"-"];//匹配得到的下标
    return [str substringFromIndex:range.location+1];
}
-(NSArray *)getArray:(NSString *)str symbol:(NSString *)symbol{
    NSArray *array = [str componentsSeparatedByString:symbol]; //从字符A中分隔成2个元素的数组
    return array;
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
