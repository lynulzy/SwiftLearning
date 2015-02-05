//
//  BulidingViewController.h
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface BulidingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate,UIAlertViewDelegate>

- (IBAction)selectCity:(id)sender;
@property (nonatomic,assign)BOOL isReload;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectCityButton;
@property (nonatomic,assign)BOOL isAttentionBuilding;
@end
