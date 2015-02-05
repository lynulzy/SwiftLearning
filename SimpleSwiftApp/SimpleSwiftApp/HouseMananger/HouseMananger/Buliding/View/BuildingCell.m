//
//  BuildingCell.m
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "BuildingCell.h"
#import "UIImageView+WebCache.h"
@implementation BuildingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setBuildingModel:(BuildingModel *)buildingModel{
    if (_buildingModel != buildingModel) {
        _buildingModel = buildingModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    if (_buildingModel.highest_commission_ratio == nil) {
        _moneyLabel.text = [NSString stringWithFormat:@"%@/套",_buildingModel.highest_commission_price];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"%@％/套",_buildingModel.highest_commission_ratio];
    }
    _locationLabel.text = [NSString stringWithFormat:@"[%@]",_buildingModel.region_name];
    _nameLabel.text = [NSString stringWithFormat:@"%@",_buildingModel.name];
    _priceLabel.text = [NSString stringWithFormat:@"%@/平方米",_buildingModel.price];
    _managerLabel.text = [NSString stringWithFormat:@"%@",_buildingModel.partner_num];
    _customerLabel.text = [NSString stringWithFormat:@"%@",_buildingModel.intention_customer_num];
    [_logoImgView sd_setImageWithURL:[NSURL URLWithString:_buildingModel.logo]];
}
- (IBAction)addCustomer:(id)sender {
    _passValueBlock(_buildingModel.buildingId);
}
@end
