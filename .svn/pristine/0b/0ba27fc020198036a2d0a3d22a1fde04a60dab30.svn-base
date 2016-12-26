//
//  TitleMultiCheckBox.m
//  callmec
//
//  Created by sam on 16/9/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TitleMultiCheckBox.h"

@interface TitleMultiCheckBox()
@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation TitleMultiCheckBox

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void) initData
{
    _checkTitleArray = [NSMutableArray array];
    _checkValueArray = [NSMutableArray array];
}

- (void) initView
{
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTextColor:RGBHex(g_black)];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
    }];
}


- (void) setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:_title];
}
- (void) setCheckTitles:(NSMutableArray*)titles withValue:(NSMutableArray*)values
{
    _checkTitleArray = titles;
    _checkValueArray = values;
    
    UIButton *lastView;
    NSInteger i = 0;
    for (NSString *title in _checkTitleArray) {
       UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(g_assit_c) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        CGSize size = [title sizeFont:13];
        [btn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateHighlighted];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,5, 0, 5)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 5)];
        [btn setTag:100+i];
        [btn addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.left.equalTo(_titleLabel.mas_right).offset(10);
            }else{
                make.left.equalTo(lastView.mas_right);
            }
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self);
            //NSLog(@"Size:%@",NSStringFromCGSize(size));
            make.width.mas_equalTo(size.width+30);
        }];
       
        i++;
        lastView = btn;
    }
}

- (void) buttonTarget:(UIButton*)button
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (button == view) {
                button.selected = !button.selected;
                if (_checkValueArray) {
                    @try {
                        _value = _checkValueArray[button.tag-100];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"exception:%@",exception);
                    }
                    @finally {
                        
                    }
                }
            }else{
                ((UIButton*)view).selected = NO;
            }
        }
    }
}

@end
