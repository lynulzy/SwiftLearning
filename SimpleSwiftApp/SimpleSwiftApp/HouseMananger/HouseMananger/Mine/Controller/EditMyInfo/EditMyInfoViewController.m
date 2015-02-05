//
//  EditMyInfoViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/6.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "EditMyInfoViewController.h"

#import "EditMyInfoDataController.h"

#import "UserTmpParam.h"
#import "UserDefaults.h"
#import "MessageShow.h"
#import "APortrait.h"
#import "MD5.h"

#define TAG_EDIT_NAME_ALERT          1000
#define TAG_ALERT_SIGN_OUT           1001
#define kTableHeaderHeight           150.0F
#define kHeaderIconWidth             100.0F
#define kHeightForRow                40.0F      // Cell height

@interface EditMyInfoViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
EditMyInfoDataControllerDelegate
>
{
    EditMyInfoDataController *_editMyInfoDC;
    NSString *_newNameStr;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UIImageView *headIcon;
@property(nonatomic, strong) NSData *imageData;

@end

@implementation EditMyInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    if ([APortrait isExist]) {
        self.headIcon.image = [APortrait getThePortrait];
    } else {
        self.headIcon.image = [UIImage imageNamed:@"Head_Icon_Local.png"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"个人资料";
    
    [self loadData];
    [self loadSubviews];
}

- (void)loadData {
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"editMyInfoPage" ofType:@"plist"];
    self.dataSource = [NSMutableArray arrayWithContentsOfFile:path];
}

- (void)loadSubviews {
    
    // push到下一页后 的返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height - 44) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size_width, kTableHeaderHeight)];
    self.tableView.tableHeaderView = tableHeader;
    
    // 头像
    self.headIcon = [[UIImageView alloc] init];
    self.headIcon.frame = CGRectMake((size_width - kHeaderIconWidth)/2, (kTableHeaderHeight - kHeaderIconWidth)/2, kHeaderIconWidth, kHeaderIconWidth);
    self.headIcon.image = [UIImage imageNamed:@"Head_Icon_Local.png"];
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = self.headIcon.frame.size.height/2;
    self.headIcon.layer.borderColor = [[UIColor colorWithWhite:1 alpha:1] CGColor];
    self.headIcon.layer.borderWidth = 2;
    [tableHeader addSubview:self.headIcon];
}
// 修改姓名
- (void)editUserWith:(NSString *)newName {
    NSDictionary *params = @{@"username" : newName};
    
    if (nil == _editMyInfoDC) {
        _editMyInfoDC = [[EditMyInfoDataController alloc] init];
        _editMyInfoDC.delegate = self;
    }
    
    [_editMyInfoDC mrEditUser:params];
}

// Sign out
- (void)signOut {
    
    if (nil == _editMyInfoDC) {
        _editMyInfoDC = [[EditMyInfoDataController alloc] init];
        _editMyInfoDC.delegate = self;
    }
    [_editMyInfoDC mrSignOut];
}

// 上传头像
- (void)editPortrait:(NSData *)imageData {
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArr addObject:imageData];
    NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:dataArr];
    
    NSDictionary *params = @{@"portrait" : theData};
    if (nil == _editMyInfoDC) {
        _editMyInfoDC = [[EditMyInfoDataController alloc] init];
        _editMyInfoDC.delegate = self;
    }
    
    [_editMyInfoDC mrEditPortrait:params];
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)btnIndex {
    DDLog(@"%ld", (long)btnIndex)
    if(0 == btnIndex) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
            [MessageShow showMessageView:MESSAGE_TYPE_ERROR code:0 msg:@"请检查摄像头" autoClose:1 time:1.3];
        }
    }
    
    if (1 == btnIndex) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        UIImage *photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        self.imageData = UIImageJPEGRepresentation(photoImage, 0.2);
        [self editPortrait:self.imageData];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:0];
}

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
    
    static NSString *EditMyInfoCell = @"EditMyInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EditMyInfoCell];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EditMyInfoCell];
    }
    
    NSDictionary *cellData = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [cellData objectForKey:@"title"];

    if ([cellData objectForKey:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if([[cellData objectForKey:@"title"] isEqualToString:@"修改姓名"]) {
    
        cell.detailTextLabel.text = [UserTmpParam getUserName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *optionDict = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *titleStr = [optionDict objectForKey:@"title"];
    
    
    if ([titleStr isEqualToString:@"修改头像"]) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                              initWithTitle:@"请选择图片来源"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"拍照",@"手机相册", nil];
        
        [myActionSheet showInView:self.view];
    }
    
    if ([titleStr isEqualToString:@"修改姓名"]) {
        UIAlertView *editNameAlert = [[UIAlertView alloc]
                                      initWithTitle:@"修改姓名"
                                      message:@"填写真实姓名，赚取更多佣金！"
                                      delegate:self cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确认修改", nil];
        editNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        editNameAlert.tag = TAG_EDIT_NAME_ALERT;
        [editNameAlert show];
    }
    
    if ([titleStr isEqualToString:@"退出登录"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"退出登录之后，下次打开软件将不会自动登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认退出", nil];
        alertView.tag = TAG_ALERT_SIGN_OUT;
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DDLog(@"%ld", buttonIndex);
    if (TAG_EDIT_NAME_ALERT == alertView.tag) {
        if (1 == buttonIndex) {
            UITextField *nameTF = [alertView textFieldAtIndex:0];
            _newNameStr = nameTF.text;
            [self editUserWith:nameTF.text];
        }
    }
    
    // 退出登录提示
    if (TAG_ALERT_SIGN_OUT == alertView.tag) {
        if (1 == buttonIndex) {
            [self signOut];
        }
    }
}

#pragma mark - EditMyInfoDataControllerDelegate
// 修改头像
- (void)onGetEditPortraitReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
    [UserTmpParam setPortraitUrl:receiveDict[@"content"][@"portrait"]];
    
    [APortrait saveThePortrait:self.imageData];
    
    self.headIcon.image = [UIImage imageWithData:self.imageData];
}

- (void)onGetEditPortraitFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {

}

// 修改姓名
- (void)onGetEditUserReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = _newNameStr;
    
    [UserTmpParam setUserName:_newNameStr];
}

- (void)onGetEditUserFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {

}

// 退出登录
- (void)onGetSignOutReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {

    [MessageShow showMessageView:MESSAGE_TYPE_OK code:0 msg:@"退出成功" autoClose:1 time:1.5f];
    [UserTmpParam clearLoginData];
//    [UserDefaults setUsername:@""];
    [UserDefaults setPassword:@""];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onGetSignOutFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR code:error.code msg:@"退出失败!" autoClose:1 time:1.5f];
}

@end
