//
//  NSString+extends.m
//  WikryDon
//
//  Created by dodohua on 13-1-10.
//  Copyright (c) 2013年 Gale. All rights reserved.
//

#import "NSString+extends.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (extends)
//判断是否是中国移动的电话号码
- (BOOL)checkPhoneNumber
{
    NSString *urlRegex = @"^0{0,1}(13[4-9]|15[7-9]|14[7-7]|15[0-2]|18[2-3]|18[7-8])[0-9]{8}$";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
	
	return [pred evaluateWithObject:self];
}

//判断身份证号  15位  或者18位
-(BOOL)checkIDcard
{
    NSString *urlRegex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
	return [pred evaluateWithObject:self];
}

    //判断是否是整数
-(BOOL)checkNum
{
    NSString *urlRegex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [pred evaluateWithObject:self];
}
    //判断是否为26个英文字母组成的字符串

-(BOOL)checkcharacter{
    NSString *urlRegex = @"^[A-Za-z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [pred evaluateWithObject:self];
}

//替换字符
-(NSString *)replaceString:(NSString *)replace Range:(NSRange)range
{
    NSInteger formIndex = range.location;
    NSInteger toIndex = range.location+range.length;
    
    if (formIndex < toIndex && toIndex<=self.length) {
        NSRange deleteRange = NSMakeRange(formIndex, toIndex-formIndex);
        replace = [@"" stringByPaddingToLength:range.length withString: replace startingAtIndex:0];
        return [self stringByReplacingCharactersInRange:deleteRange withString:replace];
    }
    
    return self;
}

//加星号  //后 n位
-(NSString *)changeToStar:(int)range
{
    if (self.length<=range) {
        return self;
    }else{
        NSRange range_r;
        range_r.location = self.length - range;
        range_r.length = range;
        return [self replaceString:@"*" Range:range_r];
    }
}
//加星号  身份证年月 4位  18位
-(NSString *)IDchangeToStar
{
    if (self.length<18) {
        return self;
    }
    NSRange range;
    range.location = 9;
    range.length = 4;
    return [self replaceString:@"*" Range:range];
}
    //加星号  驾驶证号 年月
-(NSString *)DriveIDchangeToStar
{
    if (self.length<18) {
        return self;
    }
    NSRange range;
    range.location = 6;
    range.length = 6;
    return [self replaceString:@"*" Range:range];
}
    //姓名加星
-(NSString *)namechangeToStar
{
    if (self.length<18) {
        return self;
    }
    NSRange range;
    range.location = 0;
    range.length = 4;
    return [self replaceString:@"*" Range:range];
}

//生成32位 MD5
- (NSString *) stringFromMD5{
    /*
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
     */
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

//去掉空格
-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//判断是否包含 子字符串
-(BOOL)isContainString:(NSString *)str
{
    if ([self rangeOfString:str].length > 0)
    {
        return YES;
    }
    return NO;
}

//替换regular 正则  替换多个为 “”  <[\\s\\S]*?>|&nbsp;
-(NSString *)replaceStringByRegular:(NSString *)regular
{
    return  [self replaceStringByRegular:regular toStr:@""];
}

-(NSString *)replaceStringByRegular:(NSString *)regular toStr:(NSString *)toStr
{
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regular
                                                                           options:0
                                                                             error:&error];
    
    NSString* result = [regex stringByReplacingMatchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, self.length)
                                                  withTemplate:toStr];
    
    return  result;
}

//替换正则  只替换一次
-(NSString *)replaceRegularOnce:(NSString *)regular
{
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regular
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *firstMatch=[regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (firstMatch) {
        
        NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
        
        //从urlString当中截取数据
        NSString *result = @"";
        if (resultRange.location>0) {
            result = [self substringToIndex:resultRange.location];
        }
        NSRange tmpRange;
        tmpRange.location = resultRange.location+resultRange.length;
        tmpRange.length = self.length -tmpRange.location;
        result = [result stringByAppendingString:[self substringWithRange:tmpRange]];
        //NSString *result=[self substringWithRange:resultRange];
        return result;
    }
    return self;
}

//查找子串出现的次数
- (NSInteger)countOccurencesOfString:(NSString*)searchString {
    int strCount = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}

-(NSString *)StrToFormatDateStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    
    NSDate *date =[dateFormat dateFromString:self];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *newString = [dateFormat stringFromDate:date];
    return newString;
}

