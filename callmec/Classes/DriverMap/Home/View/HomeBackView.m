//
//  HomeBackView.m
//  callmec
//
//  Created by wt on 2017/2/7.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "HomeBackView.h"

@implementation HomeBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

-(void)layoutSubviews {
    // Drawing code
    _sureButton.layer.cornerRadius = 5;
    _headImage.layer.cornerRadius = 31;
    _headImage.layer.masksToBounds = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@getMHeadIcon?id=%@&token=%@",kserviceURL,
                        [GlobalData sharedInstance].user.userInfo.ids,
                        [GlobalData sharedInstance].user.session];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"teng"]];
    _nameLabel.text = [GlobalData sharedInstance].user.userInfo.realName?[GlobalData sharedInstance].user.userInfo.realName:[GlobalData sharedInstance].user.userInfo.phoneNo;
}

- (IBAction)buttonClick:(UIButton *)sender {
    
//    if (_delegate &&[_delegate respondsToSelector:@selector(buttonSelected:Index:)]) {
        [_delegate buttonTarget:sender];
//    }
}
@end
