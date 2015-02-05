//
//  CustomerViewController.m
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "CustomerViewController.h"
#import "Common.h"
#import "MyDataService.h"
#import "UIViewExt.h"
#import "StatusCell.h"
#import "PeopleCell.h"
#import "BaseNavigationController.h"
#import "MBProgressHUD.h"
#import "UserTmpParam.h"
#import "AFHTTPRequestOperation.h"
#import "CustomerModel.h"
#import "PhonePersonController.h"
#import "CustomerDetailController.h"
#import "EditCustomerController.h"
#import "SelectBuildController.h"
#import "BuildingDataController.h"
#import "BulidingViewController.h"
#import "LoginViewController.h"
static NSString * indetify = @"StatusCell";
static NSString * peopleCellIndetify = @"PeopleCell";
@interface CustomerViewController (){
    
    UIView * _navaView;
    UITableView * _selectTabView;
    UITableView * _mainTabView;
    UIButton * _midButton;
    UIView * _searchView;
    UIView * _shadowView;
    UIView * _bgView;
    UITextField * _searchTextFiled;
    MBProgressHUD * _hud;
    NSInteger  _currentPage;
    AFHTTPRequestOperation * _customerListServiceOpera;
    EGORefreshTableFooterView * _refreshFooterView;
    UILabel * _noDatalabel;
    BOOL _reloading;
    NSMutableArray * _peopleArray;
    NSMutableArray * _praticeArray;
    BOOL _isRefresh;
    NSString * _bigTitile;
    NSMutableArray * _selectCellArray;
    AFHTTPRequestOperation * _addCusetomerOpera;
    NSMutableArray * _contetStrArray;
    BuildingDataController * _buildingDataCtlr;
    NSInteger _runRefresh;
    UIImageView  * _noCusImgView;
    UILabel * _noCusLabel;
    UIButton * _noCusButton;
    UIView * _noCusView;
    UIView * _noLoginView;
}