//判断  一个数组 是否 含有这个字符串
-(BOOL)ArrHasStr:(NSArray *)arr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", self];
    if ([arr filteredArrayUsingPredicate:predicate].count>0) {
        return YES;
    }
    return NO;
}

//中英文混合
- (int)strLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}

-(NSDate *)formatStrToDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:self];
}

- (NSString *)urlEncodeString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        NULL, (__bridge CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]\" "), kCFStringEncodingUTF8));

    return result;
}

-(NSString *)urlDecodeString
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//处理url  param foo=1&baa=2
-(NSDictionary *)paramUrlToDic
{
    NSArray *queryElements = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *element in queryElements) {
        NSRange range = [element rangeOfString:@"="];
        if (range.length>0) {
            NSString *key = [element substringToIndex:range.location];
            NSString *value = [element substringFromIndex:range.location+1];
            [dic setObject:value forKey:key];
        }
        
    }
    return dic;
}

//中间添加4个*
-(NSString *)addStartBySub:(int)leftIndex rightIndex:(int)rightIndex
{
    if ((leftIndex+rightIndex)>=self.length) {
        return nil;
    }
    NSString *leftStr = @"";
    NSString *rightStr = @"";
    if (leftIndex>0) {
        leftStr = [self substringToIndex:leftIndex];
    }
    
    if (rightIndex>0) {
        rightStr = [self substringFromIndex:(self.length-rightIndex)];
    }
    
    return [NSString stringWithFormat:@"%@****%@",leftStr,rightStr];
}

-(NSString *)addStartBySub:(int)leftIndex lastStr:(NSString *)lastStr
{
    int rightIndex = 0;
    NSRange range = [self rangeOfString:lastStr];
    if (range.length > 0){
        rightIndex = self.length - range.location;
    }
    return [self addStartBySub:leftIndex rightIndex:rightIndex];
}

- (NSString*) unescapeUnicodeString
{
    //NSString* input = @"ab\"cA\"BC\\u2345\\u0123";
    
    // will cause trouble if you have "abc\\\\uvw"
    NSString* esc1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString* esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
    NSData* data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
    NSString* unesc = [NSPropertyListSerialization propertyListFromData:data
                                                       mutabilityOption:NSPropertyListImmutable format:NULL
                                                       errorDescription:NULL];
    assert([unesc isKindOfClass:[NSString class]]);
    // done
    return unesc;
}

- (NSString*) escapeUnicodeString
{
    // lastly escaped quotes and back slash
    // note that the backslash has to be escaped before the quote
    // otherwise it will end up with an extra backslash
    NSString* escapedString = [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    // convert to encoded unicode
    // do this by getting the data for the string
    // in UTF16 little endian (for network byte order)
    NSData* data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
    size_t bytesRead = 0;
    const char* bytes = data.bytes;
    NSMutableString* encodedString = [NSMutableString string];
    
    // loop through the byte array
    // read two bytes at a time, if the bytes
    // are above a certain value they are unicode
    // otherwise the bytes are ASCII characters
    // the %C format will write the character value of bytes
    while (bytesRead < data.length)
    {
        uint16_t code = *((uint16_t*) &bytes[bytesRead]);
        if (code > 0x007E)
        {
            [encodedString appendFormat:@"%%u%04X", code];
        }
        else
        {
            [encodedString appendFormat:@"%C", code];
        }
        bytesRead += sizeof(uint16_t);
    }
    
    // done
    return encodedString;
}

//保留两位小数  小数后面是0的 不保留
+(NSString *)formatNumber:(NSNumber *)num
{
    if (num == nil) {
        return @"";
    }
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    
    [fmt setPositiveFormat:@"0.##"];
    //NSLog(@"format:%@",[fmt stringFromNumber:[NSNumber numberWithFloat:[num floatValue]]]);
    return [fmt stringFromNumber:[NSNumber numberWithFloat:[num floatValue]]];
}

/**
 *ios7以上计算文字高度
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [self boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end
