//
//  ScrollNavigationTitle.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/28.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ScrollNavigationTitle : NSObject

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSTimer *tTimer;

- (UIView*)makeScrollNavigationTiteWithString:(NSString*)titleStr
                                     withFont:(CGFloat)font
                           withTitleViewWidth:(CGFloat)width
                          withTitleViewHeight:(CGFloat)height
                              withScrollSpeed:(CGFloat)scrollSpeed
                            withBeginInterval:(CGFloat)beginInterval;

@end
