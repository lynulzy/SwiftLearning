//
//  BuildingDetailController.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BuildingDetailController.h"
#import "BuildDetailHeaderView.h"
#import "UIViewExt.h"
#import "Common.h"
#import "BuildingParamsController.h"
@interface BuildingDetailController (){
    BuildDetailHeaderView * _headerView;
    UIView * _footView;
}

@end

@implementation BuildingDetailController
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"楼盘详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.tableView.top = view.bottom;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BuildDetailHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = _headerView;
    [self _creatFootView];
    
}
- (void)_creatFootView{
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(10, 5, kScreenWidth-20, 30);
        [shareButton setTitle:@"分享楼盘" forState:UIControlStateNormal];
        shareButton.backgroundColor = [UIColor greenColor];
        [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:shareButton];
        
        UIButton * addCustomerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addCustomerButton.frame = CGRectMake(shareButton.frame.origin.x, shareButton.bottom+5, shareButton.width, shareButton.height);
        [addCustomerButton setTitle:@"报备客户" forState:UIControlStateNormal];
        addCustomerButton.backgroundColor = [UIColor greenColor];
        [addCustomerButton addTarget:self action:@selector(addCustomerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:addCustomerButton];
        
        UIButton * sendNews = [UIButton buttonWithType:UIButtonTypeCustom];
        sendNews.frame = CGRectMake(shareButton.frame.origin.x, addCustomerButton.bottom+5, shareButton.width, shareButton.height);
        [sendNews setTitle:@"发个帖子说说" forState:UIControlStateNormal];
        sendNews.backgroundColor = [UIColor greenColor];
        [sendNews addTarget:self action:@selector(sendNewsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:sendNews];
    
        UIButton * attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        attentionButton.frame = CGRectMake(shareButton.frame.origin.x, sendNews.bottom+5, shareButton.width, shareButton.height);
        [attentionButton setTitle:@"关注/取消关注" forState:UIControlStateNormal];
        attentionButton.backgroundColor = [UIColor greenColor];
        [attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:attentionButton];
    }
        self.tableView.tableFooterView = _footView;
    
}
- (void)shareAction:(UIButton *)button{

}
- (void)addCustomerAction:(UIButton *)button{
    
}
- (void)sendNewsAction:(UIButton *)button{
    
}
- (void)attentionAction:(UIButton *)button{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        BuildingParamsController * buildingParamsController = [[UIStoryboard storyboardWithName:@"Buliding" bundle:nil] instantiateViewControllerWithIdentifier:@"BuildingParamsController"];
        [self.navigationController pushViewController:buildingParamsController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}
@end
