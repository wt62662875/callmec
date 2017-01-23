//
//  AppiontGoodsCarController.m
//  callmec
//
//  Created by sam on 16/8/11.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppiontGoodsCarController.h"
#import "BrowerController.h"
#import "SearchAddressController.h"
#import "PayOrderController.h"
#import "WaitingGoodsCarController.h"

#import "LeftIconLabel.h"
#import "LeftIconView.h"
#import "LeftInputView.h"
#import "RightTitleLabel.h"
#import "TitleTailTextView.h"
#import "TitleMultiCheckBox.h"

#import "MyTimePickerView.h"
#import "MyTimeTool.h"
#import "CMDriverManager.h"


@interface AppiontGoodsCarController ()<TargetActionDelegate,SearchViewControllerDelegate>
@property (nonatomic,strong) UIView *top_container;
@property (nonatomic,strong) UIView *goods_container;
@property (nonatomic,strong) UIView *people_container;
@property (nonatomic,strong) UIScrollView *containerView;
@property (nonatomic,strong) UIView *totalViews;

@property (nonatomic,strong) UILabel *titleView;
@property (nonatomic,strong) UIButton *buttonLeft;
@property (nonatomic,strong) UIButton *buttonRight;
@property (nonatomic,strong) LeftInputView *startTimeLabel;
@property (nonatomic,strong) LeftInputView *startLabel;
@property (nonatomic,strong) LeftInputView *endLabel;
@property (nonatomic,strong) UIButton *buttonInsurance;

@property (nonatomic,strong) TitleTailTextView * goodsNameLabel;
@property (nonatomic,strong) TitleTailTextView * goodsWeightLabel;
//@property (nonatomic,strong) TitleTailTextView * goodsSizeLabel;
@property (nonatomic,strong) TitleMultiCheckBox * goodsLLabel;  //长
@property (nonatomic,strong) TitleMultiCheckBox * goodsWLabel;  //宽
@property (nonatomic,strong) TitleMultiCheckBox * goodsHLabel;  //高

@property (nonatomic,strong) TitleTailTextView * goodsReservedLabel;//

@property (nonatomic,strong) TitleTailTextView * consigneeName;
@property (nonatomic,strong) TitleTailTextView * consigneeMobile;

@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,assign) NSInteger tripType;

@property (nonatomic,strong) CMLocation *startLocation;
@property (nonatomic,strong) CMLocation *endLocation;
@end

@implementation AppiontGoodsCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void) initView
{
    _tripType = 0;
    [self setTitle:@"发布货物信息"];
    [self.view setBackgroundColor:RGBHex(g_gray)];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self setRightButtonText:@"计价说明" withFont:[UIFont systemFontOfSize:14]];
    [self.rightButton setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    
    _containerView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 800)];
    _containerView.contentSize = CGSizeMake(kScreenSize.width, 800);
    _containerView.scrollEnabled = YES;
    
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _totalViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 750)];
    [_containerView addSubview:_totalViews];
   
    
    _top_container =[[UIView alloc] init];
    [_top_container.layer setCornerRadius:5];
    [_top_container.layer setMasksToBounds:YES];
    [_top_container setBackgroundColor:[UIColor whiteColor]];
    [_totalViews addSubview:_top_container];
    [_top_container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalViews).offset(10);
        make.left.equalTo(_totalViews).offset(10);
        make.width.equalTo(_totalViews).offset(-20);
        make.height.mas_equalTo(250);

    }];

    _goods_container =[[UIView alloc] init];
    [_goods_container.layer setCornerRadius:5];
    [_goods_container.layer setMasksToBounds:YES];
    [_goods_container setBackgroundColor:[UIColor whiteColor]];
    [_totalViews addSubview:_goods_container];
    [_goods_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_container.mas_bottom).offset(10);
        make.left.equalTo(_totalViews).offset(10);
        make.width.equalTo(_totalViews).offset(-20);
        make.height.mas_equalTo(320);
    }];
    
    _people_container =[[UIView alloc] init];
    [_people_container.layer setCornerRadius:5];
    [_people_container.layer setMasksToBounds:YES];
    [_people_container setBackgroundColor:[UIColor whiteColor]];
    [_totalViews addSubview:_people_container];
    [_people_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goods_container.mas_bottom).offset(10);
        make.left.equalTo(_totalViews).offset(10);
        make.width.equalTo(_totalViews).offset(-20);
        make.height.mas_equalTo(180);
    }];
    [self initTopView];
    [self initGoodsView];
    [self initPeopleView];
}


