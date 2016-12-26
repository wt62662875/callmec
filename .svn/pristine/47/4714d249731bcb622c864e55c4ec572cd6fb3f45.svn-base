//
//  UIImageView.m
//  crownbee
//
//  Created by sam on 16/5/25.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "UIImageView+Circle.h"
#import "ImageTools.h"
@implementation UIImageView(Circle)


- (void) sd_setCircleImageWithURL:(NSString *)surl placeholderImage:(UIImage *)placeholder
{
    if (surl==nil || surl.length==0) {
        self.image = placeholder;
        return;
    }
    NSURL *url=[NSURL URLWithString:surl];
    NSString *image_url_cache = [surl stringByAppendingString:@"cache_circle"];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:image_url_cache];
    if (!cacheImage) {
        cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:image_url_cache];
        self.image = cacheImage;
    }
    if (!cacheImage) {
        [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (!error)
            {
                UIImage *radiusImage = [ImageTools cicleImage:image withParam:1];
                self.image = radiusImage;
                [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:image_url_cache];
                [[SDImageCache sharedImageCache] removeImageForKey:surl];
            }
        }];
    }else{
        self.image = cacheImage;
    }
}

@end
