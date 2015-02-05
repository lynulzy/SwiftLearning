//
//  PublishViewController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/22.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "PublishViewController.h"

#import "PublishDataController.h"
#import "Define.h"
#import "TheAssetPickerController.h"
#import "MessageShow.h"

#define PicLength                       60.0F
#define PicSize                         CGSizeMake(PicLength, PicLength)
#define kMaximumPicCount                6
#define kMaximumCharacterCount          150

#define TAG_PIC_BEGIN           1000
#define TAG_BTN_BEGIN           2000
#define TAG_BG_SCROLLVIEW       8000
#define TAG_ACTION_SHEET        7000
#define TAG_ALERT_QUIT          9000

#define HEIGHT_TextView         120

@interface PublishViewController ()
<
UITextViewDelegate,
TheAssetPickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UIScrollViewDelegate,
PublishDataControllerDelegate,
UIAlertViewDelegate
>
{
    BOOL isCamera;// 相机
    int columns;// 列
    float minimumInteritemSpacing;// 图片与图片之的间隙
    float minimumLineSpacing;// 每行之间的间隙
}
@property(nonatomic, strong) UIScrollView *bgScrollView;
@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UITextView *theTextView;
@property(nonatomic, strong) UILabel *placeLabel;
@property(nonatomic, strong) UILabel *characterCountLab;

@property(nonatomic, strong) UIButton *addPicBtn;
@property(nonatomic, strong) UIView *picBgView;

@property(nonatomic, strong) NSMutableArray *assetsArray;
@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) PublishDataController *publishDC;
@property(nonatomic, copy) NSString *latitude;
@property(nonatomic, copy) NSString *longitude;

@end

@implementation PublishViewController

- (void)dealloc {
    DDLog(@"PublishViewController Dealloc")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR_DARK;
    
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"发帖";
    isCamera = NO;
    self.assetsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    minimumInteritemSpacing = 2;
    minimumLineSpacing = 2;
    columns = floor((size_width - 10 - 10) / (PicLength + minimumInteritemSpacing));
    [self loadSubViews];
}

- (void)loadSubViews {
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleBordered) target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // scrollView窗口
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height - 44)];
    self.bgScrollView.contentSize = CGSizeMake(size_width, size_height - 40);
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = BACK_COLOR_DARK;
    self.bgScrollView.userInteractionEnabled = YES;
    self.bgScrollView.tag = TAG_BG_SCROLLVIEW;
    [self.view addSubview:self.bgScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyBoard)];
    [self.bgScrollView addGestureRecognizer:tap];
    
    // TextView
    self.theTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, size_width - 10, HEIGHT_TextView)];
    self.theTextView.delegate = self;
    self.theTextView.font = [UIFont systemFontOfSize:16.0F];
    self.theTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.theTextView];
    
    // characterCountLab
    self.characterCountLab = [[UILabel alloc] initWithFrame:CGRectMake(self.theTextView.frame.size.width - 50, self.theTextView.frame.size.height - 15, 50, 15)];
    self.characterCountLab.textAlignment = NSTextAlignmentCenter;
    self.characterCountLab.font = [UIFont systemFontOfSize:12.0F];
    self.characterCountLab.textColor = [UIColor lightGrayColor];
    [self.theTextView addSubview:self.characterCountLab];
    
    // PlaceHolder
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    self.placeLabel.backgroundColor = [UIColor clearColor];
    self.placeLabel.text = @" 说点什么吧...";
    self.placeLabel.font = [UIFont systemFontOfSize:16.0];
    self.placeLabel.textAlignment = NSTextAlignmentLeft;
    [self.theTextView addSubview:self.placeLabel];
    
    // 图片 背景View
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(5,
                                                           self.theTextView.frame.origin.y + HEIGHT_TextView + 5,
                                                           size_width - 10,
                                                           PicLength + 10)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    // 添加照片按钮
    self.addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addPicBtn.frame = CGRectMake(5, 5, PicLength, PicLength);
    [self.addPicBtn setBackgroundImage:[UIImage imageNamed:@"Add_Pic_Btn.png"] forState:UIControlStateNormal];
    [self.addPicBtn addTarget:self action:@selector(addPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.addPicBtn];
}

