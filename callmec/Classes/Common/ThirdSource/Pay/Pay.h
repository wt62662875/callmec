//
//  Pay.h
//  crownbee
//
//  Created by Likid on 10/15/15.
//  Copyright © 2015 callmec. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
    支付状态
 */
typedef NS_ENUM(NSInteger, YASPayResultStatus) {
    YASPaySuccess = 0,
    YASPayFailed = -1,
    YASPayCanceled = -2,
    YASPayNetworkError = -3,
};

/*!
 @brief  支付宝客户端错误码
 */
typedef NS_ENUM(NSInteger, YASAlipayResultStatus) {
    /*!
     订单支付成功
     */
    YASAlipaySuccess = 9000,
    /*!
     正在处理中
     */
    YASAlipayProcessing = 8000,
    /*!
     订单支付失败
     */
    YASAlipayFailed = 4000,
    /*!
     用户中途取消
     */
    YASAlipayCanceled = 6001,
    /*!
     网络连接出错
     */
    YASAlipayNetworkError = 6002,
};


/*
    支付方式
 */
typedef NS_ENUM(NSInteger, PayType) {
    PayTypeAlipay, // 支付宝
    PayTypeWechat, // 微信
    PayTypeWallet, // 聚给力钱包
};



extern NSString *const YASNtfPaySuccess;
extern NSString *const YASNtfPayFailure;

extern NSString *const YASPayResultKey;
extern NSString *const YASPayTypeKey;



@interface AlipayModel : BaseModel

@property (copy, nonatomic) NSString *notify_url;
@property (copy, nonatomic) NSString *out_trade_no;

// 支付宝单位为 元，微信钱包单位为 分
@property (copy, nonatomic) NSString *total_fee;

// Alipay

/*
 body = "";
 "notify_url" = "http://www.gotobee.cn/gotobeetest/index.php/App/Account/notifyurl";
 "out_trade_no" = 201510165620e4889ee1b;
 "payment_type" = 1;
 "return_url" = "http://www.gotobee.cn/gotobeetest/index.php/Home/Account/wallet";
 service = "create_direct_pay_by_user";
 "show_url" = "";
 subject = "\U94b1\U5305\U5145\U503c";
 "total_fee" = "0.01";
 */


@property (copy, nonatomic) NSString *body;
@property (copy, nonatomic) NSString *payment_type;
@property (copy, nonatomic) NSString *return_url;
@property (copy, nonatomic) NSString *service;
@property (copy, nonatomic) NSString *show_url;
@property (copy, nonatomic) NSString *subject;

// Wechat

/*
 "notify_url" = "http://www.gotobee.cn/gotobeetest/index.php/App/WeChatPay/paynotify";
 "out_trade_no" = 201510165620e4904f2e9;
 "time_expire" = 20151016200040;
 "time_start" = 20151016195040;
 title = "\U94b1\U5305\U5145\U503c";
 "total_fee" = 100;
 "trade_type" = APP;
 uid = 561bc06e9ca60;
 */

@property (copy, nonatomic) NSString *time_expire;
@property (copy, nonatomic) NSString *time_start;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *trade_type;
@property (copy, nonatomic) NSString *uid;

@end








@interface Pay : NSObject

/**
 *  提供两种支付的方法
 */
+ (void)payWithAmount:(CGFloat)amount orderId:(NSString*)orderId type:(PayType)type success:(LKObjectBlock)success failure:(QueryErrorBlock)failure;

/**
 *  中途退款的方法
 */
+ (void)processPayCallback:(id)result type:(PayType)type;

+ (Pay *)sharedInstance;

- (void)callback:(id)sender;
@end
