//
//  AttBuildButtonCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/2/3.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PassEventBlock)();
@interface AttBuildButtonCell : UITableViewCell
- (IBAction)addCustomerAction:(id)sender;
@property (nonatomic,copy)PassEventBlock passEventBlock;
@end
