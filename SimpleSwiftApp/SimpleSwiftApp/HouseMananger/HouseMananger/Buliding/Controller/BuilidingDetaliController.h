//
//  BuilidingDetaliController.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface BuilidingDetaliController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIAlertViewDelegate>
@property (nonatomic,copy)NSString * buildingID;
@end
