//
//  ChooseRouteController.m
//  callmec
//
//  Created by sam on 16/7/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "ChooseRouteController.h"
#import "AppiontRouteModel.h"
@interface ChooseRouteController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *inputContainer;
@property (nonatomic,strong) UITextField *inputField;
@property (nonatomic,strong) UITextField *endField;
@property (nonatomic,strong) UIButton *buttonSearch;
@property (nonatomic,strong) UIButton *switchButton;
@property (nonatomic,strong) NSString *keyWords;
@property (nonatomic,strong) NSString *endKeyWords;
@end

@implementation ChooseRouteController
{
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    _dataArray =[NSMutableArray array];
    
    [self initView];
    
//    [self initData];
}

-(void) initView
{
    [self setTitle:@"选择快车路线"];
    
    _inputContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_inputContainer];
    [_inputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_inputField setPlaceholder:@"起始点"];
//    [_inputField.layer setBorderWidth:1];
//    [_inputField.layer setBorderColor:RGBHex(g_assit_gray).CGColor];
//    [_inputField.layer setCornerRadius:5];
//    [_inputField.layer setMasksToBounds:YES];
    _inputField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_inputField setFont:[UIFont systemFontOfSize:14]];
    [_inputContainer addSubview:_inputField];
    UIView *viewleft =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    [_inputField setLeftView:viewleft];
    [_inputField setLeftViewMode:UITextFieldViewModeAlways];
    
    
    _endField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_endField setPlaceholder:@"目的地"];
//    [_endField.layer setBorderWidth:1];
//    [_endField.layer setBorderColor:RGBHex(g_assit_gray).CGColor];
//    [_endField.layer setCornerRadius:5];
//    [_endField.layer setMasksToBounds:YES];
    _endField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_endField setFont:[UIFont systemFontOfSize:14]];
    [_inputContainer addSubview:_endField];
    UIView *endleft =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    [_endField setLeftView:endleft];
    [_endField setLeftViewMode:UITextFieldViewModeAlways];
    
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchButton setImage:[UIImage imageNamed:@"daoda"] forState:UIControlStateNormal];
    [_switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputContainer addSubview:_switchButton];
    
    _buttonSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [_buttonSearch.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_buttonSearch.layer setCornerRadius:5];
    [_buttonSearch setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    [_buttonSearch setTitleColor:RGBHex(g_blue) forState:UIControlStateSelected];
//    [_buttonSearch setTitleColor:RGBHex(g_assit_gray) forState:UIControlStateHighlighted];
    [_buttonSearch.layer setMasksToBounds:YES];
    [_buttonSearch.layer setBorderColor:RGBHex(g_blue).CGColor];
    [_buttonSearch.layer setBorderWidth:1];
    [_buttonSearch addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_inputContainer addSubview:_buttonSearch];
//    [_buttonSearch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_inputContainer.mas_centerY);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(60);
//        make.right.equalTo(_inputContainer).offset(-20);
//    }];
//    [UIFont systemFontOfSize:(CGFloat)];
//    [self setRightButtonText:@"搜索" withFont:[UIFont systemFontOfSize:14]];
//    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
//    [self.rightButton addTarget:self action:@selector(buttonSearchE:) forControlEvents:UIControlEventTouchUpInside];
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputContainer.mas_centerY);
        make.left.equalTo(_inputContainer).offset(60);
        make.right.equalTo(_inputContainer.mas_centerX).offset(-20);
        make.height.mas_equalTo(30);
    }];
    [_endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputContainer.mas_centerY);
        make.left.equalTo(_inputContainer.mas_centerX).offset(20);
        make.right.equalTo(_inputContainer).offset(-60);
        make.height.mas_equalTo(30);
    }];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputContainer.mas_centerY);
        make.centerX.equalTo(_inputContainer.mas_centerX);

    }];
    [_buttonSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputContainer.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
        make.right.equalTo(_inputContainer).offset(-10);
    }];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [_mTableView.mj_header beginRefreshing];
    
    _mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self initMoreData];
    }];
    [self.view addSubview:_mTableView];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputContainer.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) initData
{
    page = 1;
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }else{
        _dataArray =[NSMutableArray array];
    }
    [AppiontRouteModel fetchAppiontRouteWithPage:page withKeyWords:_keyWords withEnd:_endKeyWords Success:^(NSArray *result, int pageCount, int recordCount) {
        for (NSDictionary *dict in result) {
            AppiontRouteModel *model = [[AppiontRouteModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        [_mTableView.mj_header endRefreshing];
        [_mTableView reloadData];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [_mTableView.mj_header endRefreshing];
    }];
}

- (void) initMoreData
{
    page++;
   
    [AppiontRouteModel fetchAppiontRouteWithPage:page withKeyWords:_keyWords withEnd:_endKeyWords Success:^(NSArray *result, int pageCount, int recordCount) {
        for (NSDictionary *dict in result) {
            AppiontRouteModel *model = [[AppiontRouteModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        [_mTableView.mj_footer endRefreshing];
        [_mTableView reloadData];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [_mTableView.mj_footer endRefreshing];
    }];
}

#pragma  mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cellids";;
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    AppiontRouteModel *model = _dataArray[indexPath.section];
    UIView *container = [cell viewWithTag:1000];
    if (!container) {
        container = [[UIView alloc] init];
        container.tag = 1000;
        [cell.contentView addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell);
            make.width.equalTo(cell);
            make.height.equalTo(cell);
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 1;
        [titleLabel setText:model.name];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [container addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(container).offset(5);
            make.width.equalTo(container).offset(10);
            make.height.equalTo(container).dividedBy(2);
            make.left.equalTo(container).offset(10);
            make.centerY.equalTo(container);
        }];
        
        UILabel *descLabel = [[UILabel alloc] init];
        [descLabel setText:model.descriptions];
        [descLabel setTextColor:RGBHex(g_assit_c)];
        [descLabel setFont:[UIFont systemFontOfSize:13]];
        descLabel.tag = 2;
        [container addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(0);
            make.width.equalTo(container).offset(10);
            make.height.equalTo(container).dividedBy(3);
            make.left.equalTo(container).offset(15);
        }];
        
    }else{
        UILabel *title = [container viewWithTag:1];
        [title setText:model.name];
        UILabel *desc = [container viewWithTag:2];
        [desc setText:model.descriptions];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma  mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppiontRouteModel *model = _dataArray[indexPath.section];
    
    if (self.delegateCallback)
    {
        [self.delegateCallback callback:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) buttonSearchE:(UIButton*)button
{
    _keyWords = [_inputField.text length]>0?_inputField.text:nil;
    _endKeyWords =[_endField.text length]>0?_endField.text:nil;


    [self.mTableView.mj_header beginRefreshing];
}

- (void) buttonTarget:(id)sender
{
    if (self.leftButton == sender) {
        [super buttonTarget:sender];
    }else if(_buttonSearch == sender)
    {
        [self buttonSearchE:sender];
    }
}
-(void)switchButtonClick:(UIButton *)sender{
    NSString *tempStr;
    tempStr = _inputField.text;
    _inputField.text = _endField.text;
    _endField.text = tempStr;
}
@end