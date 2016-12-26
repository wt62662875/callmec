//
//  SwipeBarCodeViewController.h
//  YouLeXian
//
//  Created by feiwei on 15/12/17.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "BaseController.h"
#import "ZBarSDK.h"

@interface SwipeBarCodeViewController : BaseController<ZBarReaderViewDelegate>

@property (nonatomic, strong) ZBarReaderView *readerView;
@property (nonatomic, strong) ZBarCameraSimulator *cameraSim;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *button;

@end
