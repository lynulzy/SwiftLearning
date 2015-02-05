//
//  CycleScrollView.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/20.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

- (void)dealloc {
    self.contentViews = nil;
    self.scrollView = nil;
    self.animationTimer = nil;
}

- (void)invalidateTheTimer {
    
    [self.animationTimer invalidate];
}

- (void)startAutoCycleScroll {
    
    if (self.totalPagesCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration {
    
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        
       self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration = animationDuration target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
        
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame),
                                                 CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
    }
    return self;
}

#pragma mark - Config contentViews
- (void)configContentViews {
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 准备数据 3 张图片
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    // 把 3 张图片码上
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    // 让(0, 1, 2)中间的那张显示
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
}

#pragma mark - 设置数据源(当前要显示的图片 和它的前、后两张)
- (void)setScrollViewContentDataSource {
    // 当前显示的图片的 前一张
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    // 后一张
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(fetchContentViewAtIndex:)]) {
        // 前一张
        [self.contentViews addObject:(UIImageView*)[self.delegate fetchContentViewAtIndex:previousPageIndex]];
        // 当前
        [self.contentViews addObject:(UIImageView*)[self.delegate fetchContentViewAtIndex:_currentPageIndex]];
        // 后一张
        [self.contentViews addObject:(UIImageView*)[self.delegate fetchContentViewAtIndex:rearPageIndex]];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)thePageIndex {
    
    if (thePageIndex == -1) {
        return self.totalPagesCount - 1;
    } else if (thePageIndex == self.totalPagesCount) {
        return 0;
    } else {
        return thePageIndex;
    }
}

#pragma mark - UIScrollViewDelegate
// 拖动拖动开始 pauseTimer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.animationTimer pauseTimer];
}
// 拖动结束 resumeTimer
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}
// 滚动后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int contentOffsetX = scrollView.contentOffset.x;
    // 通过contentOffset计算向前滚还是向后滚
    if (contentOffsetX == (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        // 返回当前显示的是第几页
        [self.delegate returnCurrentPageIndex:self.currentPageIndex];
        // 重置ContentViews
        [self configContentViews];
    }
    
    if (contentOffsetX == 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self.delegate returnCurrentPageIndex:self.currentPageIndex];
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
- (void)animationTimerDidFired:(NSTimer *)timer {
    
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
    
    [self.delegate tapContentView:self.currentPageIndex];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
