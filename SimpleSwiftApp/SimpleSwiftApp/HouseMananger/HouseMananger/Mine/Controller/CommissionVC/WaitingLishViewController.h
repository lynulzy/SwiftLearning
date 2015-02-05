//
//  WaitingLishViewController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/27.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaitingLishViewControllerDelegate <NSObject>

- (void)pushToDetailWith:(NSDictionary*)dataDic andType:(NSString *)settlementStr;

@end

@interface WaitingLishViewController : UIViewController

@property(nonatomic, assign) id<WaitingLishViewControllerDelegate>delegate;

- (id)initWithFrame:(CGRect)theRect;

@end