@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _ininViews];
//    if (_isLoadNoAdd == YES) {
//        [self _loadNoAddCus];
//    }else{
//        [self _loadData:_bigTitile];
//    }
}
- (void)_ininViews{
    if ([self isLogin]) {
        _currentPage = 1;
        _bigTitile = @"所有";
        if (_isLoadNoAdd == YES &&_selectCellArray == nil) {
            _selectCellArray = [NSMutableArray array];
        }
        [self _creatSearchView];
        if (_isLoadNoAdd ==NO) {
            [self _creatNavaBarView];
        }else{
            [self _creatRightButton];
        }
        if (_mainTabView == nil ) {
            
            if (_isLoadNoAdd == YES) {
                _mainTabView  =[[UITableView alloc] initWithFrame:CGRectMake(0, _searchView.bottom, kScreenWidth, kScreenHeight-64-_searchView.height) style:UITableViewStylePlain];
            }else {
                _mainTabView  =[[UITableView alloc] initWithFrame:CGRectMake(0, _searchView.bottom, kScreenWidth, kScreenHeight-64-48-_searchView.height) style:UITableViewStylePlain];
            }
            _mainTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _mainTabView.delegate = self;
            _mainTabView.dataSource = self;
            _mainTabView.tag = 200;
            [_mainTabView registerNib:[UINib nibWithNibName:@"PeopleCell" bundle:nil] forCellReuseIdentifier:peopleCellIndetify];
            [self.view addSubview:_mainTabView];
        }
    }else{
        if (_noLoginView == nil) {
            [self _creatNoLoginView];
        }
    }
}
- (void)_creatNoLoginView{
    if (_hud !=nil) {
        [_hud hide:YES];
        _hud = nil;
    }
    _noLoginView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-122)/2,( _noLoginView.height-122)/2-40-40, 122, 122)];
    imgView.image = [UIImage imageNamed:@"没登录.png"];
    [_noLoginView addSubview:imgView];
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, imgView.bottom+10, 100, 20)];
    tipLabel.textColor  =[UIColor grayColor];
    tipLabel.text = @"您还没有登录~";
    tipLabel.font=  [UIFont systemFontOfSize:13];
    [_noLoginView addSubview:tipLabel];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"登录.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake((kScreenWidth-79)/2, tipLabel.bottom+10, 79, 38);
    [button addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_noLoginView addSubview:button];
    
    [self.view addSubview:_noLoginView];
}
- (void)LoginAction:(UIButton *)button{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (BOOL)isLogin {
    
    if ([UserTmpParam getUserId].length == 0 || [UserTmpParam getSession].length == 0) {
        return NO;
    } else {
        return YES;
    }
}

//创建上啦加载数据
- (void)_creatEGOFooterView{
    if (_refreshFooterView == nil) {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0, _mainTabView.contentSize.height, _mainTabView.width, _mainTabView.contentSize.height)];
        _refreshFooterView.delegate = self;
        [_mainTabView addSubview:_refreshFooterView];
    }
}
//创建tabView尾视图
- (void)_creatTabViewFooterView{
    if (_noDatalabel == nil) {
        _noDatalabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _noDatalabel.text = @"没有更多数据!";
        _noDatalabel.textAlignment = NSTextAlignmentCenter;
        _noDatalabel.font = [UIFont systemFontOfSize:14];
        [_mainTabView setTableFooterView:_noDatalabel];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _ininViews];
//    if (_isReload == YES) {
        if (_isLoadNoAdd == YES) {
            self.title = @"客户";
            [self _loadNoAddCus];
        }else{
            self.title = @"所有";
            [self _loadData:_bigTitile];
        }
//    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_mainTabView setTableFooterView:nil];
    _isReload = NO;
    _currentPage = 1;
    _bigTitile = @"所有";
//
}
- (void)_loadData:(NSString *)type{
    NSString * actValue;
    if ([type isEqualToString:@"所有"]) {
        actValue = @"0";
    }
    if ([type isEqualToString:@"无效客户"]) {
        actValue = @"1";
    }
    if ([type isEqualToString:@"未报备"]) {
        actValue = @"2";
    }
    if ([type isEqualToString:@"已报备"]) {
        actValue = @"3";
    }
    if ([type isEqualToString:@"已带看"]) {
        actValue = @"4";
    }
    if ([type isEqualToString:@"已预约"]) {
        actValue = @"5";
    }
    if ([type isEqualToString:@"已认购"]) {
        actValue = @"6";
    }
    if ([type isEqualToString:@"已结佣"]) {
        actValue = @"7";
    }
    if (_mainTabView.hidden == YES) {
        _mainTabView.hidden =NO;
        [_noCusButton removeFromSuperview];
        _noCusButton = nil;
        [_noCusImgView removeFromSuperview];
        _noCusImgView = nil;
        [_noCusLabel removeFromSuperview];
        _noCusLabel = nil;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    if (_currentPage == 1) {
        [_praticeArray removeAllObjects];
        _praticeArray = nil;
//        [_peopleArray removeAllObjects];
        _peopleArray  = nil;
    }
    if (_peopleArray == nil) {
        _peopleArray = [NSMutableArray array];
        _praticeArray = [NSMutableArray array];
    }
    if (_isRefresh == NO) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"正在加载..";
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"\{\"user_id\":\"%@\",\"session\":\"%@\",\"page_size\":\"10\",\"page\":\"%@\",\"customer_status\":\"%@\"}",[UserTmpParam getUserId],[UserTmpParam getSession],[NSString stringWithFormat:@"%ld",(long)_currentPage],actValue];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * customerListService = [[MyDataService alloc] init];
    [customerListService setFailureBlock:^{
        _hud.hidden = YES;
        _hud = nil;
        if (_noLoginView == nil) {
            [self _creatRequsetData:self.view];
        }
    }];
    _customerListServiceOpera = [customerListService requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_customer_list" timeStamp:dataStr complection:^(id result) {
        _mainTabView.contentInset = UIEdgeInsetsZero;
        
        if (_isRefresh == YES) {
            [self finishReloadingData];
            _isRefresh = NO;
        }else {
            [_hud hide:YES afterDelay:0];
            _hud = nil;
        }
        if ([[result objectForKey:@"error"] integerValue]==0) {
            if (_refreshFooterView != nil) {
                _refreshFooterView.hidden = YES;
                [_refreshFooterView removeFromSuperview];
                _refreshFooterView = nil;
            }
            NSLog(@"%@",result);
            if (_isReload == YES) {
                _isReload = NO;
            }
            for (NSDictionary * buildDic in [[result objectForKey:@"content"] objectForKey:@"get_customer_list"]) {
                CustomerModel * customerModel = [[CustomerModel alloc] initWithDataDic:buildDic];
                [_praticeArray addObject:customerModel];
            }
            _peopleArray = [NSMutableArray arrayWithArray:_praticeArray];
//            0x7f9f25941920
            if (_peopleArray.count == 0) {
                [self _creatNoCusView];
            }else {
                [_mainTabView reloadData];
            }
            if ([[[result objectForKey:@"content"] objectForKey:@"page_count"] integerValue]>[[[result objectForKey:@"content"] objectForKey:@"cur_page_no"] integerValue]) {
                if (_noDatalabel != nil) {
                    [_mainTabView setTableFooterView:nil];
                    _noDatalabel = nil;
                }
                _runRefresh = _runRefresh + 1;
                [self _creatEGOFooterView];
            }else {
                NSLog(@"%ld",(long)_runRefresh);
                if (_runRefresh != 0) {
                    _refreshFooterView.hidden = YES;
                    _refreshFooterView = nil;
                    [self _creatTabViewFooterView];
                }
            }
        }else{
            if ([[result objectForKey:@"error"] integerValue]==1021) {
               UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录实效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                alertView.tag = 2000;
                [alertView show];
            }
        }
    }];
}
- (void)_creatNoCusView{
    _mainTabView.hidden = YES;
    _noCusView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchView.bottom, kScreenWidth, _mainTabView.height)];
    _noCusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-60, kScreenHeight/2-60-100, 120, 120)];
    _noCusImgView.image =[UIImage imageNamed:@"没有客户.png"];
    [_noCusView addSubview:_noCusImgView];

    _noCusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_noCusImgView.origin.x, _noCusImgView.bottom, 140, 30)];
    _noCusLabel.font = [UIFont systemFontOfSize:15];
    _noCusLabel.text = @"暂时还没有客户哦~";
    _noCusLabel.textColor = [UIColor grayColor];
    [_noCusView addSubview:_noCusLabel];
    
    _noCusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _noCusButton.frame = CGRectMake(kScreenWidth/2-50, _noCusLabel.bottom+10, 100, 35);
    [_noCusButton setImage:[UIImage imageNamed:@"添加客户.png"] forState:UIControlStateNormal];
    [_noCusButton addTarget:self action:@selector(addCustomerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_noCusView addSubview:_noCusButton];
    [self.view addSubview:_noCusView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_noCusView addGestureRecognizer:tap];
    if (_selectTabView != nil) {
        [self.view bringSubviewToFront:_selectTabView];
    }
}
- (void)tapAction{
    if ([_searchTextFiled isFirstResponder] == YES) {
        [_searchTextFiled resignFirstResponder];
    }
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    _mainTabView.hidden = YES;
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }
    if (_isLoadNoAdd == YES) {
        [self.reloadButton addTarget:self action:@selector(_loadNoAddCus) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.reloadButton addTarget:self action:@selector(faluerLoadData) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)faluerLoadData{
    [self _loadData:_bigTitile];
}
- (void)_loadNoAddCus{
    if (_mainTabView.hidden == YES) {
        _mainTabView.hidden = NO;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    if (_currentPage == 1) {
        _praticeArray = nil;
        _peopleArray  = nil;
    }
    if (_peopleArray == nil) {
        _peopleArray = [NSMutableArray array];
        _praticeArray = [NSMutableArray array];
    }

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"page_size\":\"10\",\"user_id\":\"%@\",\"build_id\":\"%@\",\"session\":\"%@\"}",(long)_currentPage,[UserTmpParam getUserId],_buildId,[UserTmpParam getSession]];
    [params setObject:contenStr forKey:@"data"];
    if (_isRefresh == NO) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"正在加载..";
    }
    MyDataService * noAddCusReq = [[MyDataService alloc] init];
    [noAddCusReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    [noAddCusReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"not_build_customer" timeStamp:dataStr complection:^(id result) {
        if ([[result objectForKey:@"error"] integerValue] == 0) {
            if (_refreshFooterView != nil) {
                _refreshFooterView.hidden = YES;
                [_refreshFooterView removeFromSuperview];
                _refreshFooterView = nil;
            }
            _mainTabView.contentInset = UIEdgeInsetsZero;
            NSLog(@"%@",result);
            if (_isRefresh == YES) {
                [self finishReloadingData];
                _isRefresh = NO;
            }else {
                [_hud hide:YES afterDelay:0];
                _hud = nil;
            }
            if (_isReload == YES) {
                _isReload = NO;
            }
            for (NSDictionary * buildDic in [[result objectForKey:@"content"] objectForKey:@"get_customer_list"]) {
                CustomerModel * customerModel = [[CustomerModel alloc] initWithDataDic:buildDic];
                [_praticeArray addObject:customerModel];
            }
            _peopleArray = [NSMutableArray arrayWithArray:_praticeArray];
            [_mainTabView reloadData];
            if ([[[result objectForKey:@"content"] objectForKey:@"page_count"] integerValue]>[[[result objectForKey:@"content"] objectForKey:@"cur_page_no"] integerValue]) {
                if (_noDatalabel != nil) {
                    [_mainTabView setTableFooterView:nil];
                    _noDatalabel = nil;
                }
                [self _creatEGOFooterView];
            }else {
                _refreshFooterView.hidden = YES;
                _refreshFooterView = nil;
                [self _creatTabViewFooterView];
            }
        }else{
            if ([[result objectForKey:@"error"] integerValue] == 1021) {
                UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录实效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                alertView.tag = 2000;
                [alertView show];
            }
        }
    }];

}
- (void)_creatNavaBarView{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addCustomerAction:)];
    rightButton.image = [UIImage imageNamed:@"添加.png"];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _midButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _midButton.frame = CGRectMake(kScreenWidth/2-50, 32, 100, 20);
    [_midButton setTitle:@"所有" forState:UIControlStateNormal];
    [_midButton setFont:[UIFont systemFontOfSize:18]];
    [_midButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_midButton setImage:[UIImage imageNamed:@"向下.png"] forState:UIControlStateNormal];
