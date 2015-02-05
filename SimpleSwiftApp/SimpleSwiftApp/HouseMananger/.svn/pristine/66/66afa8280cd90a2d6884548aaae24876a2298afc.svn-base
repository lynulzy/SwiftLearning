//
//  ScrollNavigationTitle.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/28.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "ScrollNavigationTitle.h"

@interface ScrollNavigationTitle (){
    CGFloat viewWidth;
    CGFloat scrollTime;
}
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ScrollNavigationTitle

- (void)dealloc {
    self.titleView = nil;
    self.titleLabel = nil;
    self.tTimer = nil;
}

- (UIView*)makeScrollNavigationTiteWithString:(NSString *)titleStr
                                     withFont:(CGFloat)font
                           withTitleViewWidth:(CGFloat)width
                          withTitleViewHeight:(CGFloat)height
                              withScrollSpeed:(CGFloat)scrollSpeed
                            withBeginInterval:(CGFloat)beginInterval {

    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.clipsToBounds = YES;
    
    viewWidth = width;

    CGSize labelSize = [titleStr sizeWithFont:[UIFont boldSystemFontOfSize:font]];
    
    CGFloat labelWidth = (labelSize.width > viewWidth) ? labelSize.width : viewWidth;
    
    // Title label
    self.titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, labelWidth, height)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = titleStr;
    if (labelWidth > viewWidth) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    
    // Add
    [self.titleView addSubview:self.titleLabel];
    
    // Fire moving timer
    if ( nil != titleStr && self.titleLabel.frame.size.width > viewWidth ) {
        
//        scrollTime = viewWidth / (self.titleLabel.frame.size.width - viewWidth) * scrollSpeed;
        scrollTime = scrollSpeed;
        if (nil != titleStr) {
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:titleStr, @"goods_name", nil];
            
            self.tTimer = [NSTimer scheduledTimerWithTimeInterval:scrollTime + 0.3 target:self selector:@selector(rollNavTitle:) userInfo:userInfo repeats:YES];
        }
    }
    return self.titleView;
}

- (void)rollNavTitle:(NSTimer*)theTimer {
    
    if (nil == self.titleView || nil == self.titleLabel) {
        return;
    }
    
    // Roll title label
    [UIView animateWithDuration:scrollTime animations:^{
        
        if (0.0F == self.titleLabel.frame.origin.x) {
            self.titleLabel.frame = CGRectMake(viewWidth - self.titleLabel.frame.size.width,
                                             0.0F,
                                             self.titleLabel.frame.size.width,
                                             self.titleLabel.frame.size.height);
        } else {
            self.titleLabel.frame = CGRectMake(0.0F,
                                             0.0F,
                                             self.titleLabel.frame.size.width,
                                             self.titleLabel.frame.size.height);
        }
    }];
}

@end
