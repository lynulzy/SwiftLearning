//
//  MineViewController.m
//  HouseMananger
//
//  Created by ZXH on 14-12-30.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "MineViewController.h"
#import "MineDataController.h"

#import "UserTmpParam.h"
#import "UserDefaults.h"
#import "MessageShow.h"
#import "UIImageView+WebCache.h"

#import "LoginViewController.h"         // 登录
#import "EditMyInfoViewController.h"    // 编辑个人资料

#import "RankViewController.h"          // 排行榜
#import "CommissionViewController.h"    // 我的佣金
#import "BulidingViewController.h"      // 关注的楼盘
#import "CustomerAFViewController.h"    // 已报备客户

#import "MyNewsViewController.h"        // 我的消息
#import "UserSuggestViewController.h"   // 用户反馈
#import "SoftUpgradeViewController.h"   // 版本更新与帮助

#import "APortrait.h"

#define kHeadIconWidth                  75.0F           // 头像宽度
#define kNameLabHeight                  35.0F           // 用户姓名Label高度
#define kCompanyLabHeight               25.0F           // 公司名称
#define kInfoViewHeight                 (75 + 35 + 25)  // 用户信息托盘
#define kBtnViewHeight                  80.0F           // 几个按钮的托盘
#define kBtnWidth                       (80 - 40)
#define kPersonalImgHeight              ((75 + 35 + 25) + 80) // 以上几项的托盘

#define TAG_CONTROL_BEGIN               2000

#define kHeightForRow                   45.0F      // Cell height

#define TAG_ALERT_CLEARCACHE            1001

@interface MineViewController ()<
UITableViewDataSource,
UITableViewDelegate,
MineDataControllerDelegate,
NSURLConnectionDataDelegate
>
{
    MineDataController *_mineDC;
    
    CGFloat topHeight;
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *topBackIV;
@property(nonatomic, strong) UIImageView *headIcon;
@property(nonatomic, strong) UILabel *userNameLab;
@property(nonatomic, strong) UILabel *companyLab;
@property(nonatomic, strong) UILabel *goLoginLab;

@property(nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MineViewController

- (void)dealloc {
    DDLog(@"MineViewController dealloc")
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.translucent = YES;

    [self updateTopView];
}

// Update top view
- (void)updateTopView {
    if ([self isLogin]) {
        self.userNameLab.hidden = NO;
        self.companyLab.hidden = NO;
        self.goLoginLab.hidden = YES;
        
        if ([APortrait isExist]) {
            
            self.headIcon.image = [APortrait getThePortrait];
        } else if (0 != [UserTmpParam getPortraitUrl].length){
            
            dispatch_queue_t t2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(t2, ^{
                NSURL *reqURL = [NSURL URLWithString:[UserTmpParam getPortraitUrl]];
                NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:reqURL];
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
                [APortrait saveThePortrait:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.headIcon.image = [APortrait getThePortrait];
                });
            });
        } else {
            
            self.headIcon.image = [UIImage imageNamed:@"Head_Icon_Local.png"];
        }
    } else {
        self.userNameLab.hidden = YES;
        self.companyLab.hidden = YES;
        self.goLoginLab.hidden = NO;
        self.headIcon.image = [UIImage imageNamed:@"Head_Icon_Local.png"];
    }
    
    self.userNameLab.text = [UserTmpParam getUserName];
    
    if (0 < [UserTmpParam getCompanyName].length) {
        self.companyLab.text = [UserTmpParam getCompanyName];
    } else {
        self.companyLab.text = @"暂无加入公司";
    }
}

// 判断是否为已登录状态
- (BOOL)isLogin {
    
    if ([UserTmpParam getUserId].length == 0 || [UserTmpParam getSession].length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IOS7Later) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"";
    
    // NavgationBar 透明
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self loadData];
    [self loadSubviews];
}

- (void)loadData {
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"myInfoPage" ofType:@"plist"];
    self.dataSource = [NSMutableArray arrayWithContentsOfFile:path];
}

- (void)loadSubviews {
    
    // 设置到 Push 到下一页后 的返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;

    CGFloat tableHeight = size_height - 49 + 20;
    if (IOS7) {
        topHeight = kPersonalImgHeight + 64;
    }
    if (IOS8Later) {
        topHeight = kPersonalImgHeight;
    }
    // TableView
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, size_width, tableHeight) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0F green:243/255.0F blue:241/255.0F alpha:1.0F];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topHeight, 0, 0, 0);
    DDLog(@"%f", self.tableView.contentOffset.y)
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mineCellIdentifier"];
    
    // Top view
    [self loadTopView];
}

