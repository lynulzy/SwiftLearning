//
//  GuideViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/29.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "GuideViewController.h"
#import "MainTabBarController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    NSInteger totalPageCount;
}

@property(nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GuideViewController

- (id)initWithFrame:(CGRect)theRect {
    if ((self = [super init])) {
        self.view.frame = theRect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *imgs = @[@"guide1.png",
                      @"guide2.png",
                      @"guide3.png"];
    totalPageCount = imgs.count;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height + 20)];
    scrollView.contentSize = CGSizeMake(size_width * (totalPageCount+1), size_height + 20);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, size_height - 40, size_width, 20)];
    [self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.pageControl.numberOfPages = imgs.count;
    [self.view addSubview:self.pageControl];
    
//    self.skipButton = [[UIButton alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width - 80, self.pageControl.frame.origin.y, 80, self.pageControl.frame.size.height)];
//    
//    [self.skipButton setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
//    [self.skipButton setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
//    [self.skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.skipButton];

    //2.创建图片视图
    for (int i=0; i<imgs.count; i++) {
        NSString *name = imgs[i];
        UIImage *img = [UIImage imageNamed:name];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(size_width * i, 0, size_width, size_height + 20);
        [scrollView addSubview:imgView];
        if (i == imgs.count-1) {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMain)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DDLog(@"%f", scrollView.contentOffset.x)
    DDLog(@"%f", scrollView.frame.size.width)
    NSInteger currentPageIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    if (currentPageIndex == totalPageCount) {
        if ([self respondsToSelector:@selector(showMain)]) {
            [self showMain];
        }
    }
    
    self.pageControl.currentPage = currentPageIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat scroWidth = scrollView.frame.size.width;
    if (offset > scroWidth * (totalPageCount - 1)) {
        self.view.alpha = (scroWidth * totalPageCount - offset)/(scroWidth-30);
    }
//    float  / self.scrollView.frame.size.width;
//    NSInteger page = (int)(offset);
//    
//    if (page == (pageViews.count - 1) && self.swipeToExit) {
//        self.alpha = ((self.scrollView.frame.size.width*pageViews.count)-self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
//    } else {
//        [self crossDissolveForOffset:offset];
//    }
}

//显示主界面
- (void)showMain {
    
    [self.view removeFromSuperview];
    self.view = nil;
//    [self.view.subviews performSelector:@selector(removeFromSuperview)];
//    [self.view removeFromSuperview];
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
