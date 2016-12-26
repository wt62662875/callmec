//
//  CenterFunctionCell.m
//  callmec
//
//  Created by sam on 16/9/28.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CenterFunctionCell.h"
#import "BaseItemModel.h"
#import "VerticalView.h"

@implementation CenterFunctionCell
{
    NSMutableDictionary *_dictionary;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) initView{
    _dictionary = [NSMutableDictionary dictionary];
}

- (void) setModel:(BaseModel *)model
{
    [super setModel:model];
    FunctionModel *mds = (FunctionModel*)model;
    int i=0;
    for (FunctionItemModel *md in mds.dataArray) {
        VerticalView *btn= [_dictionary objectForKey:[NSString stringWithFormat:@"%d",i]];
        if (!btn) {
            btn = [[VerticalView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [_dictionary setObject:btn forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [btn setTitle:md.title];
        [btn setImageUrl:md.icons];
        
        [self addSubview:btn];
        [btn setMake:@"userCenter"];
        [btn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(i*(SCREENWIDTH/8));
            make.centerY.equalTo(self).offset(20);
        }];

        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(i*(SCREENWIDTH/4));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(SCREENWIDTH/4);
            make.height.equalTo(self);
        }];
        [btn setTitleFont:[UIFont systemFontOfSize:10]];
        [btn setImageBackgroudColor:RGBHex(g_white)];

//        if (i==0) {
//            [btn setImageBackgroudColor:RGBHex(g_white)];
//        }else if (i==1) {
//            [btn setImageBackgroudColor:RGBHex(g_assit_orign)];
//        }else if (i==2) {
//            [btn setImageBackgroudColor:RGBHex(g_assit_yellow)];
//        }else if (i==3) {
//            [btn setImageBackgroudColor:RGBHex(g_assit_green)];
//        }
        btn.delegate = self.delegate;
        [btn setTag:i];
        i++;
    }
}

- (void) buttonTarget:(UIButton*)btn
{
    if (_delegate&&[_delegate respondsToSelector:@selector(buttonTarget:)]) {
        [_delegate buttonTarget:btn];
    }
}
@end
