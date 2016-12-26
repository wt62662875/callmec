//
//  AspSandBoxHelper.h
//  MiGuFM
//
//  Created by sam on 15/12/1.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ConfigurationInformationModel.h"

@interface SandBoxHelper : NSObject

+ (NSString *)  sandBoxHomePath;       // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)  sandBoxAppPath;        // 程序目录，不能存任何东西
+ (NSString *)  sandBoxDocPath;        // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)  sandBoxLibPrefPath;    // 配置目录，配置文件存这里
+ (NSString *)  sandBoxLibCachePath;   // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)  sandBoxTmpPath;        // 临时缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)  sandBoxMediaVoicePath; // 存放meida voice的目录
+ (BOOL) hasLive:(NSString *)path;    // 判断目录是否存在，不存在则创建
+ (BOOL) fileExits:(NSString*)path;
+ (NSMutableDictionary*) defaultConfig;
+ (void) saveDefaultHost:(NSString*)host;
+ (NSString*) fetchDefaultHost;

/** 保存配置*/
+ (void) saveConfig:(NSDictionary*)config;

/**获取配置对象*/
//+ (ConfigurationInformationModel*) fetchConfig;

/**获取配置字典*/
+ (NSDictionary*) fetchConfigDictionary;

+ (NSString *) fetchNormalQuestion;
+ (BOOL) isDownloadHidden;          //是否隐藏下载
+ (BOOL) isOrderHidden;             //是否隐藏定制
+ (BOOL) isBiggerDataHidden;        //是否隐藏大数据
+ (NSString*) fetchBigDataUrl;       //获取大数据接口地址
+ (NSString*) fetchOrderUrl;         //获取信息
+ (void) saveProvisionCity:(NSDictionary*)city;   //保存区域信息
+ (NSDictionary*) fetchProvisionCity;              //获取区域信息
+ (NSInteger) fetchPromotCounts;
+ (void) savePromoteCounts:(NSInteger)counts;
+ (NSString *) getShareUrl; // 分享地址

+(void) saveHistorySearch:(NSArray*)historySearch;

+ (NSString*) fetchLoginNumber;
+ (NSString*) fetchLoginRandomCode;
+ (void) saveLoginParams:(NSString*)number random:(NSString*)random;
+ (NSArray *)fetchHistorySearch;

+ (NSDictionary*)fetchCarPoolingInfo;
+ (void) setVoiceStatus:(BOOL)status;
+ (BOOL) getVoiceStatus;

/*** 保存获取搜索历史纪录 ***/
+ (NSMutableArray*)fetchSearchList;
+ (void)saveSearchList:(NSMutableArray*)reslut;
+ (void)saveSearchResult:(CMLocation*)location;
@end
