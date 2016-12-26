//
//  BrowerController.h
//  callmec
//
//  Created by sam on 15/11/26.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "BrowerController.h"

#define kWebBtnWidth 25
#define kWebBtnHeight 25
#define kFootBarHeight 44

#define kCustomProtocolScheme @"wvjbscheme"
#define kQueueHasMessage @"__WVJB_QUEUE_MESSAGE__"

typedef  NS_ENUM(NSInteger, ASPWebAction){
    ASPWebActionPlayProgram = 0
    
};

@interface BrowerController ()
{
    
   AppDelegate *_delegate;
 
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIButton *goForwardBtn;
@property (nonatomic, strong) UIButton *backOffBtn;
@property (strong, nonatomic) NSString *messageString;

@end

@implementation BrowerController

- (NSURLRequestCachePolicy)requestCachePolicy
{
    if (!_requestCachePolicy) {
        _requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _requestCachePolicy;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]
                    initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.scalesPageToFit = YES; //支持页面自动缩放
        _webView.opaque = NO;
    }
    return _webView;
}


- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)];
        _indicatorView.center = CGPointMake(self.webView.frame.size.width / 2, self.webView.frame.size.height / 2);
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

- (UIButton *)goForwardBtn
{
    if (!_goForwardBtn) {
        _goForwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, kWebBtnWidth, kWebBtnHeight)];
        [_goForwardBtn setImage:[UIImage imageNamed:@"webview_go"] forState:UIControlStateNormal];
        [_goForwardBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        _goForwardBtn.tag = 101;
    }
    return _goForwardBtn;
}

- (UIButton *)backOffBtn
{
    if (!_backOffBtn) {
        _backOffBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, kWebBtnWidth, kWebBtnHeight)];
        [_backOffBtn setImage:[UIImage imageNamed:@"webview_back"] forState:UIControlStateNormal];
        [_backOffBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        _backOffBtn.tag = 102;
        
    }
    return _backOffBtn;
}

- (void)addFootBar
{
    UIImageView *footBarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webview_bottom"]];
    footBarView.frame = CGRectMake(0, kScreenSize.height - kFootBarHeight, kScreenSize.width, kFootBarHeight);
    [self.view addSubview:footBarView];
    footBarView.userInteractionEnabled = YES;
    [footBarView addSubview:self.backOffBtn];
    [footBarView addSubview:self.goForwardBtn];
    UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - kWebBtnWidth - 20, 8, kWebBtnWidth, kWebBtnHeight)];
    [refreshBtn setImage:[UIImage imageNamed:@"webview_fresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    refreshBtn.tag = 103;
    
    [footBarView addSubview:refreshBtn];
}


#pragma mark - Life Cycle

- (void)loadView
{
    NSDictionary *dictionary = @{@"UserAgent": @"callme/1.1"};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [super loadView];
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.titleStr;
    [self addFootBar];
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.view addSubview:self.indicatorView];
    [self loadUrl];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}


- (void)doAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) { //前进
        self.backOffBtn.enabled = YES;
        [self.webView goForward];
        
    } else if (btn.tag == 102) { //后退
        self.goForwardBtn.enabled = YES;
        [self.webView goBack];
        
    } else if (btn.tag == 103) { //刷新
        
        [self.webView reload];
    }
}

- (void)loadUrl
{

    if ([self.urlStr length] > 0) {
        if ([self.urlStr rangeOfString:@"http"].location == NSNotFound) {
            self.urlStr = [NSString stringWithFormat:@"http://%@", self.urlStr];
        }
        NSString *urlString = (NSString
                     *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self.urlStr, nil, nil, kCFStringEncodingUTF8));
        NSLog(@"url %@", urlString);

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:urlString];
            [self.webView loadRequest:[NSURLRequest requestWithURL:url
                                                       cachePolicy:self.requestCachePolicy
                                                   timeoutInterval:10]];

        });
    }
}



