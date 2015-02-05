//
//  DemoController.m
//  HouseMananger
//
//  Created by 王晗 on 15/2/3.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "DemoController.h"
#import "Common.h"
#import "UIViewExt.h"
@interface DemoController (){
    UIView * _headerView;
}

@end

@implementation DemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initViews];
}
- (void)_initViews{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _headerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_headerView];
    
    UIImageView * imgView  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,kScreenWidth/2-20 , _headerView.height)];
    imgView.image = [UIImage imageNamed:@"20086191343254_2.jpg"];
    [_headerView addSubview:imgView];
    
    UILabel * buildNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, imgView.origin.y, 80, 30)];
    buildNameLabel.font = [UIFont systemFontOfSize:16];
    [_headerView addSubview:buildNameLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(buildNameLabel.origin.x, buildNameLabel.bottom+5, 60, 20)];
    priceLabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:priceLabel];
    
    UILabel * moneylabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right+10, priceLabel.origin.y, 60, 20)];
    moneylabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:moneylabel];
    
    UILabel * startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(buildNameLabel.origin.x, priceLabel.bottom +5, 80, 20)];
    startTimeLabel.font = [UIFont systemFontOfSize:14];
    [_headerView  addSubview:startTimeLabel];
    
    UILabel * cusCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(buildNameLabel.origin.x, startTimeLabel.bottom+5, 50, 20)];
    cusCountLabel.font = [UIFont systemFontOfSize:14];
    cusCountLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:cusCountLabel];
    
    UILabel * tipCusLabel = [[UILabel alloc] initWithFrame:CGRectMake(buildNameLabel.origin.x, cusCountLabel.bottom+3, 50, 20)];
    tipCusLabel.font = [UIFont systemFontOfSize:14];
    tipCusLabel.textAlignment = NSTextAlignmentCenter;
    tipCusLabel.text = @"意向客户" ;
    [_headerView addSubview:cusCountLabel];
    
    UILabel * spreateLabel = [[UILabel alloc] initWithFrame:CGRectMake(cusCountLabel.right+20, cusCountLabel.origin.y, 1, 45)];
    spreateLabel.backgroundColor = [UIColor grayColor];
    [_headerView addSubview:spreateLabel];
    
    UILabel * managerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(spreateLabel.right+20, cusCountLabel.origin.y, 50, 20)];
    managerCountLabel.font = [UIFont systemFontOfSize:14];
    managerCountLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:cusCountLabel];
    
    UILabel * tipManagerLabel = [[UILabel alloc] initWithFrame:CGRectMake(managerCountLabel.origin.x, managerCountLabel.bottom+3, 50, 20)];
    tipManagerLabel.font = [UIFont systemFontOfSize:14];
    tipManagerLabel.textAlignment = NSTextAlignmentCenter;
    tipManagerLabel.text = @"合作经纪人" ;
    [_headerView addSubview:cusCountLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
