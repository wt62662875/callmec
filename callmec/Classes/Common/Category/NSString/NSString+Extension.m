//
//  NSString+Extension.m
//  crownbee
//
//  Created by 张小聪 on 16/4/21.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    /*
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = 0.5;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.paragraphSpacing = 0;
    paragraphStyle.paragraphSpacingBefore= 0;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CGRect rect = [attributedString boundingRectWithSize:maxSize options:
                   NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 context:context];
    */
    /*
     
     NSStringDrawingUsesDeviceMetrics
     NSStringDrawingTruncatesLastVisibleLine
     NSStringDrawingUsesFontLeading
     NSStringDrawingUsesLineFragmentOrigin
     */
//    return rect.size;
//    NSStringDrawingUsesDeviceMetrics
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

-(CGSize)sizeWithFonts:(UIFont *)font
{
    //    NSStringDrawingUsesDeviceMetrics
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:CGSizeMake(kScreenSize.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}
- (CGSize) sizeFont:(NSInteger)size
{
    if (IOS_VERSION>7.0f) {
        return [self sizeWithFont:[UIFont systemFontOfSize:size] maxSize:CGSizeMake(180.0f, 20000.0f)];
    }else{
        return [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    }
}
@end
