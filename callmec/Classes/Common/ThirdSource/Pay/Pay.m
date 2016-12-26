//
//  Pay.m
//  crownbee
//
//  Created by Likid on 10/15/15.
//  Copyright © 2015 crownbee. All rights reserved.
//

#import "Pay.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "payRequsestHandler.h"

NSString *const YASNtfPaySuccess = @"YASNtfPaySuccess";
NSString *const YASNtfPayFailure = @"YASNtfPayFailure";

NSString *const YASPayResultKey = @"YASPayResultKey";
NSString *const YASPayTypeKey = @"YASPayTypeKey";

@implementation AlipayModel

@end

@interface Pay ()

@property (copy, nonatomic) LKObjectBlock success;
@property (copy, nonatomic) QueryErrorBlock failure;

@end

@implementation Pay

+ (Pay *)sharedInstance {
    static id _sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addNotificationObservers];
    }
    return self;
}

- (void)addNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paySuccess:)
                                                 name:YASNtfPaySuccess
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(payFailure:)
                                                 name:YASNtfPayFailure
                                               object:nil];
}

- (void)paySuccess:(NSNotification *)notification {
    if (self.success) {
        self.success(notification.userInfo);
    }
}

- (void)payFailure:(NSNotification *)notification {
    if (self.failure) {
        NSError *error = notification.userInfo[YASPayResultKey];
        self.failure(error.code, error.localizedFailureReason);
    }
}

+ (void)payWithAmount:(CGFloat)amount orderId:(NSString*)orderId
                 type:(PayType)type
              success:(LKObjectBlock)success
              failure:(QueryErrorBlock)failure {

    [self sharedInstance].success = success;
    [self sharedInstance].failure = failure;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (orderId) {
        [param setObject:orderId forKey:@"id"];
    }
    if (type == PayTypeAlipay) {
        [param setObject:@"1" forKey:@"payType"];
    }else if(type == PayTypeWechat)
    {
        [param setObject:@"2" forKey:@"payType"];
    }
    
    [HttpShareEngine callWithFormParams:param withMethod:@"signOrder" succ:^(NSDictionary *resultDictionary)
    {
        NSLog(@"resultDictionary:%@",resultDictionary);
        if (type == PayTypeAlipay) {
            NSString *message =resultDictionary[@"message"];
            if (message) {
                [self alipayTrade:message];
            }else{
                if (failure) {
                    failure(-1,@"平台返回参娄非法!");
                }
            }
        } else {
            [self payWithWechat:resultDictionary amount:amount];
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (failure) {
            failure(errorCode,errorMessage);
        }
    }];
}

+ (void) alipayTrade:(NSString*)orderString
{
    NSString *appScheme = @"comhyhwakioscallmec";
    [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary *resultDic) {
                                        [self processPayCallback:resultDic type:PayTypeAlipay];
                                    }];

}

+ (void)processPayCallback:(id)result type:(PayType)type {
    NSLog(@"pay resultDic: %@", result);

    NSError *error = nil;
    YASPayResultStatus status = YASPayFailed;

    if (type == PayTypeAlipay) {
        NSDictionary *alipayResult = result;

        YASAlipayResultStatus alipayResultStatus = [alipayResult[@"resultStatus"] integerValue];
        if (alipayResultStatus != YASAlipaySuccess) {
            NSString *reason = @"";
            if (alipayResultStatus == YASAlipayCanceled) {
                reason = @"已取消"; // 用户主动取消，不进行处理
                status = YASPayCanceled;
            } else {
                status = YASPayFailed;
                reason = @"订单支付异常";
            }

            NSDictionary *userInfo = @{
                NSLocalizedFailureReasonErrorKey : reason,
                NSLocalizedDescriptionKey : alipayResult.description,
            };
            error = [NSError errorWithDomain:@"" code:alipayResultStatus userInfo:userInfo];

        } else {
            status = YASPaySuccess;
        }
    } else if (type == PayTypeWechat) {
        PayResp *resp = result;

        NSString *reason = @"";

        switch (resp.errCode) {
        case WXSuccess: {
            status = YASPaySuccess;
        } break;
        case WXErrCodeUserCancel: {
            status = YASPayCanceled;
            reason = @"已取消"; // 用户主动取消，不进行处理
        } break;
        default:
            status = YASPayFailed;
            reason = @"订单支付异常";
            break;
        }

        NSDictionary *userInfo = @{
            NSLocalizedFailureReasonErrorKey : reason,
            NSLocalizedDescriptionKey : resp.errStr ?: @"",
        };
        error = [NSError errorWithDomain:@"" code:status userInfo:userInfo];
    }

    if (status == YASPaySuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YASNtfPaySuccess
                                                            object:nil
                                                          userInfo:@{
                                                              YASPayResultKey : result,
                                                              YASPayTypeKey : @(type),
                                                          }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:YASNtfPayFailure
                                                            object:nil
                                                          userInfo:@{
                                                              YASPayResultKey : error,
                                                              YASPayTypeKey : @(type),
                                                          }];
    }
}

#pragma mark - Wechat

+ (void)payWithWechat:(NSDictionary *)resultDictionary amount:(CGFloat)amount {
    NSDictionary *message = resultDictionary[@"message"];
    [self wechatPay:message];
}

+ (void)wechatPay:(NSDictionary *)dict {
    if ([WXApi isWXAppInstalled] == NO) {
        [self sharedInstance].failure(-1, @"尚未安装微信");
        return;
    }
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现

    //创建支付签名对象
//    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
//    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
//    [req setKey:PARTNER_ID];

    //}}}

    //获取到实际调起微信支付的参数后，在app端调起支付
    if (dict == nil) {
        //错误提示
//        NSString *debug = [req getDebugifo];

//        [self processPayCallback:debug type:PayTypeWechat];

//        NSLog(@"%@\n\n", debug);
    } else {
//        NSLog(@"%@\n\n", [req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];

        NSMutableString *stamp = [dict objectForKey:@"timestamp"];

        //调起微信支付
        PayReq *req = [[PayReq alloc] init];
        req.openID = [dict objectForKey:@"appid"];
        req.partnerId = [dict objectForKey:@"partnerid"];
        req.prepayId = [dict objectForKey:@"prepayid"];
        req.nonceStr = [dict objectForKey:@"noncestr"];
        req.timeStamp = stamp.intValue;
        req.package = [dict objectForKey:@"package"];
        req.sign = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}

@end
