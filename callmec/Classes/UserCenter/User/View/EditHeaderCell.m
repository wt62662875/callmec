//
//  EditHeaderCell.m
//  callmec
//
//  Created by sam on 16/7/9.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "EditHeaderCell.h"
#import "BaseCellModel.h"

@interface EditHeaderCell()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIImageView *editView;
@end

@implementation EditHeaderCell

- (void) initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"touxiangbeij"]];
    [backImage setFrame:self.frame];
    [self addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self setBackgroundColor:RGBHex(g_header_c)];
    _iconView =[[UIImageView alloc] init];
    [_iconView setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:@"icon_user"];
    [_iconView setImage:image];
    [_iconView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTargets:)];
    [_iconView addGestureRecognizer:gesture];
   
    [self addSubview:_iconView ];//icon_user
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.height.width.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    
    _editView =[[UIImageView alloc] init];
    [_editView setImage:[UIImage imageNamed:@"icon_edit"]];
    [self addSubview:_editView ];
    [_editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(-25);
        make.bottom.equalTo(_iconView);
    }];
}

- (void) setImageData:(UIImage *)imageData
{
    if (imageData) {
        [_iconView.layer setCornerRadius:_iconView.frame.size.height/2];
        [_iconView.layer setMasksToBounds:YES];
        [_iconView setClipsToBounds:YES];
        
        _imageData = imageData;
        [_iconView setImage:_imageData];
    }
}

- (void) setModel:(BaseModel *)model
{
    [super setModel:model];
    BaseCellModel *md = (BaseCellModel*)model;
    if (md.value && [md.value hasPrefix:@"http://"]) {
        [_iconView sd_setCircleImageWithURL:md.value placeholderImage:[UIImage imageNamed:@"icon_user"]];
    }
}
- (void) setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
//    [_iconView sd_setCircleImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"icon_user"]];
}

- (void) buttonTargets:(UITapGestureRecognizer*)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonTarget:)])
    {
        [self.delegate buttonTarget:gesture.view];
    }
}
@end
