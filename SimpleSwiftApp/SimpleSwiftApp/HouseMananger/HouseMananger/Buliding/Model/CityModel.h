//
//  CityModel.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-9.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "WXBaseModel.h"

@interface CityModel : WXBaseModel
@property (nonatomic,copy)NSString *agency_id;//城市Id
@property (nonatomic,copy)NSString *parent_id;//城市Id
@property (nonatomic,copy)NSString *region_id;//城市Id
@property (nonatomic,copy)NSString *region_name;//城市名字
@property (nonatomic,copy)NSString *region_type;//城市名字
@end
