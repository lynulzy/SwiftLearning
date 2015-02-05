//
//  PrivacyPolicyViewController.m
//  StoreClient
//
//  Created by ZXH on 14-9-17.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

#import "HTTPDefine.h"
#import "UIDefine.h"

@interface PrivacyPolicyViewController ()

@property(nonatomic, strong)UIWebView *webView;

@end


@implementation PrivacyPolicyViewController

- (void)dealloc {
    DDLog(@"PrivacyPolicyViewController dealloc");
}

- (void)loadSubViews {
    if (nil !=  self.webView && [self.webView canGoBack]) {
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, size_width, size_height - 44.0F)];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_PRIVACY_POLICY]]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.view.backgroundColor = BACK_COLOR;
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"用户协议";
    
    [self loadSubViews];
}

- (void)didReceiveMemoryWarning {
    
	[super didReceiveMemoryWarning];
}

@end
