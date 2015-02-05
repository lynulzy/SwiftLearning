//
//  NameCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/19.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSwitch.h"
typedef void (^PassNameBlock)(NSString * name);
@interface NameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueLabel;
@property (nonatomic,strong)ZJSwitch * switch2;
@property (nonatomic,copy)PassNameBlock  passNameBlock;
@property (nonatomic,copy)PassNameBlock  passValueBlock;

@end
