//
//  BuildingDetalModel.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-12.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "WXBaseModel.h"

@interface BuildingDetalModel : WXBaseModel
@property (nonatomic,copy)NSString * name;//楼盘名字
@property (nonatomic,copy)NSString * city;//城市Id
@property (nonatomic,copy)NSString * district;//区县Id
@property (nonatomic,copy)NSString * region_name;//区县名字
@property (nonatomic,copy)NSString * logo;//楼盘logo
@property (nonatomic,copy)NSString * price;//楼盘单价
@property (nonatomic,copy)NSString * highest_commission_ratio;//楼盘最高佣金比例
@property (nonatomic,copy)NSString * highest_commission_price;//楼盘最高佣金价格
@property (nonatomic,copy)NSString * partner_num;//合作经纪人数量
@property (nonatomic,copy)NSString * intention_customer_num;//意向客户数量
@property (nonatomic,copy)NSString * province;//省
@property (nonatomic,copy)NSString * address;//详细地址
@property (nonatomic,copy)NSString * addressDescription;//地址描述
@property (nonatomic,copy)NSString * startTime;//开盘时间
@property (nonatomic,copy)NSString * developer;//开发商
@property (nonatomic,copy)NSString * property_company;//物业公司
@property (nonatomic,copy)NSString * property_type;//物业类型
@property (nonatomic,copy)NSString * building_area;//建筑面积
@property (nonatomic,copy)NSString * building_type;//建筑类型
@property (nonatomic,copy)NSString * renovation_situation;//装修情况
@property (nonatomic,copy)NSString * house_number;//总户数
@property (nonatomic,copy)NSString * car_number;//车位数
@property (nonatomic,copy)NSString * plot_ratio;//容积率
@property (nonatomic,copy)NSString * green_ratio;//绿地率
@property (nonatomic,copy)NSString * property_fee;//物业费
@property (nonatomic,copy)NSString * create_time;//创建时间
@property (nonatomic,strong)NSArray * buy_point;//卖点(数组)
@property (nonatomic,strong)NSArray * building_img;//楼盘图(数组)
@property (nonatomic,copy)NSString * lng;//经度
@property (nonatomic,copy)NSString * lat;//纬度
@property (nonatomic,copy)NSString * is_guanzhu;//是否关注
@end
