//
//  UIColor+Hex.m
//
//
//  Created by me on 15/6/15.
//  Copyright (c) 2015年 me. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    return [UIColor colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *) hexColor alpha:(CGFloat)alpha
{
    //线程锁@synchronized(self){}
    @synchronized(self)
    {
        if ([hexColor length] < 6) return [UIColor blackColor];
        if ([hexColor hasPrefix:@"#"]) hexColor = [hexColor substringFromIndex:1];
        if ([hexColor length] < 6) return [UIColor blackColor];
        unsigned int redInt_, greenInt_, blueInt_;
        NSRange rangeNSRange_;
        rangeNSRange_.length = 2;  // 范围长度为2
        
        // 取红色的值
        rangeNSRange_.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&redInt_];
        
        // 取绿色的值
        rangeNSRange_.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&greenInt_];
        
        // 取蓝色的值
        rangeNSRange_.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&blueInt_];
        
        return [UIColor colorWithRed:(float)(redInt_/255.0f) green:(float)(greenInt_/255.0f) blue:(float)(blueInt_/255.0f) alpha:alpha];
    }
    
}

//返回两个颜色渐变的中间值
+(UIColor *)colorInTwo:(NSString *)firstColor secondColor:(NSString *)secondColor  percent:(CGFloat)percent
{
    if ([firstColor length] < 6) return [UIColor blackColor];
    if ([firstColor hasPrefix:@"#"]) firstColor = [firstColor substringFromIndex:1];
    if ([firstColor length] < 6) return [UIColor blackColor];
    
    if ([secondColor length] < 6) return [UIColor blackColor];
    if ([secondColor hasPrefix:@"#"]) secondColor = [secondColor substringFromIndex:1];
    if ([secondColor length] < 6) return [UIColor blackColor];
    unsigned int redInt_1, greenInt_1, blueInt_1,redInt_2, greenInt_2, blueInt_2;
    int redInt_3, greenInt_3, blueInt_3;
    // 取红色的值
    NSRange rangeNSRange_;
    rangeNSRange_.length = 2;  // 范围长度为2
    rangeNSRange_.location = 0;
    [[NSScanner scannerWithString:[firstColor substringWithRange:rangeNSRange_]] scanHexInt:&redInt_1];
    
    // 取绿色的值
    rangeNSRange_.location = 2;
    [[NSScanner scannerWithString:[firstColor substringWithRange:rangeNSRange_]] scanHexInt:&greenInt_1];
    
    // 取蓝色的值
    rangeNSRange_.location = 4;
    [[NSScanner scannerWithString:[firstColor substringWithRange:rangeNSRange_]] scanHexInt:&blueInt_1];
    
    
    rangeNSRange_.location = 0;
    [[NSScanner scannerWithString:[secondColor substringWithRange:rangeNSRange_]] scanHexInt:&redInt_2];
    
    // 取绿色的值
    rangeNSRange_.location = 2;
    [[NSScanner scannerWithString:[secondColor substringWithRange:rangeNSRange_]] scanHexInt:&greenInt_2];
    
    // 取蓝色的值
    rangeNSRange_.location = 4;
    [[NSScanner scannerWithString:[secondColor substringWithRange:rangeNSRange_]] scanHexInt:&blueInt_2];
    
    redInt_3 = (int)redInt_1 +((int)redInt_2 - (int)redInt_1)*percent;
    greenInt_3 = (int)greenInt_1 + ((int)greenInt_2 - (int)greenInt_1)*percent;
    blueInt_3 = (int)blueInt_1 + ((int)blueInt_2- (int)blueInt_1)*percent;
    //NSLog(@"颜色值：redInt_3：%d greenInt_3: %d;  blueInt_3 :%d",redInt_3,greenInt_3,blueInt_3);
    return [UIColor colorWithRed:(float)(redInt_3/255.0f) green:(float)(greenInt_3/255.0f) blue:(float)(blueInt_3/255.0f) alpha:1.0f];
}

//创建纯色图片
+(UIImage *)createColorImg:(NSString *)hexColor alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor colorWithHexString:hexColor alpha:alpha];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage *)createColorImg:(NSString *)hexColor
{
    UIColor *color = [UIColor colorWithHexString:hexColor];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