- (void) initTopView
{
    _titleView = [[UILabel alloc] init];
    [_titleView setText:@"请填写以下用车信息"];
    [_titleView setFont:[UIFont systemFontOfSize:15]];
    
    [_top_container addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top_container).offset(10);
        make.left.equalTo(_top_container).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:RGBHex(g_assit_gray)];
    [_top_container addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLeft setTitle:@"包车" forState:UIControlStateNormal];
    [_buttonLeft.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonLeft setImage:[UIImage imageNamed:@"nvyuan"] forState:UIControlStateNormal];
    [_buttonLeft setImage:[UIImage imageNamed:@"nanyuan"] forState:UIControlStateSelected];
    [_buttonLeft setImage:[UIImage imageNamed:@"nanyuan"] forState:UIControlStateHighlighted];
    [_buttonLeft addTarget:self action:@selector(buttonSwitchStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonLeft setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_top_container addSubview:_buttonLeft];
    [_buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(_top_container.mas_centerX).offset(4);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(150);
    }];
    
    UIView *midline = [[UIView alloc] init];
    [midline setBackgroundColor:RGBHex(g_assit_gray)];
    [_top_container addSubview:midline];
    [midline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(_top_container);
        make.width.mas_equalTo(1);
    }];
    
    _buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonRight setTitle:@"拼货" forState:UIControlStateNormal];
    [_buttonRight.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonRight setImage:[UIImage imageNamed:@"nvyuan"] forState:UIControlStateNormal];
    [_buttonRight setImage:[UIImage imageNamed:@"nanyuan"] forState:UIControlStateSelected];
    [_buttonRight setImage:[UIImage imageNamed:@"nanyuan"] forState:UIControlStateHighlighted];
    [_buttonRight addTarget:self action:@selector(buttonSwitchStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonRight setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_top_container addSubview:_buttonRight];
    [_buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(_top_container.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(150);
    }];
    if (_tripType==0) {
        [_buttonLeft setSelected:YES];
    }else{
        [_buttonRight setSelected:YES];
    }
    
    UIView *secondline = [[UIView alloc] init];
    [secondline setBackgroundColor:RGBHex(g_assit_gray)];
    [_top_container addSubview:secondline];
    [secondline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonRight.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _startTimeLabel = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_startTimeLabel setDelegate:self];
    [_startTimeLabel setPlaceHolder:@"选择发货时间"];
    [_startTimeLabel setTitleFont:[UIFont systemFontOfSize:15]];
    [_startTimeLabel setEnable:NO];
    [_top_container addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondline.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-1);
        make.height.mas_equalTo(40);
    }];
    
    UIView *threeline = [[UIView alloc] init];
    [threeline setBackgroundColor:RGBHex(g_assit_gray)];
    [_top_container addSubview:threeline];
    [threeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startTimeLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _startLabel = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_startLabel setDelegate:self];
    [_startLabel setPlaceHolder:@"设置发货地点"];
    [_startLabel setImageUrl:@"icon_fahuo"];
    [_startLabel setTitleFont:[UIFont systemFontOfSize:15]];
    [_startLabel setEnable:NO];
    
    _startLocation = [GlobalData sharedInstance].location;
    if (_startLocation) {
        [_startLabel setTitle:_startLocation.name];
    }
    [_top_container addSubview:_startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeline.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-1);
        make.height.mas_equalTo(40);
    }];
    
    UIView *fourline = [[UIView alloc] init];
    [fourline setBackgroundColor:RGBHex(g_assit_gray)];
    [_top_container addSubview:fourline];
    [fourline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _endLabel = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_endLabel setDelegate:self];
    [_endLabel setPlaceHolder:@"设置收货地点"];
    [_endLabel setImageUrl:@"icon_shouhuo"];
    [_endLabel setTitleFont:[UIFont systemFontOfSize:15]];
    [_endLabel setEnable:NO];
    [_top_container addSubview:_endLabel];
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourline.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-1);
        make.height.mas_equalTo(40);
    }];
    
    UIView *fiveline = [[UIView alloc] init];
    [fiveline setBackgroundColor:RGBHex(g_assit_gray)];
    [_top_container addSubview:fiveline];
    [fiveline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endLabel.mas_bottom);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _buttonInsurance = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonInsurance setTitle:@"购买保险" forState:UIControlStateNormal];
    [_buttonInsurance.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonInsurance setContentMode:UIViewContentModeBottomLeft];
    [_buttonInsurance setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [_buttonInsurance setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateSelected];
    [_buttonInsurance setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateHighlighted];
    [_buttonInsurance addTarget:self action:@selector(buttonSwitchStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonInsurance setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_buttonInsurance setImageEdgeInsets:UIEdgeInsetsMake(0, -180, 0, 0)];
    [_buttonInsurance setTitleEdgeInsets:UIEdgeInsetsMake(0, -155, 0, 0)];
    [_buttonInsurance setHidden:YES];
    //    [_buttonInsurance setBackgroundColor:[UIColor redColor]];
    [_top_container addSubview:_buttonInsurance];
    [_buttonInsurance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fiveline.mas_bottom);
        make.left.equalTo(_top_container).offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(260);
    }];
}