- (void)leftItemClick {
    DDLog(@"self.imageArray.count = %ld",self.imageArray.count);
    if (![self.theTextView.text isEqualToString:@""] || self.imageArray.count != 0) {
        
        UIAlertView *quitAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"您要放弃当前编辑的内容吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        quitAlert.tag = TAG_ALERT_QUIT;
        [quitAlert show];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightItemClick {
    DDLog(@"发帖！ 发帖！")
    if ([self.theTextView.text isEqualToString:@""]) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"文字内容不能为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [theAlert show];
        return;
    }
    if (self.theTextView.text.length > 150) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多输入150个字" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [theAlert show];
        return;
    }
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIImage *image in self.imageArray) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        [dataArr addObject:imageData];
    }
    
    NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:dataArr];
    
    NSDictionary *params = @{@"content"     : [self.theTextView text],
                             @"fname[]"     : theData,
                             @"build_id"    : self.buildID};
    // Send request
    if (nil == self.publishDC) {
        self.publishDC = [[PublishDataController alloc] init];
        self.publishDC.delegate = self;
    }
    [MessageShow showMessageView:MESSAGE_TYPE_WAITING code:0 msg:@"正在提交..." autoClose:1 time:15.0F];
    [self.publishDC mrPublishQuestion:params];
}

- (void)tapHideKeyBoard {
    [self.theTextView resignFirstResponder];
}

// 添加图片按钮 点击事件
-(void)addPicBtnClick:(UIButton *)btn {
    
    [self.theTextView resignFirstResponder];
    
    if (self.imageArray.count < kMaximumPicCount) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                              initWithTitle:nil
                              delegate:self
                              cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"拍照",@"手机相册", nil];
        myActionSheet.tag = TAG_ACTION_SHEET;
        [myActionSheet showInView:self.view];
    } else {
        NSString *msg = [NSString stringWithFormat:@"最多添加%d张图片", kMaximumPicCount];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [theAlert show];
    }
}

