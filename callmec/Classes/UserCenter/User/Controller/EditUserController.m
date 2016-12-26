//
//  EditUserController.m
//  callmec
//
//  Created by sam on 16/7/6.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "EditUserController.h"
#import "EditHeaderCell.h"
#import "EditContentCell.h"
#import "BaseCellModel.h"
#import "SexyCell.h"

#import "ASBirthSelectSheet.h"

@interface EditUserController()<UITableViewDataSource,UITableViewDelegate,TargetActionDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIImage *headerImage;
@property (nonatomic,copy) NSString* iconData;
@property (nonatomic,copy) UIButton* saveButton;

@end


@implementation EditUserController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self fetchUserIcon];
}

- (void) initData
{
    UserInfoModel *model = [GlobalData sharedInstance].user.userInfo;
    
    NSString *headerIcon = [NSString stringWithFormat:@"%@getMHeadIcon?id=%@&token=%@",kserviceURL,
                                          [GlobalData sharedInstance].user.userInfo.ids,
                                          [GlobalData sharedInstance].user.session];
    
    NSLog(@"SDImageCache:%@",headerIcon);
    _dataArray= [NSMutableArray array];
    [_dataArray addObject:[NSArray arrayWithObject:
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"头像",
                                                                       @"value":headerIcon,
                                                                       @"hasMore":@(1),
                                                                       @"id":@(1),
                                                                       @"height":@(100)} error:nil]]];
    [_dataArray addObject:[NSArray arrayWithObjects:
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"姓名",
                                                                       @"value":model.realName?model.realName:@"",
                                                                       @"hasMore":@(1),
                                                                       @"id":@(2),
                                                                       @"height":@(50)} error:nil],
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"姓别",
                                                                       @"value":model.gender?model.gender:@"0",
                                                                       @"hasMore":@(0),
                                                                       @"id":@(3),
                                                                       @"height":@(100)} error:nil],
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"所在城市",
                                                                       @"value":model.address?model.address:([GlobalData sharedInstance].city?[GlobalData sharedInstance].city:@""),
                                                                       @"hasMore":@(1),
                                                                       @"id":@(4),
                                                                       @"height":@(50)} error:nil],
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"生日",
                                                                       @"value":model.birthday?model.birthday:@"",
                                                                       @"hasMore":@(0),
                                                                       @"id":@(5),
                                                                       @"height":@(100)} error:nil],
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"职业",
                                                                       @"value":model.job?model.job:@"",
                                                                       @"hasMore":@(1),
                                                                       @"id":@(6),
                                                                       @"height":@(100)} error:nil],
                           [[BaseCellModel alloc] initWithDictionary:@{@"title":@"个人简介",
                                                                       @"value":model.descriptions?model.descriptions:@"",
                                                                       @"hasMore":@(1),
                                                                       @"id":@(7),
                                                                       @"height":@(100)} error:nil],nil]];
}

- (void) initView
{
    [self setTitle:@"个人详情"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setRightButtonText:@"保存" withFont:[UIFont systemFontOfSize:15]];
//    [self.rightButton setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setFrame:CGRectMake(0, 0, 0, 0)];
    [_saveButton setBackgroundColor:RGBHex(g_blue)];
    [_saveButton setTitle:@"保存信息" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mTableView).offset(50);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [_mTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)[_dataArray objectAtIndex:section]).count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data =[_dataArray objectAtIndex:indexPath.section];
    BaseCellModel *model = [data objectAtIndex:indexPath.row];
    if (indexPath.section==0)
    {
        static NSString *cellid = @"dirver_cellid";
        EditHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell =[[EditHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell setModel:model];
        [cell setImageData:self.headerImage];
        [cell setDelegate:self];
        return cell;
    }else if(indexPath.row==1){//SexyCell.h
        static NSString *cellid1 = @"dirver_cellid_cell1";
        SexyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid1];
        if (!cell) {
            cell =[[SexyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
        }
        [cell setModel:model];
        return cell;
    }else{
        static NSString *cellid1 = @"dirver_cellid1";
        EditContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid1];
        if (!cell) {
            cell =[[EditContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
        }
        [cell setModel:model];
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 120;
    }
    return 50;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dat = _dataArray[indexPath.section];
    [self onChoiceModel:dat[indexPath.row]];
    
}

#pragma mark - buttonTarget
- (void) buttonTarget:(id)sender
{
    
    
    if (sender == self.leftButton) {
        if (self.delegateCallback &&[self.delegateCallback respondsToSelector:@selector(callback:)]) {
            [self.delegateCallback callback:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender == _saveButton){
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        NSArray *data0 = _dataArray[0];
        BaseCellModel *md0 = data0[0];
        if ([@"1" isEqualToString:md0.ids] && _iconData) {
            [param setObject:_iconData forKey:@"icon"];
        }
        [param setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"id"];
        NSArray *data = _dataArray[1];
        
        for (BaseCellModel *md in data) {
            NSLog(@"Model%@",md);
            if ([@"1" isEqualToString:md.hasChanged]) {
                //UserInfoModel *mds;
                if ([@"2" isEqualToString:md.ids]) {
                    [param setObject:md.value forKey:@"realName"];
                }else if ([@"3" isEqualToString:md.ids]) {
                    [param setObject:md.value forKey:@"gender"];
                }else if ([@"4" isEqualToString:md.ids]) {
                    [param setObject:md.value forKey:@"address"];
                }else if ([@"5" isEqualToString:md.ids]) {
                    [param setObject:md.value forKey:@"birthday"];
                }else if ([@"6" isEqualToString:md.ids]) {
                    [param setObject:md.value forKey:@"job"];
                }else if ([@"7" isEqualToString:md.ids]) {
                    [param setObject:md.value forKey:@"description"];
                }
                
            }else{
                continue;
            }
        }
        
        [self saveUserInfo:param];
    }else if([sender isKindOfClass:[UIImageView class]]){
        [self openPhotoChoiceDialog];
    }
}

- (void) onChoiceModel:(BaseCellModel*)model
{
    if ([@"1" isEqualToString:model.ids]) {
        
    }else if([@"5" isEqualToString:model.ids]){
        [self showBirthday:model];
    }
}

- (void) openPhotoChoiceDialog
{
    if (iOS8Later){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *selectPhotoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self photoLibrary];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:takePhotoAction];
        [alertController addAction:selectPhotoAction];
        if (alertController) {
            [self presentViewController:alertController animated:YES completion:nil];
        }}else if(iOS7Later)
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
            [sheet showInView:self.view];
        }

}

#pragma  mark - Photo Choice

#pragma mark - 从相册中选择
- (void)photoLibrary
{
    //从相册选择
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES  completion:^(){}];
    
}

