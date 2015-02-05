//
//  CityController.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-9.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BaseViewController.h"

@interface CityController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end
