//
//  DriverCommentCell.m
//  callmec
//
//  Created by sam on 16/7/9.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "DriverCommentCell.h"
#import "RateViewBar.h"

@interface DriverCommentCell()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) RateViewBar *startRateBar;
@end

@implementation DriverCommentCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
    }
    return self;
}

- (void) initView
{
    _iconView =[[UIImageView alloc] init];
    [_iconView setImage:[UIImage imageNamed:@"top_user"]];
    [self addSubview:_iconView];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    _titleLbl = [[UILabel alloc] init];
    [_titleLbl setText:@"非常好的师傅,第一次使用专车，非常满意！"];
    [_titleLbl setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_titleLbl];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.top.equalTo(self).offset(5);
    }];
    
    _timeLbl = [[UILabel alloc] init];
    [_timeLbl setText:@"2016-06-20"];
    [_timeLbl setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_timeLbl];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.top.equalTo(_titleLbl.mas_bottom).offset(5);
    }];
    
    _startRateBar = [[RateViewBar alloc] init];
    _startRateBar.rateNumber = 5;
    
    [self addSubview:_startRateBar];
    
    [_startRateBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLbl.mas_bottom).offset(5);
        make.left.equalTo(_timeLbl.mas_right).offset(50);
        make.bottom.equalTo(self).offset(-10);
    }];
}
@end
