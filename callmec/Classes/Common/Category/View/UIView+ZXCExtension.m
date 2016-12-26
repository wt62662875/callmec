//
//  UIView+ZXCExtension.m
//  百思不得姐
//
//  Created by 张小聪 on 16/2/19.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "UIView+ZXCExtension.h"

@implementation UIView (ZXCExtension)


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)X
{
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}


-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void)setY:(CGFloat)Y
{
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}


-(CGFloat)width
{
    return  self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)X
{
    return self.frame.origin.x;
}

- (CGFloat)Y
{
    return self.frame.origin.y;
}


-(CGSize)size
{
    return self.frame.size; 
}

@end
