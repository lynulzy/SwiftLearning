//
//  SelectBuildController.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/26.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "SelectBuildController.h"
#import "Common.h"
#import "MyDataService.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "UserTmpParam.h"
#import "AFHTTPRequestOperation.h"
#import "SelectBuildCell.h"
#import "SelectModel.h"
#import "CustomerViewController.h"
static NSString * selectBuildCellId = @"SelectBuildCell";
@interface SelectBuildController (){
    UITableView * _mainTabView;
    MBProgressHUD * _hud;
    NSMutableArray * _data;
    AFHTTPRequestOperation * _buildReqOpera;
    AFHTTPRequestOperation * _addCusToBuildOpera;
    SelectModel * _selectedModel;
}

@end

@implementation SelectBuildController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择楼盘";
    if (_mainTabView == nil ) {
            _mainTabView  =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    }
    _mainTabView.delegate = self;
    _mainTabView.dataSource = self;
    _mainTabView.tag = 200;
    _mainTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTabView registerNib:[UINib nibWithNibName:@"SelectBuildCell" bundle:nil] forCellReuseIdentifier:selectBuildCellId];
    [self.view addSubview:_mainTabView];
    [self _loadData];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //YES: 当前此控制器被push之后，隐藏UITabbarController对象上的UITabbar
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}
- (void)_loadData{
    _data = [NSMutableArray array];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{\"city_id\":\"%@\",\"customer_id\":\"%@\",\"user_id\":\"%@\",\"session\":\"%@\"}",[[NSUserDefaults  standardUserDefaults] objectForKey:@"cityId"],_customerId,[UserTmpParam getUserId],[UserTmpParam getSession]];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * buildReq = [[MyDataService alloc] init];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在加载..";
    [buildReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    _buildReqOpera = [buildReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"report_build_region" timeStamp:dataStr complection:^(id result) {
        _hud.hidden = YES;
        _hud = nil;
        for (NSDictionary * dic in [result objectForKey:@"content"]) {
            SelectModel * selectModel = [[SelectModel alloc] initWithDataDic:dic];
            [_data addObject:selectModel];
        }
        [_mainTabView reloadData];
    }];
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    _mainTabView.hidden = YES;
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }
    [self.reloadButton addTarget:self action:@selector(_loadData) forControlEvents:UIControlEventTouchUpInside];
}
- (void)_creatRightButton{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth-48, 32, 40, 20);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setFont:[UIFont systemFontOfSize:16]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(addCustomerReqAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBuildCell * cell = [tableView dequeueReusableCellWithIdentifier:selectBuildCellId forIndexPath:indexPath];
    cell.selectModel = _data[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _selectedModel = _data[indexPath.row];
    if ([_selectedModel.is_report integerValue] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定报备客户到%@",_selectedModel.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
}
#pragma mark  -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    if (buttonIndex == 1) {
        [self _addCusToBuildReq];
    }
}
- (void)_addCusToBuildReq{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{\"build_id\":\"%@\",\"customer_id\":\"%@\",\"user_id\":\"%@\",\"session\":\"%@\"}",_selectedModel.buildId,_customerId,[UserTmpParam getUserId],[UserTmpParam getSession]];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * addCusToBuildReq = [[MyDataService alloc] init];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在加载..";
    [addCusToBuildReq setFailureBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"报备失败,点击确定重新报备!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }];
    _addCusToBuildOpera = [addCusToBuildReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"report_customer" timeStamp:dataStr complection:^(id result) {
        _hud.hidden = YES;
        CustomerViewController * customerVC =  self.navigationController.viewControllers[0];
        customerVC.isReload = YES;
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",result);
    }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