- (void)loadTopView {
    
    // 背景图片
    self.topBackIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_back.png"]];
    self.topBackIV.frame = CGRectMake(0, -topHeight, self.view.frame.size.width, topHeight);
    [self.tableView addSubview:self.topBackIV];
    self.topBackIV.userInteractionEnabled = YES;
    
    // 用户信息内容托盘
    UIView *infoView = [[UIView alloc] init];
//    infoView.backgroundColor = [UIColor brownColor];
    infoView.frame = CGRectMake(0, -kPersonalImgHeight, size_width, kInfoViewHeight);
    [self.tableView addSubview:infoView];
    
    // UIControl
    UIControl *infoViewControl = [[UIControl alloc] initWithFrame:infoView.bounds];
    [infoViewControl addTarget:self
                        action:@selector(tapHeaderView)
              forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:infoViewControl];

    // Head icon
    self.headIcon = [[UIImageView alloc] init];
    self.headIcon.frame = CGRectMake((size_width - kHeadIconWidth)/2,
                                     0,
                                     kHeadIconWidth,
                                     kHeadIconWidth);
    self.headIcon.image = [UIImage imageNamed:@"Head_Icon_Local.png"];
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = self.headIcon.frame.size.height/2;
    self.headIcon.layer.borderColor = [[UIColor colorWithWhite:1 alpha:1] CGColor];
    self.headIcon.layer.borderWidth = 2;
    [infoView addSubview:self.headIcon];
    
    // 右箭头
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.frame = CGRectMake(size_width - 40, (kInfoViewHeight - 35)/2, 17, 35);
    rightArrow.image = [UIImage imageNamed:@"myInfo_arrow.png"];
    [infoView addSubview:rightArrow];
    
    // User name
    self.userNameLab = [[UILabel alloc] init];
    self.userNameLab.frame = CGRectMake(40,
                                        kHeadIconWidth,
                                        (size_width - 80),
                                        kNameLabHeight);
    self.userNameLab.font = [UIFont boldSystemFontOfSize:20.0F];
    self.userNameLab.textColor = [UIColor whiteColor];
    self.userNameLab.textAlignment = NSTextAlignmentCenter;
//    self.userNameLab.backgroundColor = [UIColor blackColor];
    [infoView addSubview:self.userNameLab];
    
    // My company
    self.companyLab = [[UILabel alloc] init];
    self.companyLab.frame = CGRectMake(40,
                                       kHeadIconWidth + kNameLabHeight,
                                       (size_width - 80),
                                       kCompanyLabHeight);
    self.companyLab.font = [UIFont boldSystemFontOfSize:14.0F];
    self.companyLab.textColor = [UIColor whiteColor];
    self.companyLab.textAlignment = NSTextAlignmentCenter;
    self.companyLab.numberOfLines = 0;
    [infoView addSubview:self.companyLab];
    
    // Label 登录/注册
    self.goLoginLab = [[UILabel alloc] init];
    self.goLoginLab.frame = CGRectMake(40,
                                       kHeadIconWidth + 15,
                                       (size_width - 80),
                                       kNameLabHeight);
    self.goLoginLab.font = [UIFont boldSystemFontOfSize:19.0F];
    self.goLoginLab.textColor = [UIColor whiteColor];
    self.goLoginLab.textAlignment = NSTextAlignmentCenter;
    self.goLoginLab.text = @"登录/注册";
    [infoView addSubview:self.goLoginLab];
    
    // 横排按钮
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -kBtnViewHeight, size_width, kBtnViewHeight)];
    btnBackView.userInteractionEnabled = YES;
    [self.tableView addSubview:btnBackView];
    
    NSArray *imageName = @[@"mine_commission.png",
                           @"mine_att_building.png",
                           @"mine_customer.png",
                           @"mine_experience.png"];
    NSArray *titleArr = @[@"我的佣金",
                          @"关注的楼盘",
                          @"已报备的客户",
                          @"经验值"];
    NSInteger btnCount = imageName.count;
    for (NSInteger i = 0; i < btnCount; i++) {
        
        // 托盘 View
        CGFloat palletWidth = size_width/btnCount;
        UIView *pallet = [[UIView alloc] initWithFrame:CGRectMake(0 + i * palletWidth,
                                                                  0,
                                                                  palletWidth,
                                                                  kBtnViewHeight)];
        pallet.userInteractionEnabled = YES;
        [btnBackView addSubview:pallet];
        
        // UIControl
        UIControl *control = [[UIControl alloc] initWithFrame:pallet.bounds];
        [control addTarget:self action:@selector(tapTheControl:) forControlEvents:UIControlEventTouchUpInside];
        control.tag = TAG_CONTROL_BEGIN + i;
        [pallet addSubview:control];
        
        // ImageIcon
        UIImageView *btnIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName[i]]];
        btnIcon.frame = CGRectMake((palletWidth - kBtnWidth)/2, 10, kBtnWidth, kBtnWidth);
        [pallet addSubview:btnIcon];
        
        // TitleLab
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      10 + kBtnWidth ,
                                                                      palletWidth,
                                                                      30)];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont boldSystemFontOfSize:13.0F];
        titleLab.text = titleArr[i];
        [pallet addSubview:titleLab];
        
//        // 竖线
//        if (i < 2) {
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(palletWidth - 0.3, 15, 0.3, kBtnViewHeight - 30)];
//            lineView.backgroundColor = [UIColor whiteColor];
//            [pallet addSubview:lineView];
//        }
    }
}

