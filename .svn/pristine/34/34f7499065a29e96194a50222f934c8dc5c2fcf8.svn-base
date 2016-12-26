//
//  DriverInfoCell.m
//  callmec
//
//  Created by sam on 16/7/8.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "DriverInfoCell.h"

@interface DriverInfoCell()

@property (nonatomic,strong) UIImageView *iconView;         //服务者头像
@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UILabel *nameLabel;            //服务者名称
@property (nonatomic,strong) UILabel *areaLabel;            //所属地区
@property (nonatomic,strong) UILabel *serTimeLbl;           //服务次数
@property (nonatomic,strong) UILabel *rankingLbl;           //排名Label
@property (nonatomic,strong) UILabel *driverTypeLbl;        //司机类型 自营，等等
@property (nonatomic,strong) UILabel *carNumberLbl;         //车牌号
@property (nonatomic,strong) UILabel *carTypeLbl;           //车型号
@property (nonatomic,strong) UILabel *carColorLbl;          //车颜色
@property (nonatomic,strong) UILabel *driverIdNumberLbl;    //司机身份证号
@end

@implementation DriverInfoCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
    }
    return self;
}

- (void) initView
{
    _iconView =[[UIImageView alloc] init];
    [_iconView setImage:[UIImage imageNamed:@"app_icon"]];
    [self addSubview:_iconView];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self.mas_width).multipliedBy(0.56);
    }];

    _container =[[UIView alloc] init];
    _container.alpha=0.5;
    _container.backgroundColor =[UIColor blackColor];
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom).offset(-50);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setText:@"吴师傅"];
    [_nameLabel setFont:[UIFont systemFontOfSize:20]];
    [_container addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_container);
        make.left.equalTo(_container).offset(10);
    }];
    
    _areaLabel =[[UILabel alloc] init];
    [_areaLabel setTextColor:[UIColor whiteColor]];
    [_areaLabel setText:@"云南.昆明"];
    [_areaLabel setFont:[UIFont systemFontOfSize:12]];
    [_container addSubview:_areaLabel];

    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(15);
        make.bottom.equalTo(_nameLabel.mas_bottom);
    }];
    
    UIView *left_container = [[UIView alloc] init];
//    [left_container setBackgroundColor:[UIColor greenColor]];
    [self addSubview:left_container];
    [left_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom);
        make.left.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.mas_equalTo(60);
    }];
    
    //服务次数
    _serTimeLbl = [[UILabel alloc] init];
    [_serTimeLbl setText:@"499"];
    [_serTimeLbl setFont:[UIFont systemFontOfSize:25]];
    [_serTimeLbl setTextColor:[UIColor redColor]];
    [_serTimeLbl setTextAlignment:NSTextAlignmentCenter];
    [left_container addSubview:_serTimeLbl];
    
    [_serTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_container);
        make.top.equalTo(left_container).offset(5);
        make.centerX.equalTo(left_container);
        make.height.equalTo(left_container).multipliedBy(0.5);
    }];
    
    UILabel *sName = [[UILabel alloc] init];
    [sName setText:@"服务次数"];
    [sName setTextAlignment:NSTextAlignmentCenter];
    [sName setFont:[UIFont systemFontOfSize:12]];
    [sName setTextColor:RGBHex(g_gray)];
    [left_container addSubview:sName];
    [sName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_container);
        make.top.equalTo(_serTimeLbl.mas_bottom);
        make.centerX.equalTo(left_container);
        make.height.equalTo(left_container).multipliedBy(0.25);
    }];
    
    
    UIView *right_container = [[UIView alloc] init];
//    [right_container setBackgroundColor:[UIColor brownColor]];
    [self addSubview:right_container];
    [right_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom);
        make.left.equalTo(left_container.mas_right);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.mas_equalTo(60);
    }];
    
    //排名
    _rankingLbl = [[UILabel alloc] init];
    [_rankingLbl setText:@"1499"];
    [_rankingLbl setFont:[UIFont systemFontOfSize:25]];
    [_rankingLbl setTextColor:[UIColor redColor]];
    [_rankingLbl setTextAlignment:NSTextAlignmentCenter];
    [right_container addSubview:_rankingLbl];
    
    [_rankingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(right_container);
        make.top.equalTo(right_container).offset(5);
        make.centerX.equalTo(right_container);
        make.height.equalTo(right_container).multipliedBy(0.5);
    }];
    
    UILabel *rName = [[UILabel alloc] init];
    [rName setText:@"司机排名"];
    [rName setTextColor:RGBHex(g_gray)];
    [rName setTextAlignment:NSTextAlignmentCenter];
    [rName setFont:[UIFont systemFontOfSize:12]];
    [left_container addSubview:rName];
    [rName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(right_container);
        make.top.equalTo(_rankingLbl.mas_bottom);
        make.centerX.equalTo(right_container);
        make.height.equalTo(right_container).multipliedBy(0.25);
    }];
    
    UIView *lineGray = [[UIView alloc] init];
    [lineGray setBackgroundColor:RGBHex(g_gray)];
    [self addSubview:lineGray];
    
    [lineGray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(left_container.mas_bottom);
    }];
    
    UIView *centerLineGray = [[UIView alloc] init];
    [centerLineGray setBackgroundColor:RGBHex(g_gray)];
    [self addSubview:centerLineGray];
    
    [centerLineGray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2);
        make.left.equalTo(left_container.mas_right).offset(-1);
        make.top.equalTo(left_container).offset(15);
        make.bottom.equalTo(left_container).offset(-15);
    }];

    //司机类型
    _driverTypeLbl = [[UILabel alloc] init];
    [_driverTypeLbl setText:@"呼我自营司机"];
    [_driverTypeLbl setFont:[UIFont systemFontOfSize:14]];
    [_driverTypeLbl setTextColor:RGBHex(g_red)];
    
    [self addSubview:_driverTypeLbl];
    [_driverTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineGray).offset(10);
        make.left.equalTo(self).offset(10);
    }];
    
    //车牌
    _carNumberLbl = [[UILabel alloc] init];
    [_carNumberLbl setText:@"京B.4914"];
    [_carNumberLbl setFont:[UIFont systemFontOfSize:14]];
    [_carNumberLbl setTextColor:RGBHex(g_black)];
    
    [self addSubview:_carNumberLbl];
    [_carNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driverTypeLbl.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
    }];
    
    //汽车类型
    _carTypeLbl = [[UILabel alloc] init];
    [_carTypeLbl setText:@"本田雅阁"];
    [_carTypeLbl setFont:[UIFont systemFontOfSize:14]];
    [_carTypeLbl setTextColor:RGBHex(g_black)];
    
    [self addSubview:_carTypeLbl];
    [_carTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driverTypeLbl.mas_bottom).offset(10);
        make.left.equalTo(_carNumberLbl.mas_right).offset(5);
    }];
    
    //身份证
    _driverIdNumberLbl = [[UILabel alloc] init];
    [_driverIdNumberLbl setText:@"身份证:532511440232*****12123"];
    [_driverIdNumberLbl setFont:[UIFont systemFontOfSize:14]];
    [_driverIdNumberLbl setTextColor:RGBHex(g_black)];
    
    [self addSubview:_driverIdNumberLbl];
    [_driverIdNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carNumberLbl.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
    }];
}

@end
