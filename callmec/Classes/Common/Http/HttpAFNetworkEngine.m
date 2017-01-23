//
//  HttpAFNetworkEngine.m
//  LotteryForZCW
//
//  Created by dodo on 14-7-9.
//  Copyright (c) 2014年 ZCW. All rights reserved.
//

#import "HttpAFNetworkEngine.h"

@implementation HttpAFNetworkEngine

SYNTHESIZE_SINGLETON_FOR_CLASS(HttpAFNetworkEngine)

+ (HttpAFNetworkEngine *)sharedManager
{
    return [HttpAFNetworkEngine sharedHttpAFNetworkEngine];
}

// @param params 查询参数
// @param successBlock 查询成功的回调
// @method 接口名称
// @param errorBlock 查询失败的回调
- (void)callWithParams:(NSDictionary* )infoParams
            serviceUrl:(NSString *)serviceUrl
          OnCompletion:(QuerySuccessBlock)successBlock
               onError:(QueryErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//去掉null字段

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 将字典的类型的数据转化为
 
    NSString *infoParamsJson = [infoParams lk_JSONString];
    //[self addCustomHeader:manager headerDic:[HttpShareEngine creatHeaders:infoParamsJson method:method]];
    
    NSSet *mContentTypeSet = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",nil];
    manager.responseSerializer.acceptableContentTypes = mContentTypeSet;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return infoParamsJson;
    }];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:infoParams];
    NSDictionary *param = [temp  objectForKey:@"params"];
    if (param) {
        NSString *param_json = [param lk_JSONString];
//        NSLog(@"Json_param:%@", param_json);
        if (param_json) {
//            NSString *param_encode = [DES3Util AES128Encrypt:param_json];
            [temp removeObjectForKey:@"params"];
//            [temp setObject:param_encode forKey:@"data"];
        }
    }else{
        
    }
    [manager POST:serviceUrl parameters:temp progress:^(NSProgress *uploadProgress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        if(errorBlock)
        {
            errorBlock(((NSHTTPURLResponse*)task.response).statusCode,
                       [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse*)task.response).statusCode]);
        }
    }];
}
//添加header
-(void)addCustomHeader:(AFHTTPSessionManager *)manager headerDic:(NSDictionary *)headerDic
{
    [headerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

+ (void) callWithFormParam:(NSDictionary*)params serviceUrl:(NSString *)serviceUrl
              OnCompletion:(QuerySuccessBlock)successBlock
                   onError:(QueryErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//去掉null字段

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 将字典的类型的数据转化为
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:params];
    if (tmp &&![tmp objectForKey:@"token"]) {
        if ([GlobalData sharedInstance].user.isLogin) {
            [tmp setObject:[GlobalData sharedInstance].user.session forKey:@"token"];
        }else{
            NSLog(@"未登录!");
        }
        if ([tmp objectForKey:@"hasmemberId"] && [GlobalData sharedInstance].user.isLogin) {
            [tmp removeObjectForKey:@"hasmemberId"];
            [tmp setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"memberId"];
        }
    }
    
    NSString *infoParamsJson = [tmp lk_JSONString];
    
    NSLog(@"%@",infoParamsJson);
    NSSet *mContentTypeSet = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",nil];
    manager.responseSerializer.acceptableContentTypes = mContentTypeSet;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return infoParamsJson;
    }];
    
    [manager POST:serviceUrl parameters:tmp constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject)
        {
            if (successBlock) {
                successBlock(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        if(errorBlock)
        {
            errorBlock(((NSHTTPURLResponse*)task.response).statusCode,
                               [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse*)task.response).statusCode]);
        }
    }];
}

+ (void) callWithUrl:(NSDictionary*)params serviceUrl:(NSString *)serviceUrl
              OnCompletion:(QuerySuccessBlock)successBlock
                   onError:(QueryErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//去掉null字段

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSSet *mContentTypeSet = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",nil];
    manager.responseSerializer.acceptableContentTypes = mContentTypeSet;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    if (serviceUrl) {
        serviceUrl =[serviceUrl stringByAppendingString:@"?"];
        for (NSString *key in params) {
            if ([serviceUrl hasSuffix:@"?"]) {
                serviceUrl =[serviceUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
            }else{
                serviceUrl =[serviceUrl stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,params[key]]];
            }
        }
        
        if ([GlobalData sharedInstance].user.isLogin) {
            
            serviceUrl =[serviceUrl stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",
                                                             @"token",
                                                             [GlobalData sharedInstance].user.session]];
        }else{
            NSLog(@"未登录!");
        }
    }
    NSLog(@"url:%@",serviceUrl);
    [manager GET:serviceUrl parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject)
        {
            if (successBlock) {
                successBlock(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(errorBlock)
        {
            errorBlock(((NSHTTPURLResponse*)task.response).statusCode,
                       [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse*)task.response).statusCode]);
        }
    }];
}
@end
