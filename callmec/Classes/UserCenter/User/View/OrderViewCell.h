//
//  OrderViewCell.h
//  callmec
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderViewCell : UITableViewCell

@property (nonatomic,strong) BaseModel *model;
@property (nonatomic,weak) id<CellTargetDelegate> delegateCell;

- (void) setTopLineHidden:(BOOL)state;
- (void) setBottomLineHidden:(BOOL)state;

@end
