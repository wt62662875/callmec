//
//  TripScrollerView.m
//  callmec
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TripScrollerView.h"
#import "TripTypeModel.h"

@interface TripScrollerView()

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *redlineView;
@end

@implementation TripScrollerView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView{


}
- (void) setDataArray:(NSArray *)dataArray
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _lineView = [[UIView alloc] init];
    [_lineView setBackgroundColor:RGBHex(g_gray)];
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.equalTo(self);
        make.width.equalTo(self);
    }];
    
    _redlineView = [[UIView alloc] init];
    [_redlineView setBackgroundColor:RGBHex(g_blue)];
    [self addSubview:_redlineView];
    [_redlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2);
        make.left.equalTo(self);
        make.width.equalTo(self).dividedBy(2);
    }];
    
    _dataArray = dataArray;
    UIButton *btn_old;
    for (int i = 0;i<_dataArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn.titleLabel setText:_dataArray[i]];
        [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(g_blue) forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            if (!btn_old)
            {
                make.left.equalTo(self);
            }else{
                make.left.equalTo(btn_old.mas_right);
            }
            make.width.equalTo(self).dividedBy(2);
        }];
        if (_selectIndex==i) {
            [btn setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
            /*
            [_redlineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kScreenSize.width*0.25*i);
            }];
            */
            [_redlineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.height.mas_equalTo(2);
                make.left.equalTo(btn);
                make.width.equalTo(self).dividedBy(2);
            }];
        }else{
            [btn setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
        }
        btn_old = btn;
    }
}



- (void) buttonTarget:(UIButton*)sender
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            if (sender!=view) {
                [btn setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
            }
        }
    }
    
    NSInteger tag = sender.tag;
    [self startAnimation:sender withTag:tag];
    if (_delegate && [_delegate respondsToSelector:@selector(buttonSelectedIndex:)])
    {
        [_delegate buttonSelectedIndex:tag];
    }else if(_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [_delegate buttonTarget:sender];
    }
}

- (void) startAnimation:(UIView*)view withTag:(NSInteger)tag
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_redlineView cache:YES];
    [UIView setAnimationDuration:0.3];
    
    // 设置要变化的frame 推入与推出修改对应的frame即可
    [UIView commitAnimations];
    // 执行动画
    if (_redlineView) {//remake
        [_redlineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.mas_equalTo(2);
            //make.left.equalTo(view);
            make.centerX.equalTo(view);
            make.width.equalTo(self).dividedBy(2);
        }];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void) setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    //[self startAnimation:_redlineView withTag:selectIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(buttonSelectedIndex:)])
    {
        [_delegate buttonSelectedIndex:selectIndex];
    }else if(_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [_delegate buttonTarget:nil];
    }
}

@end
