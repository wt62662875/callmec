//
//  TXImageTools.m
//  crownbee
//
//  Created by sam on 16/6/2.
//

#import "ImageTools.h"

@implementation ImageTools


// 对图片尺寸进行压缩 和 转格式
+ (NSData *)imagechangeWithImage:(UIImage *)image
{
    // 对图片尺寸进行压缩
    // 以屏幕的宽度为图片的宽度，高度等比例计算
    CGRect bounces = [UIScreen mainScreen].bounds;
    CGSize imageSize = image.size;
    CGFloat imageH = bounces.size.width * (imageSize.height/imageSize.width);
    
    UIImage * imageNew = [self imageWithImage:image scaledToSize:CGSizeMake(bounces.size.width, imageH)];
    NSData *data;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(imageNew)) {
        //返回为png图像。
        data =   UIImagePNGRepresentation(imageNew);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(imageNew,0);
    }
    
    return data;
}

//对图片尺寸进行压缩
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*) imageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage*) cicleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    CGFloat max_h = 0;
    if (image.size.height>image.size.width) {
        max_h = image.size.width;
            }else{
        max_h = image.size.height;
    }
    if (inset==0) {
        inset = 1;
    }
    UIGraphicsBeginImageContext(CGSizeMake(max_h, max_h));

    CGContextRef context =UIGraphicsGetCurrentContext();
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    
    //(image.size.width-max_h*inset)/2
    CGRect rect = CGRectMake(0, 0, max_h*inset, max_h*inset);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newimg;
}
@end
