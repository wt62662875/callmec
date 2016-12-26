//
//  TXRateViewBar.h
//  crownbee
//
//  Created by sam on 16/5/19.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RateViewBarDelegate <NSObject>

@optional - (void) rateChangeValue:(CGFloat)value view:(UIView*)view;

@end

@interface RateViewBar : UIView

@property (nonatomic,strong) NSString *starLight; //star_light
@property (nonatomic,strong) NSString *grayLight; //star_gray
@property (assign,nonatomic) CGFloat rateNumber;             // 0~5 的比例

@property (nonatomic,assign) CGFloat *paddingOfStar;
@property (nonatomic,assign) BOOL dragEnabled;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,weak) id<RateViewBarDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame light:(NSString*)str_img_light gray:(NSString*)str_img_gray;
@end

