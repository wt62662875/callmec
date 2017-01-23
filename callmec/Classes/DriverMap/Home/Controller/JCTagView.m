//
//  JCTagView.m
//  JCLabel
//
//  Created by QB on 16/4/26.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "JCTagView.h"

#define HORIZONTAL_PADDING 5.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f

///随机颜色
#define RandomColor  [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];

@interface JCTagView ()
{
    CGRect _previousFrame;
    int _totalHeight;
    UIButton *_tag;
}

@end

@implementation JCTagView

//初始化方法
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _totalHeight = 0;
        self.frame = frame;
    }
    
    return self;
}


//设置 标签数组
- (void)setArrayTagWithLabelArray:(NSArray *)array {
    //设置frame
    _previousFrame = CGRectZero;
    [array enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
    [self setupBtnWithNSString:str];
    }];
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self setupBtnWithNSString:obj];
//        
//    }];
    ///设置整个View的背景
    if(_JCbackgroundColor){
        
        self.backgroundColor = _JCbackgroundColor;
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}


//初始化按钮

- (void)setupBtnWithNSString:(NSString *)str {
    //初始化按钮
    _tag = [UIButton buttonWithType:UIButtonTypeCustom];
    _tag.frame = CGRectZero;
    if (_JCSignalTagColor) {
        _tag.backgroundColor = _JCSignalTagColor;
    }else {
        _tag.backgroundColor = RandomColor;
    }
    //设置内容水平居中
    _tag.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_tag setTitle:str forState:UIControlStateNormal];
    //设置字体的大小
    _tag.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _tag.layer.cornerRadius = 5;
    _tag.layer.masksToBounds = YES;
    _tag.layer.borderColor = RGB(187, 187, 187).CGColor;
    _tag.layer.borderWidth = 1;
    //设置字体的颜色
    [_tag setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
    [_tag setSelected:NO];
    //设置方法
    [_tag addTarget:self action:@selector(clickHandle:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]};
    CGSize StrSize = [str sizeWithAttributes:attribute];
    StrSize.width += HORIZONTAL_PADDING * 2+10;
    StrSize.height += VERTICAL_PADDING *2;
    ///新的 SIZE
    CGRect  NewRect = CGRectZero;
    
    if (_previousFrame.origin.x + _previousFrame.size.width + StrSize.width + LABEL_MARGIN > self.bounds.size.width) {
        
        NewRect.origin = CGPointMake(0, _previousFrame.origin.y + StrSize.height + BOTTOM_MARGIN);
        _totalHeight += StrSize.height + BOTTOM_MARGIN;
    }else {
        if (_previousFrame.origin.x == 0 && _previousFrame.origin.y ==0 && _previousFrame.size.width ==0 && _previousFrame.size.height ==0) {
            NewRect.origin = CGPointMake(_previousFrame.origin.x + _previousFrame.size.width, _previousFrame.origin.y);
        }else{
            NewRect.origin = CGPointMake(_previousFrame.origin.x + _previousFrame.size.width + LABEL_MARGIN, _previousFrame.origin.y);
        }
    }
    NewRect.size = StrSize;
    [_tag setFrame:NewRect];
    _previousFrame = _tag.frame;
    [self setHight:self andHight:_totalHeight + StrSize.height + BOTTOM_MARGIN];
    [self addSubview:_tag];
    ///设置背景 颜色
   

}

#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}


#pragma mark==========按钮的处理方法

///按钮的处理方法
- (void)clickHandle:(UIButton *)sender{
    if (sender.isSelected) {
        [sender setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
        sender.layer.borderColor = RGB(187, 187, 187).CGColor;
        [sender setSelected:NO];
    }else{
        [sender setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
        sender.layer.borderColor = RGBHex(g_blue).CGColor;
        [sender setSelected:YES];
    }
    [self.delegate buttonClick:sender.titleLabel.text];
    
}

@end