//    [_midButton setImage:[UIImage imageNamed:@"向上.png"] forState:UIControlStateSelected];
//    [_midButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
//    [_midButton setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    [_midButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _midButton;
    
}
- (void)_creatRightButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(addCustomerReqAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;

}
- (void)selectAction:(UIButton *)button{
    [_searchTextFiled resignFirstResponder];
    if (_selectTabView == nil) {
        _selectTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, -312, kScreenWidth, 312) style:UITableViewStyleGrouped];
        _selectTabView.tag = 100;
        [_selectTabView registerNib:[UINib nibWithNibName:@"StatusCell" bundle:nil] forCellReuseIdentifier:indetify];
        _selectTabView.delegate = self;
        _selectTabView.dataSource = self;
        
        if (_noCusView != nil) {
            [_selectTabView insertSubview:self.view aboveSubview:_noCusView];
        }else {
            [self.view addSubview:_selectTabView];
        }
    }
    
    if (button.selected == NO) {
        [UIView animateWithDuration:.5 animations:^{
            _selectTabView.transform = CGAffineTransformMakeTranslation(0, _selectTabView.height);
        }];
    }else {
        [UIView animateWithDuration:.5 animations:^{
            _selectTabView.transform = CGAffineTransformIdentity;
        }];
    }
    button.selected = !button.selected;
}
- (void)_creatSearchView{
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, _navaView.bottom, kScreenWidth, 40)];
        _searchView.backgroundColor = TAB_BAR_COLOR;
        
        UIImage * image = [UIImage imageNamed:@"搜索条.png"];
        image = [image stretchableImageWithLeftCapWidth:(image.size.width/2) topCapHeight:(image.size.height/2)];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, kScreenWidth-40, 30)];
        imgView.image = image;
        [_searchView addSubview:imgView];

       
        _searchTextFiled = [[UITextField alloc] init];
        _searchTextFiled.delegate = self;
        _searchTextFiled.frame = CGRectMake(20, 5, kScreenWidth-40, 30);
        _searchTextFiled.font = [UIFont systemFontOfSize:14];
        _searchTextFiled.placeholder = @"请输入名字或者电话号码,进行查找";
        _searchTextFiled.backgroundColor = [UIColor clearColor];
        [_searchTextFiled addTarget:self action:@selector(changeAction:)
            forControlEvents:UIControlEventEditingChanged];
        [_searchView addSubview:_searchTextFiled];
        [self.view addSubview:_searchView];
    }
}
- (void)changeAction:(UITextField *)textField {
        NSString *text = [textField text];
        //1.定义谓词
        //[c] 忽略大小写
        NSString *t;
        NSPredicate *predicate;
        if ([self isPureInt:text]) {
            t = [NSString stringWithFormat:@"customer_mobile like [c]'*%@*'",text];
            predicate = [NSPredicate predicateWithFormat:t];
        }else{
            t = [NSString stringWithFormat:@"customer_name like [c]'*%@*'",text];
            predicate = [NSPredicate predicateWithFormat:t];
        }
        //2.使用谓词过滤
        _peopleArray = (NSMutableArray *)[_praticeArray filteredArrayUsingPredicate:predicate];
        //3.显示
        [_mainTabView reloadData];
        NSLog(@"%lu",(unsigned long)_peopleArray.count);
}
//判断字符串全部是由数字组成
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
- (void)addCustomerAction:(UIButton *)button{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从通讯录选取" otherButtonTitles:@"直接添加", nil];
    [sheet showInView:self.view];
}
- (void)addCustomerReqAction:(UIButton *)button{
    if (_selectCellArray.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择客户,请选择需要报备到此楼盘的客户!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认报备这些客户到%@?",_buildName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.tag =4000;
    [alerView show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==3000) {
        BulidingViewController * buildVC =  self.navigationController.viewControllers[0];
        buildVC.isReload = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 2000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }if (alertView.tag == 4000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            if (_contetStrArray == nil) {
                _contetStrArray = [NSMutableArray array];
            }
            for (int i = 0; i<_selectCellArray.count; i++) {
                NSMutableDictionary *dddd = [[NSMutableDictionary alloc] init];
                [dddd setObject:[UserTmpParam getUserId] forKey:@"user_id"];
                [dddd setObject:_buildId forKey:@"build_id"];
                [dddd setObject:_selectCellArray[i] forKey:@"customer_id"];
                [dddd setObject:@"3" forKey:@"order_status"];
                [_contetStrArray addObject:dddd];
            }
            
            NSDictionary *xxxx = @{@"customers" : _contetStrArray};
            NSDictionary *cccc = @{@"customers" : xxxx,
                                   @"session": [UserTmpParam getSession]};
            NSData *data = [NSJSONSerialization dataWithJSONObject:cccc options:0 error:nil];
            if (_buildingDataCtlr == nil) {
                _buildingDataCtlr = [[BuildingDataController alloc] init];
                _buildingDataCtlr.delegate= self;
            }
            if (_hud == nil) {
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            _hud.mode = MBProgressHUDModeIndeterminate;
            _hud.labelText = @"正在加载..";
            [_buildingDataCtlr mrBuilding:cccc];
        }
    }
}
- (void)onGetBuildingReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag{
    [_hud hide:YES];
    _hud = nil;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"报备客户成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    alertView.tag = 3000;
}
- (void)onGetBuildingFailedWithError:(NSError *)error withReqTag:(NSInteger)tag{
    _hud.hidden = YES;
    _hud = nil;
    NSLog(@"%@",error);
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"添加客户失败,报备次数过多，每天最多报备5次客户!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {  //通讯录选择
        PhonePersonController * phonePersonCtrl = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"PhonePersonController"];
        [self.navigationController pushViewController:phonePersonCtrl animated:YES];
    }
    else if (buttonIndex == 1) {  //直接添加
        EditCustomerController * addPersonCtrl = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCustomerController"];
        [self.navigationController pushViewController:addPersonCtrl animated:YES];
        
    }
    else if (buttonIndex == 2){     //取消
        return;
    };
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100) {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return 5;
        }
        if (section == 2) {
            return 2;
        }
    }
    return _peopleArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 200) {
        if (_isLoadNoAdd) {
            NSLog(@"%@",[tableView cellForRowAtIndexPath:indexPath]);
            PeopleCell * cell = (PeopleCell *)[_mainTabView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            CustomerModel * customer =_peopleArray[indexPath.row];
            if (cell.selectButton.selected == YES) {
                [_selectCellArray addObject:customer.customer_id];
            }else{
                [_selectCellArray removeObject:customer.customer_id];
            }
            cell.selectCellArray =_selectCellArray;
        }else {
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CustomerDetailController * customerrDetailCtrl = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerDetailController"];
            CustomerModel * customerModel = _peopleArray[indexPath.row];
            customerrDetailCtrl.customerID = customerModel.customer_id;
            [self.navigationController pushViewController:customerrDetailCtrl animated:YES];
        }
    }
    if (tableView.tag == 100) {
        StatusCell * cell = (StatusCell *)[tableView cellForRowAtIndexPath:indexPath];
        [_midButton setTitle:[NSString stringWithFormat:@"%@",cell.statusNameLabel.text] forState:UIControlStateNormal];
        _midButton.selected = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIView animateWithDuration:.5 animations:^{
            _selectTabView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _currentPage = 1;
            _bigTitile =[_midButton titleForState:UIControlStateNormal];
            _runRefresh = 0;
            [_mainTabView setTableFooterView:nil];
            [self _loadData:_bigTitile];
        }];
    }
    if (_searchTextFiled.resignFirstResponder == YES) {
        [_searchTextFiled resignFirstResponder];
        return;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 35;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        StatusCell * cell = [tableView dequeueReusableCellWithIdentifier:indetify forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.statusNameLabel.text = @"所有";
        }
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    cell.statusNameLabel.text = @"已报备";
                    break;
                case 1:
                    cell.statusNameLabel.text = @"已带看";
                    break;
                case 2:
                    cell.statusNameLabel.text = @"已预约";
                    break;
                case 3:
                    cell.statusNameLabel.text = @"已认购";
                    break;
                case 4:
                    cell.statusNameLabel.text = @"已结佣";
                    break;
            }
        }
        if (indexPath.section == 2) {
            switch (indexPath.row) {
                case 0:
                    cell.statusNameLabel.text = @"未报备";
                    break;
                    
                default:cell.statusNameLabel.text = @"无效客户";
                    break;
            }
        }
        return cell;
    }else {
        if (_isLoadNoAdd) {
            PeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:peopleCellIndetify forIndexPath:indexPath];
            cell.customerModel = _peopleArray[indexPath.row];
            cell.selectCellArray = _selectCellArray;
            cell.selectButton.hidden = NO;
            cell.statusImgView .hidden = YES;
            cell.addCustomerButton.hidden = YES;
            return cell;
        }else{
            PeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:peopleCellIndetify forIndexPath:indexPath];
            CustomerModel * customerModel = _peopleArray[indexPath.row];
                cell.customerModel = customerModel;
            [cell setPassEvent:^{
                SelectBuildController * selectVC = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectBuildController"];
                selectVC.customerId = customerModel.customer_id;
                [self.navigationController pushViewController:selectVC animated:YES];
            }];
            cell.selectButton.hidden = YES;
            cell.statusImgView.hidden = NO;
            cell.addCustomerButton.hidden = NO;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (tableView.tag == 200) {
        if (_isLoadNoAdd) {
            PeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:peopleCellIndetify forIndexPath:indexPath];
            cell.selectButton.selected = NO;
        }
    }
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//完成刷新数据
- (void)finishReloadingData{
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_mainTabView];
    }
}
//开始刷新数据
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    // should be calling your tableviews data source model to reload
    _reloading = YES;
    _isRefresh = YES;
    if (aRefreshPos == EGORefreshFooter) {
        _currentPage++;
        if (_isLoadNoAdd) {
            [self _loadNoAddCus];
        }else{
            [self _loadData:_bigTitile];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextFiled resignFirstResponder];
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:_mainTabView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:_mainTabView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos scrollView:(UIScrollView *)scrollView{
    
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

@end
