//
//  PicScanViewController.m
//  PicScan
//
//  Created by ZXH on 14/11/28.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "PicScanViewController.h"
#import "UIImageView+WebCache.h"
#import "MessageShow.h"

#define IOS7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IMAGE_SCR_TAG_BEGIN     2000
#define IMAGE_VIEW_TAG_BEGIN    1234578
@interface PicScanViewController ()<UIScrollViewDelegate,UIAlertViewDelegate> {
    
    NSInteger window_Width;
    NSInteger window_Hight;
    
    NSInteger currPage;
    NSInteger totalImageCount;
    
    BOOL showBottomView;
}

@property(nonatomic, strong)UIScrollView *bgBigScroll;// 存放小ScrollView 的大ScrollView
//@property(nonatomic, strong)UIScrollView *imageScroll;// 存放图片的小ScrollView

@property(nonatomic, strong)UIView *bottomView;// 底部工具栏
@property(nonatomic, strong)UILabel *pageLabel;// 页码Label
@property(nonatomic, strong)NSMutableArray *urlArr;
@end

@implementation PicScanViewController

- (void)dealloc {
    
    DDLog(@"PicScanViewController dealloc")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.imageUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.urlArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 取宽、高
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window_Width = window.frame.size.width;
    window_Hight = window.frame.size.height;
    
    currPage = self.currentPage;
    showBottomView = YES;
    totalImageCount = self.imageUrlArray.count;
    for(int i = 0; i < totalImageCount; i++) {
        NSURL *url = [NSURL URLWithString:self.imageUrlArray[i]];
        [self.urlArr addObject:url];
    }
    
    // 创建大scrollview
    [self setupScollviewPictures];
    // 创建存放图片的小scrollviewImageView
    [self setupScollviewImageView];
    // 创建工具条
    [self setupBottomView];
}

- (void)setupBottomView {
    // 创建工具条
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, window_Hight - 49, window_Width, 49)];
    self.bottomView.backgroundColor = [UIColor blackColor];
    self.bottomView.alpha = 1;
    [self.view addSubview:self.bottomView];
    NSInteger bottomWidth = self.bottomView.frame.size.width;
    NSInteger bottomHight = self.bottomView.frame.size.height;
    
    // 返回
    UIButton *picEnlargeBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    picEnlargeBackBtn.frame = CGRectMake(12, 7, 31, 31);
    [picEnlargeBackBtn setBackgroundImage:[UIImage imageNamed:@"picScan_back.png"] forState:UIControlStateNormal];
    [picEnlargeBackBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:picEnlargeBackBtn];
    
    // 页数Table
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((bottomWidth - 80)/2, 0, 80, bottomHight)];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currPage, (long)totalImageCount];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.font = [UIFont systemFontOfSize:19.0F];
    self.pageLabel.alpha = 1;
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.pageLabel];
    
    // 保存图片按钮
    UIButton *savePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savePicBtn.frame = CGRectMake(bottomWidth - 15 - 29, 7, 29, 29);
    [savePicBtn setBackgroundImage:[UIImage imageNamed:@"picScan_download.png"] forState:UIControlStateNormal];
    [savePicBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:savePicBtn];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)saveBtnClick {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存照片" message:@"保存照片到本地相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //下标为1的就是确定，此时把图片保存到手机中，
    if (1 == buttonIndex) {
        NSInteger index =( self.bgBigScroll.contentOffset.x )/ self.bgBigScroll.bounds.size.width;
        UIScrollView *scrollview = (UIScrollView *)[self.bgBigScroll viewWithTag:IMAGE_SCR_TAG_BEGIN + index];
        UIImageView *imageView = (UIImageView *)[[scrollview subviews]firstObject];
        //保存图片到手机中
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    [MessageShow showMessageView:0 code:1 msg:@"保存成功" autoClose:1 time:1];
}

- (void)setupScollviewPictures {
    // 设置scrollview的内容contentsize
    self.bgBigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                     20,
                                                                     window_Width,
                                                                     window_Hight - 20 - 49)];
    self.bgBigScroll.backgroundColor = [UIColor blackColor];
    self.bgBigScroll.contentSize = CGSizeMake(totalImageCount * window_Width,
                                              self.bgBigScroll.frame.size.height);
    self.bgBigScroll.contentOffset = CGPointMake(window_Width * (currPage - 1), 0);
    // 允许整屏翻动
    self.bgBigScroll.pagingEnabled = YES;
    // 设置代理对象
    self.bgBigScroll.delegate = self;
    [self.view addSubview:self.bgBigScroll];
}

