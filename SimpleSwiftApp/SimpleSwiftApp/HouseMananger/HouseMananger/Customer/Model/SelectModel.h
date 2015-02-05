//
//  SelectModel.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/27.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "WXBaseModel.h"

@interface SelectModel : WXBaseModel
@property (nonatomic,copy)NSString * buildId;//楼盘Id
@property (nonatomic,copy)NSString * name;//楼盘名称
@property (nonatomic,copy)NSString * region_id;//地区id
@property (nonatomic,copy)NSString * region_name;//地区名字
@property (nonatomic,copy)NSString * is_report;//是否已报备
@end