// 照相
- (void)takePhoto {
    isCamera = YES;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *theCamera = [[UIImagePickerController alloc]init];
        theCamera.delegate = self;
        //设置拍照后的图片可否被编辑
        theCamera.allowsEditing = NO;
        theCamera.sourceType = sourceType;
        [theCamera setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [self presentViewController:theCamera animated:YES completion:0];
    } else {
        [MessageShow showMessageView:MESSAGE_TYPE_ERROR code:0 msg:@"没有找到摄像头" autoClose:1 time:1.2F];
    }
}
// 本地相册
- (void)localPhoto {
    TheAssetPickerController *picker = [[TheAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = kMaximumPicCount - self.imageArray.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:NULL];
}
// Reload照片
- (void)reloadSubviews {
    self.bgView.frame = CGRectMake(5,
                                   self.theTextView.frame.origin.y + HEIGHT_TextView + 15,
                                   size_width - 10,
                                   (PicLength + 2) * (self.imageArray.count / columns + 1) + 10);
    
    
    self.addPicBtn.frame = CGRectMake(5 + (PicLength + 2) * (self.imageArray.count % columns),
                                      5 + (PicLength + 2) * (self.imageArray.count / columns),
                                      PicLength,
                                      PicLength);
    
    for (UIView *tempView in self.bgView.subviews) {
        
        if ([tempView isKindOfClass:[UIImageView class]]) {
            [tempView removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIImageView *picIV = [[UIImageView alloc] initWithFrame:CGRectMake(5 + (PicLength + 2) * (i % columns),
                                                                           5 + (PicLength + 2) * (i / columns),
                                                                           PicLength,
                                                                           PicLength)];
        picIV.clipsToBounds = YES;
        picIV.tag = TAG_PIC_BEGIN + i;
        picIV.userInteractionEnabled = YES;
        picIV.layer.cornerRadius = 2.0F;
        [picIV setImage:self.imageArray[i]];
        [self loadDeleteBtn:picIV];
        [self.bgView addSubview:picIV];
    }
}
// 照片删除按钮
- (void)loadDeleteBtn:(UIImageView*)picIV {
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(-2, -2, 25, 25);
    delBtn.tag = TAG_BTN_BEGIN + (picIV.tag - TAG_PIC_BEGIN);
    [delBtn setBackgroundImage:[UIImage imageNamed:@"DeletePicButton.png"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [picIV addSubview:delBtn];
}
// 照片删除按钮 点击事件
- (void)deleteBtnClick:(UIButton*)btn {
    [self.imageArray removeObjectAtIndex:(btn.tag - TAG_BTN_BEGIN)];
    [self reloadSubviews];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
*/

#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (TAG_ALERT_QUIT == alertView.tag) {
        if (1 == buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (TAG_BG_SCROLLVIEW == scrollView.tag) {
        [self.theTextView resignFirstResponder];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(photoImage, 0.2);
    UIImage *image = [UIImage imageWithData:imageData];
    [self.imageArray addObject:image];
    [self reloadSubviews];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (isCamera) {
            //保存到相册
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:[photoImage CGImage]
                                      orientation:(ALAssetOrientation)[photoImage imageOrientation]
                                  completionBlock:nil];
        }
        isCamera = NO;
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    isCamera = NO;
    [picker dismissViewControllerAnimated:YES completion:0];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)btnIndex {
    
    if (TAG_ACTION_SHEET == actionSheet.tag) {
        if (0 == btnIndex) {
            [self takePhoto];
        }
        
        if (1 == btnIndex) {
            [self localPhoto];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.placeLabel removeFromSuperview];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([self.theTextView.text isEqualToString:@""]) {
        [self.theTextView addSubview:self.placeLabel];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    DDLog(@"字数：%lu",(unsigned long)[textView.text length]);
    self.characterCountLab.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)[textView.text length], (long)kMaximumCharacterCount];
    
    if (kMaximumCharacterCount >= [textView.text length] ) {
        self.characterCountLab.textColor = [UIColor lightGrayColor];
    } else {
        self.characterCountLab.textColor = [UIColor redColor];
    }
}

#pragma mark - TheAssetPickerController Delegate
-(void)assetPickerController:(TheAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [self.assetsArray removeAllObjects];
    
    [self.assetsArray addObjectsFromArray:assets];
    
    for (NSInteger i = 0; i < self.assetsArray.count; i++) {
        ALAsset *asset = self.assetsArray[i];
        [self.imageArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
    }
    [self reloadSubviews];
}

-(void)assetPickerControllerDidMaximum:(TheAssetPickerController *)picker {
    NSString *msg = [NSString stringWithFormat:@"最多添加%d张图片", kMaximumPicCount];
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [theAlert show];
}

#pragma mark - PublishDataControllerDelegate
- (void)onGetPublishData:(NSInteger)tag receiveData:(NSMutableDictionary *)data {

    [MessageShow closeMsgAlertView];
    if ([data[@"opt_rst"] isEqualToString:@"success"]) {

        [MessageShow showMessageView:MESSAGE_TYPE_OK
                                code:0
                                 msg:@"提交成功"
                           autoClose:1
                                time:1.3F];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"publish" forKey:@"from"];
}

- (void)onGetPublishRequestError:(NSInteger)tag error:(NSError *)error {
    
    [MessageShow closeMsgAlertView];
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR
                            code:error.code
                             msg:nil
                       autoClose:1
                            time:1.3F];
}

@end
