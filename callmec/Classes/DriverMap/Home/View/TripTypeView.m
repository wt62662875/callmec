//
//  CarTypeView.m
//  callmec
//
//  Created by sam on 16/7/6.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TripTypeView.h"
#import "TripTypeModel.h"
#import "VerticalView.h"

@interface TripTypeView()<TargetActionDelegate>
@property (nonatomic,strong) VerticalView *selectView;
@property (nonatomic,strong) UIView *bottomLine;
@end

@implementation TripTypeView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView
{
//    [self setBackgroundColor:RGBHex(g_blue)];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    int i = 0;
    VerticalView *old_btn;
    for (TripTypeModel *md in _dataArray) {
        NSLog(@"%@",md);
        
        VerticalView *btn = [[VerticalView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        btn.selectColor = self.selectColor ;
        [btn setTitle:md.title];
        [btn setImageUrl:md.icons];
        [btn setSelectImageUrl:md.selectIcons];
        [btn setDelegate:self];
        [btn setTag:i];
        [self addSubview:btn];
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (old_btn) {
                make.left.equalTo(old_btn.mas_right);
            }else{
                make.left.equalTo(self);
            }
            make.centerY.equalTo(self);
            make.width.equalTo(self).dividedBy(2);
            make.height.equalTo(self);
        }];
        [btn setTitleFont:[UIFont systemFontOfSize:14]];
        [btn setImageBackgroudColor:RGBHex(md.colors)];
        if (_indexSelect==i) {
            [btn setIsSelected:!btn.isSelected];
            _selectView = btn;
        }
        old_btn = btn;
        i++;
    }
    
    _bottomLine = [[UIView alloc] init];
    [_bottomLine setBackgroundColor:RGBHex(g_assit_gray)];
    [self addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void) setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self initView];
}

- (void) setIndexSelect:(NSInteger)indexSelect
{
    _indexSelect = indexSelect;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[VerticalView class]]) {
            if (_indexSelect == view.tag) {
                ((VerticalView*)view).isSelected = !((VerticalView*)view).isSelected;
                continue;
            }else{
                ((VerticalView*)view).isSelected = NO;
            }
        }else{
            continue;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [_delegate buttonTarget:_selectView];
    }
}

- (void)buttonTarget:(VerticalView*)sender
{
    _indexSelect = sender.tag;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[VerticalView class]]) {
            if (sender == view) {
                ((VerticalView*)view).isSelected = !((VerticalView*)view).isSelected;
                continue;
            }else{
                ((VerticalView*)view).isSelected = NO;
            }
        }else{
            continue;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [_delegate buttonTarget:sender];
    }
}
@end