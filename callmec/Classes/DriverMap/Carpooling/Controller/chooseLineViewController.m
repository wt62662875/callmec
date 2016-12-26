//
//  chooseLineViewController.m
//  callmec
//
//  Created by wt on 2016/11/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "chooseLineViewController.h"
#import "collectionCell.h"
#import "headCollectionReusableView.h"
#import "CarPoolingHomeController.h"
#import "chooseDetailsLineCollectionViewController.h"
#import "CMSearchManager.h"
#import "chooseEndAddressViewController.h"


@interface chooseLineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,backLineDelegate>
{
    NSMutableArray *datasArray;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation chooseLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerNib:[UINib nibWithNibName:@"collectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"headCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCollectionReusableView"];
    
    if ([_startOrEnd isEqualToString:@"start"]) {
        [self setTitle:@"出发地"];
    }else{
        [self setTitle:@"目的地"];
    }
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view from its nib.
    

    [self getdatas];
    
    // 下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        datasArray = [[NSMutableArray alloc]init];
        [self initLocationConfig];
        [self getdatas];
    }];
}
- (void) amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    [super amapLocationManager:manager didUpdateLocation:location];
        [[CMSearchManager sharedInstance] searchLocation:location completionBlock:^(id request,
                                                                                    CMLocation *clocation,
                                                                                    NSError *error)
         {
             NSLog(@"clocation:%@",clocation);
             [self getStartCity:clocation.city district:clocation.district];

             [self stopLocation];
         }];

}
-(void)getStartCity:(NSString *)city district:(NSString *)district{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(1) forKey:@"page"];
    [params setObject:@"1" forKey:@"pageSize"];
    [params setObject:district forKey:@"name"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *resultArray = [resultDictionary objectForKey:@"rows"];
        if (resultArray.count>0) {
            [GlobalData sharedInstance].city = district;
        }else{
            [self getStartCity:city district:city];
        }
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}
- (void) amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    
    if (error) {
        NSLog(@"error:%@",error);
        [MBProgressHUD showAndHideWithMessage:@"无法获取定位信息！" forHUD:nil onCompletion:^{
//            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
    [super amapLocationManager:manager didFailWithError:error];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)listLineDatas:(NSString *)name departmentId:(NSString *)departmentId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (name.length>0) {
        [params setObject:name forKey:@"name"];
    }
    if (departmentId.length>0) {
        [params setObject:departmentId forKey:@"departmentId"];
    }
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *resultArray = [resultDictionary objectForKey:@"rows"];
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[GlobalData sharedInstance].city,@"shortName", nil], nil];
        for (int i = 0; i<resultArray.count; i++) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[self getString:[resultArray[i] objectForKey:@"name"]],@"shortName", nil];
            [tempArray addObject:tempDic];
        }
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"当前城市-%@",[GlobalData sharedInstance].city],@"shortName",tempArray ,@"children",nil];
        [datasArray insertObject:tempDic atIndex:0];
        NSLog(@"%@",datasArray);

        [_collectionView reloadData];
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}
-(void)getdatas{
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type", nil];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"getDepartmentTree" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *resultArray = [resultDictionary objectForKey:@"rows"];
        datasArray = [[NSMutableArray alloc]init];

        for (int i = 0; i<resultArray.count; i++) {
            [datasArray addObject:resultArray[i]];
        }
        NSLog(@"%@",datasArray);
        if ([GlobalData sharedInstance].city.length > 0) {
            [self listLineDatas:[NSString stringWithFormat:@"%@-",[GlobalData sharedInstance].city] departmentId:@""];
        }
        [_collectionView reloadData];
       
        
        [_collectionView.mj_header endRefreshing];
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}
-(NSString*)getString:(NSString *)str{
    NSRange range = [str rangeOfString:@"-"];//匹配得到的下标
    return [str substringFromIndex:range.location+1];
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
    if (indexPath.section == 0 && ([GlobalData sharedInstance].city.length > 0) && ![datasArray[0] objectForKey:@"id"]) {
        if ([_startOrEnd isEqualToString:@"start"]) {
            [self.delegate sendLine:[[datasArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"shortName"] end:@""];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self checkLine:_startLine endLine:[[datasArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"shortName"]];
        }
    }else{
        [self nextDatas:@"" departmentId:[NSString stringWithFormat:@"%@",[[datasArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"id"]]];
        
    }
    
}
-(void)nextDatas:(NSString *)name departmentId:(NSString *)departmentId{
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"加载中..." inView:nil];
    [hud show:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (name.length>0) {
        [params setObject:name forKey:@"name"];
    }
    if (departmentId.length>0) {
        [params setObject:departmentId forKey:@"departmentId"];
    }
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        [hud hide:YES];
        NSLog(@"%@",resultDictionary);
        NSArray *tempArray = [resultDictionary objectForKey:@"rows"];
        NSMutableArray *tempMutableArr = [[NSMutableArray alloc]init];
        NSMutableArray *tempDatasArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<tempArray.count; i++) {
            [tempMutableArr addObject:[self nextString:[tempArray[i] objectForKey:@"name"]]];
        }
        for (NSString *str in tempMutableArr) {
            if (![tempDatasArray containsObject:str]) {
                [tempDatasArray addObject:str];
            }
        }
        NSLog(@"%@",tempDatasArray);
        if (tempDatasArray.count == 1) {
            if ([_startOrEnd isEqualToString:@"start"]) {
                [self.delegate sendLine:tempDatasArray[0] end:@""];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self checkLine:_startLine endLine:tempDatasArray[0]];
            }
        }else{
            chooseDetailsLineCollectionViewController *detailsCV = [[chooseDetailsLineCollectionViewController alloc]initWithNibName:@"chooseDetailsLineCollectionViewController" bundle:nil];
            detailsCV.delegate = self;
            
            [detailsCV setStartLine:_startLine];
            [detailsCV setStartOrEnd:_startOrEnd];
            [detailsCV setShortNameArray:tempDatasArray];
            
            [self.navigationController pushViewController:detailsCV animated:YES];
        }
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud hide:YES];
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
            [MBProgressHUD showAndHideWithMessage:@"暂时未开通！" forHUD:nil];
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
            [MBProgressHUD showAndHideWithMessage:@"暂时未开通！" forHUD:nil];
            [hud hide:YES];

        }
        
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud hide:YES];

    }];
}


-(NSArray *)getArray:(NSString *)str symbol:(NSString *)symbol{
    NSArray *array = [str componentsSeparatedByString:symbol]; //从字符A中分隔成2个元素的数组
    return array;
}
-(NSString*)nextString:(NSString *)str{
    NSRange range = [str rangeOfString:@"-"];//匹配得到的下标
    return [str substringToIndex:range.location];
}

-(void)backLine:(NSString *)start end:(NSString *)end{
    if ([_startOrEnd isEqualToString:@"start"]) {
        [self.delegate sendLine:start end:@""];
    }else{
        [self.delegate sendLine:@"" end:end];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
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