- (void) initGoodsView
{
    _goodsNameLabel = [[TitleTailTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsNameLabel setTitle:@"名称"];
    [_goodsNameLabel setPlaceHolder:@"点击输入货物名称"];
    [_goods_container addSubview:_goodsNameLabel];
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goods_container).offset(0);
        make.top.equalTo(_goods_container).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(300);
    }];
    
    UIView *oneline = [[UIView alloc] init];
    [oneline setBackgroundColor:RGBHex(g_assit_gray)];
    [_goods_container addSubview:oneline];
    [oneline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsNameLabel.mas_bottom).offset(10);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
        make.height.mas_equalTo(1);
    }];
    
    _goodsWeightLabel = [[TitleTailTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsWeightLabel setTitle:@"重量"];
    [_goodsWeightLabel setPlaceHolder:@"点击输入货物重量"];
    [_goodsWeightLabel setTail:@"千克"];
    [_goodsWeightLabel setKeyBoardType:UIKeyboardTypeDecimalPad];//UIKeyboardTypeNumbersAndPunctuation
    [_goods_container addSubview:_goodsWeightLabel];
    [_goodsWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goods_container).offset(0);
        make.top.equalTo(oneline.mas_bottom).offset(10);
        make.right.equalTo(_goods_container);
        make.height.mas_equalTo(30);
    }];
    UIView *twoline = [[UIView alloc] init];
    [twoline setBackgroundColor:RGBHex(g_assit_gray)];
    [_goods_container addSubview:twoline];
    [twoline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsWeightLabel.mas_bottom).offset(10);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
        make.height.mas_equalTo(1);
    }];
    
    _goodsLLabel =[[TitleMultiCheckBox alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsLLabel setTitle:@"长度"];
    [_goodsLLabel setCheckTitles:[[NSMutableArray alloc] initWithObjects:@"小于1米",@"1-1.5米",@"1.5-1.78米", nil ] withValue:[[NSMutableArray alloc] initWithObjects:@"1",@"1.5",@"1.78", nil ]];
    [_goods_container addSubview:_goodsLLabel];
    [_goodsLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goods_container).offset(0);
        make.top.equalTo(twoline.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.equalTo(_goods_container);
    }];
    
    
    UIView *threeline = [[UIView alloc] init];
    [threeline setBackgroundColor:RGBHex(g_assit_gray)];
    [_goods_container addSubview:threeline];
    [threeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsLLabel.mas_bottom).offset(10);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
        make.height.mas_equalTo(1);
    }];
    
    _goodsWLabel =[[TitleMultiCheckBox alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsWLabel setTitle:@"宽度"];
    [_goodsWLabel setCheckTitles:[[NSMutableArray alloc] initWithObjects:@"小于1米",@"1-1.7米", nil ] withValue:[[NSMutableArray alloc] initWithObjects:@"1",@"1.7",nil ]];
    [_goods_container addSubview:_goodsWLabel];
    [_goodsWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goods_container).offset(0);
        make.top.equalTo(threeline.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.equalTo(_goods_container);
    }];
    UIView *fourline = [[UIView alloc] init];
    [fourline setBackgroundColor:RGBHex(g_assit_gray)];
    [_goods_container addSubview:fourline];
    [fourline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsWLabel.mas_bottom).offset(10);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
        make.height.mas_equalTo(1);
    }];
    
    _goodsHLabel =[[TitleMultiCheckBox alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsHLabel setTitle:@"高度"];
    [_goodsHLabel setCheckTitles:[[NSMutableArray alloc] initWithObjects:@"小于1米",@"1-1.5米",@"1.5-1.8米", nil ] withValue:[[NSMutableArray alloc] initWithObjects:@"1",@"1.5",@"1.8", nil ]];
    [_goods_container addSubview:_goodsHLabel];
    [_goodsHLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goods_container).offset(0);
        make.top.equalTo(fourline.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.equalTo(_goods_container);
    }];
    UIView *fiveline = [[UIView alloc] init];
    [fiveline setBackgroundColor:RGBHex(g_assit_gray)];
    [_goods_container addSubview:fiveline];
    [fiveline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsHLabel.mas_bottom).offset(10);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
        make.height.mas_equalTo(1);
    }];
    
    _goodsReservedLabel = [[TitleTailTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsReservedLabel setTitle:@"备注"];
    [_goodsReservedLabel setPlaceHolder:@"点击输入货物备注信息"];
    [_goods_container addSubview:_goodsReservedLabel];
    [_goodsReservedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goods_container).offset(0);
        make.top.equalTo(fiveline.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    
    UIView *sixline = [[UIView alloc] init];
    [sixline setBackgroundColor:RGBHex(g_assit_gray)];
    [_goods_container addSubview:sixline];
    [sixline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsReservedLabel.mas_bottom).offset(10);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
        make.height.mas_equalTo(1);
    }];
}

