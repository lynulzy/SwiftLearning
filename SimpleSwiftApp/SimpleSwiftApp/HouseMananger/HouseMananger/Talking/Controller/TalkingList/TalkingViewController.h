//
//  TalkingViewController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/15.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PassEventByBolck)(NSDictionary *);
@interface TalkingViewController : UIViewController
@property (nonatomic,assign)BOOL isBuildDetail;
@property (nonatomic,copy)PassEventByBolck passBlock;
- (id)initWithFrame:(CGRect)theRect andBuildID:(NSString*)theBuildID andTableHeight:(CGFloat)theHeight;

@end
