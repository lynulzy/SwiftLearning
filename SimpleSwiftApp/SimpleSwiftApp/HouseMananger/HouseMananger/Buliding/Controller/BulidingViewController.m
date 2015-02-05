//
//  BulidingViewController.m
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "BulidingViewController.h"
#import "BuildingCell.h"
#import "BuilidingDetaliController.h"
#import "Common.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "MyDataService.h"
#import "RC4.h"
#import "UserTmpParam.h"
#import "CityController.h"
#import "BuildingModel.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "AFHTTPRequestOperation.h"
#import "CustomerViewController.h"
#import "LoginViewController.h"
static NSString * identify = @"BuildingCell";
@interface BulidingViewController (){
    UITableView * _tabView;
    EGORefreshTableHeaderView * _refreshHeaderView;
    EGORefreshTableFooterView * _refreshFooterView;
    BOOL _reloading;
    NSMutableArray * _data;
    MBProgressHUD * _hud;
    NSInteger _currentPage;
    UILabel * _noDatalabel;
    AFHTTPRequestOperation * _attListReqOpera;
    AFHTTPRequestOperation * _buildListServiceOpera;
    BOOL  _isRunRefresh;
}


@end

@implementation BulidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    _currentPage = 1;
    self.view.backgroundColor =  BACK_COLOR;
    if (_isAttentionBuilding == YES) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight-64) style:UITableViewStylePlain];
        [self.view addSubview:_tabView];
        [self _loadAttentionBuild:NO];
    }
    if (_isAttentionBuilding == NO) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight-49-64) style:UITableViewStylePlain];
        [self.view addSubview:_tabView];
        [self _loadData:NO];
    }
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tabView registerNib:[UINib nibWithNibName:@"BuildingCell" bundle:nil] forCellReuseIdentifier:identify];
    [self _creatEGOHeaderView];
    [_selectCityButton setTitle:[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"regionName"]]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_isAttentionBuilding == YES) {
        [_selectCityButton setTitle:@""];
        _selectCityButton.enabled = NO;
        self.title = @"关注楼盘" ;
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"regionName"] isEqualToString:@""]) {
            [_selectCityButton setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"]]];
        }else{
            [_selectCityButton setTitle:[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"regionName"]]];
        }
        if (_isReload == YES) {
            [self _loadData:NO];
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _currentPage = 1;
    _isRunRefresh = NO;
    if (_attListReqOpera ) {
        [_attListReqOpera cancel];
        _hud.hidden = YES;
        _hud = nil;
//        [_tabView setTableFooterView:nil];
    }
    if (_buildListServiceOpera ) {
        [_buildListServiceOpera cancel];
        _hud.hidden = YES;
        _hud = nil;
//        [_tabView setTableFooterView:nil];
    }
//    _data = nil;
}
- (void)_loadAttentionBuild:(BOOL)isRefresh{
    if (self.baseView != nil) {
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    if (_currentPage == 1) {
        _data = nil;
    }
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    if (_tabView.hidden == YES) {
        _tabView.hidden = NO;
    }

    if (isRefresh == NO) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"正在加载..";
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contentStr = [NSString stringWithFormat:@"\{\"user_id\":\"%@\",\"session\":\"%@\",\"page\":\"%ld\",\"page_size\":\"10\"}",[UserTmpParam getUserId],[UserTmpParam getSession],(long)_currentPage];
    [params setObject:contentStr forKey:@"data"];
    MyDataService * attListReq = [[MyDataService alloc] init];
    [attListReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    _attListReqOpera = [attListReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_care_list" timeStamp:dataStr complection:^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"error"] integerValue]==0) {
            if (_refreshFooterView != nil) {
                _refreshFooterView.hidden = YES;
                [_refreshFooterView removeFromSuperview];
                _refreshFooterView = nil;
            }
            if (isRefresh == NO) {
                [_hud hide:YES afterDelay:0];
                _hud = nil;
            }
            if (isRefresh == YES) {
                [self finishReloadingData];
            }
            for (NSDictionary * buildDic in [[result objectForKey:@"content"] objectForKey:@"build_list"]) {
                BuildingModel * buildingModel = [[BuildingModel alloc] initWithDataDic:buildDic];
                [_data addObject:buildingModel];
            }
            [_tabView reloadData];
            if (_noDatalabel != nil) {
                [_tabView setTableFooterView:nil];
                _noDatalabel = nil;
            }
            if ([[[result objectForKey:@"content"] objectForKey:@"page_count"] integerValue]>[[[result objectForKey:@"content"] objectForKey:@"cur_page_no"] integerValue]) {
                _isRunRefresh = YES;
                [self _creatEGOFooterView];
            }else {
                if (_isRunRefresh == YES) {
                    [_refreshFooterView removeFromSuperview];
                    _refreshFooterView = nil;
                    [self _creatTabViewFooterView];
                }
            }
        }else{
            if ([[result objectForKey:@"error"] integerValue]==1021) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
        }
    }];
}
- (void)_loadData:(BOOL)isRefresh{
    if (_currentPage == 1) {
        _data = nil;
    }
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    if (_tabView.hidden == YES) {
        _tabView.hidden = NO;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    if (isRefresh == NO) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"正在加载..";
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = nil;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"regionName"] isEqualToString:@""]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] isEqualToString:@""]) {
        contenStr = [NSString stringWithFormat:@"\{\"city_id\":\"%@\",\"page_size\":\"10\",\"page\":\"%@\"}",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"],[NSString stringWithFormat:@"%ld",(long)_currentPage]];
    }else{
        contenStr = [NSString stringWithFormat:@"\{\"city_id\":\"%@\",\"district_id\":\"%@\",\"page_size\":\"10\",\"page\":\"%@\"}",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"],[NSString stringWithFormat:@"%ld",(long)_currentPage]];
    }
    
    
    [params setObject:contenStr forKey:@"data"];
    MyDataService * buildListService = [[MyDataService alloc] init];
    [buildListService setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    _buildListServiceOpera = [buildListService requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_build_list" timeStamp:dataStr complection:^(id result) {
        if (self.isReload == YES) {
            _isReload = NO;
        }
        if (_refreshFooterView != nil) {
            _refreshFooterView.hidden = YES;
            [_refreshFooterView removeFromSuperview];
            _refreshFooterView = nil;
        }
        NSLog(@"%@",result);
        if (isRefresh == NO) {
            [_hud hide:YES afterDelay:0];
            _hud = nil;
        }
        if (isRefresh == YES) {
            [self finishReloadingData];
        }
        for (NSDictionary * buildDic in [[result objectForKey:@"content"] objectForKey:@"build_list"]) {
            BuildingModel * buildingModel = [[BuildingModel alloc] initWithDataDic:buildDic];
            [_data addObject:buildingModel];
        }
        [_tabView reloadData];
        if (_noDatalabel != nil) {
            [_tabView setTableFooterView:nil];
            _noDatalabel = nil;
        }
        if ([[[result objectForKey:@"content"] objectForKey:@"page_count"] integerValue]>[[[result objectForKey:@"content"] objectForKey:@"cur_page_no"] integerValue]) {
            _isRunRefresh = YES;
            [self _creatEGOFooterView];
        }else {
            
            if (_isRunRefresh == YES) {
                [_refreshFooterView removeFromSuperview];
                _refreshFooterView = nil;
                [self _creatTabViewFooterView];
            }
        }
    }];

}
//创建tabView尾视图
- (void)_creatTabViewFooterView{
    if (_noDatalabel == nil) {
        _noDatalabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _noDatalabel.text = @"没有更多数据可加载了!";
        _noDatalabel.textAlignment = NSTextAlignmentCenter;
        _noDatalabel.font = [UIFont systemFontOfSize:14];
        [_tabView setTableFooterView:_noDatalabel];
    }
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    _tabView.hidden = YES;
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }
    if (_isAttentionBuilding == YES) {
        [self.reloadButton addTarget:self action:@selector(_loadAttentionBuild:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.reloadButton addTarget:self action:@selector(_loadData:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//创建下拉刷新的控件
- (void)_creatEGOHeaderView{
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tabView.bounds.size.height, _tabView.frame.size.width, _tabView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [_tabView addSubview:_refreshHeaderView];
    }
}
//创建上啦加载数据
- (void)_creatEGOFooterView{
    if (_refreshFooterView == nil) {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                             CGRectMake(0, _tabView.contentSize.height, _tabView.width, _tabView.contentSize.height)];
        _refreshFooterView.delegate = self;
        [_tabView addSubview:_refreshFooterView];
    }
}
- (IBAction)selectCity:(id)sender {
    CityController * cityCtrl = [[UIStoryboard storyboardWithName:@"Buliding" bundle:nil] instantiateViewControllerWithIdentifier:@"CityController"];
    [self.navigationController pushViewController:cityCtrl animated:YES];

}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//完成刷新数据
- (void)finishReloadingData{
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tabView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tabView];
    }

}
//开始刷新数据
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    // should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        _currentPage = 1;
        _data = nil;
        if (_isAttentionBuilding == NO) {
            [self _loadData:YES];
        }else{
            [self _loadAttentionBuild:YES];
        }
    }
    if (aRefreshPos == EGORefreshFooter) {
        _currentPage++;
        if (_isAttentionBuilding == NO) {
            [self _loadData:YES];
        }else{
            [self _loadAttentionBuild:YES];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}
- (BOOL)isLogin {
    
    if ([UserTmpParam getUserId].length == 0 || [UserTmpParam getSession].length == 0) {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    if (buttonIndex == 1) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuildingCell * cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    [cell setPassValueBlock:^(NSString * buildId){
        if ([self isLogin]) {
            CustomerViewController * addCustomerCtrl = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerViewController"];
            addCustomerCtrl.hidesBottomBarWhenPushed = YES;
            addCustomerCtrl.title = @"客户";
            addCustomerCtrl.buildId = buildId;
            addCustomerCtrl.isLoadNoAdd = YES;
            BuildingModel * model = _data[indexPath.row];
            addCustomerCtrl.buildName = model.name;
            [self.navigationController pushViewController:addCustomerCtrl animated:YES];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录点击确定登陆!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        }
    }];
    if (_data.count != 0) {
        cell.buildingModel = _data[indexPath.row];
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BuilidingDetaliController * bulidingDetailCtrl = [[UIStoryboard storyboardWithName:@"Buliding" bundle:nil] instantiateViewControllerWithIdentifier:@"BuilidingDetaliController"];
    if (_data.count >0) {
        BuildingModel * model = _data[indexPath.row];
        bulidingDetailCtrl.buildingID = model.buildingId;
    }
    [self.navigationController pushViewController:bulidingDetailCtrl animated:YES];
}
@end
