//
//  SelectBuildCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/26.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectModel.h"
@interface SelectBuildCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic,strong)SelectModel * selectModel;
@end
