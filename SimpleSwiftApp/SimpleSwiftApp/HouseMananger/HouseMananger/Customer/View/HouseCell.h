//
//  HouseCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/20.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PassBlock)(NSString*);
@interface HouseCell : UITableViewCell
@property (nonatomic,strong)UILabel *buttonLabel;
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,copy)PassBlock passBlock;
@property (nonatomic,strong)NSArray * spertaeArray;
@end