#pragma mark 拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^(){}];
    }else {
        [MBProgressHUD showTextHUBWithText:@"相机不可用" inView:nil];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self takePhoto];
    }else if(buttonIndex==1){
        [self photoLibrary];
    }
}
// 对图片尺寸进行压缩 和 转格式
- (void)imagechange
{
    // 对图片尺寸进行压缩
    UIImage * hehehe = nil;
    UIImage * imageNew = [self imageWithImage:hehehe scaledToSize:CGSizeMake(300, 40)];
    NSData *data;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(imageNew)) {
        //返回为png图像。
        data =   UIImagePNGRepresentation(imageNew);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(imageNew,0);
    }
    
}

//对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


// 从相册选择完成调用的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    self.headerImage=image;
    
    NSData *data = UIImagePNGRepresentation(image);
    _iconData = [data base64EncodedStringWithOptions:0];
    
    NSArray *d = _dataArray[0];
     BaseCellModel *md = d[0];
    md.value = _iconData;
    md.hasChanged = @"1";
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.mTableView reloadData];
}

#pragma mark 取消 imagePickerController
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];//隐藏相机图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image) {
        [self imagePickerController:nil didFinishPickingImage:image editingInfo:nil];
    }
}

- (void) showBirthday:(BaseCellModel*)model
{
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.selectDate = model.value.length>0?model.value:@"1990-12-10";
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        model.value = dateStr;
        model.hasChanged =@"1";
        [self.mTableView reloadData];
    };
    
    [self.view addSubview:datesheet];
}

- (void) saveUserInfo:(NSMutableDictionary*)param
{
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在保存,请稍后..." inView:nil];
    [hud show:YES];
    [UserInfoModel commitEditUserInfo:param succ:^(NSDictionary *resultDictionary) {
        [MBProgressHUD showAndHideWithMessage:@"保存成功" forHUD:nil];
        //NSLog(@"resultDictionary:%@",resultDictionary);
        NSDictionary *data = [resultDictionary objectForKey:@"data"];
        UserInfoModel *md = [[UserInfoModel alloc] initWithDictionary:data error:nil];
        [GlobalData sharedInstance].user.userInfo = md;
        [[GlobalData sharedInstance].user save];
        NSString *headerIcon = [NSString stringWithFormat:@"%@getMHeadIcon?id=%@&token=%@",kserviceURL,
                                [GlobalData sharedInstance].user.userInfo.ids,
                                [GlobalData sharedInstance].user.session];
        
        NSString *image_url_cache = [headerIcon stringByAppendingString:@"cache_circle"];
        NSLog(@"SDImageCache 1:%@",image_url_cache);
        [[SDImageCache sharedImageCache] removeImageForKey:image_url_cache fromDisk:YES];
        [hud setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud setHidden:YES];
    }];
}

- (void) fetchUserIcon
{
    if (![GlobalData sharedInstance].user.isLogin) {
        return;
    }
//    
//    [UserInfoModel fetchUserHeaderImage:[GlobalData sharedInstance].user.userInfo.ids succ:^(NSDictionary *resultDictionary) {
//        NSLog(@"resultDictionary:%@",resultDictionary);
//    } fail:^(NSInteger errorCode, NSString *errorMessage) {
//        NSLog(@"errorMessage:%ld %@",errorCode,errorMessage);
//    }];
}

@end
