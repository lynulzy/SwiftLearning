//
//  CustomerDetailController.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/21.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "CustomerDetailController.h"
#import "Common.h"
#import "MyDataService.h"
#import "CusDetailHeaderView.h"
#import "UserTmpParam.h"
#import "CustomerDetailModel.h"
#import "MBProgressHUD.h"
#import "CustomerDetailCell.h"
#import "EditCustomerController.h"
#import "LoginViewController.h"
#import "AttentBuildModel.h"
#import "AttBuildButtonCell.h"
#import "SelectBuildController.h"
#import "AttBuildCell.h"
static NSString * CustomerDetailCellId = @"CustomerDetailCell";
static NSString * attBuildButtonId = @"AttBuildButtonCell";
static NSString * attBuildCellId = @"AttBuildCell";
@interface CustomerDetailController (){
    UITableView * _tabView;
    CusDetailHeaderView * _headerView;
    MBProgressHUD * _hud;
    CustomerDetailModel * _coustomerDetailModel;
    
    NSMutableArray * _orderArray;
}

@end

@implementation CustomerDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _loadCustomerDetailData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _creatNavaBarView];
    self.title = @"客户详情";
    if (_tabView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CusDetailHeaderView" owner:nil options:nil] lastObject];
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        [_tabView registerNib:[UINib nibWithNibName:@"CustomerDetailCell" bundle:nil] forCellReuseIdentifier:CustomerDetailCellId];
        [_tabView registerNib:[UINib nibWithNibName:@"AttBuildButtonCell" bundle:nil] forCellReuseIdentifier:attBuildButtonId];
        [_tabView registerNib:[UINib nibWithNibName:@"AttBuildCell" bundle:nil] forCellReuseIdentifier:attBuildCellId];
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.delegate = self;
        _tabView.dataSource=  self;
        [_tabView setTableHeaderView:_headerView];
        [self.view addSubview:_tabView];
    }
//    [self _loadCustomerDetailData];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //YES: 当前此控制器被push之后，隐藏UITabbarController对象上的UITabbar
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}
- (void)_loadCustomerDetailData{
    _orderArray  = [NSMutableArray array];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"customer_id\":\"%@\",\"session\":\"%@\"}",[UserTmpParam getUserId],_customerID,[UserTmpParam getSession]];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * cusDetailReq = [[MyDataService alloc] init];
    [cusDetailReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    if (_tabView.hidden == YES) {
        _tabView.hidden = NO;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.mode =  MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在加载..";
    [cusDetailReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"customer_desc" timeStamp:dataStr complection:^(id result) {
        if ([[result objectForKey:@"error"] integerValue]==0 ) {
            _coustomerDetailModel = [[CustomerDetailModel alloc] initWithDataDic:[result objectForKey:@"content"]];
            _headerView.customerDetailModel = _coustomerDetailModel;
            _hud.hidden = YES;
            for (NSDictionary * dic in [[result objectForKey:@"content"] objectForKey:@"build_list"]) {
                AttentBuildModel * attBuildModel = [[AttentBuildModel alloc] initWithDataDic:dic];
                [_orderArray addObject:attBuildModel];
            }
            [_tabView reloadData];
            NSLog(@"%@",result);
            
        }else{
            if ([[result objectForKey:@"error"] integerValue]==1021) {
                UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录实效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                alertView.tag = 2000;
                [alertView show];
            }
        }
    }];
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    _tabView.hidden = YES;
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }

    [self.reloadButton addTarget:self action:@selector(_loadCustomerDetailData) forControlEvents:UIControlEventTouchUpInside];


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

- (void)_creatNavaBarView{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth-48, 32, 40, 20);
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton setFont:[UIFont systemFontOfSize:16]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(editCustomerAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)editCustomerAction:(UIButton *)button{
    EditCustomerController * editCustCtrl = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCustomerController"];
    editCustCtrl.isEdit = YES;
    editCustCtrl.customerDetailModel = _coustomerDetailModel;
    [self.navigationController pushViewController:editCustCtrl animated:YES];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section ==2) {
        return _orderArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomerDetailCellId forIndexPath:indexPath];
        cell.customerDetailModel = _coustomerDetailModel;
        return cell;
    }
    if (indexPath.section ==1) {
        AttBuildButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:attBuildButtonId forIndexPath:indexPath];
        [cell setPassEventBlock:^{
            SelectBuildController * selectVC = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectBuildController"];
            selectVC.customerId = _coustomerDetailModel.customer_id;
            [self.navigationController pushViewController:selectVC animated:YES];        }];
        return cell;
    }
    if (indexPath.section ==2) {
        AttBuildCell * cell  = [tableView dequeueReusableCellWithIdentifier:attBuildCellId forIndexPath:indexPath];
        cell.attBuildModel = _orderArray[indexPath.row];
        return cell;
    }
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UILabel * laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        laebl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        laebl.textColor = [UIColor colorWithWhite:1 alpha:1];
        laebl.font = [UIFont systemFontOfSize:12];
        laebl.text = @"已报备的楼盘";
        return laebl ;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        view.backgroundColor=  [UIColor  colorWithWhite:0.8 alpha:1];
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 60;
    }
    if (indexPath.section == 1) {
        return 30;
    }
    if (indexPath.section == 2) {
        return 60;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        SelectBuildController * selectVC = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectBuildController"];
        selectVC.customerId = _coustomerDetailModel.customer_id;
        [self.navigationController pushViewController:selectVC animated:YES];
    }
    if (indexPath.section == 2) {
        NSLog(@"报备详情");
    }
}
@end
