//
//  SexyCell.m
//  callmec
//
//  Created by sam on 16/7/13.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "SexyCell.h"
#import "RadioButton.h"
#import "BaseCellModel.h"

@interface SexyCell()<TargetActionDelegate>

@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) RadioButton *radioView;
@end
@implementation SexyCell


- (void) initView
{

    [self setBackgroundColor:[UIColor whiteColor]];
    _titleLbl =[[UILabel alloc] init];
    [_titleLbl setFont:[UIFont systemFontOfSize:15]];
    [_titleLbl setTextColor:RGBHex(g_black)];
    [self addSubview:_titleLbl ];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.mas_equalTo(65);
//        make.width.equalTo(self).multipliedBy(0.2);
    }];
    
    _radioView =[[RadioButton alloc] init];
    _radioView.delegate = self;
    [self addSubview:_radioView];
    
    [_radioView setIconNormal:@"nvyuan"];
    [_radioView setIconSelect:@"nanyuan"];
    [_radioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLbl.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self);
    }];
}


- (void) setModel:(BaseModel *)mode
{
    [super setModel:mode];
    if ([self.model isKindOfClass:[BaseCellModel class]]) {
        BaseCellModel *cell_mode = (BaseCellModel*)self.model;
        [_titleLbl setText:cell_mode.title];
        if (cell_mode.hasMore) {
            self.selectionStyle = UITableViewCellAccessoryNone;
            self.accessoryType = UITableViewCellSelectionStyleNone;
        }else{
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([@"0" isEqualToString:cell_mode.value]) {
            _radioView.selectIndex = 0;
        }else{
            _radioView.selectIndex = 1;
        }
        [_radioView setMargin:15];
        [_radioView setDataArray:[NSArray arrayWithObjects:@"女",@"男", nil]];
    }
}

- (void) buttonTarget:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        ((BaseCellModel*)self.model).value = ((UIButton*)sender).tag==0?@"0":@"1";
        ((BaseCellModel*)self.model).hasChanged = @"1";
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
