//
//  HttpShareEngine.h
//  LotteryForZCW
//
//  Created by dodo on 14-7-10.
//  Copyright (c) 2014年 ZCW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpAFNetworkEngine.h"
#import "HttpDifinde.h"

extern NSString *const SessionInvalidNotification;
extern NSString *const SessionInvalidTipKey;

@interface HttpShareEngine : NSObject

+ (HttpShareEngine *)sharedInstance;
- (void)callWithParams:(NSDictionary* )infoParams
                method:(NSString *)method
          OnCompletion:(QuerySuccessBlock)successBlock
               onError:(QueryErrorBlock)errorBlock;

- (void)callWithRawParams:(NSDictionary *)infoParams
                   method:(NSString *)method
             OnCompletion:(QuerySuccessBlock)successBlock
                  onError:(QueryErrorBlock)errorBlock;

- (void)callWithParams:(NSDictionary* )infoParams
                method:(NSString *)method
            serviceUrl:(NSString *)serviceUrl
          OnCompletion:(QuerySuccessListBlock)successBlock
               onError:(QueryErrorBlock)errorBlock;

//上传图片请求
+ (void)uploadImageWithHost:(NSString *)URLString
                   method:(NSString *)method
                imageData:(NSData *)imageData
                     name:(NSString *)imageName
                 fileName:(NSString *)fileName
                 MIMEType:(NSString *)mimeType
               parameters:(id)parameters
                  success:(QuerySuccessModelBlock)success
                  failure:(QueryErrorBlock)failure;

+ (void) uploadImageWithHost:(NSString *)URLString
                    method:(NSString *)method
                 imageData:(NSData *)imageData
                      name:(NSString *)imageName
                  fileName:(NSString *)fileName
                  MIMEType:(NSString *)mimeType
                parameters:(id)parameters
                  progesss:(QueryProgress)progress
                   success:(QuerySuccessModelBlock)success
                   failure:(QueryErrorBlock)failure;

+ (void) uploadImage:(NSData*)image parameters:(id)parameters
            progesss:(QueryProgress)progress
             success:(QuerySuccessModelBlock)success
             failure:(QueryErrorBlock)failure;
//上传多张图片请求
+ (id)uploadImageSWithHost:(NSString *)url
                    method:(NSString *)method
            imageDataArray:(NSArray *)imageDataArray
                   success:(QuerySuccessModelBlock)success
                   failure:(QueryErrorBlock)failure;



+ (NSDictionary*) createHeaderParams;

/** 创建公共的头信息接口 */
+ (void) createHeaderParams:(NSMutableDictionary *)dict;


+ (void)upLoadVoice:(NSData *)recordData voiceTime:(NSInteger)voiceTime succ:(QuerySuccessBlock)success fail:(QueryErrorBlock)failBlock;

/** 文件下载 */
+ (void) downloadFile:(NSString*)url savePath:(NSString*)path;

+ (void) downloadVoiceFile:(NSString *)url progress:(QueryProgress)p success:(DownloadSuccess)success fail:(DownloadFail)fail;

+ (void) downloadFile:(NSString *)url savePath:(NSString *)path progress:(QueryProgress)p success:(DownloadSuccess)success fail:(DownloadFail)fail;

/** Form格式的请求**/
+ (void) callWithFormParams:(NSDictionary*)params withMethod:(NSString*)method succ:(QuerySuccessBlock)success fail:(QueryErrorBlock)failb;

/** Form list **/
+ (void) callWithFormParams:(NSDictionary*)params withMethod:(NSString*)method succList:(QuerySuccessListBlock)list fail:(QueryErrorBlock)failb;

//Http Get Request;
+ (void) callWithUrlParams:(NSDictionary*)params withMethod:(NSString*)method succ:(QuerySuccessBlock)success fail:(QueryErrorBlock)failb;

//Http Get Request;
+ (void) callWithUrlParams:(NSDictionary*)params withMethod:(NSString*)method succList:(QuerySuccessListBlock)list fail:(QueryErrorBlock)failb;

+ (void) refreshToken;
@end
