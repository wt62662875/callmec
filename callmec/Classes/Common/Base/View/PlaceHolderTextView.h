//
//  PlaceHolderTextView.h
//  callmec
//
//  Created by sam on 16/8/2.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,strong) UIColor *placeHolderColor;
@end