- (void) initPeopleView
{
    _consigneeName = [[TitleTailTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_consigneeName setTitle:@"姓名"];
    [_consigneeName setPlaceHolder:@"点击输入收货人姓名"];
    [_people_container addSubview:_consigneeName];
    [_consigneeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_people_container).offset(0);
        make.top.equalTo(_people_container).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    
    UIView *oneline = [[UIView alloc] init];
    [oneline setBackgroundColor:RGBHex(g_assit_gray)];
    [_people_container addSubview:oneline];
    [oneline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_consigneeName.mas_bottom).offset(10);
        make.left.equalTo(_people_container);
        make.right.equalTo(_people_container);
        make.height.mas_equalTo(1);
    }];
    
    _consigneeMobile = [[TitleTailTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_consigneeMobile setTitle:@"手机"];
    [_consigneeMobile setPlaceHolder:@"点击输入手机号码"];
    [_consigneeMobile setKeyBoardType:UIKeyboardTypeNumberPad];
    [_people_container addSubview:_consigneeMobile];
    [_consigneeMobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_people_container).offset(0);
        make.top.equalTo(oneline.mas_bottom).offset(10);
        make.right.equalTo(_people_container);
        make.height.mas_equalTo(30);
    }];
    
    UIView *twoline = [[UIView alloc] init];
    [twoline setBackgroundColor:RGBHex(g_assit_gray)];
    [_people_container addSubview:twoline];
    [twoline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_consigneeMobile.mas_bottom).offset(10);
        make.left.equalTo(_people_container);
        make.right.equalTo(_people_container);
        make.height.mas_equalTo(1);
    }];
    
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setTitle:@"确定" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateHighlighted];
    [_buttonSubmit setBackgroundColor:RGBHex(g_blue)];
