//
//  BaseViewController.m
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "BaseViewController.h"
#import "Common.h"
#import "UIViewExt.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    self.navigationItem.backBarButtonItem = backBtn;

//    if (self.navigationController.viewControllers.count > 1) {
//        UIButton * backButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0, 0, 40, 40);
//        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(pushBackAction:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = item;
//    }
//
    // Do any additional setup after loading the view.
}
- (void)pushBackAction:(UIButton*)buton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)_creatRequsetData:(UIView *)view{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] initWithFrame:view.bounds];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-122)/2, (view.frame.size.height-122)/2-40, 122, 122)];
        _imgView.image = [UIImage imageNamed:@"没网.png"];
        [_baseView addSubview:_imgView];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, _imgView.bottom +10, 100, 20)];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.text = @"网络不给力啊~";
        [_baseView addSubview:_tipLabel];
        
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame =  CGRectMake((kScreenWidth-106)/2, _tipLabel.bottom+10, 106, 38);
        [_reloadButton setImage:[UIImage imageNamed:@"重新加载.png"] forState:UIControlStateNormal];
        [_baseView addSubview:_reloadButton];
        
        [view addSubview:_baseView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
