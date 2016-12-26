//
//  AppDelegate+ThirdLogin.m
//  crownbee
//
//  Created by sam on 16/5/12.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "AppDelegate+ThirdLogin.h"

#import "WXApi.h"
#import "Pay.h"
#import "payRequsestHandler.h"
#import <AlipaySDK/AlipaySDK.h>

//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"

#import "APpdelegate+ThirdLogin.h"


@implementation AppDelegate (ThirdLogin)


- (void)setupWechat {
    // 帮本app注册微信
    [WXApi registerApp:APP_ID withDescription:@"weixin_callme"];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        ShowMessageFromWXReq *temp = (ShowMessageFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg =
        [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n",
         msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onResp:(BaseResp *)resp {
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //  [Pay processPayCallback:resp type:PayTypeWechat];
        //  支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                // NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                //[self sharedInstance].success = success;
                //[Pay sharedInstance]
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [[NSNotificationCenter defaultCenter] postNotificationName:YASNtfPaySuccess object:nil userInfo:dic];
            }
                break;
                
            default:
            {
                strMsg = [NSString
                          stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode, resp.errStr];
                //            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode, resp.errStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:YASNtfPayFailure object:nil userInfo:nil];
            }
                break;
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        [ThirdPartyLogin wechatAuthResponse:resp];
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
    //                                                    message:strMsg
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"OK"
    //                                          otherButtonTitles:nil, nil];
    //    [alert show];
}


- (BOOL)applicationDealWithOpenURL:(NSURL *)url {
    
    NSString *urlString = url.absoluteString;
    if ([urlString hasPrefix:@"comhyh"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      [Pay processPayCallback:resultDic type:PayTypeAlipay];
                                                  }];
    } else if ([urlString hasPrefix:@"wxd974962afc94dd4b"]) {
        // wechat
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return NO;//[UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
@end
