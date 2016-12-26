//
//  EditContentCell.m
//  callmec
//
//  Created by sam on 16/7/9.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "EditContentCell.h"
#import "BaseCellModel.h"

@interface EditContentCell()

@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UITextField *contentLbl;

@end

@implementation EditContentCell

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
        make.width.equalTo(self).multipliedBy(0.2);
    }];
    
    _contentLbl =[[UITextField alloc] init];
    [_contentLbl setTextColor:RGBHex(g_black)];
    [_contentLbl setFont:[UIFont systemFontOfSize:15]];
    [_contentLbl addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self addSubview:_contentLbl];
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLbl.mas_right).offset(10);
        make.width.equalTo(self).multipliedBy(0.6);
    }];
    
}

- (void) setModel:(BaseModel *)mode
{
    [super setModel:mode];
    if ([self.model isKindOfClass:[BaseCellModel class]]) {
        BaseCellModel *cell_mode = (BaseCellModel*)self.model;
        [_titleLbl setText:cell_mode.title];
        [_contentLbl setText:cell_mode.value];
        if (cell_mode.hasMore) {
            [self.contentLbl setEnabled:YES];
            self.selectionStyle = UITableViewCellAccessoryNone;
            self.accessoryType = UITableViewCellSelectionStyleNone;
        }else{
            [self.contentLbl setEnabled:NO];
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (void) valueChanged:(UITextField*)field
{
    if (![((BaseCellModel*)self.model).value isEqualToString:field.text]) {
        ((BaseCellModel*)self.model).hasChanged = @"1";
        ((BaseCellModel*)self.model).value = field.text;
    }
   
}
@end
