//
//  SoftUpgradeViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/21.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "SoftUpgradeViewController.h"
#import "SoftUpgradeDataController.h"

#import "Param.h"
#import "UserTmpParam.h"

#define kHeaderViewHeight               150.0F
#define kHeaderIconWidth                100.0F
#define kHeightForRow                   40.0F      // Cell height
#define kVersionsLabWidth               200.0F

#define TAG_VERSIONS_TAG                1001
#define TAG_ALERT_SOFT_UPGRADE          1002

@interface SoftUpgradeViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
SoftUpgradeDataControllerDelegate
>
{
    SoftUpgradeDataController *_softUpgradeDC;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SoftUpgradeViewController

- (void)viewWillAppear:(BOOL)animated {
    
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
    self.navigationItem.title = @"版本更新与帮助";
    
    
    if (0 == [UserTmpParam getNewVersionsTag].length || nil == [UserTmpParam getNewVersionsTag]) {
        [self loadVersionsData];
    }
    
    [self loadData];
    [self loadSubviews];
}

- (void)loadData {
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"softUpgrade" ofType:@"plist"];
    self.dataSource = [NSMutableArray arrayWithContentsOfFile:path];
}

- (void)loadVersionsData {
    if (nil == _softUpgradeDC) {
        _softUpgradeDC = [[SoftUpgradeDataController alloc] init];
        _softUpgradeDC.delegate = self;
    }
    [_softUpgradeDC mrSoftUpgrade];
}

- (void)loadSubviews {
    // push到下一页后 的返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    // HeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size_width, kHeaderViewHeight)];
    headerView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:headerView];
    
    UILabel *versionsLab = [[UILabel alloc] initWithFrame:CGRectMake((size_width - kVersionsLabWidth)/2, 80, kVersionsLabWidth, 60)];
    versionsLab.tag = TAG_VERSIONS_TAG;
    versionsLab.text = [NSString stringWithFormat:@"当前版本：%@", [Param getVersion]];
    versionsLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:versionsLab];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, size_width, 100) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    self.headIcon = [[UIImageView alloc] init];
//    self.headIcon.frame = CGRectMake((size_width - kHeaderIconWidth)/2, (kHeaderViewHeight - kHeaderIconWidth)/2, kHeaderIconWidth, kHeaderIconWidth);
//    self.headIcon.image = [UIImage imageNamed:@"Head_Icon_Local.png"];
//    self.headIcon.layer.masksToBounds = YES;
//    self.headIcon.layer.cornerRadius = self.headIcon.frame.size.height/2;
//    self.headIcon.layer.borderColor = [[UIColor colorWithWhite:1 alpha:1] CGColor];
//    self.headIcon.layer.borderWidth = 2;
//    [tableHeader addSubview:self.headIcon];
}

// 保存 新版本信息
- (void)saveSoftUpgradeInfo:(NSDictionary *)dataDic {
    
    [UserTmpParam setNewVersionsTag:@"1"];
    [UserTmpParam setNewVersions:dataDic[@"soft_version"]];
    [UserTmpParam setNewVersionsDesc:dataDic[@"soft_desc"]];
    [UserTmpParam setNewVersionsForceUpdateTag:dataDic[@"force_update"]];
    [UserTmpParam setNewversionsURL:dataDic[@"soft_url"]];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightForRow;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.dataSource objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SoftUpgradeCell = @"SoftUpgradeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SoftUpgradeCell];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SoftUpgradeCell];
    }
    
    NSDictionary *cellData = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [cellData objectForKey:@"title"];
    
    if ([cellData objectForKey:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if([[cellData objectForKey:@"title"] isEqualToString:@"版本更新"]) {
        
        if ([[UserTmpParam getNewVersionsTag] isEqualToString:@"1"]) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"发现新版本 %@", [UserTmpParam getNewVersions]];
            cell.detailTextLabel.textColor = [UIColor redColor];
            
        } else if ([[UserTmpParam getNewVersionsTag] isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"已是最新版";
        } else {
            cell.detailTextLabel.text = @"正在检测...";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *optionDict = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *titleStr = [optionDict objectForKey:@"title"];
    
    if ([titleStr isEqualToString:@"版本更新"]) {
        // 判断是否有更新
        // 是
        if (0 == ![UserTmpParam getNewVersionsTag].length &&
            [[UserTmpParam getNewVersionsTag] isEqualToString:@"1"]) {
            NSString *alertTitle = [NSString stringWithFormat:@"发现新版本 %@", [UserTmpParam getNewVersions]];
            // 判断是否是强制更新
            // 否
            if ([[UserTmpParam getNewVersionsForceUpdateTag] isEqualToString:@"0"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[UserTmpParam getNewVersionsDesc] delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在升级", nil];
                alert.tag = TAG_ALERT_SOFT_UPGRADE;
                [alert show];
            }
            // 是
            if ([[UserTmpParam getNewVersionsForceUpdateTag] isEqualToString:@"1"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[UserTmpParam getNewVersionsDesc] delegate:self cancelButtonTitle:nil otherButtonTitles:@"现在升级", nil];
                alert.tag = TAG_ALERT_SOFT_UPGRADE;
                [alert show];
            }
        }
        
        // 否
        if (0 == ![UserTmpParam getNewVersionsTag].length &&
            [[UserTmpParam getNewVersionsTag] isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已是最新版" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            alert.tag = TAG_ALERT_SOFT_UPGRADE;
            [alert show];
        }
    }
    
    if ([titleStr isEqualToString:@"帮助"]) {
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DDLog(@"%ld", (long)buttonIndex);
    if (1 == buttonIndex && TAG_ALERT_SOFT_UPGRADE == alertView.tag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserTmpParam getNewVersionsURL]]];
        ;
    }
}

#pragma mark - SoftUpgradeDataControllerDelegate
- (void)onGetSoftUpgradeReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
    
    NSDictionary *contentDic = receiveDict[@"content"];
    if (0 != [contentDic[@"has_new_ver"] boolValue]) {
        
        NSDictionary *newVerDic = contentDic[@"new_ver_result"];
        [self saveSoftUpgradeInfo:newVerDic];
        
        NSString *titleStr = [NSString stringWithFormat:@"发现新版本 %@", newVerDic[@"soft_version"]];
        NSString *newVerDesc = newVerDic[@"soft_desc"];
        if ([newVerDic[@"force_update"] isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:newVerDesc delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在升级", nil];
            [alert show];
            
        }
        
        if ([newVerDic[@"force_update"] isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:newVerDesc delegate:self cancelButtonTitle:nil otherButtonTitles:@"升级", nil];
            [alert show];
        }
    } else {
        [UserTmpParam setNewVersionsTag:@"0"];
    }
    
    [self.tableView reloadData];
}

- (void)onGetSoftUpgradeFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    
}

@end
