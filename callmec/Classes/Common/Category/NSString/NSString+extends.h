//
//  NSString+extends.h
//  WikryDon
//
//  Created by dodohua on 13-1-10.
//  Copyright (c) 2013年 Gale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extends)
- (BOOL)checkPhoneNumber;
//判断身份证号
-(BOOL)checkIDcard;
//加星号  //后 n位
-(NSString *)changeToStar:(int)range;
//加星号  身份证年月 4位
-(NSString *)IDchangeToStar;
//加星号  驾驶证号 年月
-(NSString *)DriveIDchangeToStar;
//生成32位 MD5
- (NSString *) stringFromMD5;
    //姓名加星号
-(NSString *)namechangeToStar;

//去除首尾空格
-(NSString *)trim;

//判断是否包含 子字符串
-(BOOL)isContainString:(NSString *)str;

//替换regular 正则  替换多个为 “”
-(NSString *)replaceStringByRegular:(NSString *)regular;

//查找子串出现的次数
- (NSInteger)countOccurencesOfString:(NSString*)searchString;

-(NSString *)StrToFormatDateStr;
    //判断是否是整数
-(BOOL)checkNum;
-(BOOL)checkcharacter;

//判断  一个数组 是否 含有这个字符串
-(BOOL)ArrHasStr:(NSArray *)arr;

//中英文混合
- (int)strLength;

//把字符串转化为date格式
-(NSDate *)formatStrToDate;

-(NSString *)replaceStringByRegular:(NSString *)regular toStr:(NSString *)toStr;
-(NSString *)urlEncodeString;
-(NSString *)urlDecodeString;

//处理url  param foo=1&baa=2
-(NSDictionary *)paramUrlToDic;

//中间添加4个*
-(NSString *)addStartBySub:(int)leftIndex rightIndex:(int)rightIndex;
-(NSString *)addStartBySub:(int)leftIndex lastStr:(NSString *)lastStr;

- (NSString*) unescapeUnicodeString;
- (NSString*) escapeUnicodeString;

//保留两位小数  小数后面是0的 不保留
+(NSString *)formatNumber:(NSNumber *)num;

/**
 *ios7以上计算文字高度
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font;
//替换正则  只替换一次
-(NSString *)replaceRegularOnce:(NSString *)regular;

@end
