//
//  RadioButton.m
//  callmec
//
//  Created by sam on 16/7/13.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setDataArray:(NSArray *)dataArray
{
    [self clearView];
    if (_margin==0) {
        _margin = 5;
    }
    
    _dataArray = dataArray;
    UIButton *old_btn;
    int i= 0;
    for (NSString *title in _dataArray)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:_iconNormal] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_iconSelect] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:RGBHex(g_gray) forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        if(i==_selectIndex)
        {
            [btn setSelected:YES];
        }else{
            [btn setSelected:NO];
        }
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (old_btn) {
                make.left.equalTo(old_btn.mas_right).offset(_margin);
            }else{
                make.left.equalTo(self).offset(_margin);
            }
            make.centerY.equalTo(self);
        }];
        old_btn = btn;
        i++;
    }
}

- (void) clearView
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }

}

- (void) buttonTarget:(UIButton*)btn
{
    for (UIView *view in self.subviews) {
        if ([view  isKindOfClass:[UIButton class]]) {
            if (view ==btn)
            {
                ((UIButton*)view).selected = !btn.selected;
                if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
                {
                    [_delegate buttonTarget:view];
                }
            }else{
                ((UIButton*)view).selected = NO;
            }
        }
    }
}

- (void) setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
}
@end
