//
//  CenterHeaderCell.m
//  callmed
//
//  Created by sam on 16/9/27.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CenterHeaderCell.h"
#import "BaseItemModel.h"

@interface CenterHeaderCell()

@property (nonatomic,strong) UIImageView *iconHeaderView;
@property (nonatomic,strong) UILabel *lb_name_v;
@property (nonatomic,strong) UIButton *bt_login_v;
@end


@implementation CenterHeaderCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) initView
{
    [self setBackgroundColor:RGBHex(g_blue)];
    if (!_iconHeaderView) {
        _iconHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user"]];
    }
    
    [self addSubview:_iconHeaderView];
    [_iconHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    
    if (!_lb_name_v) {
        _lb_name_v = [[UILabel alloc] init];
    }
    [self addSubview:_lb_name_v];
    [_lb_name_v setFont:[UIFont systemFontOfSize:15]];
    [_lb_name_v setTextColor:[UIColor whiteColor]];
    
    
    [_lb_name_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconHeaderView.mas_right).offset(10);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    
    if (!_bt_login_v) {
        _bt_login_v = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [self addSubview:_bt_login_v];

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"youijianbai"]];
    
    self.accessoryView = imageView;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [_bt_login_v addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setModel:(BaseItemModel *)model
{
    [super setModel:model];
    
    [_iconHeaderView sd_setCircleImageWithURL:model.icons placeholderImage:[UIImage imageNamed:@"icon_user"]];
    [self.lb_name_v setText:model.title];
    if ([GlobalData sharedInstance].user.isLogin) {
        
        UserInfoModel *models = [GlobalData sharedInstance].user.userInfo;
        NSLog(@"phone:%@",[GlobalData sharedInstance].user.userInfo.phoneNo);
        [_lb_name_v setText:[GlobalData sharedInstance].user.userInfo.phoneNo];
        [_bt_login_v setImage:[UIImage imageNamed:@"icon_userinfo"] forState:UIControlStateNormal];
        [_bt_login_v setTitle:model.title forState:UIControlStateNormal];
    }else{
        [_lb_name_v setText:@"未登录"];
        [_bt_login_v setTitle:@"点击登录" forState:UIControlStateNormal];
        [_bt_login_v setImage:nil forState:UIControlStateNormal];
    }
    
    CGSize size= [model.title sizeFont:14];
    [_bt_login_v.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_bt_login_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(size.height+10);
//        make.width.mas_equalTo(size.width+30);
        make.right.equalTo(self).offset(-25);
    }];
}

- (void) buttonTarget:(UIButton*)btn
{
    if (_delegate&&[_delegate respondsToSelector:@selector(buttonTarget:)]) {
        [_delegate buttonTarget:btn];
    }
}

@end
