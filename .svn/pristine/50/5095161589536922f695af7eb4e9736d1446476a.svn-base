//
//  WalletInfoCell.m
//  callmec
//
//  Created by sam on 16/7/8.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "WalletInfoCell.h"

@interface WalletInfoCell()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *tailLabel;

@end

@implementation WalletInfoCell

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
    _iconView = [[UIImageView alloc] init];
    [self addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.width.mas_equalTo(30);
    }];
    
    _titleLabel =[[UILabel alloc] init];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.top.mas_equalTo(10);
    }];
    
    
    _tailLabel =[[UILabel alloc] init];
    [self addSubview:_tailLabel];
    [_tailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
}

- (void) setModel:(WalletModel *)model
{
    _model = model;
    [_titleLabel setText:_model.title];
    [_tailLabel setText:model.money];
    [_tailLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_tailLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    if ([@"1" isEqualToString:model.type]) {
        [self setBackgroundColor:RGBHex(g_header_c)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_iconView setHidden:YES];
        
        [_tailLabel setHidden:NO];
        [_tailLabel setFont:[UIFont systemFontOfSize:30]];
        [_tailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(20);
        }];
        
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tailLabel.mas_bottom).offset(5);
            make.left.equalTo(self).offset(20);
        }];
        
    }else if([@"2" isEqualToString:model.type]){
        [_iconView setImage:[UIImage imageNamed:model.icons]];
        [_tailLabel setHidden:YES];
    }else if([@"3" isEqualToString:model.type]){
        [_iconView setImage:[UIImage imageNamed:model.icons]];
        [_tailLabel setHidden:NO];
        [_tailLabel setTextColor:RGBHex(g_red)];
    }
}
@end
