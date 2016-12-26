//
//  SwipeBarCodeViewController.m
//  YouLeXian
//
//  Created by feiwei on 15/12/17.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "SwipeBarCodeViewController.h"
#import "ScanCodeBusController.h"

#define SCANVIEW_EdgeTop 40.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 0.5 //深色透明度
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SwipeBarCodeViewController ()

{
    
    UIView *_QrCodeline;
    UIView *_QrCodeline1;
    
    NSTimer *_timer;
    
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
    NSString *_resultStr;
}

@end

@implementation SwipeBarCodeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        _readerView.torchMode = 0;
    }
    [self stopTimer];
    _readerView.readerDelegate =nil;
    [_readerView stop];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setTitle:@"扫一扫"];
    
//    [self showBackButton];
    //初始化扫描界面
    [self setScanView];
    _readerView= [[ZBarReaderView alloc] init]; // 必须如此初始化
    _readerView.frame =CGRectMake(0,64, VIEW_WIDTH, VIEW_HEIGHT - 64);
    // 扫码成功后的出现的一个框框
    _readerView.tracksSymbols = NO;
    _readerView.readerDelegate = self;
    [_readerView addSubview:_scanView];
    
    //关闭闪光灯
    _readerView.torchMode = 0;
    [self.view addSubview:_readerView];
    
    //扫描区域
    [_readerView start];
    [self createTimer];
    
}

