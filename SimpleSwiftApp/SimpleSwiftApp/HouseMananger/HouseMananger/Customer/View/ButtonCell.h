//
//  ButtonCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/20.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PassVValue)(NSString * value);
@interface ButtonCell : UITableViewCell
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSArray * spertaeArray;
@property (nonatomic,assign)BOOL isRegion;
@property (nonatomic,strong)UILabel *buttonLabel;
@property (nonatomic,copy)PassVValue passValue;
@end
