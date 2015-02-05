//
//  CustomerDetailModel.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/22.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "WXBaseModel.h"

@interface CustomerDetailModel : WXBaseModel
@property (nonatomic,copy)NSString * customer_id;//顾客ID
@property (nonatomic,copy)NSString * customer_mobile;//顾客电话
@property (nonatomic,copy)NSString * customer_name;//顾客名字
@property (nonatomic,copy)NSString * customer_sex;//顾客性别
@property (nonatomic,copy)NSString * house_type;//户型
@property (nonatomic,copy)NSString * price_range;//价格
@property (nonatomic,copy)NSString * purchase_intentions;//购房意向
@property (nonatomic,copy)NSString * region;//购房区域
@property (nonatomic,copy)NSString * remark;//备注
@end