#pragma mark -- ZBarReaderViewDelegate


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
    const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    _resultStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    if ([_resultStr canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        _resultStr = [NSString stringWithCString:[_resultStr cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        if (!_resultStr) {
            _resultStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
        }
    }
    ScanCodeBusController * bus = [[ScanCodeBusController alloc] init];
    bus.carNo = _resultStr;
    
    if (_resultStr) {
        [MBProgressHUD showAndHideWithMessage:@"加载中..." forHUD:nil onCompletion:^{
            [self.navigationController pushViewController:bus animated:YES];
        }];
    }else{
        [MBProgressHUD showAndHideWithMessage:@"解析失败" forHUD:nil];
    
    }
    
    
    
//    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backView];
//    
//    
//    UILabel * tipsLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 40)];
//    tipsLbl.textAlignment = NSTextAlignmentCenter;
//    [backView addSubview:tipsLbl];
//    
//    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 60)];
//    tf.textAlignment = NSTextAlignmentCenter;
//    tf.text = resultStr;
//    tf.font = [UIFont systemFontOfSize:13];
//    tf.tag = 100;
//    tf.userInteractionEnabled = NO;
//    tf.backgroundColor = [UIColor lightGrayColor];
//    [backView addSubview:tf];
//
//    
//    UIButton *copyBtn =[[UIButton alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(tf.frame)+30,self.view.frame.size.width-200,40)];
//    [copyBtn setTitle:@"拷贝" forState:UIControlStateNormal];
//    //copyBtn.backgroundColor = ZXCGlobalYellowColor;
//    [copyBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    copyBtn.layer.cornerRadius = copyBtn.frame.size.height * 0.5f;
//    [backView addSubview:copyBtn];
//    
//    if (resultStr && [resultStr hasPrefix:@"http"]) {
//        tipsLbl.text = @"链接";
//        return;
//    }else{
//        tipsLbl.text = @"配送单号";
//        return;
//    }
//    return;
}


- (void)copyBtnClick:(UIButton *)copyBtn
{
    UITextField * tf = (UITextField *)[self.view viewWithTag:100];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = tf.text;
    if (pasteboard.string) {
        [MBProgressHUD showTextHUBWithText:@"拷贝成功" inView:self.view];
    }

}



//二维码的扫描区域
- (void)setScanView
{
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, VIEW_WIDTH,VIEW_HEIGHT - 64)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    //最上部view
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, VIEW_WIDTH,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:leftView];
    
    
    // 中间扫描区
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft)];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView.layer.borderColor=RGBHexa(@"#000000",0.2).CGColor;
    scanCropView.layer.borderWidth=2.0;
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    
    UIImageView *scan_1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, 15,15)];
    scan_1.image = [UIImage imageNamed:@"scan_1"];
    [_scanView addSubview:scan_1];
    
    
    UIImageView *scan_2=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft+scanCropView.frame.size.width-15,SCANVIEW_EdgeTop,15,15)];
    scan_2.image = [UIImage imageNamed:@"scan_2"];
    [_scanView addSubview:scan_2];
    
    
    UIImageView *scan_3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,
                                                                        SCANVIEW_EdgeTop+scanCropView.frame.size.height-15,
                                                                        15,
                                                                        15)];
    scan_3.image = [UIImage imageNamed:@"scan_3"];
    [_scanView addSubview:scan_3];

    UIImageView *scan_4 = [[UIImageView alloc]initWithFrame:CGRectMake(SCANVIEW_EdgeLeft+scanCropView.frame.size.width-15,SCANVIEW_EdgeTop+scanCropView.frame.size.height-15, 15,15)];
    scan_4.image = [UIImage imageNamed:@"scan_4"];
    [_scanView addSubview:scan_4];

    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH - SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop, VIEW_WIDTH, VIEW_HEIGHT - (VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop) - 64)];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,5, VIEW_WIDTH,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码/条形码对准方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-100.0,VIEW_WIDTH, 100.0)];
    darkView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:DARKCOLOR_ALPHA];
    [downView addSubview:darkView];
    
    //用于开关灯操作的button
    UIButton *openButton = [[UIButton alloc] initWithFrame:CGRectMake(10,20, VIEW_WIDTH-20, 40.0)];
    [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    openButton.titleLabel.font=[UIFont systemFontOfSize:22.0];
    [openButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [darkView addSubview:openButton];
    
    //画中间的基准线
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 * SCANVIEW_EdgeLeft, 1.5)];
    _QrCodeline.backgroundColor = [UIColor clearColor];
    [_scanView addSubview:_QrCodeline];
    
    //画中间的基准线
    _QrCodeline1 = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 * SCANVIEW_EdgeLeft, 1.5)];
    _QrCodeline1.backgroundColor = [UIColor greenColor];
    [_scanView addSubview:_QrCodeline1];
    
    // 先让第二根线运动一次,避免定时器执行的时差,让用户感到启动App后,横线就开始移动
    [UIView animateWithDuration:2.2 animations:^{
        
        _QrCodeline1.frame = CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft, 1.5);
    }];
    
    
}

// 闪关灯的开与关
- (void)openLight:(UIButton *)button
{
    if (_readerView.torchMode == 0) {
        _readerView.torchMode = 1;
        [button setTitle:@"关闭闪光灯" forState:UIControlStateNormal];
    } else {
        _readerView.torchMode = 0;
        [button setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    }
    
}

- (void)createTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

// 当地一根线到达底部时,第二根线开始下落运动,此时第一根线已经在顶部,当第一根线接着下落时,第二根线到达顶部.依次循环
- (void)moveUpAndDownLine
{
    CGFloat Y = _QrCodeline.frame.origin.y;
    if (Y == SCANVIEW_EdgeTop) {
        [UIView animateWithDuration:2.2 animations:^{
            
            _QrCodeline.frame = CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft, 1.5);
            _QrCodeline.backgroundColor = [UIColor greenColor];
        }];
        _QrCodeline1.frame = CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft, 1.5);
        _QrCodeline1.backgroundColor = [UIColor clearColor];
    }
    else if (Y == VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2) {
        _QrCodeline.frame = CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft, 1.5);
        _QrCodeline.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:2.2 animations:^{
            
            _QrCodeline1.frame = CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2, VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft, 1.5);
            _QrCodeline1.backgroundColor = [UIColor greenColor];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    _readerView = nil;
}

@end
