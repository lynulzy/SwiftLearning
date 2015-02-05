//
//  MainTabBarController.m
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "MainTabBarController.h"
#import "Common.h"

#import "LoginDataController.h"
#import "SoftUpgradeDataController.h"
#import "UserDefaults.h"
#import "UserTmpParam.h"

#import "PushNotification.h"

#define TAG_ALERT_SOFT_UPGRADE          1001

@interface MainTabBarController ()
<
LoginDataControllerDelegate,
SoftUpgradeDataControllerDelegate,
UIAlertViewDelegate
>

@property(nonatomic, strong) LoginDataController *loginDC;
@property(nonatomic, strong) SoftUpgradeDataController *softUpgradeDC;

@end


@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TAB_BAR_COLOR;
    if (IOS7Later) {
        // TabBar 背景颜色  不透明
        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.translucent = NO;
    }

    // 字体颜色 选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0F], NSForegroundColorAttributeName : TAB_BAR_COLOR} forState:UIControlStateSelected];

    // 字体颜色 未选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0F],  NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    
    // 图标颜色
    self.tabBar.tintColor = TAB_BAR_COLOR;
    
    // TabBar 颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    [self createViewControllers];
    
    [self autoLogin];
    
    [self loadSoftUpgradeData];
}

#pragma mark - CreateVC
- (void)createViewControllers {
    // 非选中状态图标
    NSArray *normalImgsArr = @[@"first_item.png",
                               @"second_item.png",
                               @"third_item.png",
                               @"fourth_item.png"];
    // 选中状态图标
    NSArray *selectedImgsArr = @[@"first_item_selected.png",
                                 @"second_item_selected.png",
                                 @"third_item_selected.png",
                                 @"fourth_item_selected.png"];
    // Title
    NSArray *tbItemTitles = @[@"楼盘", @"客户", @"论坛", @"我"];
    
    // 各个 storyboard 的文件名
    NSArray *storyboardNames = @[@"Buliding", @"Customer", @"Talking", @"Mine"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<storyboardNames.count; i++) {
        
        // 1.取得故事板的文件名
        NSString *name = storyboardNames[i];
        
        // 2.创建故事板加载对象
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        
        // 3.加载故事板，获取故事板中箭头指向的控制器对象
        UIViewController *NC = [storyboard instantiateInitialViewController];

        // 4.设置 TabBar上 文字&图片
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:tbItemTitles[i]
                                                                 image:[UIImage imageNamed:normalImgsArr[i]]
                                                         selectedImage:[UIImage imageNamed:selectedImgsArr[i]]];
        // 5.添加到数组
        NC.tabBarItem = tabBarItem;
        [viewControllers addObject:NC];
    }
    
    self.viewControllers = viewControllers;
}

#pragma mark - Auto Login
- (void)autoLogin {
    if ([UserDefaults getPassword].length > 0 && [UserDefaults getUsername].length > 0) {
        
        NSString *theUserName = [UserDefaults getUsername];
        NSString *thePassWord = [UserDefaults getPassword];
        
        NSDictionary *params =
        [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                             theUserName,
                                             thePassWord, nil]
                                    forKeys:[NSArray arrayWithObjects:
                                             @"mobile",
                                             @"password", nil]];
        if (nil == self.loginDC) {
            self.loginDC = [[LoginDataController alloc] init];
            self.loginDC.delegate = self;
        }
        [self.loginDC makeLoginRequest:params];
    }
}
// 自动登录成功后 保存用户信息
- (void)saveUserInfo:(NSDictionary *)contentDict {
    if ([contentDict objectForKey:@"content"]) {
        NSDictionary *content = [contentDict objectForKey:@"content"];
        // 必须保存 的用户信息
        if ([content objectForKey:@"session"]&&
            [content objectForKey:@"user_id"]&&
            [content objectForKey:@"mobile"]) {
            [UserTmpParam setUserId:[content objectForKey:@"user_id"]];
            [UserTmpParam setMobile:[content objectForKey:@"mobile"]];
            [UserTmpParam setSession:[content objectForKey:@"session"]];
            [UserTmpParam setUserName:[content objectForKey:@"username"]];
            
            // 选择保存 的用户信息
            // 性别
            NSString *sex = [content objectForKey:@"sex"];
            if (0 < sex.length) {
                [UserTmpParam setUserSex:sex];
            }
            
            // 公司
            NSString *company = [content objectForKey:@"company"];
            if (0 < company.length) {
                [UserTmpParam setPortraitUrl:company];
            }
            
            // 头像
            NSString *portrait = [content objectForKey:@"portrait"];
            if (0 < portrait.length) {
                [UserTmpParam setPortraitUrl:portrait];
            }
            
            // 用户认证状态
            NSString *authStatus = [content objectForKey:@"authentication_status"];
            if (0 < authStatus.length) {
                [UserTmpParam setAuthenticationStatus:authStatus];
            }
            
            // 邀请人手机号
            NSString *invitation_people = [content objectForKey:@"invitation_people"];
            if (0 < invitation_people.length) {
                [UserTmpParam setInvitationPeople:invitation_people];
            }
        }
    } else {
        DDLog(@"保存登录信息失败!");
    }
}

- (void)onGetLoginReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    // 登录成功
    if (0 == receiveDict.count) {
        return;
    }
    [self saveUserInfo:receiveDict];
    [[PushNotification shareInstance] setAliasWithloginedUserID:receiveDict[@"content"][@"user_id"] session:nil];
}

- (void)onGetLoginFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    // 登录失败
}

#pragma mark - Soft upgrade
- (void)loadSoftUpgradeData {
    if (nil == self.softUpgradeDC) {
        self.softUpgradeDC = [[SoftUpgradeDataController alloc] init];
        self.softUpgradeDC.delegate = self;
    }
    [self.softUpgradeDC mrSoftUpgrade];
}

- (void)saveSoftUpgradeInfo:(NSDictionary *)dataDic {
    
    [UserTmpParam setNewVersionsTag:@"1"];
    [UserTmpParam setNewVersions:dataDic[@"soft_version"]];
    [UserTmpParam setNewVersionsDesc:dataDic[@"soft_desc"]];
    [UserTmpParam setNewVersionsForceUpdateTag:dataDic[@"force_update"]];
    [UserTmpParam setNewversionsURL:dataDic[@"soft_url"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (1 == buttonIndex && TAG_ALERT_SOFT_UPGRADE == alertView.tag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserTmpParam getNewVersionsURL]]];
        ;
    }
}

- (void)onGetSoftUpgradeReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
    NSDictionary *contentDic = receiveDict[@"content"];
    if (0 != [contentDic[@"has_new_ver"] boolValue]) {
        
        NSDictionary *newVerDic = contentDic[@"new_ver_result"];
        [self saveSoftUpgradeInfo:newVerDic];
        
        NSString *titleStr = [NSString stringWithFormat:@"发现新版本 %@", newVerDic[@"soft_version"]];
        NSString *newVerDesc = newVerDic[@"soft_desc"];
        if ([newVerDic[@"force_update"] isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:newVerDesc delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在升级", nil];
            alert.tag = TAG_ALERT_SOFT_UPGRADE;
            [alert show];
            
        }
        
        if ([newVerDic[@"force_update"] isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:newVerDesc delegate:self cancelButtonTitle:nil otherButtonTitles:@"升级", nil];
            alert.tag = TAG_ALERT_SOFT_UPGRADE;
            [alert show];
        }
    } else {
        [UserTmpParam setNewVersionsTag:@"0"];
    }
}

- (void)onGetSoftUpgradeFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {

}

@end