- (void)tapTheControl:(UIControl *)control {
    if (0 == control.tag - TAG_CONTROL_BEGIN) {
        if (![self isLogin]) {
            [self goToLogin];
        } else {
            CommissionViewController *commissionVC = [[CommissionViewController alloc] init];
            commissionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commissionVC animated:YES];
        }
    }
    
    if (1 == control.tag - TAG_CONTROL_BEGIN) {
        if (![self isLogin]) {
            [self goToLogin];
        } else {
            BulidingViewController *buildingVC = [[UIStoryboard storyboardWithName:@"Buliding" bundle:nil] instantiateViewControllerWithIdentifier:@"BulidingViewController"];
            buildingVC.isAttentionBuilding = YES;
            buildingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:buildingVC animated:YES];
        }
    }
    
    if (2 == control.tag - TAG_CONTROL_BEGIN) {
        if (![self isLogin]) {
            [self goToLogin];
        } else {
            CustomerAFViewController *customerAFVC = [[CustomerAFViewController alloc] init];
            customerAFVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:customerAFVC animated:YES];
        }
    }
    
    if (3 == control.tag - TAG_CONTROL_BEGIN) {
        if (![self isLogin]) {
            [self goToLogin];
        } else {
            
        }
    }
}

// Tap top view
- (void)tapHeaderView {
    if ([self isLogin]) {
        DDLog(@"个人资料")
        EditMyInfoViewController *editMyInfoVC = [[EditMyInfoViewController alloc] init];
        editMyInfoVC.hidesBottomBarWhenPushed=  YES;
        [self.navigationController pushViewController:editMyInfoVC animated:YES];
    } else {
        [self goToLogin];
    }
}

// Top view 下拉拉长效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kPersonalImgHeight) {
        CGRect f = self.topBackIV.frame;
        f.origin.y = yOffset;
        f.size.height = fabsf(yOffset);
        self.topBackIV.frame = f;
    }
}

// Go to login
- (void)goToLogin {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
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

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightForRow;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.dataSource objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCellIdentifier"];

    NSDictionary *cellData = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [cellData objectForKey:@"title"];
    
    if ([cellData objectForKey:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *optionDict = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *titleString = [optionDict objectForKey:@"title"];
    
    if ([titleString isEqualToString:@"排行榜"]) {
        if (![self isLogin]) {
            [self goToLogin];
        } else {
            RankViewController *rankVC = [[RankViewController alloc] init];
            rankVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rankVC animated:YES];
        }
    }
        
    if ([titleString isEqualToString:@"我的消息"]) {
        if (![self isLogin]) {
            [self goToLogin];
        } else {
            MyNewsViewController *myNewVC = [[MyNewsViewController alloc] init];
            myNewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myNewVC animated:YES];
        }
    }
    
    if ([titleString isEqualToString:@"用户反馈"]) {
        UserSuggestViewController *userSuggestVC = [[UserSuggestViewController alloc] init];
        userSuggestVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userSuggestVC animated:YES];
    }
    
    if ([titleString isEqualToString:@"清空缓存"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"清空缓存能帮助节省您的内存空间" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"好的", nil];
        alertView.tag = TAG_ALERT_CLEARCACHE;
        [alertView show];
    }
    
    if ([titleString isEqualToString:@"版本更新与帮助"]) {
        SoftUpgradeViewController *softUpgradeVC = [[SoftUpgradeViewController alloc] init];
        softUpgradeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:softUpgradeVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 清除缓存提示
    if (TAG_ALERT_CLEARCACHE == alertView.tag) {
        
        if (1 == buttonIndex) {
            [self clearCache];
        }
    }
}

#pragma mark - 清除缓存
- (void)clearCache {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    __block NSString *folderSize = [self folderSizeStringAtPath:cachePath];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        for (NSString *aFileName in files) {
            NSError *error;
            NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",aFileName]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        //回到主线程更新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSString *usage = [NSString stringWithFormat:@"太棒了！减掉%@空间",folderSize];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"瘦身成功！"
                                                            message:usage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    });
}

- (NSString *)folderSizeStringAtPath:(NSString*)filePath {
    
    float size=[self folderSizeAtPath:filePath];
    NSString *fileSizeString=[NSString stringWithFormat:@"%.02f%@",[self calculateFileSizeInUnit:size],[self calculateUnit:size]];
    return fileSizeString;
}

// 获取文件夹大小
- (float)calculateFileSizeInUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3))
        return (float) (contentLength / (float)pow(1024, 3));
    else if(contentLength >= pow(1024, 2))
        return (float) (contentLength / (float)pow(1024, 2));
    else if(contentLength >= 1024)
        return (float) (contentLength / (float)1024);
    else
        return (float) (contentLength);
}

- (float)folderSizeAtPath:(NSString*) folderPath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

- (NSString *)calculateUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3))
        return @"GB";
    else if(contentLength >= pow(1024, 2))
        return @"MB";
    else if(contentLength >= 1024)
        return @"KB";
    else
        return @"Bytes";
}

- (long long)fileSizeAtPath:(NSString*) filePath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - Sign Out
- (void)onGetSoftUpgradeReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {

}

- (void)onGetSoftUpgradeFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {

}

@end
