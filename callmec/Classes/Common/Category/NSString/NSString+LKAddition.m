//
//  NSString+LKAddition.m
//
//  Created by Likid on 12/9/14.
//  Copyright (c) 2014 Likid. All rights reserved.
//

#import "NSString+LKAddition.h"
#import <CommonCrypto/CommonDigest.h>

inline NSString *NSStringFromBOOL(BOOL b) { return b ? @"YES" : @"NO"; }
inline NSString *NSStringFromInteger(NSInteger num) { return [NSString stringWithFormat:@"%ld", (long)num]; }
inline NSString *NSStringFromCGFloat(CGFloat num) { return [NSString stringWithFormat:@"%.2f", num]; }

inline NSString *LKLocalizedString(NSString *string) { return NSLocalizedString(string, @""); }

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName : self.font};

    CGSize retSize =
        [self.text boundingRectWithSize:size
                                options:NSStringDrawingTruncatesLastVisibleLine |
                                        NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:attribute
                                context:nil]
            .size;

    return retSize;
}

@end

@implementation NSString (LKAddition)

- (NSString *)stringByTrimmingWhiteSpaceCharacter {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (CGSize)boundingSizeWithSize:(CGSize)size fontSize:(NSInteger)fontSize {
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{
                               NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                           } context:nil]
        .size;
}

- (BOOL)isExistsChinese {
    for (int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];

        if (a >= 0x4e00 && a <= 0x9fa5) {
            return YES;
        }
    }

    return NO;
}

+ (NSString *)remainDayString:(NSInteger)timeInterval {
    NSInteger days = timeInterval == 0 ? 0 : timeInterval / 3600 / 24 + 1;
        
    return [NSString stringWithFormat:@"剩余%ld天", (long)days];
}

@end

@implementation NSString (LKValidation)

- (BOOL)isValidatePhoneNumber {
    
    /*
     电信号段:133/153/180/181/189/177；
     联通号段:130/131/132/155/156/185/186/145/176；
     移动号段：134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
     */
    
    //现在只有13、15和18开头的11位手机号码。以1开头，第2位数字为3或5或8，后面接9位数字
    NSString *phoneNumberRegex = @"^[1][34578][0-9]{9}$";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegex];
    return [phoneNumberTest evaluateWithObject:self];
}

- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateEmailCharacters {
    NSString *strRegex = @"(\\w|\\d|[.@\\!@#$%^&*()-=_+?,:'\\[\\]])+";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [strTest evaluateWithObject:self];
}

- (BOOL)isValidateURLCharacters {
    NSString *strRegex = @"(\\w|\\d|[.@\\!@#$%^&*()-=_+?,:'\\[\\]])+";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [strTest evaluateWithObject:self];
}

- (BOOL)isNumber {
    
//    NSString *strRegex = @"\\d";
//    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
//    return [strTest evaluateWithObject:self];

    static NSMutableCharacterSet *characterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
        
        // trimming string like @"3.0000", if string is @"3000", it will trimming to @"3", but it doesn't matter
        [characterSet addCharactersInString:@"0"];
        [characterSet addCharactersInString:@"."];
    });
    
    return [self stringByTrimmingCharactersInSet:characterSet].length == 0;
}

@end

#pragma mark - Hash

@implementation NSString (LKHash)

- (unsigned long)ELFhashValue {
    if (!self) {
        return -1;
    }

    unsigned long h = 0;
    unsigned long g;
    unsigned long word;

    for (int i = 0; i < [self length]; i++) {
        word = [self characterAtIndex:i];
        h = (h << 4) + word;
        g = h & 0xf0000000L;
        if (g)
            h ^= g >> 24;
        h &= ~g;
    }
    return h;
}

- (NSString *)sha1Base64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    NSData *base64 = [[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];

    return [base64 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
