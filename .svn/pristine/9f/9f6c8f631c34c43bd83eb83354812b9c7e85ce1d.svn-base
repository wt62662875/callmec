//
//  GoodsHomeCell.m
//  callmec
//
//  Created by sam on 16/8/12.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "GoodsHomeCell.h"
#import "LeftIconLabel.h"

@interface GoodsHomeCell()

@property (nonatomic,strong) LeftIconLabel *timeLabel;
@property (nonatomic,strong) LeftIconLabel *startLabel;
@property (nonatomic,strong) LeftIconLabel *endLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@end

@implementation GoodsHomeCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _startLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_startLabel setTitle:@"开始地点"];
    [_startLabel setImageUrl:@"icon_fahuo"];
    [_startLabel setImageW:13 withH:17];
    [self addSubview:_startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _timeLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_timeLabel setTitle:@"当前时间"];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(_startLabel.mas_top).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    _endLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_endLabel setImageUrl:@"icon_shouhuo"];
    [_endLabel setImageW:13 withH:17];
    [_endLabel setTitle:@"结束地点"];
    [self addSubview:_endLabel];
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startLabel.mas_bottom).offset(5);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    [_rightLabel setText:@"发布成功"];
    [_rightLabel setFont:[UIFont systemFontOfSize:14]];
    [_rightLabel setTextColor:[UIColor redColor]];
    
    [self addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
        make.right.equalTo(self).offset(-25);
        make.left.equalTo(_startLabel.mas_right).offset(5);
        make.width.mas_equalTo(80);
    }];
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setModel:(CarOrderModel *)model
{
    _model = model;
    [_timeLabel setTitle:_model.appointDate];
    [_startLabel setTitle:_model.slocation];
    [_endLabel setTitle:_model.elocation];
    if ([@"1" isEqualToString:model.state]) {
        [_rightLabel setText:@"发布成功"];
    }else{
        [_rightLabel setText:[CommonUtility getGoodsOrderDesc:model.state]];
    }
}

@end
