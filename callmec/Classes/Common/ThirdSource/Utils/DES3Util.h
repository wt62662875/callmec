//
//  DES3Util.h
//  crownbee
//
//  Created by sam on 16/3/25.
//  Copyright © 2016年 crownbee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

+ (NSString*) AES128Encrypt:(NSString *)plainText;

+ (NSString*) AES128Decrypt:(NSString *)encryptText;

@end