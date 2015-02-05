//
//  BuildDetailHeaderView.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BuildDetailHeaderView.h"
#import "UIImageView+WebCache.h"
@implementation BuildDetailHeaderView
- (void)setBuildingDetalModel:(BuildingDetalModel *)buildingDetalModel{
    if (_buildingDetalModel != buildingDetalModel) {
        _buildingDetalModel = buildingDetalModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    if (_buildingDetalModel == nil) {
        _moneyLabel.text = @"佣金";
        _nameLabel.text = @"楼盘名称";
        _priceLabel.text = @"楼盘单价";
        _managerLabel.text = @"";
        _customerLabel.text = @"";
        return;
    }
    if (_buildingDetalModel.highest_commission_ratio == nil) {
        _moneyLabel.text = [NSString stringWithFormat:@"%@/套",_buildingDetalModel.highest_commission_price];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"%@/套",_buildingDetalModel.highest_commission_ratio];
    }
    _nameLabel.text = [NSString stringWithFormat:@"%@",_buildingDetalModel.name];
    _priceLabel.text = [NSString stringWithFormat:@"%@/平方米",_buildingDetalModel.price];
    _managerLabel.text = [NSString stringWithFormat:@"%@",_buildingDetalModel.partner_num];
    _customerLabel.text = [NSString stringWithFormat:@"%@",_buildingDetalModel.intention_customer_num];
    [_logoImgView sd_setImageWithURL:[NSURL URLWithString:_buildingDetalModel.logo]];
    _logoImgView.array = _buildingDetalModel.building_img;
}



@end
