//
//  CarsChoiceView.m
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CarsChoiceView.h"
#import "CarModel.h"
#import "CommonVerticalView.h"

@interface CarsChoiceView()<TargetActionDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *descLabel;
@end

@implementation CarsChoiceView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _titleLabel =[[UILabel alloc] init];
        [_titleLabel setText:@"约 元"];
        [_titleLabel setTextColor:RGBHex(g_black)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        _moneyLabel =[[UILabel alloc] init];
        [_moneyLabel setText:@""];
        [_moneyLabel setTextColor:RGBHex(g_gray)];
        [_moneyLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
        [self addSubview:_moneyLabel];
        
        
        _descLabel =[[UILabel alloc] init];
        [_descLabel setText:@"预估价可能与实际价格有出入"];
        [_descLabel setFont:[UIFont systemFontOfSize:13]];
        [_descLabel setTextColor:RGBHex(g_blue)];
        [self addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_descLabel.mas_top).offset(-1);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(20);
            
        }];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_descLabel.mas_top).offset(-10);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(25);
        }];
        
        
    }
    
    return self;
}

- (void) setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    int i =0;
    for (CarModel *model in _dataArray)
    {
        
        CommonVerticalView *carView =[[CommonVerticalView alloc] init];
        carView.title = model.carTitle;
        carView.imageUrl = model.carIcon;
        [carView setTitleColor:RGBHex(g_black) state:UIControlStateNormal];
        [carView setTitleColor:RGBHex(g_blue) state:UIControlStateSelected];
        [carView setTitleFont:[UIFont systemFontOfSize:14]];
        [carView setHightLightImage:model.carIconLight];
        [carView setIsSelected:model.isSelected];
        [carView setTag:i];
        [carView setDelegate:self];
        [self addSubview:carView];
        [carView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset((kScreenSize.width-10)*(i*0.5));
            make.width.equalTo(self).dividedBy(2);
            make.height.mas_equalTo(60);
        }];
        i++;
    }
}

- (void)buttonTarget:(CommonVerticalView*)sender
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CommonVerticalView class]]) {
            if (sender == view) {
                ((CommonVerticalView*)view).isSelected = YES;
                continue;
            }else{
                ((CommonVerticalView*)view).isSelected = NO;
            }
        }else{
            continue;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(buttonSelectedIndex:)])
    {
        [_delegate buttonSelectedIndex:sender.tag];
    }else if (_delegate &&[_delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [_delegate buttonTarget:sender];
    }
}

- (void) setAboutMoney:(NSString *)aboutMoney
{

    _aboutMoney = aboutMoney;
    NSString *value = [NSString stringWithFormat:@"约%@元",_aboutMoney];
    NSMutableAttributedString *textValue = [[NSMutableAttributedString alloc] initWithString:value];
    [textValue addAttribute:NSForegroundColorAttributeName value:RGBHex(g_blue) range:NSMakeRange(1,_aboutMoney.length)];
    [textValue addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1,_aboutMoney.length)];
    [_titleLabel setAttributedText:textValue];
    [_descLabel setText:@"预估价可能与实际价格有出入"];
    //
}

- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
}
@end
