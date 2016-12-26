//
//  SearchAddressController.h
//  callmec
//
//  Created by sam on 16/6/30.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseController.h"

@class CMLocation;
@class SearchAddressController;

@protocol SearchViewControllerDelegate <NSObject>
@optional

- (void)searchViewController:(SearchAddressController*)searchViewController didSelectLocation:(CMLocation *)location;
@end

/**
 *  搜索地点的视图控制器。使用UISearchBar，对关键字进行搜索，得到相关POI信息。
 */
@interface SearchAddressController : BaseController

@property (nonatomic, weak) id<SearchViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, assign) NSInteger targetId;

@end
