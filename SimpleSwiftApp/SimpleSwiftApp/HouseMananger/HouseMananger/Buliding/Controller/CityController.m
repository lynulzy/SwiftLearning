//
//  CityController.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-9.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "CityController.h"
#import "Common.h"
#import "MyDataService.h"
#import "CityModel.h"
#import "CityCell.h"
#import "MainTabBarController.h"
#import "BulidingViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
static NSString * cityId = @"CityCell";
@interface CityController (){
    
    NSMutableArray * _bigData;
    UITableView * _smallTabView;
    NSMutableArray * _smallData;
    CityModel * _cityModel;
    MBProgressHUD * _hud;
    AFHTTPRequestOperation * _cityListReqOpera;
    AFHTTPRequestOperation * _regionReqOpera;
    NSString * _cityId;
}

@end

@implementation CityController
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //YES: 当前此控制器被push之后，隐藏UITabbarController对象上的UITabbar
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市列表";
    [_tabView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellReuseIdentifier:cityId];
    [self _loadData];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_cityListReqOpera ) {
        [_cityListReqOpera cancel];
    }
    if (_regionReqOpera) {
        [_regionReqOpera cancel];
    }
}
- (void)_loadData{
    if (_tabView.hidden == YES) {
        _tabView.hidden = NO;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    _bigData = [NSMutableArray array];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{}"];
    [params setObject:contenStr forKey:@"data"];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:_tabView animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在加载..";
    MyDataService * cityListReq =[[MyDataService alloc] init];
    [cityListReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    _cityListReqOpera = [cityListReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_city_list" timeStamp:dataStr complection:^(id result) {
        NSLog(@"%@",result);
        [_hud hide:YES afterDelay:0];
        _hud = nil;
        for (NSDictionary * cityDic in [result objectForKey:@"content"]) {
            CityModel * cityModel = [[CityModel alloc] initWithDataDic:cityDic];
            [_bigData addObject:cityModel];
        }
        [_tabView reloadData];
    }];
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }
    if (view == self.view) {
        _tabView.hidden = YES;
        [self.reloadButton addTarget:self action:@selector(_loadData) forControlEvents:UIControlEventTouchUpInside];
    }
    if (view == _smallTabView) {
        [self.reloadButton addTarget:self action:@selector(_loadDataByCityID) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)_loadDataByCityID{
    if (self.reloadButton != nil) {
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    _smallData = [NSMutableArray array];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{\"city_id\":\"%@\"}",_cityId];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * regionReq = [[MyDataService alloc] init];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:_smallTabView animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在加载..";
    [regionReq setFailureBlock:^{
        [self _creatRequsetData:_smallTabView];
    }];
   _regionReqOpera = [regionReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_one_region" timeStamp:dataStr complection:^(id result) {
        NSLog(@"%@",result);
        [_hud hide:YES afterDelay:0];
        _hud = nil;
        for (NSDictionary * cityDic in [result objectForKey:@"content"]) {
            CityModel * cityModel = [[CityModel alloc] initWithDataDic:cityDic];
            [_smallData addObject:cityModel];
        }
        [_smallTabView reloadData];
    }];
}
- (void)_creatSmallTabView{
    if (_smallTabView == nil) {
        _smallTabView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth/2, kScreenHeight-64) style:UITableViewStyleGrouped];
        _smallTabView.delegate = self;
        _smallTabView.dataSource = self;
        [_smallTabView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellReuseIdentifier:cityId];
        _smallTabView.tag = 200;
        [self.view addSubview:_smallTabView];
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100) {
        return 1;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag ==100) {
        return _bigData.count;
    }else{
        if (section == 0) {
            return 1;
        }else{
            return _smallData.count;
        }
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
            CityCell * cell = [tableView dequeueReusableCellWithIdentifier:cityId forIndexPath:indexPath];
            if (_bigData.count > 0) {
                cell.cityModel = _bigData[indexPath.row];
            }
            return cell;
        }else{
        if (indexPath.section == 0) {
            CityCell * cell = [tableView dequeueReusableCellWithIdentifier:cityId forIndexPath:indexPath];
            cell.cityModel = _cityModel;
            return cell;
        }else{
            CityCell * cell = [tableView dequeueReusableCellWithIdentifier:cityId forIndexPath:indexPath];
            if (_bigData.count > 0) {
                cell.cityModel = _smallData[indexPath.row];
            }
            return cell;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==100) {
            [self _creatSmallTabView];
            _cityModel = _bigData[indexPath.row];
            [UIView animateWithDuration:.5 animations:^{
                _smallTabView.transform = CGAffineTransformMakeTranslation(-kScreenWidth/2, 0);
            }];
        CityModel * cityModel = _bigData[indexPath.row];
        _cityId = cityModel.region_id;
        [self _loadDataByCityID];
    }else{
        CityModel * model = _smallData[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:_cityModel.region_name forKey:@"cityName"];
        [[NSUserDefaults standardUserDefaults] setObject:_cityModel.region_id forKey:@"cityId"];
        if (indexPath.section == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"regionName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"regionId"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:model.region_name forKey:@"regionName"];
            [[NSUserDefaults standardUserDefaults] setObject:model.region_id forKey:@"regionId"];
        }
        BulidingViewController * buildVC = self.navigationController.viewControllers[0];
        buildVC.isReload = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
