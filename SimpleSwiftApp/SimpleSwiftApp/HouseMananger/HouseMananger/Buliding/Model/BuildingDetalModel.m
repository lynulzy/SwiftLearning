//
//  BuildingDetalModel.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-12.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BuildingDetalModel.h"

@implementation BuildingDetalModel
- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    if (dataDic != nil) {
        self.buy_point = [dataDic objectForKey:@"buy_point"];
        self.building_img = [dataDic objectForKey:@"building_img"];
    }
}

@end
