//
//  KeyChainService.h
//  MicroEarn
//
//  Created by Yan sam on 14-5-10.
//  Copyright (c) 2014年 Yan sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainService : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)saveKey:(NSString *)service data:(id)data;
+ (id)loadKey:(NSString *)service;
+ (void)deleteKey:(NSString *)service;
@end
