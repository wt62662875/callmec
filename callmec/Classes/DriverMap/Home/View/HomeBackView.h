//
//  HomeBackView.h
//  callmec
//
//  Created by wt on 2017/2/7.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBackView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *refereesTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic,weak) id<TargetActionDelegate> delegate;

@end