// 创建存放图片的小scrollView ImageView
- (void)setupScollviewImageView {
    
    for(int i = 0; i < self.imageUrlArray.count; i++) {
        UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0 + i * window_Width,
                                                                                   0,
                                                                                   window_Width,
                                                                                   self.bgBigScroll.frame.size.height)];
        // 设置内容大小
        imageScroll.contentSize = CGSizeMake(window_Width, imageScroll.frame.size.height);
        imageScroll.zoomScale = 1.0;
        // 设置scrollPictures的最大最小缩放比例
        imageScroll.maximumZoomScale = 2.5;
        imageScroll.minimumZoomScale = 1.0;
        imageScroll.bouncesZoom = YES;
        imageScroll.delegate = self;
        imageScroll.tag = IMAGE_SCR_TAG_BEGIN + i;
        [self.bgBigScroll addSubview:imageScroll];
        
        // 双击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleClickAction:)];
        tapGesture.numberOfTapsRequired = 2;
        [imageScroll addGestureRecognizer:tapGesture];
        
        // 单击
        UITapGestureRecognizer *tapOnceGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleOnceClickAction:)];
        tapOnceGesture.numberOfTapsRequired = 1;
        [imageScroll addGestureRecognizer:tapOnceGesture];
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArray[i]] placeholderImage:[UIImage imageNamed:@"placeholderPic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imageView.frame = CGRectMake(0,
                                         0,
                                         imageScroll.frame.size.width,
                                         window_Width / imageView.image.size.width * imageView.image.size.height);
            if (self.bgBigScroll.frame.size.height < window_Width / imageView.image.size.width * imageView.image.size.height) {
                imageView.center = CGPointMake(self.bgBigScroll.frame.size.width/2,
                                               window_Width / imageView.image.size.width * imageView.image.size.height/2);
            } else {
                imageView.center = CGPointMake(self.bgBigScroll.frame.size.width/2,
                                               self.bgBigScroll.frame.size.height/2);
            }
            
            imageScroll.contentSize = CGSizeMake(window_Width, window_Width / imageView.image.size.width * imageView.image.size.height);
        }];
        
        [imageScroll addSubview:imageView];
    }
}

// 单击手势响应的方法
-(void)handleOnceClickAction:(UIGestureRecognizer *)sender{
//    [UIView animateWithDuration:0.15 animations:^{
//        
//        if (YES == showBottomView) {
//            showBottomView = NO;
//            self.bottomView.frame = CGRectMake(0, window_Hight, window_Width, 49);
//        } else {
//            showBottomView = YES;
//            self.bottomView.frame = CGRectMake(0, window_Hight - 49, window_Width, 49);
//        }
//        
//    }];
//    [self.navigationController popViewControllerAnimated:YES];
}

// 双击手势的响应方法
-(void)handleDoubleClickAction:(UIGestureRecognizer *)sender{
    UIScrollView *scrollView = (UIScrollView *)sender.view;
    if (scrollView.zoomScale == scrollView.minimumZoomScale) {
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }else{
        [scrollView setZoomScale:1.0 animated:YES];
    }
}

// 给图片添加缩放方法，允许缩放
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.bgBigScroll) {
//        DDLog(@"%@",scrollView.subviews);
        return scrollView.subviews.firstObject;// imageView
    }
    return nil;
}

// 图片缩放完成时触发的方法
// 代理方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView != self.bgBigScroll) {
        UIImageView *imageView = [scrollView.subviews firstObject];// 得到 imageView
        
        CGFloat x = 0;
        CGFloat y = 0;
        
        if (imageView.frame.size.width > self.bgBigScroll.frame.size.width) {
            x = imageView.frame.size.width / 2;
        } else {
            x = self.bgBigScroll.frame.size.width / 2;
        }
        
        if (imageView.frame.size.height > self.bgBigScroll.frame.size.height) {
            y = imageView.frame.size.height / 2;
        } else {
            y = self.bgBigScroll.frame.size.height / 2;
        }
        
        imageView.center = CGPointMake(x, y);
    }
}

// 完成拖拽的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 如果scrollView为大的scrollView时，则响应拖拽完成的方法，
    if (scrollView == self.bgBigScroll) {
        // 得到整屏偏移量的个数
        NSInteger index = self.bgBigScroll.contentOffset.x / self.bgBigScroll.bounds.size.width;
        // 添加
        // 遍历scrollView上的子视图，得到UIScrollview类型的视图
        for (UIView* tempView in scrollView.subviews) {
            if ([tempView isKindOfClass:[UIScrollView class]]) {
                // 如果此时的视图不等于拖拽之后的视图，则把之前的视图缩放成原来的大小
                if (tempView != (UIScrollView *)[self.bgBigScroll viewWithTag:IMAGE_SCR_TAG_BEGIN + index]) {
                    [(UIScrollView*)tempView setZoomScale:1.0 animated:YES];
                    
                    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)index + 1, (long)totalImageCount];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    DDLog(@"mmmm");
}

@end

