//
//  CustomerDetailController.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/21.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BaseViewController.h"

@interface CustomerDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,copy)NSString * customerID;
@end
