//
//  PrivacyPolicyViewController.m
//  StoreClient
//
//  Created by viki on 14-9-17.
//  Copyright (c) 2014年 mishi. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

#import "HTTPDefine.h"
#import "UIDefine.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController
@synthesize wv;

#pragma mark Load data & subViews -
- (void)loadData {
	
	if (nil !=  wv && [wv canGoBack]) {
		[wv removeFromSuperview];
		wv = nil;
	}
	
	wv = [[UIWebView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, size_width, size_height - 44.0F)];
	[self.view addSubview:wv];
	[wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_PRIVACY_POLICY]]];
}

- (void)loadSubViews {
	
//	if (IOS7Later) {
//		self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:NAV_TINT_R/255.0F green:NAV_TINT_G/255.0F blue:NAV_TINT_B/255.0F alpha:1.0F];
//		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//		[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//		self.navigationController.navigationBar.translucent = NO;
//	}
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:252/255.0
                                                                               green:184/255.0
                                                                                blue:39/255.0 alpha:1.0F];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
	
	self.navigationItem.title = @"用户协议";
}

#pragma mark Init data & subViews -
- (void)initData {
	
}

- (void)initSubViews {
	
	wv = [[UIWebView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, size_width, size_height - 44.0F)];
	[self.view addSubview:wv];
}

#pragma mark Init -
- (id)initWithFrame:(CGRect)theRect {
	
	if ((self = [super init])) {
		
		self.view.frame = theRect;
		self.view.backgroundColor = [UIColor whiteColor];
		
		[self initData];
		[self initSubViews];
	}
	
	return self;
}

- (void)dealloc {
	
	NSLog(@"PrivacyPolicyViewController dealloc");
	
	wv = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    DDLog(@"mmmm");
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
