//
//  PublishViewController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/22.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PubulishSuccessDelegate <NSObject>

@optional
- (void)publishSuccess:(NSDictionary *)dict;

@end


@interface PublishViewController : UIViewController

@property (nonatomic,assign)id<PubulishSuccessDelegate> delegate;

@property(nonatomic, copy) NSString *buildID;

@end
