//
//  CityCell.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-9.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
@interface CityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic,strong)CityModel * cityModel;
@end
