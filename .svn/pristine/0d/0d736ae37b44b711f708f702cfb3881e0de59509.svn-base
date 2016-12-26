//
//  BaseCell.m
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
    }
    return self;
}

- (void) initView
{

}


// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    //获取cell系统自带的分割线，获取分割线对象目的是为了保持自定义分割线frame和系统自带的分割线一样。如果不想一样，可以忽略。
    [super drawRect:rect];
    if (_hasBottomLine) {
        UIView *separatorView = [self valueForKey:@"_separatorView"];
        NSLog(@"%@",NSStringFromCGRect(separatorView.frame));
        NSLog(@"%@",NSStringFromCGRect(rect));
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor);
        //CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
        CGContextStrokeRect(context, separatorView.frame);
    }
    
}
@end
