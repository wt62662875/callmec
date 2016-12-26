//
//  HttpAFNetworkEngine.h
//  LotteryForZCW
//
//  Created by dodo on 14-7-9.
//  Copyright (c) 2014年 ZCW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDifinde.h"
#import "HttpShareEngine.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "LKJSONKit.h"
#import "LKJSONKit.h"


@interface HttpAFNetworkEngine : NSObject
+ (HttpAFNetworkEngine *)sharedManager;
- (void) callWithParams:(NSDictionary* )infoParams
            serviceUrl:(NSString *)serviceUrl
          OnCompletion:(QuerySuccessBlock)successBlock
               onError:(QueryErrorBlock)errorBlock;

+ (void) callWithFormParam:(NSDictionary*)params serviceUrl:(NSString *)serviceUrl
              OnCompletion:(QuerySuccessBlock)successBlock
                   onError:(QueryErrorBlock)errorBlock;

+ (void) callWithUrl:(NSDictionary*)params serviceUrl:(NSString *)serviceUrl
        OnCompletion:(QuerySuccessBlock)successBlock
             onError:(QueryErrorBlock)errorBlock;
@end
