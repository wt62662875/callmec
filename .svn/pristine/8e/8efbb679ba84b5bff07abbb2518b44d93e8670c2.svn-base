//
//  NSString+LKAddition..h
//
//  Created by Likid on 12/9/14.
//  Copyright (c) 2014 Likid. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *NSStringFromBOOL(BOOL b);
extern NSString *NSStringFromInteger(NSInteger num);
extern NSString *NSStringFromCGFloat(CGFloat num);

extern NSString *LKLocalizedString(NSString *string);

@interface UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;

@end

@interface NSString (LKAddition)

- (NSString *)stringByTrimmingWhiteSpaceCharacter;

- (CGSize)boundingSizeWithSize:(CGSize)size fontSize:(NSInteger)fontSize;

/*!
 @brief  whether string contains any chinese character

 @return YES, contains at least one chinese character; otherwise, NO.
 */
- (BOOL)isExistsChinese;

+ (NSString *)remainDayString:(NSInteger)timeInterval;

@end

@interface NSString (LKValidation)

- (BOOL)isValidatePhoneNumber;

/*!
 @brief  是否是有效的邮箱格式

 @return YES, isValidateEmail; otherwise, NO.
 */
- (BOOL)isValidateEmail;

- (BOOL)isValidateEmailCharacters;

- (BOOL)isValidateURLCharacters;

- (BOOL)isNumber;

@end

@interface NSString (LKHash)

- (unsigned long)ELFhashValue;
- (NSString *)sha1Base64;

@end