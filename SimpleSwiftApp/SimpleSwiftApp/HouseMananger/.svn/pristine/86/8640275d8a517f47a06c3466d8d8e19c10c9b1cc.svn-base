//
//  CycleScrollView.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/20.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate <NSObject>
// 点击图片 返回 点击的 是第几页
- (void)tapContentView:(NSInteger)pageIndex;
// 根据 pageIndex 取图片
- (UIImageView*)fetchContentViewAtIndex:(NSInteger)pageIndex;
// 滚动后 返回 当前 是第几页
- (void)returnCurrentPageIndex:(NSInteger)currentPageIndex;

@end


@interface CycleScrollView : UIView

@property (nonatomic , weak) id<CycleScrollViewDelegate>delegate;
@property (nonatomic , assign) NSInteger totalPagesCount;
@property (nonatomic , strong) NSTimer *animationTimer;


- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
- (void)startAutoCycleScroll;
- (void)invalidateTheTimer;

@end