//    [_buttonSubmit.layer setCornerRadius:5];
//    [_buttonSubmit.layer setMasksToBounds:YES];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_people_container addSubview:_buttonSubmit];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_people_container);
//        make.centerX.equalTo(_people_container);
//        make.width.mas_equalTo(200);
        make.left.equalTo(self.people_container);
        make.right.equalTo(self.people_container);
        make.height.mas_equalTo(50);
    }];
}


- (void) buttonSwitchStatus:(UIButton*)button
{
    if (_buttonInsurance == button) {
        button.selected = !button.selected;
    }else{
        if (!button.selected) {
            button.selected = YES;
            if (button == _buttonLeft) {
                _buttonRight.selected = NO;
                _tripType = 0;
            }else{
                _buttonLeft.selected = NO;
                _tripType = 1;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];//
    _containerView.contentSize = CGSizeMake(self.view.frame.size.width,800);
    _totalViews.frame = CGRectMake(0, 0, _containerView.contentSize.width, _containerView.contentSize.height);
}

//- (void)buttonSwitchStatus:(UIButton*)sender
//{
//    sender.selected = !sender.selected;
//}

- (void)buttonTarget:(id)sender
{
    if (sender == self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender == self.rightButton)
    {
        BrowerController *webview = [[BrowerController alloc] init];
        webview.urlStr = [CommonUtility getArticalUrl:@"4" type:@"4"];
        webview.titleStr = @"计价说明";
        [self.navigationController pushViewController:webview animated:YES];
    }else if([sender isKindOfClass:[LeftInputView class]])
    {
        if (sender ==_startTimeLabel) {
            [MyTimePickerView showTimePickerViewDeadLine:@"20160601" withTitle:@"请选择发货时间" CompleteBlock:^(NSDictionary *infoDic) {
                
                NSString *_startTime = infoDic[@"time_value"];
                NSString *time_fromat = [MyTimeTool formatDateTime:_startTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
                [_startTimeLabel setTitle:time_fromat];
                NSLog(@"infoDic:%@",time_fromat);
            }];
        }else if (sender ==_startLabel) {
            SearchAddressController *search = [[SearchAddressController alloc] init];
            search.delegate = self;
            search.targetId = 1;
            [self.navigationController pushViewController:search animated:YES];
        }else if (sender ==_endLabel) {
            SearchAddressController *search = [[SearchAddressController alloc] init];
            search.targetId = 2;
            search.delegate = self;
            [self.navigationController pushViewController:search animated:YES];
        }
    }else if(sender == self.buttonSubmit){
    
        NSMutableDictionary *params =[NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"%@",[GlobalData sharedInstance].user.userInfo.ids] forKey:@"memberId"];
        NSMutableDictionary *order =[NSMutableDictionary dictionary];
        
        [order setObject:@"3" forKey:@"type"];
        [order setObject:@"true" forKey:@"appoint"];
        [order setObject:@"6" forKey:@"carType"];
        if (!_startTimeLabel.title) {
            [MBProgressHUD showAndHideWithMessage:@"请选择时间" forHUD:nil];
            return;
        }
        [order setObject:_startTimeLabel.title forKey:@"appointDate"];
        
        if (!_startLocation.name) {
            [MBProgressHUD showAndHideWithMessage:@"请选择装货地址" forHUD:nil];
            return;
        }
        if (!_endLocation.name) {
            [MBProgressHUD showAndHideWithMessage:@"请选择卸货地址" forHUD:nil];
            return;
        }
        [order setObject:[NSString stringWithFormat:@"%@",_startLocation.name] forKey:@"sLocation"];
        [order setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.longitude] forKey:@"sLongitude"];
        [order setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.latitude] forKey:@"sLatitude"];
        
        [order setObject:[NSString stringWithFormat:@"%@",_endLocation.name] forKey:@"eLocation"];
        [order setObject:[NSString stringWithFormat:@"%f",_endLocation.coordinate.longitude] forKey:@"eLongitude"];
        [order setObject:[NSString stringWithFormat:@"%f",_endLocation.coordinate.latitude] forKey:@"eLatitude"];
        
       
        
        if (!_goodsNameLabel.content) {
            [MBProgressHUD showAndHideWithMessage:@"请填写货物名字！" forHUD:nil];
            return;
        }
        if (!_goodsWeightLabel.content) {
            [MBProgressHUD showAndHideWithMessage:@"请填货物重量！" forHUD:nil];
            return;
        }
        if (![CommonUtility validateNumber:_goodsWeightLabel.content]) {
            [MBProgressHUD showAndHideWithMessage:@"非法重量！请输入数字" forHUD:nil];
            return;
        }
        
//        if (_goodsSizeLabel.content &&![CommonUtility validateSizeForm:_goodsSizeLabel.content]) {
//            [MBProgressHUD showAndHideWithMessage:@"非法尺寸！请参考下：50x50x50" forHUD:nil];
//            return;
//        }
        [order setObject:_goodsNameLabel.content forKey:@"goodsName"];
        [order setObject:_goodsReservedLabel.content?_goodsReservedLabel.content:@"" forKey:@"goodsInfo"];
        [order setObject:_goodsWeightLabel.content forKey:@"goodsWeight"];
        [order setObject:_buttonLeft.selected?@"true":@"false" forKey:@"chartered"];
        if (_goodsLLabel.value&&_goodsWLabel.value&&_goodsHLabel.value) {
            [order setObject:[NSArray arrayWithObjects:_goodsLLabel.value,_goodsWLabel.value,_goodsHLabel.value, nil] forKey:@"goodsScale"];
        }else{
            [MBProgressHUD showAndHideWithMessage:@"请填写收货人姓名！" forHUD:nil];
        }
        if (!_consigneeName.content) {
            [MBProgressHUD showAndHideWithMessage:@"请填写收货人姓名！" forHUD:nil];
            return;
        }
        if (!_consigneeMobile.content ||![CommonUtility validatePhoneNumber:_consigneeMobile.content]) {
            [MBProgressHUD showAndHideWithMessage:@"非法的收货人手机！" forHUD:nil];
            return;
        }
        if (_buttonInsurance.isSelected) {
            [order setObject:@"true" forKey:@"insurance"];
        }
        [order setObject:_consigneeName.content forKey:@"receiver"];
        [order setObject:_consigneeMobile.content forKey:@"receiverPhone"];
        
        [params setObject:[order lk_JSONString] forKey:@"order"];
        NSLog(@"post:%@",[params lk_JSONString]);
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在提交信息..." inView:nil];
        [hud show:YES];
        [CMDriverManager sendCallCarRequest:params success:^(NSDictionary *resultDictionary) {
            
            [hud hide:YES];
            NSString *orderId = resultDictionary[@"message"];
            WaitingGoodsCarController *pay = [[WaitingGoodsCarController alloc] init];
            pay.orderId = orderId;
            [self.navigationController pushViewController:pay animated:YES];
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            [hud hide:YES];
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        }];
    }
}

- (void) searchViewController:(SearchAddressController *)searchViewController didSelectLocation:(CMLocation *)location
{
    if (searchViewController.targetId==1) {
        _startLocation = location;
        [_startLabel setTitle:_startLocation.name];
    }else{
        _endLocation = location;
        [_endLabel setTitle:_endLocation.name];
    };
}

@end