#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finshLoad");
    [self.indicatorView stopAnimating];
    self.backOffBtn.enabled = [self.webView canGoBack];
    self.goForwardBtn.enabled = [self.webView canGoForward];
    
    if (![[self.webView stringByEvaluatingJavaScriptFromString:@"typeof WebViewJavascriptBridge == 'object'"]
          isEqualToString:@"true"]) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *filePath = [bundle pathForResource:@"WebViewJavascriptBridge.js.txt" ofType:nil];
        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView stringByEvaluatingJavaScriptFromString:js];
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   // NSLog(@"error_code: %ld, error_message: %@", error.code, error.description);
    [self.indicatorView stopAnimating];
    
}


- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;
{
    NSString *urlStr = [[request URL] absoluteString];
    NSURL *url = [request URL];
    NSLog(@"Did start loading: %@", urlStr);
    if ([[url scheme] isEqualToString:kCustomProtocolScheme]) {
        if ([[url host] isEqualToString:kQueueHasMessage]) {
            [self flushMessageQueue:[webView stringByEvaluatingJavaScriptFromString:@"migufm.fetchQueue();"]];
        } else {
            NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@://%@",
                  kCustomProtocolScheme, [url path]);
        }
        return NO;
    }
    return YES;
}

#pragma mark -WEB JS

- (void)CallBack:(NSString *)javascriptCommand
{
    
    if ([[NSThread currentThread] isMainThread]) {
        [self.webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
    } else {
        __strong UIWebView *strongWebView = self.webView;
        dispatch_sync(dispatch_get_main_queue(),
                      ^{ [strongWebView stringByEvaluatingJavaScriptFromString:javascriptCommand]; });
    }
}

- (NSString *)_serializeMessage:(id)message
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:0 error:nil]
                                 encoding:NSUTF8StringEncoding];
}

- (NSArray *)_deserializeMessageJSON:(NSString *)messageJSON
{
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}

- (void)_log:(NSString *)action json:(id)json
{
    if (![json isKindOfClass:[NSString class]]) {
        json = [self _serializeMessage:json];
    }
    if ([json length] > 500) {
        NSLog(@"WVJB %@: %@ [...]", action, [json substringToIndex:500]);
    } else {
        NSLog(@"WVJB %@: %@", action, json);
    }
}

- (void)flushMessageQueue:(NSString *)messageQueueString
{
    /* NSString *messageQueueString = [super.webView stringByEvaluatingJavaScriptFromString:@"contact.fetchQueue();"];
     */
    id messages = [self _deserializeMessageJSON:messageQueueString];
    if (![messages isKindOfClass:[NSArray class]]) {
        NSLog(@"WebViewJavascriptBridge: WARNING: Invalid %@ received: %@", [messages class], messages);
        return;
    }
    
    for (NSDictionary *message in messages) {
        if (![message isKindOfClass:[NSDictionary class]]) {
            NSLog(@"WebViewJavascriptBridge: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        
        [self _log:@"RCVD" json:message];
        
        @try {
            NSString *action = message[@"action"];
            NSInteger iAct = [action integerValue];
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[message[@"data"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            switch (iAct) {
                case ASPWebActionPlayProgram:
                    [self playProgram:dataDic];
                    break;
                default:break;
            }

        }
        @catch (NSException *exception)
        {
            NSLog(@"WebViewJavascriptBridge: WARNING: objc handler threw. %@ %@", message, exception);
        }
    }
}

- (void)playProgram:(NSDictionary *)data
{
    /*

    BaseEntityModel *program = [[BaseEntityModel alloc] init];
    program.mediatype = data[@"mediatype"];
    program.bdes = data[@"playname"];
    program.playname = data[@"playname"];
    program.imgurl = data[@"cover"];
    program.cmsId = data[@"cmsId"];
    program.programId = data[@"programId"];    
    [_delegate.playerVC showWithModal:program]; // show 应该只需要传programId、cmsId 通过这两个获取播放地址播放（单利）
     */

}


- (void) buttonTarget:(id)sender
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [super buttonTarget:sender];
    }
}




@end
