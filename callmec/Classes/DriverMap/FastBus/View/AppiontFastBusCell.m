//
//  AppiontFastBusCell.m
//  callmec
//
//  Created by sam on 16/9/3.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppiontFastBusCell.h"
#import "LeftInputView.h"
#import "AppiontBusModel.h"
@interface AppiontFastBusCell()<TargetActionDelegate>

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) LeftInputView *startLabel;
@property (nonatomic,strong) LeftInputView *endLabel;
@property (nonatomic,strong) LeftInputView *peopleLabel;
@property (nonatomic,strong) LeftInputView *feedbackLabel;
@end

@implementation AppiontFastBusCell

- (void) initView
{
    [self setBackgroundColor:[UIColor clearColor]];
    _containerView = [[UIView alloc] init];
    [_containerView.layer setCornerRadius:5];
    [_containerView.layer setMasksToBounds:YES];
    [_containerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:@"填写用户信息"];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_titleLabel setTextColor:RGBHex(g_black)];
    [_containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIView *lineone = [[UIView alloc] init];
    [lineone setBackgroundColor:RGBHex(g_gray)];
    [_containerView addSubview:lineone];
    [lineone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _startLabel =[[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_startLabel setTitleFont:[UIFont systemFontOfSize:14]];
    [_startLabel setPlaceHolder:@"请选择开始地点"];
    [_startLabel setEnable:NO];
    [_startLabel setDelegate:_delegate];
    [_startLabel setImageUrl:@"icon_qidian_dot_3"];
    [_startLabel setTag:0];
    [_containerView addSubview:_startLabel];
    [_startLabel setHidden:YES];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineone.mas_bottom).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    UIView *linetwo = [[UIView alloc] init];
    [linetwo setBackgroundColor:RGBHex(g_gray)];
    [_containerView addSubview:linetwo];
    [linetwo setHidden:YES];
    [linetwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startLabel.mas_bottom).offset(5);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _endLabel =[[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_endLabel setTitleFont:[UIFont systemFontOfSize:14]];
    [_endLabel setPlaceHolder:@"请选择下车地点"];
    [_endLabel setEnable:NO];
    [_endLabel setDelegate:_delegate];
    [_endLabel setImageUrl:@"cuntianwenquan"];
    [_endLabel setTag:1];
    [_containerView addSubview:_endLabel];
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(linetwo.mas_bottom).offset(10);
        make.top.equalTo(lineone.mas_bottom).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    UIView *linethree = [[UIView alloc] init];
    [linethree setBackgroundColor:RGBHex(g_gray)];
    [_containerView addSubview:linethree];
    [linethree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endLabel.mas_bottom).offset(5);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _peopleLabel =[[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_peopleLabel setTitleFont:[UIFont systemFontOfSize:14]];
    [_peopleLabel setPlaceHolder:@"请输入乘车人数"];
    [_peopleLabel setImageUrl:@"chengcherenshu"];
    [_peopleLabel setEnable:NO];
    [_peopleLabel setTag:2];
    [_peopleLabel setDelegate:_delegate];
    [_containerView addSubview:_peopleLabel];
    [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linethree.mas_bottom).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    UIView *linefour = [[UIView alloc] init];
    [linefour setBackgroundColor:RGBHex(g_gray)];
    [_containerView addSubview:linefour];
    [linefour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_peopleLabel.mas_bottom).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    _feedbackLabel =[[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_feedbackLabel setTitleFont:[UIFont systemFontOfSize:14]];
    [_feedbackLabel setPlaceHolder:@"请备注说明信息"];
    [_feedbackLabel setTag:3];
    [_feedbackLabel setImageUrl:@"shurubeizhu"];
    [_feedbackLabel setDelegate:self];
    [_containerView addSubview:_feedbackLabel];
    [_feedbackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linefour.mas_bottom).offset(10);
        make.left.equalTo(_containerView).offset(10);
        make.right.equalTo(_containerView).offset(-10);
        make.height.mas_equalTo(35);
    }];
}

- (void) setModel:(BaseModel *)model
{
    [super setModel:model];
    if (self.model) {
        CarOrderModel *md = ((CarOrderModel*)self.model);
        [_startLabel setTitle:md.slocation];
        [_endLabel setTitle:md.elocation];
        [_peopleLabel setTitle:md.orderPerson];
    }

}

- (void) setDelegate:(id<TargetActionDelegate>)delegate
{
    _delegate = delegate;
    [_peopleLabel setDelegate:_delegate];
    [_startLabel setDelegate:_delegate];
    [_endLabel setDelegate:_delegate];
}

- (void) valueChanged:(UIView *)view
{
    ((CarOrderModel*)self.model).descriptions =_feedbackLabel.title;
}

@end
