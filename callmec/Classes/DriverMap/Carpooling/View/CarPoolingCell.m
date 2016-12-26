//
//  CarPoolingCell.m
//  callmec
//
//  Created by sam on 16/7/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CarPoolingCell.h"
#import "LeftIconLabel.h"

#import "CarOrderModel.h"

@interface CarPoolingCell()

@property (nonatomic,strong) LeftIconLabel *timeLabel;
@property (nonatomic,strong) LeftIconLabel *lineLabel;
@property (nonatomic,strong) UIButton *orderStatus;

@end

@implementation CarPoolingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) initView
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    _timeLabel =[[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_timeLabel];
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.width.equalTo(self).offset(100);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.mas_centerY);

    }];
    
    _lineLabel =[[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_lineLabel setImageUrl:@"icon_pc_location"];
    //icon_pc_location
    [self addSubview:_lineLabel];
    [_lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.width.equalTo(self).offset(100);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.mas_centerY);
    }];
    
    _orderStatus =[UIButton buttonWithType:UIButtonTypeCustom];
    [_orderStatus.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_orderStatus addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_orderStatus];
    [_orderStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);///
        make.width.mas_equalTo(80);
        make.right.equalTo(self).offset(-5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setModel:(BaseModel *)model
{
    [super setModel:model];
    CarOrderModel *mod = (CarOrderModel*)model;
    [_timeLabel setTitle:mod.appointDate];
    [_lineLabel setTitle:mod.lineName];
    [_orderStatus setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    [_orderStatus setTitle:[CommonUtility getOrderDescription:mod.state] forState:UIControlStateNormal];
}

- (void)buttonTarget:(UIButton*)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTarget:)]) {
        [_delegate cellTarget:self.model];
    }
}
@end