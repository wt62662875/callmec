//
//  TitleTailTextView.m
//  callmec
//
//  Created by sam on 16/8/11.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "TitleTailTextView.h"
@interface TitleTailTextView()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *inputText;
@property (nonatomic,strong) UILabel *tailLabel;

@end

@implementation TitleTailTextView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView
{
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
    
    _inputText =[[UITextField alloc] init];
    [_inputText addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_inputText setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_inputText];
    [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
    }];

    _tailLabel = [[UILabel alloc] init];
    [_tailLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_tailLabel];
    [_tailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:_title];
}

- (void) setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [_titleLabel setFont:_titleFont];
}

- (void) setContent:(NSString *)content
{
    _content = content;
    [_inputText setText:_content];
//    _inputText.keyboardType
}

- (void) setContentFont:(UIFont *)contentFont
{
    _contentFont = contentFont;
    [_inputText setFont:_contentFont];
}

- (void) setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    [_inputText setPlaceholder:_placeHolder];
}

- (void) setTail:(NSString *)tail
{
    _tail = tail;
    [_tailLabel setText:_tail];
}

- (void) valueChanged:(UITextField*)field
{
    if (![_content isEqualToString:field.text]) {
       _content = field.text;
    }
}

- (void) setKeyBoardType:(UIKeyboardType)keyBoardType
{
    _keyBoardType = keyBoardType;
    [_inputText setKeyboardType:_keyBoardType];
}
@end
