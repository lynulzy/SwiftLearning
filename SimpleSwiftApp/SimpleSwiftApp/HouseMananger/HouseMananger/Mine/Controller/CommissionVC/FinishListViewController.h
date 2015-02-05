//
//  FinishListViewController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/27.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishListViewControllerDelegate <NSObject>

- (void)pushToDetailWith:(NSDictionary*)dataDic andType:(NSString *)settlementStr;

@end

@interface FinishListViewController : UIViewController

@property(nonatomic, assign) id<FinishListViewControllerDelegate>delegate;

- (id)initWithFrame:(CGRect)theRect;

@end
